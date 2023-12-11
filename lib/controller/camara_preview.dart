import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:naviga/controller/detect_screen.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    setupCameras();
    loadModel();
  }

  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      setState(() {
        isCameraInitialized = true;
      });
    } on CameraException catch (e) {
      log('Error: $e.code\nError Message: $e.message');
    }
  }

  loadModel() async {
    String? res;

    res = await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt",
    );

    log("$res");
  }

  // onSelect() {
  //   if (isCameraInitialized) {
  //     loadModel();
  //     final route = MaterialPageRoute(builder: (context) {
  //       return DetectScreen(cameras: cameras);
  //     });
  //     Navigator.of(context).push(route);
  //   } else {
  //     // Handle the case where the camera is not initialized
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('Camera Not Available'),
  //         content: const Text(
  //             'Unable to access the camera. Check camera permissions and try again.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Reload the model when the dependencies (e.g., assets) change
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isCameraInitialized
            ? DetectScreen(cameras: cameras)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
