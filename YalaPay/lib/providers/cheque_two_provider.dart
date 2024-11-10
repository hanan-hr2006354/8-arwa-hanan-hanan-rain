// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:quickmart/models/chequeTwo.dart';

// class ChequeTwoNotifier extends StateNotifier<List<ChequeTwo>> {
//   ChequeTwoNotifier() : super([]); // Initial state of the cheques list

//   // Load cheques from a JSON file
//   Future<void> loadCheques() async {
//     try {
//       final String response =
//           await rootBundle.loadString('assets/data/cheques.json');
//       final List<dynamic> data = json.decode(response);
//       state = data.map((json) => ChequeTwo.fromJson(json)).toList();
//     } catch (e) {
//       // Handle error (e.g., log the error, show a message)
//       print('Error loading cheques: $e');
//     }
//   }

//   // Add a new cheque to the list
//   void addCheque(ChequeTwo newCheque) {
//     state = [...state, newCheque];
//   }

//   // Update an existing cheque in the list
//   void updateCheque(ChequeTwo updatedCheque) {
//     state = state.map((cheque) {
//       return cheque.chequeNo == updatedCheque.chequeNo ? updatedCheque : cheque;
//     }).toList();
//   }

//   List<ChequeTwo> searchByChequeNo(int? chequeNo) {
//     if (chequeNo == null) return []; // Return an empty list if chequeNo is null
//     return state.where((cheque) => cheque.chequeNo == chequeNo).toList();
//   }
// }

// final chequetwoNotifierProvider =
//     StateNotifierProvider<ChequeTwoNotifier, List<ChequeTwo>>(
//   (ref) => ChequeTwoNotifier(),
// );
