// import 'package:flutter/material.dart';
// import 'package:quickmart/widgets/custom_app_bar.dart';

// class PaymentsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color(0xFFFEFFF7),
//         appBar: CustomAppBar(
//           titleText: 'Payments',
//           subtitleText: 'Manage your payments data',
//         ));
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickmart/models/cheque.dart';
import 'package:quickmart/models/payment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/providers/cheque_provider.dart';
import '../providers/payment_provider.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});
  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  // search by invoiceNo / PaymentId
  final TextEditingController _searchController = TextEditingController();
  String? selectedinvoiceNo;
  String? selectedPaymentMode;
  String? selectedCustomerName;
  List<Payment> filteredPayments = [];
  String? paymentDate;
  String? dueDate;

  @override
  void initState() {
    super.initState();
    filteredPayments = [];
  }

  Cheque getch(String n, List<Cheque> l) {
    Cheque cheque;
    return cheque = l.firstWhere((e) => e.chequeNo == n);
  }

  List<String> paymentsmodes() {
    try {
      final jsonString = File('payment-modes.json').readAsStringSync();
      return List<String>.from(jsonDecode(jsonString));
    } catch (e) {
      print("Error reading string list from JSON file: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    //final paymentsmodes = ref.watch(chequeRepositoryProvider).paymentmodes;
    //final invoices = ref.watch(invoiceNotifierProvider);
    // final payments = ref.watch(paymentNotifierProvider);
    final cheques = ref.watch(chequeProvider);
    //final cheque;
    _filterPayments();
    final List<String> modes = paymentsmodes();

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
                    'Payments',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF915050),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Mange payments  ',
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
                  //--------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search by Payment ID  or InvoiceNo",
                        hintStyle: const TextStyle(color: Color(0xFF915050)),
                        filled: true,
                        fillColor: Colors.brown[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) => _filterPayments(),
                    ),
                  ),
                  //--------------
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            _AddPaymenteDialog(modes); //payments
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 9, 6, 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Creat an Payment',
                            style: TextStyle(
                                color: Color.fromARGB(255, 250, 250, 250)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //--------------
                  Expanded(
                    child: filteredPayments.isEmpty
                        ? const Center(child: Text('No payments found.'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: filteredPayments.length,
                            itemBuilder: (context, index) {
                              final payment = filteredPayments[index];
                              return Card(
                                color: const Color.fromARGB(255, 244, 236, 236),
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Payment ID: ${payment.id}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF915050),
                                        ),
                                      ),
                                      Text(
                                        'Invoice No: ${payment.invoiceNo}', // Display customer name
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF915050),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                          'Payment Date: ${payment.paymentDate}'),
                                      Text(
                                          'Payment Mode: ${payment.paymentMode}'),
                                      chequeDetails(payment,
                                          getch(payment.chequeNo, cheques)),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                _updatePaymentDialog(
                                                    payment, modes);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
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
                                                    .read(
                                                        paymentNotifierProvider
                                                            .notifier)
                                                    .deletePayment(payment.id);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
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

                  //--------------
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _filterPayments() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPayments = ref.read(paymentNotifierProvider).where((payment) {
        return payment.chequeNo.toLowerCase().contains(query) ||
            payment.id.toLowerCase().contains(query);
      }).toList();
    });
  }

  // ignore: non_constant_identifier_names
  void _AddPaymenteDialog(List<String> modes) {
    final TextEditingController _paymentAmountController =
        TextEditingController();
    final TextEditingController _paymentDateController =
        TextEditingController();
    final TextEditingController _paymentchequeNoController =
        TextEditingController();
    final TextEditingController _invoiceNoController = TextEditingController();

    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 236, 222, 221),
          title: Center(
            child: const Text(
              'Add payment',
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

                ///add more here
                TextField(
                  controller: _paymentDateController,
                  decoration: const InputDecoration(labelText: 'Invoice Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, _paymentDateController),
                ),
                //   TextField(
                //     controller:  _paymentDueDateController,
                //     decoration: const InputDecoration(labelText: 'Due Date'),
                //     readOnly: true,
                //  onTap: () => _selectDate(context,  _paymentDueDateController),
                //   ),

                TextField(
                  controller: _paymentAmountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _invoiceNoController,
                  decoration:
                      const InputDecoration(labelText: 'Total Payments'),
                  keyboardType: TextInputType.number,
                ),

                TextField(
                  controller: _paymentchequeNoController,
                  decoration:
                      const InputDecoration(labelText: 'Total Payments'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: selectedPaymentMode,
                  decoration: InputDecoration(labelText: 'Select Mode'),
                  items: modes.map((mode) {
                    return DropdownMenuItem<String>(
                      value: mode,
                      child: Text(mode,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 171, 75, 56))),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPaymentMode = newValue;
                      // selectedCustomerName = customers
                      //     .firstWhere((customer) => customer.id == newValue)
                      //     .companyName;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a mode';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (selectedPaymentMode == null ||
                    _invoiceNoController.text.isEmpty ||
                    _paymentAmountController.text.isEmpty ||
                    _paymentDateController.text.isEmpty ||
                    _paymentchequeNoController.text.isEmpty) {
                  setState(() {
                    errorMessage = 'Please fill in all fields.';
                  });
                  return;
                } else {
                  errorMessage = null;
                }

                final newpayment = Payment(
                    id: (ref.read(paymentNotifierProvider).length + 1)
                        .toString(),
                    invoiceNo: _invoiceNoController.text,
                    amount: _paymentAmountController.text,
                    paymentDate: _paymentDateController.text,
                    paymentMode: selectedPaymentMode!,
                    chequeNo: _paymentchequeNoController.text);

                ref
                    .read(paymentNotifierProvider.notifier)
                    .addPayment(newpayment);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 120, 50, 50),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Color.fromARGB(255, 252, 254, 255),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 250, 250, 250),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromARGB(255, 120, 50, 50),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updatePaymentDialog(Payment payment, List<String> modes) {
    final TextEditingController _paymentIdController =
        TextEditingController(text: payment.id);
    final TextEditingController _paymentDateController =
        TextEditingController(text: payment.paymentDate);
    final TextEditingController _paymentAmountController =
        TextEditingController(text: payment.amount.toString());
    final TextEditingController _paymentmodeController =
        TextEditingController(text: payment.paymentMode.toString());
    final TextEditingController _paymentInvoiceNoController =
        TextEditingController(text: payment.invoiceNo.toString());

    final TextEditingController _paymentChequeNoController =
        TextEditingController(text: payment.chequeNo.toString());

    String? errorMessage; // Variable to hold error message

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 224, 218, 204),
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
                TextField(
                  controller: _paymentIdController,
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    hintText: 'Enter due date',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _paymentInvoiceNoController,
                  decoration: const InputDecoration(
                    labelText: 'Invoice No',
                    hintText: 'Enter Invoice No',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _paymentDateController,
                  decoration: const InputDecoration(
                    labelText: 'payment Date',
                    hintText: 'Enter payment date',
                  ),
                  onTap: () => _selectDate(context, _paymentDateController),
                ),
                TextField(
                  controller: _paymentAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount',
                  ),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: selectedPaymentMode,
                  decoration: InputDecoration(labelText: 'Select Mode'),
                  items: modes.map((mode) {
                    return DropdownMenuItem<String>(
                      value: mode,
                      child: Text(mode,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 171, 75, 56))),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPaymentMode = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a mode';
                    }
                    return null;
                  },
                ),
                TextField(
                  controller: _paymentChequeNoController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 250, 250, 250),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromARGB(255, 120, 50, 50),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedPayment = Payment(
                    id: _paymentIdController.text.isNotEmpty
                        ? _paymentIdController.text
                        : payment.id,
                    invoiceNo: _paymentInvoiceNoController.text.isNotEmpty
                        ? _paymentInvoiceNoController.text
                        : payment.invoiceNo,
                    amount: _paymentAmountController.text.isNotEmpty
                        ? _paymentAmountController.text
                        : payment.amount,
                    paymentDate: _paymentDateController.text.isNotEmpty
                        ? _paymentDateController.text
                        : payment.paymentDate,
                    paymentMode: _paymentmodeController.text.isNotEmpty
                        ? _paymentmodeController.text
                        : payment.paymentMode,
                    chequeNo: _paymentChequeNoController.text.isNotEmpty
                        ? _paymentChequeNoController.text
                        : payment.chequeNo);
                //selectedPaymentMode

                ref
                    .read(paymentNotifierProvider.notifier)
                    .updatePayment(updatedPayment);

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 120, 76, 50),
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                  color: Color.fromARGB(255, 252, 254, 255),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget chequeDetails(Payment payment, Cheque cheque) {
  if (payment.paymentMode != 'cheque') return Container();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Cheque No: ${cheque.chequeNo}'),
      Text('Drawer: ${cheque.drawer}'),
      Text('Drawer Bank: ${cheque.bankName}'),
      Text('Status: ${cheque.status}'),
      Text('Received Date: ${cheque.receivedDate}'),
      Text('Due Date: ${cheque.dueDate}'),
      Image.asset(cheque.chequeImageUri),
    ],
  );
}

Future<void> _selectDate(
    BuildContext context, TextEditingController controller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (pickedDate != null) {
    controller.text = "${pickedDate.toLocal()}".split(' ')[0];
  }
}
