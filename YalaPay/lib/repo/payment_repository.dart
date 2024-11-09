import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickmart/models/payment.dart';

class PaymentRepository {
  Future<String> _getPaymentsFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/payments.json';
  }

  Future<List<Payment>> loadPayments() async {
    try {
      final path = await _getPaymentsFilePath();
      final file = File(path);

      if (!(await file.exists())) {
        final assetData =
            await rootBundle.loadString('assets/data/payments.json');
        await file.writeAsString(assetData);
      }

      final data = await file.readAsString();
      final List<dynamic> paymentsMap = jsonDecode(data);
      return paymentsMap.map((payment) => Payment.fromJson(payment)).toList();
    } catch (e) {
      print('Error loading payments: $e');
      return [];
    }
  }

  Future<String> get _paymentsFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return 'assets/data/payments.json';
  }

  // Update a specific payment in the payments.json file
  Future<void> updatePayment(
      String id, Map<String, dynamic> updatedPayment) async {
    try {
      final path = await _paymentsFilePath;
      final file = File(path);
      final paymentsData = await file.readAsString();
      List<Map<String, dynamic>> paymentsList =
          List<Map<String, dynamic>>.from(jsonDecode(paymentsData));

      // Find and update the payment with the given ID
      final index = paymentsList.indexWhere((payment) => payment['id'] == id);
      if (index != -1) {
        paymentsList[index] = updatedPayment;
        print("Payment updated: $id"); //check updatind
      } else {
        print("Payment with ID $id not found."); //check updatind
      }

      // Write updated list back to the JSON file
      await file.writeAsString(jsonEncode(paymentsList),
          mode: FileMode.write, flush: true);
    } catch (e) {
      print("Error updating payment: $e");
    }
  }

  Future<void> savePayments(List<Payment> payments) async {
    try {
      final path = await _getPaymentsFilePath();
      final file = File(path);
      final data =
          jsonEncode(payments.map((payment) => payment.toJson()).toList());
      await file.writeAsString(data);
    } catch (e) {
      print('Error saving payments: $e');
    }
  }

  Future<List<String>> loadPaymentModes() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/payment-modes.json');
      if (!(await file.exists())) {
        final assetData =
            await rootBundle.loadString('assets/payment-modes.json');
        await file.writeAsString(assetData);
      }

      final data = await file.readAsString();
      final Map<String, dynamic> parsed = jsonDecode(data);
      return List<String>.from(parsed['payment_modes']);
    } catch (e) {
      print('Error loading payment modes: $e');
      return [];
    }
  }
}
