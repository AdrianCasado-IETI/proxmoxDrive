import 'package:flutter/material.dart';
import 'package:proxmox_drive/pages/home.dart';
import 'package:proxmox_drive/pages/login.dart';
import 'package:proxmox_drive/ssh_conn.dart';
import '/widgets/server_status_light.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _loggedIn = false;
  bool isRunning = true; // Estado del servidor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _loggedIn
          ? Home(
              onLogOut: () {
                print("Logged out");
                setState(() {
                  SSHConn instance = SSHConn.getInstance();
                  instance.disconnect();
                  _loggedIn = false;
                });
              },
            )
          : Login(
              onLogin: () {
                setState(() {
                  _loggedIn = true;
                });
              },
            ),
      builder: (context, child) {
        return Stack(
          children: [
            child ?? Container(),
            if (isRunning)
              Align(
                alignment: Alignment.bottomCenter,
                child: ServerStatusWidget(
                  serverName: "NodeJS",
                  port: 3000,
                  isRunning: isRunning,
                ),
              ),
          ],
        );
      },
    );
  }
}
