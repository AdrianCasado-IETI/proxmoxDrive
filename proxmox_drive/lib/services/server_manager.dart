import 'package:dartssh2/dartssh2.dart';

class ServerManager {
  final SSHClient client;

  ServerManager(this.client);

  Future<String?> detectServer(String remotePath) async {
    try {
      String output = await executeCommand("ls $remotePath");
      if (output.contains("package.json")) {
        return "node";
      } else if (output.contains(".jar")) {
        return "java";
      }
      return null;
    } catch (e) {
      print("Error detectando servidor: $e");
      return null;
    }
  }

  Future<bool> isServerRunning(int port) async {
    try {
      String output = await executeCommand("netstat -tulnp | grep :$port");
      return output.isNotEmpty;
    } catch (e) {
      print("Error verificando el servidor: $e");
      return false;
    }
  }

  Future<void> startServer(String type, String remotePath, int port) async {
    try {
      if (type == "node") {
        await executeCommand("nohup node $remotePath/server.js > /dev/null 2>&1 &");
      } else if (type == "java") {
        await executeCommand("nohup java -jar $remotePath/app.jar > /dev/null 2>&1 &");
      }
      print("Servidor $type iniciado en el puerto $port.");
    } catch (e) {
      print("Error iniciando el servidor: $e");
    }
  }

  Future<void> stopServer(int port) async {
    try {
      await executeCommand("fuser -k $port/tcp");
      print("Servidor detenido en el puerto $port.");
    } catch (e) {
      print("Error deteniendo el servidor: $e");
    }
  }

  Future<void> restartServer(String type, String remotePath, int port) async {
    await stopServer(port);
    await startServer(type, remotePath, port);
  }

  Future<void> setupPortForwarding(String remoteHost, int remotePort, int localPort) async {
    try {
      await client.forwardLocal(remoteHost, remotePort, localHost: 'localhost', localPort: localPort);
      print("Redirección de puerto creada: localhost:$localPort -> $remoteHost:$remotePort");
    } catch (e) {
      print("Error configurando la redirección de puertos: $e");
    }
  }

  Future<String> executeCommand(String command) async {
    final result = await client.run(command);
    return String.fromCharCodes(result);
  }
}
