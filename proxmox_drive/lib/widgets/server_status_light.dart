import 'package:flutter/material.dart';

class ServerStatusWidget extends StatelessWidget {
  final String serverName;
  final int port;
  final bool isRunning;

  const ServerStatusWidget({
    Key? key,
    required this.serverName,
    required this.port,
    required this.isRunning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: Size(14, 14),
              painter: StatusLightPainter(isRunning: isRunning),
            ),
            SizedBox(width: 8),
            Text(
              "Servidor $serverName funcionando en el puerto $port",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusLightPainter extends CustomPainter {
  final bool isRunning;

  StatusLightPainter({required this.isRunning});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = isRunning ? Colors.green : Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
