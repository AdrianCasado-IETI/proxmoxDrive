import 'package:dartssh2/dartssh2.dart';
import 'dart:io';

class FileManager {
  final SSHClient client;

  FileManager(this.client);

  // Lista archivos y carpetas en un directorio remoto
  Future<void> listFiles(String remotePath) async {
    try {
      final sftp = await client.sftp();
      final entries = await sftp.listDirectory(remotePath);

      print("📂 Contenido de $remotePath:");

      for (final entry in entries) {
        print(entry.filename);
      }
    } catch (e) {
      print("❌ Error listando archivos: $e");
    }
  }

  // Cambia el nombre de un archivo o carpeta
  Future<void> renameFile(String oldPath, String newPath) async {
    try {
      final sftp = await client.sftp();
      await sftp.rename(oldPath, newPath);
      print("✅ Archivo renombrado: $oldPath -> $newPath");
    } catch (e) {
      print("❌ Error cambiando el nombre: $e");
    }
  }

  // Descarga un archivo desde el servidor remoto
  Future<void> downloadFile(String remotePath, String localPath) async {
    try {
      final sftp = await client.sftp();
      final remoteFile = await sftp.open(remotePath, mode: SftpFileOpenMode.read);
      final localFile = File(localPath);

      final data = await remoteFile.readBytes();
      await localFile.writeAsBytes(data);
      await remoteFile.close();

      print("✅ Archivo descargado con éxito: $remotePath -> $localPath");
    } catch (e) {
      print("❌ Error descargando archivo: $e");
    }
  }

  // Elimina un archivo o carpeta en el servidor remoto
  Future<void> deleteFile(String remotePath) async {
    try {
      final sftp = await client.sftp();
      await sftp.remove(remotePath);
      print("✅ Archivo eliminado: $remotePath");
    } catch (e) {
      print("❌ Error eliminando archivo: $e");
    }
  }

  // Muestra información detallada de un archivo o carpeta
  Future<void> getFileInfo(String remotePath) async {
    try {
      final sftp = await client.sftp();
      final stat = await sftp.stat(remotePath);

      print("📄 Información del archivo:");
      print("- Tamaño: ${stat.size} bytes");
      print("- Permisos: ${stat.mode.toRadixString(8)}");
      print("- Última modificación: ${DateTime.fromMillisecondsSinceEpoch(stat.mtime * 1000)}");
    } catch (e) {
      print("❌ Error obteniendo información del archivo: $e");
    }
  }
}
