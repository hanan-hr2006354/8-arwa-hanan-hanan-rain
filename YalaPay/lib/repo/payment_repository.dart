import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickmart/models/payment.dart';

class PaymentRepository {
  // Get the file path for storing the payments JSON file in the app's documents directory
  Future<String> _getPaymentsFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/payments.json';
  }

  // Load payments from the documents directory, or fallback to assets if not found
  Future<List<Payment>> loadPayments() async {
    try {
      final path = await _getPaymentsFilePath();
      final file = File(path);

      // If the file doesn't exist, load initial data from assets and save to file
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

  // Save the list of payments to the payments.json file in the documents directory
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

  // Load payment modes from the documents directory, or fallback to assets if not found
  Future<List<String>> loadPaymentModes() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/payment-modes.json');

      // If the file doesn't exist, load initial data from assets and save to file
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
