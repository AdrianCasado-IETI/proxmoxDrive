import 'dart:io';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';

class SSHService {
  late SSHClient client;
  final String serverName;
  final String serverAddress;
  final int port;
  final String privateKeyPath;

  // Constructor
  SSHService._({
    required this.serverName,
    required this.serverAddress,
    required this.port,
    required this.privateKeyPath,
  });

  // Método estático para inicializar SSH correctamente
  static Future<SSHService> create({
    required String serverName,
    required String serverAddress,
    required int port,
    required String privateKeyPath,
  }) async {
    SSHService instance = SSHService._(
      serverName: serverName,
      serverAddress: serverAddress,
      port: port,
      privateKeyPath: privateKeyPath,
    );

    await instance._connect();
    return instance;
  }

  // Método privado para inicializar la conexión SSH con timeout
  Future<void> _connect() async {
    print("🔌 Conectando a $serverAddress:$port con usuario $serverName...");
    
    try {
      final socket = await SSHSocket.connect(serverAddress, port).timeout(Duration(seconds: 10));

      // Leer la clave privada
      final privateKeyContent = await File(privateKeyPath).readAsString();
      final identity = (await SSHKeyPair.fromPem(privateKeyContent)).first;

      client = SSHClient(
        socket,
        username: serverName,
        identities: [identity],
      );

      print("✅ Conexión SSH establecida con éxito.");
    } catch (e) {
      print("❌ Error conectando al servidor SSH: $e");
    }
  }

  // Método para ejecutar comandos remotos
  Future<String> executeCommand(String command) async {
    try {
      print("⌨️ Ejecutando comando: $command");
      final result = await client.run(command);
      return String.fromCharCodes(result);
    } catch (e) {
      return '❌ Error ejecutando comando: $e';
    }
  }

  // Método para cerrar la conexión SSH
  void disconnect() {
    print("🔌 Desconectando SSH...");
    client.close();
  }
}
