import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class AppData {

  static Future<List<dynamic>> getServers() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data.json');
      return jsonDecode(jsonString);
    } catch(error) {
      return [];
    }
  }

  static Future<bool> saveServer(Map<String, dynamic> server) async {
    try {
      final file = File('assets/data.json');

      List<dynamic> servers = [];
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        servers = jsonDecode(jsonString);
      }

      servers.add(server);

      String updatedJsonString = jsonEncode(servers);

      await file.writeAsString(updatedJsonString);

      return true;
    } catch (error) {
      print('Error al guardar el servidor: $error');
      return false;
    }
  }
}