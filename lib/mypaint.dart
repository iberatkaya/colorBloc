import 'package:flutter/material.dart';

class MyPaint extends CustomPainter {
  List<Color> colors = [];
  int space = 0;
  MyPaint({@required this.colors, @required this.space});
  @override
  void paint(Canvas canvas, Size size) {
    int maxRadius = size.height ~/ 16 * 7;
    int ctr = 0;
    for (var color in colors) {
      var paint = Paint();
      paint.color = color;
      print(color);
      print(space);
      print(ctr);
      paint.strokeWidth = 1;
      var path = Path();
      print((maxRadius - space * ctr).toDouble());
      if ((maxRadius - space * ctr) > 0) {
        path.addOval(Rect.fromCircle(
            center: size.topCenter(Offset(0, size.height / 16 * 5)),
            radius: (maxRadius - space * ctr).toDouble()));
        canvas.drawPath(path, paint);
      }
      ctr++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
