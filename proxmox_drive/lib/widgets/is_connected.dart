import 'package:flutter/material.dart';

class IsConnected extends StatelessWidget {

  final bool isConnected;
  final Function onClick;

  const IsConnected({
    super.key,
    required this.isConnected,
    required this.onClick
  });


  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onClick();
        },
        child: SizedBox(
          height: 24,
          width: 24,
          child: CustomPaint(
            painter: IsConnectedPainter(isConnected: isConnected),
            size: const Size(12, 12),
          ),
        ),
      ),
    );
  }

}

class IsConnectedPainter extends CustomPainter {

  final bool isConnected;
  const IsConnectedPainter({
    required this.isConnected
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isConnected ? Colors.green : Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, 12, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}