import 'package:flutter/material.dart';
import '/widgets/server_status_light.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ServerScreen(),
    );
  }
}

class ServerScreen extends StatefulWidget {
  @override
  _ServerScreenState createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Estado del Servidor")),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isRunning = !isRunning; 
                });
              },
              child: Text(isRunning ? "Detener Servidor" : "Iniciar Servidor"),
            ),
          ),
          if (isRunning)
            ServerStatusWidget(
              serverName: "NodeJS",
              port: 3000,
              isRunning: isRunning,
            ),
        ],
      ),
    );
  }
}
