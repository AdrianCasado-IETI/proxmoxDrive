import 'package:flutter/material.dart';
import 'services/ssh_services.dart';
import 'services/server_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("🚀 Iniciando conexión SSH...");

  SSHService ssh = await SSHService.create(
    serverName: "root",
    serverAddress: "192.168.1.100",
    port: 22,
    privateKeyPath: "/ruta/a/id_rsa",
  );

  print("✅ Conexión establecida. Ejecutando comando...");

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
