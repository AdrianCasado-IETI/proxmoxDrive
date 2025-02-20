import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import '/widgets/error_dialog.dart'; 

class SSHConn {
  static final SSHConn _instance = SSHConn._internal();

  late SSHClient _client;

  bool _isConnected = false;

  SSHConn._internal();

  static SSHConn getInstance() {
    return _instance;
  }

Future<bool> connect({
    required BuildContext context, // Se agrega el contexto para el popup
    required String serverName,
    required String serverAddress,
    required int port,
    required String privateKeyPath,
  }) async {
    if (_isConnected) {
      print("Ya hay una conexión activa.");
      return true;
    }

    try {
      print("Conectando a $serverAddress:$port con usuario $serverName...");

      final socket = await SSHSocket.connect(serverAddress, port)
          .timeout(Duration(seconds: 10));

      final privateKeyContent = await File(privateKeyPath).readAsString();
      final identity = (await SSHKeyPair.fromPem(privateKeyContent)).first;

      _client = SSHClient(
        socket,
        username: serverName,
        identities: [identity],
      );

      _isConnected = true;

      print("Conexión SSH establecida con éxito.");
      return true;

    } catch (e) {
      print("Error conectando al servidor SSH: $e");

      // Muestra el popup de error
      ErrorDialog.show(context, "Error de conexión SSH: ${e.toString()}");

      return false;
    }
  }

  Future<String> executeCommand(String command) async {
    if (!_isConnected) {
      throw Exception("No se ha establecido una conexión SSH válida.");
    }

    try {
      print("⌨️ Ejecutando comando: $command");
      final result = await _client.run(command);
      print(result);
      return String.fromCharCodes(result);
    } catch (e) {
      return '❌ Error ejecutando comando: $e';
    }
  }

  void disconnect() {
    if (!_isConnected) {
      print("No hay ninguna conexión activa para desconectar.");
      return;
    }

    print("🔌 Desconectando SSH...");
    _client.close();
    _isConnected = false; 
  }

  Future<bool> uploadFile(String localPath, String serverPath) async {
    final sftp = await _client.sftp();
    final file = File(localPath);
    if(!file.existsSync()) {
      return false;
    }

    try {
      final remoteFile = await sftp.open("$serverPath/${localPath.split("\\").last.replaceAll(" ", "_")}", mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
      await remoteFile.write(file.openRead().cast());
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> downloadFile(String fileDir, String localPath, [bool? isDir]) async {
    try {
      if(isDir == null || !isDir) {
        final sftp = await _client.sftp();
      
        final sftpFile = await sftp.open(fileDir);
        final fileBytes = await sftpFile.readBytes();
        final localFile = File("$localPath\\${fileDir.split("/").last}");
        
        await localFile.writeAsBytes(fileBytes);

        return true;
      }

      await executeCommand("sudo zip -r ${fileDir}_tmp.zip $fileDir -i $fileDir/*");

      await downloadFile("${fileDir}_tmp.zip", localPath);
      
      await deleteFile("${fileDir}_tmp.zip");

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFile(String fileDir) async {
    try {
      await executeCommand("sudo rm -rf $fileDir");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}