import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/invoice.dart';
import 'package:quickmart/models/customer.dart';
import 'package:quickmart/providers/invoice_provider.dart';
import 'package:quickmart/providers/customer_provider.dart';
import 'package:quickmart/widgets/custom_app_bar.dart';

class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  double screenWidth = 0;
  int columns = 1;

  final TextEditingController _searchController = TextEditingController();
  String? selectedCustomerId;
  String? selectedCustomerName;
  List<Invoice> filteredInvoices = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    columns = switch (screenWidth) {
      < 840 => 1,
      >= 840 && < 1150 => 2,
      _ => 3,
    };
  }

  @override
  void initState() {
    super.initState();
    filteredInvoices = [];
  }

  @override
  Widget build(BuildContext context) {
    final invoices = ref.watch(invoiceNotifierProvider);
    final customers = ref.watch(customerNotifierProvider);
    _filterInvoices();

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFF7),
      appBar: CustomAppBar(
        titleText: 'Invoices',
        subtitleText: 'Manage your invoice data',
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search by Customer Name or Invoice ID",
                  hintStyle: const TextStyle(color: Color(0xFF915050)),
                  filled: true,
                  fillColor: Colors.brown[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => _filterInvoices(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _showAddInvoiceDialog(customers);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 9, 6, 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Add an Invoice',
                      style:
                          TextStyle(color: Color.fromARGB(255, 250, 250, 250)),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: filteredInvoices.isEmpty
                  ? const Center(child: Text('No invoices found.'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 270,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredInvoices.length,
                      itemBuilder: (context, index) {
                        final invoice = filteredInvoices[index];
                        return Card(
                          color: const Color.fromARGB(255, 244, 236, 236),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Customer Name: ${invoice.customerName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF915050),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Invoice ID: ${invoice.id}'),
                                Text('Invoice Date: ${invoice.invoiceDate}'),
                                Text('Due Date: ${invoice.dueDate}'),
                                Text(
                                    'Amount: \$${invoice.amount?.toStringAsFixed(2)}'),
                                Text(
                                    'Total Payments: \$${invoice.totalPayments?.toStringAsFixed(2)}'),
                                Text(
                                  'Balance: \$${(invoice.amount! - invoice.totalPayments!).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _showUpdateInvoiceDialog(
                                              invoice, customers);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 239, 224, 205),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: const Text('Update',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 103, 41, 41))),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          ref
                                              .read(invoiceNotifierProvider
                                                  .notifier)
                                              .deleteInvoice(invoice.id);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 240, 200, 200),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: const Text('Delete',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 103, 41, 41))),
                                      ),
                                    ],
                                  ),
                                ),
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

  void _filterInvoices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredInvoices = ref.read(invoiceNotifierProvider).where((invoice) {
        return invoice.customerName.toLowerCase().contains(query) ||
            invoice.id.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showAddInvoiceDialog(List<Customer> customers) {
    final TextEditingController _invoiceDateController =
        TextEditingController();
    final TextEditingController _dueDateController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();
    final TextEditingController _totalPaymentsController =
        TextEditingController();

    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 236, 222, 221),
          title: Center(
            child: const Text(
              'Add Invoice',
              style: TextStyle(
                color: Color.fromARGB(255, 119, 81, 81),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                DropdownButtonFormField<String>(
                  value: selectedCustomerId,
                  decoration: InputDecoration(labelText: 'Select Customer'),
                  items: customers.map((Customer customer) {
                    return DropdownMenuItem<String>(
                      value: customer.id,
                      child: Text("${customer.companyName}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 171, 75, 56))),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCustomerId = newValue;
                      selectedCustomerName = customers
                          .firstWhere((customer) => customer.id == newValue)
                          .companyName;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a customer';
                    }
                    return null;
                  },
                ),
                TextField(
                  controller: _invoiceDateController,
                  decoration: const InputDecoration(labelText: 'Invoice Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, _invoiceDateController),
                ),
                TextField(
                  controller: _dueDateController,
                  decoration: const InputDecoration(labelText: 'Due Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, _dueDateController),
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _totalPaymentsController,
                  decoration:
                      const InputDecoration(labelText: 'Total Payments'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (selectedCustomerId == null ||
                    _amountController.text.isEmpty ||
                    _totalPaymentsController.text.isEmpty ||
                    _invoiceDateController.text.isEmpty ||
                    _dueDateController.text.isEmpty) {
                  setState(() {
                    errorMessage = 'Please fill in all fields';
                  });
                  return;
                }

                final newInvoice = Invoice(
                  id: (ref.read(invoiceNotifierProvider).length + 1).toString(),
                  customerId: selectedCustomerId!,
                  customerName: selectedCustomerName!,
                  invoiceDate: _invoiceDateController.text,
                  dueDate: _dueDateController.text,
                  amount: double.tryParse(_amountController.text) ?? 0.0,
                  totalPayments:
                      double.tryParse(_totalPaymentsController.text) ?? 0.0,
                );

                ref
                    .read(invoiceNotifierProvider.notifier)
                    .addInvoice(newInvoice);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateInvoiceDialog(Invoice invoice, List<Customer> customers) {
    final TextEditingController _invoiceDateController =
        TextEditingController(text: invoice.invoiceDate);
    final TextEditingController _dueDateController =
        TextEditingController(text: invoice.dueDate);
    final TextEditingController _amountController =
        TextEditingController(text: invoice.amount?.toString());
    final TextEditingController _totalPaymentsController =
        TextEditingController(text: invoice.totalPayments?.toString());

    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 236, 222, 221),
          title: Center(
            child: const Text(
              'Update Invoice',
              style: TextStyle(
                color: Color.fromARGB(255, 119, 81, 81),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                DropdownButtonFormField<String>(
                  value: selectedCustomerId ?? invoice.customerId,
                  decoration: InputDecoration(labelText: 'Select Customer'),
                  items: customers.map((Customer customer) {
                    return DropdownMenuItem<String>(
                      value: customer.id,
                      child: Text("${customer.companyName}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 171, 75, 56))),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCustomerId = newValue;
                      selectedCustomerName = customers
                          .firstWhere((customer) => customer.id == newValue)
                          .companyName;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a customer';
                    }
                    return null;
                  },
                ),
                TextField(
                  controller: _invoiceDateController,
                  decoration: const InputDecoration(labelText: 'Invoice Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, _invoiceDateController),
                ),
                TextField(
                  controller: _dueDateController,
                  decoration: const InputDecoration(labelText: 'Due Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, _dueDateController),
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _totalPaymentsController,
                  decoration:
                      const InputDecoration(labelText: 'Total Payments'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (selectedCustomerId == null ||
                    _amountController.text.isEmpty ||
                    _totalPaymentsController.text.isEmpty ||
                    _invoiceDateController.text.isEmpty ||
                    _dueDateController.text.isEmpty) {
                  setState(() {
                    errorMessage = 'Please fill in all fields';
                  });
                  return;
                }

                final updatedInvoice = Invoice(
                  customerId: selectedCustomerId ?? invoice.customerId,
                  customerName: selectedCustomerName ?? invoice.customerName,
                  invoiceDate: _invoiceDateController.text.isNotEmpty
                      ? _invoiceDateController.text
                      : invoice.invoiceDate,
                  dueDate: _dueDateController.text.isNotEmpty
                      ? _dueDateController.text
                      : invoice.dueDate,
                  amount: _amountController.text.isNotEmpty
                      ? double.tryParse(_amountController.text) ?? 0.0
                      : invoice.amount,
                  totalPayments: _totalPaymentsController.text.isNotEmpty
                      ? double.tryParse(_totalPaymentsController.text) ?? 0.0
                      : invoice.totalPayments,
                  id: invoice.id,
                );

                ref
                    .read(invoiceNotifierProvider.notifier)
                    .updateInvoice(updatedInvoice);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = "${picked.toLocal()}".split(' ')[0];
    }
  }
}
