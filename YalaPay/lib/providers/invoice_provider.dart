import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickmart/models/invoice.dart';

class InvoiceNotifier extends Notifier<List<Invoice>> {
  InvoiceNotifier() {
    _initializeState();
  }

  @override
  List<Invoice> build() {
    return [];
  }

  Future<void> _initializeState() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final data = await file.readAsString();
        final invoicesMap = jsonDecode(data) as List;
        state = invoicesMap.map((invoice) => Invoice.fromJson(invoice)).toList();
      } else {
        final data = await rootBundle.loadString('assets/data/invoices.json');
        final invoicesMap = jsonDecode(data) as List;
        state = invoicesMap.map((invoice) => Invoice.fromJson(invoice)).toList();
        await _saveToFile();
      }
      print("Data loaded into memory from JSON file.");
    } catch (e) {
      print('Error initializing invoices: $e');
    }
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/invoices.json');
  }

  Future<void> _saveToFile() async {
    try {
      final file = await _localFile;
      final List<Map<String, dynamic>> jsonData = state.map((invoice) => invoice.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
      print("Data saved to JSON file.");
    } catch (e) {
      print('Error saving invoices to file: $e');
    }
  }

  void addInvoice(Invoice invoice) {
    state = [...state, invoice];
    _saveToFile();
  }

  void updateInvoice(Invoice updatedInvoice) {
    state = state.map((invoice) {
      return invoice.id == updatedInvoice.id ? updatedInvoice : invoice;
    }).toList();
    _saveToFile();
  }

  void deleteInvoice(String id) {
    state = state.where((invoice) => invoice.id != id).toList();
    _saveToFile();
  }

  List<Invoice> searchInvoices(String query) {
    if (query.isEmpty) {
      return state;
    }
    return state.where((invoice) {
      return invoice.customerName.toLowerCase().contains(query.toLowerCase()) ||
          invoice.id.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

final invoiceNotifierProvider =
    NotifierProvider<InvoiceNotifier, List<Invoice>>(() => InvoiceNotifier());
