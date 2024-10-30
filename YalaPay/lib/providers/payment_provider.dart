import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickmart/models/payment.dart';

class PaymentNotifier extends Notifier<List<Payment>> {
  PaymentNotifier() {
    _initializeState();
  }

  @override
  List<Payment> build() {
    return [];
  }

  Future<void> _initializeState() async {
    try {
      final data = await rootBundle.loadString('assets/data/payments.json');
      final paymentsMap = jsonDecode(data) as List;
      for (var payment in paymentsMap) {
        addPayment(Payment.fromJson(payment));
      }
      print("Data loaded into memory from JSON file.");
    } catch (e) {
      print('Error initializing invoices: $e');
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/payments.json');
  }

  Future<void> savePaymentsToFile() async {
    try {
      final file = await _getLocalFile();
      final jsonData =
          jsonEncode(state.map((payment) => payment.toJson()).toList());
      await file.writeAsString(jsonData);
      print('Payments saved to file at ${file.path}');
    } catch (e) {
      print('Error saving payments to file: $e');
    }
  }
//   Future<List<String>> paymentsModes() async {
//   try {
//     final file = File('payment-modes.json');
//     final jsonString = await file.readAsString();
//     final List<String> stringList = List<String>.from(jsonDecode(jsonString));

//     return stringList;
//   } catch (e) {
//     print("Error reading string list from JSON file: $e");
//     return [];
//   }
// }

  void addPayment(Payment payment) {
    state = [...state, payment];
  }

  void updatePayment(Payment updatedPayment) {
    state = state.map((payment) {
      return payment.id == updatedPayment.id ? updatedPayment : payment;
    }).toList();
  }

  void deletePayment(String id) {
    state = state.where((payment) => payment.id != id).toList();
  }

  List<Payment> searchPayments(String query) {
    if (query.isEmpty) {
      return state;
    }
    return state.where((payment) {
      //chech search method
      return payment.id.toLowerCase().contains(query.toLowerCase()) ||
          payment.id.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

final paymentNotifierProvider =
    NotifierProvider<PaymentNotifier, List<Payment>>(() => PaymentNotifier());
