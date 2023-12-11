import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naviga/controller/scan_contoller.dart';

import '../controller/voice_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Camera preview
              controller.isCameraInitialized.value
                  ? CameraPreview(controller.cameraController)
                  : const Center(child: CircularProgressIndicator()),

              // Overlay
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
              const Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child:
                      SizedBox(width: 350, height: 300, child: AnimatedMic()),
                ),
              ),

              const Positioned(
                left: 24,
                top: 483,
                child: Text(
                  '55 ml',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'IBM Plex Sans Devanagari',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              const Positioned(
                left: 47,
                top: 517,
                child: Text(
                  'Turn right',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              const Positioned(
                left: 283,
                top: 493,
                child: Text(
                  '20 step to go',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              const Positioned(
                left: 44,
                top: 562,
                child: Text(
                  'San Carlos City, Pangasinan',
                  style: TextStyle(
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
          );
        },
      ),
    );
  }
}
