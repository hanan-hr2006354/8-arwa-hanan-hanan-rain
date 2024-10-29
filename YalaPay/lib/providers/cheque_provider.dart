// lib/providers/cheque_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/repo/cheque_repository.dart';
import '../models/cheque.dart';

class ChequeNotifier extends StateNotifier<List<Cheque>> {
  ChequeNotifier(this._repository) : super([]);

  final ChequeRepository _repository;

  // Reset environment and reload cheques from JSON
  Future<void> resetAndLoadCheques() async {
    await _repository.resetData(); // Reset all data
    state = await _repository.loadCheques(); // Load fresh data
  }

  Future<void> createDeposit(List<Cheque> selectedCheques, String bankAccountNo) async {
    await _repository.createDeposit(selectedCheques, bankAccountNo);
    state = await _repository.loadCheques(); // Reload data after update
  }
}

final chequeProvider = StateNotifierProvider<ChequeNotifier, List<Cheque>>((ref) {
  final repository = ref.watch(chequeRepositoryProvider);
  return ChequeNotifier(repository);
});
