import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/cheque.dart';
import 'package:quickmart/models/chequeTwo.dart'; // Ensure you have the ChequeTwo model imported

class CheckTwoNotifier extends Notifier<List<ChequeTwo>> {
  CheckTwoNotifier() {
    _initializeState();
  }

  @override
  List<ChequeTwo> build() {
    return [];
  }

  Future<void> _initializeState() async {
    try {
      final data = await rootBundle.loadString('assets/data/cheques.json');
      final chequesMap = jsonDecode(data) as List;
      for (var cheque in chequesMap) {
        addCheque(ChequeTwo.fromJson(cheque));
      }
      print("Data loaded into memory from JSON file.");
    } catch (e) {
      print('Error initializing cheques: $e');
    }
  }

  void addCheque(ChequeTwo cheque) {
    state = [...state, cheque];
  }

  void updateCheque(ChequeTwo updatedCheque) {
    state = state.map((cheque) {
      return cheque.chequeNo == updatedCheque.chequeNo ? updatedCheque : cheque;
    }).toList();
  }

  void deleteCheque(int chequeNo) {
    state = state.where((cheque) => cheque.chequeNo != chequeNo).toList();
  }

  List<ChequeTwo> searchCheques(String query) {
    if (query.isEmpty) {
      return state;
    }
    return state.where((cheque) {
      return cheque.drawer.toLowerCase().contains(query.toLowerCase()) ||
          cheque.chequeNo.toString().contains(query);
    }).toList();
  }

  ChequeTwo searchByChequeNo(int chequeNo) {
    final exists = state.any((cheque) => cheque.chequeNo == chequeNo);

    if (exists) {
      return state.firstWhere((cheque) => cheque.chequeNo == chequeNo);
    } else {
      return ChequeTwo(
        chequeNo: chequeNo,
        amount: 0.0,
        drawer: "unknown",
        bankName: "unknown",
        status: "unknown",
        receivedDate: DateTime.now(),
        dueDate: DateTime.now(),
        chequeImageUri: "unknown",
      );
    }
  }
}

final checkTwoNotifierProvider =
    NotifierProvider<CheckTwoNotifier, List<ChequeTwo>>(
        () => CheckTwoNotifier());
