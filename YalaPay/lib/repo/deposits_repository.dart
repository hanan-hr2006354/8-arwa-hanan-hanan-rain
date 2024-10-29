import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DepositsRepository {
  Future<String> get _depositsFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return 'assets/data/cheque-deposits.json';
  }

  // Load all deposits from the JSON file
  Future<List<Map<String, dynamic>>> loadDeposits() async {
    try {
      final path = await _depositsFilePath;
      final depositsData = await File(path).readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(depositsData));
    } catch (e) {
      print("Error loading deposits: $e");
      return [];
    }
  }

  // Delete a deposit by ID
  Future<void> deleteDeposit(String id) async {
    try {
      final path = await _depositsFilePath;
      final file = File(path);
      final depositsData = await file.readAsString();
      List depositsJson = jsonDecode(depositsData);

      depositsJson.removeWhere((deposit) => deposit['id'] == id);

      await file.writeAsString(jsonEncode(depositsJson), mode: FileMode.write, flush: true);
    } catch (e) {
      print("Error deleting deposit: $e");
    }
  }
}

final depositsRepositoryProvider = Provider((ref) => DepositsRepository());
