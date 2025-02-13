import 'package:flutter/material.dart';

class TitledInput extends StatefulWidget {
  @override
  State<TitledInput> createState() => _TitledInputState();
}

class _TitledInputState extends State<TitledInput> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: TitledInputPainter(),
        )
      ],
    );
  }
}

class TitledInputPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

}