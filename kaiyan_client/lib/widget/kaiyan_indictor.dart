import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KaiyanIndictor extends Decoration {

//  final double w;
  @override
  BoxPainter createBoxPainter([onChanged]) {
    return _KaiyanIndictorPainter();
  }
}

class _KaiyanIndictorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint();
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;

    final w = 30.0;
    final h = 3.0;

    canvas.drawRect(
        Rect.fromLTWH(offset.dx - w/2 + configuration.size.width/2, configuration.size.height - h,  w, h),
        paint);
  }

}