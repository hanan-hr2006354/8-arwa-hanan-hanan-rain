import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bankProvider = FutureProvider<List<String>>((ref) async {
  final String data = await rootBundle.loadString('assets/data/banks.json');
  final List<dynamic> jsonList = jsonDecode(data);
  return jsonList.map((e) => e as String).toList();
});
