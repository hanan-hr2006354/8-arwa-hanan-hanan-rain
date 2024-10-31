import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../models/payment.dart';

class PaymentRepository {
  Future<String> get _paymentsFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return 'assets/data/payments.json';
  }

  Future<void> resetData() async {
    final path = await _paymentsFilePath;
    await File(path).writeAsString(jsonEncode([]));
  }

  Future<List<Payment>> loadPayments() async {
    try {
      final path = await _paymentsFilePath;
      final paymentsData = await File(path).readAsString();
      final List paymentsJson = jsonDecode(paymentsData);
      return paymentsJson.map((json) => Payment.fromJson(json)).toList();
    } catch (e) {
      print("Error loading payments: $e");
      return [];
    }
  }

  Future<void> savePayments(List<Payment> payments) async {
    final path = await _paymentsFilePath;
    final paymentsJson = payments.map((payment) => payment.toJson()).toList();
    await File(path).writeAsString(jsonEncode(paymentsJson),
        mode: FileMode.write, flush: true);
  }

  Future<void> addPayment(Payment payment) async {
    try {
      final path = await _paymentsFilePath;
      final file = File(path);
      final paymentsData = await file.readAsString();
      List paymentsJson = jsonDecode(paymentsData);
      paymentsJson.add(payment.toJson());
      await file.writeAsString(jsonEncode(paymentsJson),
          mode: FileMode.write, flush: true);
    } catch (e) {
      print("Error adding payment: $e");
    }
  }

  Future<void> updatePayment(Payment updatedPayment) async {
    try {
      final path = await _paymentsFilePath;
      final file = File(path);
      final paymentsData = await file.readAsString();
      List paymentsJson = jsonDecode(paymentsData);

      final index = paymentsJson
          .indexWhere((payment) => payment['id'] == updatedPayment.id);
      if (index != -1) {
        paymentsJson[index] = updatedPayment.toJson();
        await file.writeAsString(jsonEncode(paymentsJson),
            mode: FileMode.write, flush: true);
      }
    } catch (e) {
      print("Error updating payment: $e");
    }
  }

  Future<void> deletePayment(String id) async {
    try {
      final path = await _paymentsFilePath;
      final file = File(path);
      final paymentsData = await file.readAsString();
      List paymentsJson = jsonDecode(paymentsData);
      final updatedPayments =
          paymentsJson.where((payment) => payment['id'] != id).toList();
      await file.writeAsString(jsonEncode(updatedPayments),
          mode: FileMode.write, flush: true);
    } catch (e) {
      print("Error deleting payment: $e");
    }
  }

    Future<List<Payment>> searchPayments(String query) async {
    final payments = await loadPayments();
    if (query.isEmpty) {
      return payments;
    }
    return payments.where((payment) {
      return (payment.invoiceNo.toLowerCase() ?? '').contains(query.toLowerCase()) ||
            (payment.chequeNo?.toString().toLowerCase() ?? '').contains(query.toLowerCase());
    }).toList();
  }}


final paymentRepositoryProvider = Provider((ref) => PaymentRepository());