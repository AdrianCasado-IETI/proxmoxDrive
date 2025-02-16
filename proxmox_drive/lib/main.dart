import 'package:flutter/material.dart';
import 'services/ssh_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MainApp());
}

  String output = await ssh.executeCommand("ls -l /var/lib/lxc/");
  print("📂 Archivos en el servidor:\n$output");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: const Login()
    );
  }
}
