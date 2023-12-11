import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:naviga/controller/bndbox.dart';
import 'package:naviga/controller/location.dart';
import 'package:naviga/controller/voice_controller.dart';
import 'dart:math' as math;

import 'camera.dart';

class DetectScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  // final String model;

  const DetectScreen({super.key, required this.cameras});

  @override
  State<DetectScreen> createState() => _DetectScreenState();
}

class _DetectScreenState extends State<DetectScreen> {
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String locationAddress = "";
  GetLocation getLocation = GetLocation();

  late StreamSubscription<Position> _positionStreamSubscription;
  Position? _currentPosition;
  FlutterTts flutterTts = FlutterTts();

  bool detection = false;

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    determinePosition();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  determinePosition() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    // ignore: unused_local_variable
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      setState(() {
        _currentPosition = position;
      });
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });

    Position position = await getLocation.determinePosition();

    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: "en");

    logger.d(placemarks);

    setState(() {
      locationAddress = placemarks.first.locality.toString();
    });
  }

  introDetector(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.speak(text);
  }

  void updateDetection(bool newDetection) {
    setState(() {
      detection = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () async {
          // Handle back button press
          Navigator.pop(context); // This will pop the current route
          return false; // Return false to prevent default behavior
        },
        child: Scaffold(
          body: Stack(
            children: [
              if (!detection) Camera(widget.cameras, setRecognitions),

              if (!detection)
                BndBox(
                  _recognitions == null ? [] : _recognitions!,
                  math.max(_imageHeight, _imageWidth),
                  math.min(_imageHeight, _imageWidth),
                  screen.height,
                  screen.width,
                ),
              // Absolute Text Overlay
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 360,
                  height: 800,
                  decoration: const BoxDecoration(color: Color(0xB2565555)),
                ),
              ),
              Positioned(
                left: 172,
                top: 708,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: SizedBox(
                    width: 350,
                    height: 300,
                    child: AnimatedMic(updateDetection, detection),
                  ),
                ),
              ),

              // const Positioned(
              //   left: 24,
              //   top: 483,
              //   child: Text(
              //     '55 ml',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 20,
              //       fontFamily: 'IBM Plex Sans Devanagari',
              //       fontWeight: FontWeight.w700,
              //       height: 0,
              //     ),
              //   ),
              // ),

              Positioned(
                right: 20,
                bottom: 50,
                child: GestureDetector(
                  onTap: () {
                    if (!detection) {
                      introDetector('Detector deactivated');
                    } else {
                      introDetector('Detector reactivated');
                    }

                    setState(() {
                      detection = !detection;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: LottieBuilder.asset(
                          'assets/detect.json',
                          repeat: detection ? true : false,
                          animate: detection,
                        ),
                      ),
                      const Positioned(
                        // Adjust the position of the text as needed
                        right: 15,
                        bottom: 30,
                        child: Text(
                          'Detector',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 250,
                top: 480,
                child: Text(
                  'Coordinates',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 225,
                top: 497,
                child: Text(
                  _currentPosition != null
                      ? '${_currentPosition!.latitude.toString()} - ${_currentPosition!.longitude.toString()}'
                      : 'Unknown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 44,
                top: 532,
                child: Lottie.asset('assets/marker.json', animate: true),
              ),
              Positioned(
                left: 40,
                top: 580,
                child: Text(
                  locationAddress.isNotEmpty
                      ? locationAddress
                      : 'Location is disabled',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 517,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const Stack(children: [
                    // No extra comma here
                  ]),
                ),
              ),
              Positioned(
                left: 25,
                top: 562,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const Stack(children: [
                    // No extra comma here
                  ]),
                ),
              ),
              Positioned(
                left: 25,
                top: 562,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const Stack(children: [
                    // No extra comma here
                  ]),
                ),
              ),
              Positioned(
                left: 84,
                top: 640,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                ),
              ),
              Positioned(
                left: 264.43,
                top: 508.28,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(-1.59),
                  child: Container(
                    width: 18.94,
                    height: 15.15,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    child: const Stack(children: [
                      // No extra comma here
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Cancel the position stream subscription when the widget is disposed
    _positionStreamSubscription.cancel();
    super.dispose();
  }
}
