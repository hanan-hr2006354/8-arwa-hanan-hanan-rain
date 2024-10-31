import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/payment.dart'; // Adjust the import as needed
import 'package:quickmart/providers/invoice_provider.dart';
import 'package:quickmart/providers/payment_provider.dart';
import 'package:quickmart/widgets/custom_app_bar.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  String? selectedInvoiceId;
  String? selectedCustomerName;
  List<Payment> filteredPayments = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final paymentNotifier = ref.read(paymentNotifierProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoices = ref.watch(invoiceNotifierProvider);
    final payments = ref.watch(paymentNotifierProvider);

    // Filter payments based on the selected invoice
    if (selectedInvoiceId != null) {
      filteredPayments = payments
          .where((payment) => payment.invoiceNo == selectedInvoiceId)
          .toList();
    } else {
      filteredPayments = payments; // Show all if no invoice is selected
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filteredPayments = ref
          .read(paymentNotifierProvider.notifier)
          .searchPayments(searchQuery);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFF7),
      appBar: CustomAppBar(
        titleText: 'Payments',
        subtitleText: 'Manage your payment data',
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<String>(
                hint: const Text("Select Invoice"),
                value: selectedInvoiceId,
                items: invoices.map((invoice) {
                  return DropdownMenuItem<String>(
                    value: invoice.id, // Assuming invoice has an id property
                    child: Text(
                      "${invoice.id} - ${invoice.customerName} - ${invoice.amount}", // Adjust as needed
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedInvoiceId = value;
                    selectedCustomerName = invoices
                        .firstWhere((invoice) => invoice.id == value)
                        .customerName; // Assuming invoice has a customerName property
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Payments...',
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredPayments.isEmpty
                  ? const Center(child: Text('No payments found.'))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 200,
                      ),
                      padding: const EdgeInsets.all(10),
                      itemCount: filteredPayments.length,
                      itemBuilder: (context, index) {
                        final payment = filteredPayments[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Payment ID: ${payment.id}"),
                                Text("Amount: \$${payment.amount}"),
                                Text("Date: ${payment.paymentDate}"),
                                Text("Mode: ${payment.paymentMode}"),
                                // Add update and delete buttons here if needed
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
