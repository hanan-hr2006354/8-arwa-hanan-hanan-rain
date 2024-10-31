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
    final TextEditingController modeController =
        TextEditingController(text: isAddMode ? '' : payment!.paymentMode);
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
                  _buildTextField(
                    controller: modeController,
                    label: 'Payment Mode',
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
                          _showChequeDetailsDialog(context, ref, chequeNo);
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
                            // Create a new payment object
                            final newPayment = Payment(
                              id: UniqueKey().toString(),
                              invoiceNo: invoiceId ?? '',
                              amount:
                                  double.tryParse(amountController.text) ?? 0,
                              paymentDate:
                                  DateFormat('yyyy-MM-dd').format(selectedDate),
                              paymentMode: modeController.text,
                              chequeNo: payment?.chequeNo, // Include chequeNo
                            );

                            ref
                                .read(paymentNotifierProvider.notifier)
                                .addPayment(newPayment);
                            print("Added payment: ${newPayment.id}");
                          } else {
                            // Update existing payment
                            final updatedPayment = Payment(
                              id: payment!.id,
                              invoiceNo: payment.invoiceNo,
                              amount:
                                  double.tryParse(amountController.text) ?? 0,
                              paymentDate:
                                  DateFormat('yyyy-MM-dd').format(selectedDate),
                              paymentMode: modeController.text,
                              chequeNo: payment.chequeNo, // Include chequeNo
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

  void _showChequeDetailsDialog(
      BuildContext context, WidgetRef ref, int chequeNo) {
    final cheques = ref.read(checkTwoNotifierProvider);
    final foundCheque = cheques.firstWhere((c) => c.chequeNo == chequeNo);

    final TextEditingController amountController =
        TextEditingController(text: foundCheque.amount.toString());
    final TextEditingController drawerController =
        TextEditingController(text: foundCheque.drawer);
    final TextEditingController bankController =
        TextEditingController(text: foundCheque.bankName);
    final TextEditingController statusController =
        TextEditingController(text: foundCheque.status);

    // New controllers for additional fields
    final TextEditingController receivedDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(foundCheque.receivedDate));
    final TextEditingController dueDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(foundCheque.dueDate));
    final TextEditingController chequeImageUriController =
        TextEditingController(text: foundCheque.chequeImageUri);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cheque Details - No: ${foundCheque.chequeNo}'),
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
                _buildTextField(controller: bankController, label: 'Bank Name'),
                const SizedBox(height: 12),
                _buildTextField(controller: statusController, label: 'Status'),
                const SizedBox(height: 12),
                _buildTextField(
                    controller: receivedDateController,
                    label: 'Received Date',
                    keyboardType: TextInputType.none), // Date format only
                const SizedBox(height: 12),
                _buildTextField(
                    controller: dueDateController,
                    label: 'Due Date',
                    keyboardType: TextInputType.none), // Date format only
                const SizedBox(height: 12),
                _buildTextField(
                    controller: chequeImageUriController,
                    label: 'Cheque Image URI'),
                const SizedBox(height: 12),
                // Display the cheque image from assets
                if (foundCheque.chequeImageUri.isNotEmpty)
                  Column(
                    children: [
                      const Text('Cheque Image:'),
                      const SizedBox(height: 8),
                      Image.asset(
                        'assets/data/cheques/${foundCheque.chequeImageUri}', // Use the image name from the cheque object
                        height: 150, // Set desired height
                        width: 250, // Set desired width
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Image not available');
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Save the updated cheque details
                final updatedCheque = ChequeTwo(
                  chequeNo: foundCheque.chequeNo,
                  amount: double.tryParse(amountController.text) ?? 0,
                  drawer: drawerController.text,
                  bankName: bankController.text,
                  status: statusController.text,
                  receivedDate: DateTime.parse(
                      receivedDateController.text), // Convert back to DateTime
                  dueDate: DateTime.parse(
                      dueDateController.text), // Convert back to DateTime
                  chequeImageUri: chequeImageUriController.text,
                );

                // Update the cheque in the provider
                ref
                    .read(checkTwoNotifierProvider.notifier)
                    .updateCheque(updatedCheque);

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
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
        fillColor: Colors.grey[300],
        filled: true,
        labelText: label,
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
}
