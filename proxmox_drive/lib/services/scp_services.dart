import 'dart:io';
import 'package:dartssh2/dartssh2.dart';

class SCPService {
  late SSHClient client;
  final String serverName;
  final String serverAddress;
  final int port;
  final String privateKeyPath;

  SCPService._({
    required this.serverName,
    required this.serverAddress,
    required this.port,
    required this.privateKeyPath,
  });

  static Future<SCPService> create({
    required String serverName,
    required String serverAddress,
    required int port,
    required String privateKeyPath,
  }) async {
    SCPService instance = SCPService._(
      serverName: serverName,
      serverAddress: serverAddress,
      port: port,
      privateKeyPath: privateKeyPath,
    );

    await instance._connect();
    return instance;
  }

  Future<void> _connect() async {
    print("Conectando a $serverAddress:$port como $serverName...");

    try {
      final socket = await SSHSocket.connect(serverAddress, port).timeout(Duration(seconds: 10));

      final privateKeyContent = await File(privateKeyPath).readAsString();
      final identity = (await SSHKeyPair.fromPem(privateKeyContent)).first;

      client = SSHClient(
        socket,
        username: serverName,
        identities: [identity],
      );

      print("Conexión SSH establecida para SCP.");
    } catch (e) {
      print("Error conectando al servidor SCP: $e");
    }
  }

  Future<void> uploadFile(String localPath, String remotePath) async {
    try {
      final localFile = File(localPath);
      if (!await localFile.exists()) {
        throw FileSystemException("El archivo local no existe", localPath);
      }

      final sftp = await client.sftp();
      final remoteFile = await sftp.open(remotePath, mode: SftpFileOpenMode.create | SftpFileOpenMode.write);

      final bytes = await localFile.readAsBytes();
      await remoteFile.write(Stream.value(bytes));
      await remoteFile.close();

      print("Archivo subido con éxito: $localPath -> $remotePath");
    } catch (e) {
      print("Error subiendo archivo: $e");
    }
  }

  Future<void> downloadFile(String remotePath, String localPath) async {
    try {
      final sftp = await client.sftp();
      final remoteFile = await sftp.open(remotePath, mode: SftpFileOpenMode.read);
      final localFile = File(localPath);

      final data = await remoteFile.readBytes();
      await localFile.writeAsBytes(data);
      await remoteFile.close();

      print("Archivo descargado con éxito: $remotePath -> $localPath");
    } catch (e) {
      print("Error descargando archivo: $e");
    }
  }

  void disconnect() {
    print("Desconectando SCP...");
    client.close();
  }
}
