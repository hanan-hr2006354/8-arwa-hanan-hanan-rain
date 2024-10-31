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
      final data = await rootBundle.loadString('assets/data/invoices.json');
      final invoicesMap = jsonDecode(data) as List;
      for (var invoice in invoicesMap) {
        addInvoice(Invoice.fromJson(invoice));
      }
      print("Data loaded into memory from JSON file.");
    } catch (e) {
      print('Error initializing invoices: $e');
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('assets/data/invoices.json');
  }

  Future<void> saveInvoicesToFile() async {
    try {
      final file = await _getLocalFile();
      final jsonData =
          jsonEncode(state.map((invoice) => invoice.toJson()).toList());
      await file.writeAsString(jsonData);
      print('Invoices saved to file at ${file.path}');
    } catch (e) {
      print('Error saving invoices to file: $e');
    }
  }

  void addInvoice(Invoice invoice) {
    state = [...state, invoice];
  }

  void updateInvoice(Invoice updatedInvoice) {
    state = state.map((invoice) {
      return invoice.id == updatedInvoice.id ? updatedInvoice : invoice;
    }).toList();
  }

  void deleteInvoice(String id) {
    state = state.where((invoice) => invoice.id != id).toList();
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

  Future<void> saveToFileOnDemand() async {
    await saveInvoicesToFile();
  }
  //-------------

//----------
}

final invoiceNotifierProvider =
    NotifierProvider<InvoiceNotifier, List<Invoice>>(() => InvoiceNotifier());
