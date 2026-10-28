// Template-derived GET boundary. Only local json-server reads.
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

const demoState = String.fromEnvironment('DEMO_STATE');
String get apiBase {
  const override = String.fromEnvironment('API_BASE');
  if (override.isNotEmpty) return override;
  return !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:3000'
      : 'http://localhost:3000';
}

typedef ItemsLoader = Future<List<Item>> Function();
Future<List<Item>> fetchItems() async {
  if (demoState == 'loading' || demoState == 'slow') {
    await Future<void>.delayed(const Duration(seconds: 3));
  }
  if (demoState == 'error') throw Exception('demo');
  if (demoState == 'empty') return [];
  final response = await http
      .get(Uri.parse('$apiBase/items'))
      .timeout(const Duration(seconds: 5));
  if (response.statusCode != 200) {
    throw Exception('HTTP ${response.statusCode}');
  }
  return (jsonDecode(utf8.decode(response.bodyBytes)) as List)
      .map((j) => Item.fromJson(j as Map<String, dynamic>))
      .toList();
}
