import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class AppData {

  static Future<List<dynamic>> getServers() async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/data.json');

    if (await file.exists()) {
      String jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    } else {
      return [];
    }
  } catch (error) {
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
      return false;
    }
  }

  static Future<String?> chooseLocalFile() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if(result != null) {
      return result.files.single.path;
    }
    return null;
    
  }

  static Future<String?> chooseLocalDir() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    return result;
  }
}