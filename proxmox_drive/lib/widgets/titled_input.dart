import 'package:flutter/material.dart';

class TitledInput extends StatefulWidget {

  final String title;
  final String? value;
  Function(String) callback;

  TitledInput({
    super.key,
    required this.title,
    required this.value,
    required this.callback
  });

  @override
  State<TitledInput> createState() => _TitledInputState();
}

class _TitledInputState extends State<TitledInput> {

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value ?? "";
  }

  @override
  void didUpdateWidget(covariant TitledInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.value != widget.value) {
      setState(() {
        _controller.text = widget.value ?? "";
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomPaint(
            painter: TitledInputPainter(),
            child: const SizedBox(
              width: 300,
              height: 30, 
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          child: Text(
            "${widget.title}:",
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(
          width: 300, 
          height: 30, 
          child: TextField(
            controller: _controller,
            onChanged: (value) {widget.callback(value);},
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 100, bottom: 5),
            ),
          ),
        ),
      ],
);

  }
}

class TitledInputPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 211, 211, 211)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const rect = Rect.fromLTWH(0, 0, 300, 30);
    final rrect = RRect.fromRectAndRadius(
      rect, 
      const Radius.circular(10)
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}