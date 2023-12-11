import 'dart:async';

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:naviga/controller/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class AnimatedMic extends StatefulWidget {
  final Function(bool) updateDetection;
  final bool detection;

  const AnimatedMic(this.updateDetection, this.detection, {Key? key})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedMicState createState() => _AnimatedMicState();
}

class _AnimatedMicState extends State<AnimatedMic> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final DialogFlowtter dialogFlowtter = DialogFlowtter();
  FlutterTts flutterTts = FlutterTts();

  bool _speechEnabled = false;
  String _recognizeSpeak = '';
  String _status = "Press the mic to start";
  String place = "";
  // ignore: unused_field
  double _confidenceLevel = 0;
  GetLocation getLocation = GetLocation();

  List<String> landmarks = [];

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    var status = await Permission.microphone.request();

    if (status.isGranted) {
      _speechEnabled = await _speech.initialize();

      if (_speechEnabled) {
        Position position = await getLocation.determinePosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark firstPlacemark = placemarks.first;

          String thoroughfare = firstPlacemark.thoroughfare ?? '';
          String subThoroughfare = firstPlacemark.subThoroughfare ?? '';
          String locality = firstPlacemark.locality ?? '';
          String subLocality = firstPlacemark.subLocality ?? '';
          String administrativeArea = firstPlacemark.administrativeArea ?? '';
          String subAdministrativeArea =
              firstPlacemark.subAdministrativeArea ?? '';
          String postalCode = firstPlacemark.postalCode ?? '';
          String country = firstPlacemark.country ?? '';

          String fullAddress =
              '$subThoroughfare $thoroughfare, $subLocality $locality, $subAdministrativeArea $administrativeArea, $postalCode, $country';

          setState(() {
            place = fullAddress;
            _status = 'Press mic to start';
            _recognizeSpeak = '';
            landmarks = placemarks.map((e) => e.name.toString()).toList();
          });
        } else {
          setState(() {
            place = '';
            _status = 'Press mic to start';
            _recognizeSpeak = '';
            landmarks = [];
          });
        }

        // The recognizer is ready
        print('Speech recognition is available');
      } else {
        setState(() {
          _status = 'Not available';
        });
        // The recognizer is not available
        print('Speech recognition is not available');
      }
    } else if (status.isDenied) {
      setState(() {
        _status = 'Microphone permission denied';
      });
      print('Microphone permission is denied');
      // Permission is denied.
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, take the user to app settings.
      openAppSettings();
      setState(() {
        _status = 'Permission permanently denied';
      });
    }
  }

  void _startListening() async {
    if (!_speech.isListening && await _speech.initialize()) {
      await _speech.listen(onResult: _onSpeechResult);
      setState(() {
        _confidenceLevel = 0;
      });
    }
  }

  void _stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
      setState(() {
        _recognizeSpeak = '';
        _status = '';
      });
    }
  }

  void _onSpeechResult(result) async {
    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(text: TextInput(text: result.recognizedWords)),
    );

    print('detectedmessage');

    // QueryResult? fulfillmentMessages = response.queryResult;

    List<Message>? getResponse = response.queryResult?.fulfillmentMessages;

    print(getResponse);

    print('detectedmessage');

    String? textContent = response.text;

    if (textContent != null && textContent != result.recognizedWords) {
      _status = 'Bot is speaking...';
      if (textContent == 'getLocation') {
        if (place.isEmpty) {
          playText(
              'Location is disabled, please enable location and try again');

          Geolocator.openAppSettings();
        } else {
          playText('Your located at $place');
          print('Your located at $place');
        }
      } else if (textContent == 'getDate') {
        DateTime now = DateTime.now();

        String formattedDate = DateFormat('MMMM dd yyyy').format(now);

        playText('The date is $formattedDate');
      } else if (textContent == 'getTime') {
        DateTime now = DateTime.now();

        String formattedTime = DateFormat('HH:mm:ss').format(now);

        playText('The time is $formattedTime');
      } else if (textContent == 'getLandmark') {
        if (landmarks.isEmpty) {
          playText(
              'Location is disabled, please enable location and try again');
        } else {
          playText('The nearest landmarks to your position are $landmarks');
        }
      } else {
        playText(textContent);
        print('Text Content: $textContent');
      }

      await Future.delayed(const Duration(seconds: 3));
      _status = 'Press the mic to start';
    } else {
      print('No text available');
    }

    // Using await to properly wait for the delayed future

    setState(() {
      _recognizeSpeak = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
  }

  playText(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // First Text
        Text(
          _recognizeSpeak,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'IBM Plex Sans Devanagari',
            fontWeight: FontWeight.w700,
            height: 0,
            decoration: TextDecoration.none,
          ),
        ),

        // GestureDetector for Icon
        GestureDetector(
          onTap: () {
            setState(() {
              widget.updateDetection(widget.detection);
            });
            if (_speech.isListening) {
              _stopListening();
            } else {
              _startListening();
            }
          },
          child: Center(
            child: SizedBox(
              width: 200,
              height: 100,
              child: Lottie.asset(
                'assets/mic.json',
                animate: _speech.isListening,
              ),
            ),
          ),
        ),

        // Second Text
        if (_speech.isNotListening)
          Text(
            _status == '' ? 'Press the mic to start' : _status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'IBM Plex Sans Devanagari',
              fontWeight: FontWeight.w700,
              height: 0,
              decoration: TextDecoration.none,
            ),
          ),
        // Text(
        //   'Landmarks: $landmarks',
        //   style: const TextStyle(
        //     color: Colors.white,
        //     fontSize: 20,
        //     fontFamily: 'IBM Plex Sans Devanagari',
        //     fontWeight: FontWeight.w700,
        //     height: 0,
        //     decoration: TextDecoration.none,
        //   ),
        // )
      ],
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }
}
