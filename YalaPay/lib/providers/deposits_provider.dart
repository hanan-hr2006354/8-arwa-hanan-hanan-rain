import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/repo/deposits_repository.dart';

// Provider for DepositsRepository
final depositsRepositoryProvider = Provider((ref) => DepositsRepository());

// StateNotifier for managing deposits state
class DepositsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final DepositsRepository depositsRepository;

  DepositsNotifier(this.depositsRepository) : super([]) {
    loadDeposits(); // Load deposits initially
  }

  // Load deposits from the repository and update the state
  Future<void> loadDeposits() async {
    final deposits = await depositsRepository.loadDeposits();
    state = deposits;
  }

  // Delete a deposit by ID, update the repository and state
  Future<void> deleteDeposit(String id) async {
    await depositsRepository.deleteDeposit(id);
    // Remove the deleted deposit from the state
    state = state.where((deposit) => deposit['id'] != id).toList();
  }

  // Refresh deposits from the repository
  Future<void> refreshDeposits() async {
    await loadDeposits();
  }
}

// Provider for managing deposits state
final depositsProvider = StateNotifierProvider<DepositsNotifier, List<Map<String, dynamic>>>((ref) {
  final depositsRepository = ref.watch(depositsRepositoryProvider);
  return DepositsNotifier(depositsRepository);
});
