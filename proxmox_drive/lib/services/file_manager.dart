import 'package:dartssh2/dartssh2.dart';
import 'dart:io';

class FileManager {
  final SSHClient client;

  FileManager(this.client);

  // Cambia el nombre de un archivo o carpeta
  Future<void> renameFile(String oldPath, String newPath) async {
    try {
      final sftp = await client.sftp();
      await sftp.rename(oldPath, newPath);
      print("Archivo o carpeta renombrado: $oldPath -> $newPath");
    } catch (e) {
      print("Error al renombrar: $e");
    }
  }

  // Descarga un archivo remoto al sistema local
  Future<void> downloadFile(String remotePath, String localPath) async {
    try {
      final sftp = await client.sftp();
      final remoteFile = await sftp.open(remotePath, mode: SftpFileOpenMode.read);
      final localFile = File(localPath);

      final data = await remoteFile.readBytes();
      await localFile.writeAsBytes(data);
      await remoteFile.close();

      print("Archivo descargado: $remotePath -> $localPath");
    } catch (e) {
      print("Error al descargar archivo: $e");
    }
  }

  // Elimina un archivo o carpeta en el servidor remoto
  Future<void> deleteFile(String remotePath) async {
    try {
      final sftp = await client.sftp();
      await sftp.remove(remotePath);
      print("Archivo o carpeta eliminado: $remotePath");
    } catch (e) {
      print("Error al eliminar archivo: $e");
    }
  }

  // Muestra información del archivo o carpeta, incluyendo permisos
  Future<void> getFileInfo(String remotePath) async {
    try {
      final output = await executeCommand("ls -l $remotePath");
      print("Información del archivo o carpeta:");
      print(output);
    } catch (e) {
      print("Error obteniendo información del archivo: $e");
    }
  }

  // Método auxiliar para ejecutar comandos SSH
  Future<String> executeCommand(String command) async {
    final result = await client.run(command);
    return String.fromCharCodes(result);
  }
}
