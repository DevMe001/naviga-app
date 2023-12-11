import 'package:flutter/material.dart';
import 'dart:math' as math;

class BndBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  BndBox(this.results, this.previewH, this.previewW, this.screenH, this.screenW,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Draw x and y axis lines
        CustomPaint(
          painter: AxisPainter(screenW, screenH),
        ),
        // Render bounding boxes
        ...renderBoxes(),
      ],
    );
  }

  List<Widget> renderBoxes() {
    return results.map((re) {
      var x0 = re["rect"]["x"];
      var w0 = re["rect"]["w"];
      var y0 = re["rect"]["y"];
      var h0 = re["rect"]["h"];
      dynamic scaleW, scaleH, x, y, w, h;

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
            ),
          ),
        ),
      );
    }).toList();
  }
}

class AxisPainter extends CustomPainter {
  final double screenW;
  final double screenH;

  AxisPainter(this.screenW, this.screenH);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    // Draw x-axis line
    canvas.drawLine(
        Offset(0, screenH / 2), Offset(screenW, screenH / 2), paint);
    // Draw y-axis line
    canvas.drawLine(
        Offset(screenW / 2, 0), Offset(screenW / 2, screenH), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
