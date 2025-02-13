import 'dart:convert';

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
}