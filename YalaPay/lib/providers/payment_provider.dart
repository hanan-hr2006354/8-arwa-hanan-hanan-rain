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
    return []; // Initial state is an empty list
  }

  Future<void> _initializeState() async {
    try {
      final data = await rootBundle.loadString('assets/data/payments.json');
      final List<dynamic> paymentsMap = jsonDecode(data);
      state = paymentsMap.map((payment) => Payment.fromJson(payment)).toList();
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

  void deleteAllPayments() {
    state = [];
  }

  Payment? getPaymentById(String id) {
    return state.firstWhere((payment) => payment.id == id);
  }

  void deletePayment(String id) {
    state = state.where((payment) => payment.id != id).toList();
  }

  List<Payment> getFilteredPayments(String query, String? selectedInvoiceId) {
    return state.where((payment) {
      final matchesInvoice =
          selectedInvoiceId == null || payment.invoiceNo == selectedInvoiceId;
      final matchesQuery = query.isEmpty ||
          payment.invoiceNo.toLowerCase().contains(query.toLowerCase()) ||
          payment.amount
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          payment.paymentMode.toLowerCase().contains(query.toLowerCase());

      return matchesInvoice && matchesQuery;
    }).toList();
  }

  List<String> paymentModes = [];

  Future<List<String>> loadPaymentModes() async {
    try {
      final String response =
          await rootBundle.loadString('assets/payment-modes.json');
      final data = json.decode(response);
      paymentModes = List<String>.from(data['payment_modes']);
      return paymentModes;
    } catch (e) {
      print('Error initializing invoices: $e');
      return [];
    } // Return the list of payment modes
  }

  List<String> getPaymentModes() {
    return paymentModes;
  }
}

final paymentNotifierProvider =
    NotifierProvider<PaymentNotifier, List<Payment>>(() => PaymentNotifier());
