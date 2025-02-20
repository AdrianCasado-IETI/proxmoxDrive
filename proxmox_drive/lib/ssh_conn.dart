import 'dart:io';
import 'package:dartssh2/dartssh2.dart';

class SSHConn {
  static final SSHConn _instance = SSHConn._internal();

  late SSHClient _client;

  bool _isConnected = false;

  SSHConn._internal();

  static SSHConn getInstance() {
    return _instance;
  }

  Future<bool> connect({
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
      print("🔌 Conectando a $serverAddress:$port con usuario $serverName...");

      final socket = await SSHSocket.connect(serverAddress, port).timeout(Duration(seconds: 10));

      final privateKeyContent = await File(privateKeyPath).readAsString();
      final identity = (await SSHKeyPair.fromPem(privateKeyContent)).first;

      _client = SSHClient(
        socket,
        username: serverName,
        identities: [identity],
      );

      _isConnected = true; 

      print("✅ Conexión SSH establecida con éxito.");
      return true;
      
    } catch (e) {
      print("❌ Error conectando al servidor SSH: $e");
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
      return false;
    }
  }

  Future<bool> renameFile(String oldName, String newName) {
    try {
      executeCommand("mv $oldName $newName");
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<bool> unzipFile(String dir, String fileName) {
    try {
      executeCommand("unzip $dir/$fileName -d $dir");
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<bool> executeNodeServer(String dir) async {
    bool existsServer = await findNodeServer(dir);

    if (!existsServer) {
      return false;
    }

    try {
      await executeCommand("cd $dir/server && node server.js");
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<bool> findNodeServer(String dir) async {
  try {
    final packageJsonPath = '$dir/package.json';
    if (!File(packageJsonPath).existsSync()) {
      return false;
    }

    final packageJsonContent = await File(packageJsonPath).readAsString();
    if (!packageJsonContent.contains('dependencies')) {
      return false; 
    }

    final nodeModulesPath = '$dir/node_modules';
    if (Directory(nodeModulesPath).existsSync()) {
      return true;
    }

    if (packageJsonContent.contains('express') || packageJsonContent.contains('http')) {
      return true;
    }

    return false;
  } catch (e) {
    print('Error al verificar el directorio: $e');
    return false;
  }
}
}