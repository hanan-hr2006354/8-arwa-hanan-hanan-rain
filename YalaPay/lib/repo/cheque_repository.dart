// lib/repo/cheque_repository.dart

import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Ensure this import is added
import '../models/cheque.dart';

class ChequeRepository {
  Future<String> get _chequesFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return 'assets/data/cheques.json';
  }

  Future<String> get _depositsFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return 'assets/data/cheque-deposits.json';
  }

  // Force clean environment by resetting cheques.json and cheque-deposits.json
  Future<void> resetData() async {
    final chequesPath = await _chequesFilePath;
    final depositsPath = await _depositsFilePath;

    await File(chequesPath).writeAsString(jsonEncode([]));
    await File(depositsPath).writeAsString(jsonEncode([]));
  }

  Future<List<Cheque>> loadCheques() async {
    try {
      final path = await _chequesFilePath;
      final chequesData = await File(path).readAsString();
      final List chequesJson = jsonDecode(chequesData);
      return chequesJson.map((json) => Cheque.fromJson(json)).toList();
    } catch (e) {
      print("Error loading cheques: $e");
      return [];
    }
  }

  Future<void> createDeposit(List<Cheque> selectedCheques, String bankAccountNo) async {
    final depositDate = DateTime.now();
    final newDepositId = DateTime.now().millisecondsSinceEpoch.toString();
    final selectedChequeNos = selectedCheques.map((cheque) => cheque.chequeNo).toList();

    await _updateChequesStatus(selectedChequeNos);

    final newDeposit = {
      "id": newDepositId,
      "depositDate": depositDate.toIso8601String(),
      "bankAccountNo": bankAccountNo,
      "status": "Deposited",
      "chequeNos": selectedChequeNos,
    };
    await _appendDepositToFile(newDeposit);
  }

  Future<void> _updateChequesStatus(List<int> selectedChequeNos) async {
    try {
      final path = await _chequesFilePath;
      final file = File(path);
      final chequesData = await file.readAsString();
      List chequesJson = jsonDecode(chequesData);

      chequesJson = chequesJson.map((cheque) {
        if (selectedChequeNos.contains(cheque['chequeNo'])) {
          cheque['status'] = "Deposited";
        }
        return cheque;
      }).toList();

      await file.writeAsString(jsonEncode(chequesJson), mode: FileMode.write, flush: true);
    } catch (e) {
      print("Error updating cheques.json: $e");
    }
  }

  Future<void> _appendDepositToFile(Map<String, dynamic> newDeposit) async {
    try {
      final path = await _depositsFilePath;
      final file = File(path);
      final depositsData = await file.readAsString();
      List depositsJson = jsonDecode(depositsData);
      depositsJson.add(newDeposit);

      await file.writeAsString(jsonEncode(depositsJson), mode: FileMode.write, flush: true);
    } catch (e) {
      print("Error writing to cheque-deposits.json: $e");
    }
  }

  void debugFileContent() async {
    final path = await _chequesFilePath;
    final chequesData = await File(path).readAsString();
    print("Cheques JSON content: $chequesData");
  }
}

// Define the provider
final chequeRepositoryProvider = Provider((ref) => ChequeRepository());
