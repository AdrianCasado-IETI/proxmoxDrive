import 'package:flutter/material.dart';
import 'services/ssh_services.dart';
import 'services/server_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Iniciando conexión SSH...");

  SSHService ssh = await SSHService.create(
    serverName: "imagia3",
    serverAddress: "ieticloudpro.ieti.cat",
    port: 20127,
    privateKeyPath: "/home/nacro/.ssh/clave",
  );

  print("Conexión establecida. Detectando servidores...");

  ServerManager serverManager = ServerManager(ssh.client);

  String remotePath = "/home/super/ImagIA_Server";
  int remotePort = 3000;
  int localPort = 8080;

  String? serverType = await serverManager.detectServer(remotePath);

  if (serverType != null) {
    bool isRunning = await serverManager.isServerRunning(remotePort);

    if (!isRunning) {
      print("Servidor $serverType no está en ejecución. Iniciando...");
      await serverManager.startServer(serverType, remotePath, remotePort);
    } else {
      print("Servidor $serverType ya está en ejecución en el puerto $remotePort.");
    }

    print("Configurando redirección de puertos...");
    await serverManager.setupPortForwarding("127.0.0.1", remotePort, localPort);
  } else {
    print("No se detectó un servidor NodeJS o Java en $remotePath.");
  }

  ssh.disconnect();
}
