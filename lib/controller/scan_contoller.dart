import 'dart:math';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class ScanController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    initCamera();
    initTFlite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max
          // imageFormatGroup: ImageFormatGroup.bgra8888,
          );
      // await cameraController.initialize().then((value) {
      //   cameraController.startImageStream((image) {
      //     cameraCount++;
      //     if (cameraCount % 10 == 0) {
      //       cameraCount = 0;

      //       objectDetector(image);
      //     }
      //     update();
      //   });
      // });
      await cameraController.initialize();
      isCameraInitialized(true);
      update();
    } else {
      // Get.snackbar("Permission Denied", "Please allow camera permission");
      print("Permission Denied");
    }
  }

  initTFlite() async {
    try {
      await Tflite.loadModel(
        model: "assets/yolov2_tiny.tflite",
        labels: "assets/yolov2_tiny.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false,
      );

      print("Model loaded successfully");
    } catch (e) {
      print("Error loading TensorFlow Lite model: $e");
    }
  }

  // objectDetector(CameraImage image) async {
  //   var detector = await Tflite.runModelOnFrame(
  //     bytesList: image.planes.map((e) {
  //       return e.bytes;
  //     }).toList(),
  //     // asynch: true,
  //     imageHeight: image.height,
  //     imageWidth: image.width,
  //     imageMean: 127.5,
  //     imageStd: 127.5,
  //     numResults: 1,
  //     rotation: 90,
  //     threshold: 0.4,
  //   );

  //   if (detector != null) {
  //     log("Result is $detector" as num);
  //   } else {
  //     log("Result is not found" as num);
  //   }
  // }

  bool isModelBusy = false;

  void objectDetector(CameraImage image) async {
    if (!isModelBusy) {
      isModelBusy = true;

      try {
        var detector = await Tflite.runModelOnFrame(
          bytesList: image.planes.map((e) {
            return e.bytes;
          }).toList(),
          asynch: true,
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 127.5,
          imageStd: 127.5,
          numResults: 1,
          rotation: 90,
          threshold: 0.4,
        );
        if (detector != null && detector.isNotEmpty) {
          print("Result is $detector");
          // Perform actions based on the detection result
        } else {
          print("Result is not found or empty");
        }
      } finally {
        isModelBusy = false;
      }
    }
  }
}
