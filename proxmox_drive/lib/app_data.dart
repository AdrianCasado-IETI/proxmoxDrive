import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppData {

  static Future<List<dynamic>> getServers() async {
  try {
    // Obtener el directorio de documentos
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/data.json');

    if (await file.exists()) {
      String jsonString = await file.readAsString();
      print("Raw: $jsonString");
      return jsonDecode(jsonString);
    } else {
      // Si el archivo no existe, devuelve una lista vacía
      return [];
    }
  } catch (error) {
    print("Error al obtener servidores: $error");
    return [];
  }
}

static Future<bool> saveServer(Map<String, dynamic> server) async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/data.json');

    List<dynamic> servers = [];
    if (await file.exists()) {
      String jsonString = await file.readAsString();
      servers = jsonDecode(jsonString);
    }

    bool exists = false;
    for (int i = 0; i < servers.length; i++) {
      if (server["name"] == servers[i]["name"]) {
        servers[i] = server;
        exists = true;
        break;
      }
    }

    if (!exists) {
      servers.add(server);
    }

    String updatedJsonString = jsonEncode(servers);
    await file.writeAsString(updatedJsonString);
    return true;
  } catch (error) {
    print("Error al guardar servidor: $error");
    return false;
  }
}

  static Future<bool> deleteServer(String serverName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/data.json');  

      List<dynamic> servers = [];
      if(await file.exists()) {
        String jsonString = await file.readAsString();
        servers = jsonDecode(jsonString);
      }

      for(dynamic server in servers) {
        if(server["name"] == serverName) {
          servers.remove(server);
          break;
        }
      }

      await file.writeAsString(jsonEncode(servers));
      return true;
    } catch(error) {
      print("Ha habido un error eliminando: $error");
      return false;
    }
  }
}