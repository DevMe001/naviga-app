import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_tts/flutter_tts.dart';
import 'package:logger/logger.dart';

class BndBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  FlutterTts objectSpeak = FlutterTts();

  var logger = Logger();

  BndBox(this.results, this.previewH, this.previewW, this.screenH, this.screenW,
      {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> renderBoxes() {
      return results.map((re) {
        var x0 = re["rect"]["x"];
        var w0 = re["rect"]["w"];
        var y0 = re["rect"]["y"];
        var h0 = re["rect"]["h"];
        dynamic scaleW, scaleH, x, y, w, h;

        var objPosition = '';

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (x0 - difW / 2) * scaleW;
          w = w0 * scaleW;
          if (x0 < difW / 2) w -= (difW / 2 - x0) * scaleW;
          y = y0 * scaleH;
          h = h0 * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = x0 * scaleW;
          w = w0 * scaleW;
          y = (y0 - difH / 2) * scaleH;
          h = h0 * scaleH;
          if (y0 < difH / 2) h -= (difH / 2 - y0) * scaleH;
        }

        var detectItem = re["detectedClass"];
// top left,right
        if (x >= screenW) {
          objPosition = 'center $detectItem';
        } else {
// top left,right
          if (y < screenH / 2) {
            if (x > screenW / 2 && y < screenH / 2 * 1.125) {
              objPosition = 'right $detectItem';
            } else if (x < screenW / 2) {
              objPosition = 'left $detectItem';
            } else {
              objPosition = 'top $detectItem';
            }
          }
// bottom left,right
          else if (y > screenH / 2) {
            if (x > screenW / 2 && y > screenH / 2 * 1.125) {
              objPosition = 'right $detectItem';
            } else if (x < screenW / 2) {
              objPosition = 'left $detectItem';
            } else {
              objPosition = 'bottom $detectItem';
            }
          } else {
            objPosition = 'center $detectItem';
          }
        }
        // logger.d('$w width value');
        // logger.d('$h height value');
        // logger.d('$x x value');
        // logger.d('$y y value');
        // logger.d(objPosition);
        // logger.d(re);

        const Duration(milliseconds: 500);

        detectedObjectSpeak(objPosition);

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
              padding: const EdgeInsets.only(top: 5.0, left: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 220, 247, 17),
                  width: 2,
                ),
              ),
              child: Center(
                  child: Text(
                "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Color.fromRGBO(247, 243, 17, 1),
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ))),
        );
      }).toList();
    }

    return Stack(
      children: renderBoxes(),
    );
  }

  Future<void> detectedObjectSpeak(String objPosition) async {
    // Split the input string into a list of words
    List<String> words = [objPosition];

    // Join the array of strings with a space as a separator
    String result = words.join(',');

    print(result); // Output: Hello World Dart
    await objectSpeak.speak(result);
  }
}
