import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KaiyanIndictor extends Decoration {

  final double w;
  final Color color;

  KaiyanIndictor({this.w = 30.0, this.color = Colors.black});

  @override
  BoxPainter createBoxPainter([onChanged]) {
    return _KaiyanIndictorPainter(w: w, color: color);
  }
}

class _KaiyanIndictorPainter extends BoxPainter {

  final double w;
  final Color color;


  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint();
    paint.color = this.color;
    paint.style = PaintingStyle.fill;
    final h = 3.0;
    canvas.drawRect(
        Rect.fromLTWH(offset.dx - this.w/2 + configuration.size.width/2, configuration.size.height - h,  w, h),
        paint);
  }

  _KaiyanIndictorPainter({this.w = 30.0, this.color = Colors.black});

}