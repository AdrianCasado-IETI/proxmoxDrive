import 'package:flutter/material.dart';
import 'package:proxmox_drive/pages/home.dart';
import 'package:proxmox_drive/pages/login.dart';
import 'package:proxmox_drive/ssh_conn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: _loggedIn ? Home(
        onLogOut: () {
          setState(() {
            SSHConn instance = SSHConn.getInstance();
            instance.disconnect();
            _loggedIn = false;
          });
        },
      ) : Login(
        onLogin: () {
          setState(() {
            _loggedIn = true;
          });
        },
      )
    );
  }
}
