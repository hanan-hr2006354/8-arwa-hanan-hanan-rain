import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/invoice.dart';
import 'package:quickmart/providers/invoice_provider.dart';

class InvoiceReportScreen extends ConsumerStatefulWidget {
  const InvoiceReportScreen({super.key});

  @override

  // ignore: library_private_types_in_public_api
  _InvoiceReportScreenState createState() => _InvoiceReportScreenState();
}

class _InvoiceReportScreenState extends ConsumerState<InvoiceReportScreen> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  String _selectedStatus = "All";

  //State? get state => null;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) controller.text = picked.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    final invoices = ref.watch(invoiceNotifierProvider);
    return Scaffold(
      backgroundColor: Color(0xFFFEFFF7),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 7.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.PNG'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Invoice Reports',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF915050),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    ' ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF915050).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 3.4,
            left: 0,
            right: 0,
            child: ClipPath(
              child: Container(
                color: Color(0xFFFEFFF7),
                padding: EdgeInsets.all(30),
                child: Column(children: [
//-------------
                  TextField(
                    controller: _fromDateController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'From Date'),
                    onTap: () => _selectDate(context, _fromDateController),
                  ),

                  TextField(
                    controller: _toDateController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'To Date'),
                    onTap: () => _selectDate(context, _toDateController),
                  ),

                  DropdownButton<String>(
                    value: _selectedStatus,
                    items: ["All", "Pending", "Partially Paid", "Paid"]
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) _selectedStatus = value;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final fromDate = DateTime.parse(_fromDateController.text);
                      final toDate = DateTime.parse(_toDateController.text);
                      final filteredInvoices = getInvoicesByPeriodAndStatus(
                        invoices: invoices,
                        fromDate: fromDate,
                        toDate: toDate,
                        status: _selectedStatus,
                      );

                      final totalAmount =
                          calculateTotalAmount(filteredInvoices);
                      final totalBalance =
                          calculateTotalBalance(filteredInvoices);

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //textStyle
                              Text('Invoices found: $invoices.length'),
                              Text('Total amount: $totalAmount'),
                              Text('Total amount: $totalBalance'),
                              if (_selectedStatus == 'All')
                                ...calculateTotalsByStatus(invoices)
                                    .entries
                                    .map((e) => Text('${e.key}: ${e.value}')),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text('Submit'),
                  )

//-------------
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Invoice> getInvoicesByPeriodAndStatus({
    required List<Invoice> invoices,
    required DateTime fromDate,
    required DateTime toDate,
    required String status,
  }) {
    return invoices.where((invoice) {
      final invoiceDate = DateTime.parse(invoice.invoiceDate);
      final isWithinDateRange =
          invoiceDate.isAfter(fromDate) && invoiceDate.isBefore(toDate);
      final matchesStatus = (status == "All") || (invoice.status == status);

      return isWithinDateRange && matchesStatus;
    }).toList();
  }

  double calculateTotalAmount(List<Invoice> invoices) {
    return invoices.fold(0.0, (sum, invoice) => sum + invoice.balance);
  }

  double calculateTotalBalance(List<Invoice> invoices) {
    return invoices.fold(0.0, (sum, invoice) => sum + invoice.balance);
  }

  Map<String, double> calculateTotalsByStatus(List<Invoice> invoices) {
    final statuses = ["Pending", "Partially Paid", "Paid"];
    final totals = <String, double>{};

    for (var status in statuses) {
      final filteredInvoices = getInvoicesByPeriodAndStatus(
        invoices: invoices,
        fromDate: DateTime(2000),
        toDate: DateTime.now(),
        status: status,
      );
      totals[status] = calculateTotalAmount(filteredInvoices);
    }

    totals["Grand Total"] = calculateTotalAmount(invoices);
    return totals;
  }
}
