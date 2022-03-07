import 'package:breathe/models/recognitions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BndBox extends StatelessWidget {
  final List<Recognition> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  const BndBox(this.results, this.previewH, this.previewW, this.screenH, this.screenW,);

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBoxes() {
      return results.map((re) {
        var _x = re.location.left;
        var _w = re.location.width;
        var _y = re.location.top;
        var _h = re.location.height;
        var scaleW, scaleH, x, y, w, h;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
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
                color: const Color.fromRGBO(37, 213, 253, 1.0),
                width: 3.0,
              ),
            ),
            child: Text(
              "${re.label} ${(re.score * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList();
    }

    return Stack(
      children: _renderBoxes(),
    );
  }
}