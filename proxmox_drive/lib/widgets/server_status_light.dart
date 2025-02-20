import 'package:flutter/material.dart';

class ServerStatusWidget extends StatelessWidget {
  final String serverName;
  final int port;
  final bool isRunning;

  const ServerStatusWidget({
    super.key,
    required this.serverName,
    required this.port,
    required this.isRunning,
  });

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
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isRunning ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8), 
            Text(
              "Servidor $serverName funcionando en el puerto $port",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
