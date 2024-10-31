import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/payment.dart';
import 'package:quickmart/models/chequeTwo.dart';
import 'package:quickmart/providers/cheque_two_provider.dart';
import 'package:quickmart/providers/payment_provider.dart';
import 'package:quickmart/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

class UpdatePaymentScreen extends ConsumerWidget {
  final String? paymentId;
  final String? invoiceId;

  const UpdatePaymentScreen({
    Key? key,
    this.paymentId,
    this.invoiceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Payment? payment;

    if (paymentId != null) {
      payment = ref.watch(paymentNotifierProvider).firstWhere(
            (p) => p.id == paymentId,
          );
    }

    final isAddMode = payment == null;

    final TextEditingController amountController = TextEditingController(
        text: isAddMode ? '' : payment!.amount.toString());
    String selectedMode = isAddMode ? '' : payment!.paymentMode;
    DateTime selectedDate =
        isAddMode ? DateTime.now() : DateTime.parse(payment!.paymentDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        titleText: isAddMode ? 'Add Payment' : 'Update Payment',
        subtitleText:
            isAddMode ? 'Add new payment details' : 'Edit payment details',
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: amountController,
                    label: 'Amount',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  if (isAddMode)
                    _buildPaymentModeDropdown(selectedMode, (value) {
                      selectedMode = value!;
                      if (selectedMode == 'Cheque') {
                        _showAddChequeDialog(context, ref);
                      }
                    })
                  else
                    _buildTextField(
                      controller: TextEditingController(text: selectedMode),
                      label: 'Payment Mode',
                      keyboardType: TextInputType.none,
                    ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        selectedDate = pickedDate;
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Payment Date',
                          hintText: "${selectedDate.toLocal()}".split(' ')[0],
                          suffixIcon: const Icon(Icons.calendar_today),
                          fillColor: Colors.grey[300],
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(0, 162, 162, 163),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(0, 162, 162, 163),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (payment?.chequeNo != null)
                    ElevatedButton(
                      onPressed: () {
                        final chequeNo = payment!.chequeNo;
                        if (chequeNo != null) {
                          _showChequeDetailsDialog(
                              context, ref, chequeNo as String);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Cheque number not available')),
                          );
                        }
                      },
                      child: const Text('View Cheque Details'),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 153, 99, 95),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Navigate back
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 115, 159, 196),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (isAddMode) {
                            final newPayment = Payment(
                              id: UniqueKey().toString(),
                              invoiceNo: invoiceId ?? '',
                              amount:
                                  double.tryParse(amountController.text) ?? 0,
                              paymentDate:
                                  DateFormat('yyyy-MM-dd').format(selectedDate),
                              paymentMode: selectedMode,
                              chequeNo: payment?.chequeNo,
                            );

                            ref
                                .read(paymentNotifierProvider.notifier)
                                .addPayment(newPayment);
                            print("Added payment: ${newPayment.id}");
                          } else {
                            final updatedPayment = Payment(
                              id: payment!.id,
                              invoiceNo: payment.invoiceNo,
                              amount:
                                  double.tryParse(amountController.text) ?? 0,
                              paymentDate:
                                  DateFormat('yyyy-MM-dd').format(selectedDate),
                              paymentMode: selectedMode,
                              chequeNo: payment.chequeNo,
                            );

                            ref
                                .read(paymentNotifierProvider.notifier)
                                .updatePayment(updatedPayment);
                            print("Updated payment: ${updatedPayment.id}");
                          }
                          Navigator.of(context).pop(); // Navigate back
                        },
                        child: Text(isAddMode ? 'Add' : 'Update'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentModeDropdown(
      String selectedMode, ValueChanged<String?> onChanged) {
    const List<String> paymentModes = [
      "Bank transfer",
      "Credit card",
      "Cheque",
    ];

    return DropdownButtonFormField<String>(
      value: selectedMode.isEmpty ? null : selectedMode,
      items: paymentModes.map((String mode) {
        return DropdownMenuItem<String>(
          value: mode,
          child: Text(mode),
        );
      }).toList(),
      decoration: InputDecoration(
        fillColor: Colors.grey[300],
        filled: true,
        labelText: 'Payment Mode',
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(0, 162, 162, 163),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(0, 162, 162, 163), width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
      hint: const Text('Select Payment Mode'),
    );
  }

  void _showAddChequeDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController drawerController = TextEditingController();
    final TextEditingController receivedDateController =
        TextEditingController();
    final TextEditingController dueDateController = TextEditingController();
    final TextEditingController chequeImageUriController =
        TextEditingController();

    DateTime? selectedReceivedDate;
    DateTime? selectedDueDate;
    String? selectedStatus;
    String? selectedBank;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a New Cheque'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                    controller: amountController,
                    label: 'Amount',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                _buildTextField(controller: drawerController, label: 'Payee'),
                const SizedBox(height: 12),
                _buildBankDropdown((value) {
                  selectedBank = value; // Capture selected bank
                }),
                const SizedBox(height: 12),
                _buildStatusDropdown((value) {
                  selectedStatus = value; // Capture selected status
                }),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedReceivedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      selectedReceivedDate = pickedDate;
                      receivedDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  child: AbsorbPointer(
                    child: _buildTextField(
                      controller: receivedDateController,
                      label: 'Received Date',
                      keyboardType: TextInputType.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDueDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      selectedDueDate = pickedDate;
                      dueDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  child: AbsorbPointer(
                    child: _buildTextField(
                      controller: dueDateController,
                      label: 'Due Date',
                      keyboardType: TextInputType.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                    controller: chequeImageUriController,
                    label: 'Cheque Image URI'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Logic to save the cheque details
                // Create a new ChequeTwo object and save it here
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        fillColor: Colors.grey[300],
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(0, 162, 162, 163),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(0, 162, 162, 163), width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(ValueChanged<String?> onChanged) {
    const List<String> statuses = [
      "Awaiting",
      "Deposited",
      "Cashed",
      "Returned"
    ];

    return DropdownButtonFormField<String>(
      value: null, // No initial value
      items: statuses.map((String status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status),
        );
      }).toList(),
      decoration: InputDecoration(
        fillColor: Colors.grey[300],
        filled: true,
        labelText: 'Status',
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(0, 162, 162, 163),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(0, 162, 162, 163), width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
      hint: const Text('Select Status'),
    );
  }

  Widget _buildBankDropdown(ValueChanged<String?> onChanged) {
    const List<String> banks = [
      "Qatar National Bank",
      "Doha Bank",
      "Commercial Bank",
      "Qatar International Islamic Bank",
      "Qatar Islamic Bank",
      "Qatar Development Bank",
      "Arab Bank",
      "Ahlibank",
      "Mashreq Bank",
      "HSBC Bank Middle East",
      "BNP Paribas",
      "Bank Saderat Iran",
      "United Bank ltd.",
      "Standard Chartered Bank",
      "Masraf Al Rayan",
      "International Bank of Qatar",
      "Barwa Bank"
    ];

    return DropdownButtonFormField<String>(
      value: null, // No initial value
      items: banks.map((String bank) {
        return DropdownMenuItem<String>(
          value: bank,
          child: Text(bank),
        );
      }).toList(),
      decoration: InputDecoration(
        fillColor: Colors.grey[300],
        filled: true,
        labelText: 'Bank',
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(0, 162, 162, 163),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(0, 162, 162, 163), width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
      hint: const Text('Select Bank'),
    );
  }

  void _showChequeDetailsDialog(
      BuildContext context, WidgetRef ref, String chequeNo) {
    // Implement your cheque details dialog here
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cheque Details'),
          content: Text('Details for Cheque No: $chequeNo'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
