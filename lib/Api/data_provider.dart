// // data_provider.
//
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';
//
// final dataProvider = FutureProvider<List<dynamic>>((ref) async {
//   final String response = await rootBundle.loadString('assets/data.json');
//   final data = await json.decode(response);
//   return data;
// });
