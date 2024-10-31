import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/payment.dart'; // Adjust the import as needed

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
      print("Payments loaded into memory from JSON file.");
    } catch (e) {
      print('Error initializing payments: $e');
    }
  }

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
      return payment.amount.toLowerCase().contains(query.toLowerCase()) ||
          payment.paymentDate.toLowerCase().contains(query.toLowerCase()) ||
          payment.paymentMode.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void chooseInvoice(String invoiceId) {
    final filteredPayments =
        state.where((payment) => payment.invoiceNo == invoiceId).toList();
    state = filteredPayments;
  }
}

final paymentNotifierProvider =
    NotifierProvider<PaymentNotifier, List<Payment>>(() => PaymentNotifier());
