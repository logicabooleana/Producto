import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const int _DefaultDashes = 20;
const List<Color> _DefaultGradient = [Color.fromRGBO(129, 52, 175, 1.0)];
const double _DefaultGapSize = 3.0;
const double _DefaultStrokeWidth = 2.0;

class DashedCircle extends StatelessWidget {
  final int dashes;
  final List<Color> gradientColor;
  final double gapSize;
  final double strokeWidth;
  final Widget child;

  DashedCircle(
      {this.child,
      this.dashes = _DefaultDashes,
      this.gradientColor = _DefaultGradient,
      this.gapSize = _DefaultGapSize,
      this.strokeWidth = _DefaultStrokeWidth});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedCirclePainter(
        gradientColor: gradientColor,
          dashes: dashes,
          gapSize: gapSize,
          strokeWidth: strokeWidth),
      child: child,
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final int dashes;
  final List<Color> gradientColor;
  final double gapSize;
  final double strokeWidth;

  DashedCirclePainter(
      {this.dashes = _DefaultDashes,
      this.gradientColor = _DefaultGradient,
      this.gapSize = _DefaultGapSize,
      this.strokeWidth = _DefaultStrokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final double gap = pi / 180 * gapSize;
    final double singleAngle = (pi * 2) / dashes;

    // create a bounding square, based on the centre and radius of the arc
    Rect rect = new Rect.fromCircle(
      center: new Offset(165.0, 55.0),
      radius: 190.0,
    );


    for (int i = 0; i < dashes; i++) {
      final Paint paint = Paint()
        ..shader = RadialGradient(colors: gradientColor).createShader(rect)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawArc(Offset.zero & size, gap + singleAngle * i,
          singleAngle - gap * 1, false, paint);
    }
  }

  @override
  bool shouldRepaint(DashedCirclePainter oldDelegate) {
    return dashes != oldDelegate.dashes ;
  }
}
