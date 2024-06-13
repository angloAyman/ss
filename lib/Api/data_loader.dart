import 'dart:convert';
import 'package:flutter/services.dart';

class DataLoader {
  Future<List<dynamic>> loadJsonData() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    return data;
  }
}
