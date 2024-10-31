// lib/repo/invoice_repository.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart';
import '../models/invoice.dart';

class InvoiceRepository {
  Future<String> get _invoicesFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return 'assets/data/invoices.json';
  }

  Future<void> resetData() async {
    final path = await _invoicesFilePath;
    await File(path).writeAsString(jsonEncode([]));
  }

  Future<List<Invoice>> loadInvoices() async {
    try {
      final path = await _invoicesFilePath;
      final invoicesData = await File(path).readAsString();
      final List invoicesJson = jsonDecode(invoicesData);
      return invoicesJson.map((json) => Invoice.fromJson(json)).toList();
    } catch (e) {
      print("Error loading invoices: $e");
      return [];
    }
  }

  Future<void> saveInvoices(List<Invoice> invoices) async {
    final path = await _invoicesFilePath;
    final invoicesJson = invoices.map((invoice) => invoice.toJson()).toList();
    await File(path).writeAsString(jsonEncode(invoicesJson),
        mode: FileMode.write, flush: true);
  }

  Future<void> addInvoice(Invoice invoice) async {
    try {
      final path = await _invoicesFilePath;
      final file = File(path);
      final invoicesData = await file.readAsString();
      List invoicesJson = jsonDecode(invoicesData);
      invoicesJson.add(invoice);
      await file.writeAsString(jsonEncode(invoicesJson),
          mode: FileMode.write, flush: true);
    } catch (e) {
      print("Error updating cheques.json: $e");
    }
  }

  Future<void> updateInvoice(Invoice updatedInvoice) async {
    try {
      final path = await _invoicesFilePath;
      final file = File(path);
      final invoicesData = await file.readAsString();
      List invoicesJson = jsonDecode(invoicesData);

      final index =
          invoicesJson.indexWhere((invoice) => invoice.id == updatedInvoice.id);
      if (index != -1) {
        invoicesJson[index] = updatedInvoice;
        await file.writeAsString(jsonEncode(invoicesJson),
            mode: FileMode.write, flush: true);
      }
    } catch (e) {
      print("Error updating cheques.json: $e");
    }
  }

  Future<void> deleteInvoice(String id) async {
    try {
      final path = await _invoicesFilePath;
      final file = File(path);
      final invoicesData = await file.readAsString();
      List invoicesJson = jsonDecode(invoicesData);
      final updatedInvoices =
          invoicesJson.where((invoice) => invoice.id != id).toList();
      await file.writeAsString(jsonEncode(updatedInvoices),
          mode: FileMode.write, flush: true);
    } catch (e) {
      print("Error writing to cheque-deposits.json: $e");
    }
  }

  Future<List<Invoice>> searchInvoices(String query) async {
    final invoices = await loadInvoices();
    if (query.isEmpty) {
      return invoices;
    }
    return invoices.where((invoice) {
      return invoice.customerName.toLowerCase().contains(query.toLowerCase()) ||
          invoice.id.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

final invoiceRepositoryProvider = Provider((ref) => InvoiceRepository());
