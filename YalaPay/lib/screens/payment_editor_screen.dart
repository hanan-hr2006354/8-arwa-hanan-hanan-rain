import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/payment.dart';
import 'package:quickmart/providers/payment_provider.dart';
import 'package:quickmart/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

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
          ); // Handle case when payment is not found
    }

    // If the payment is null, we're in add mode
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
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
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
                              id: UniqueKey()
                                  .toString(), // Generate a unique ID
                              invoiceNo: invoiceId ??
                                  '', // Use invoiceId or empty string
                              amount:
                                  double.tryParse(amountController.text) ?? 0,
                              paymentDate:
                                  DateFormat('yyyy-MM-dd').format(selectedDate),
                              paymentMode: modeController.text,
                            );

                            ref
                                .read(paymentNotifierProvider.notifier)
                                .addPayment(newPayment);
                            print(
                                "Added payment: ${newPayment.id}"); // Debugging
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
                            );

                            ref
                                .read(paymentNotifierProvider.notifier)
                                .updatePayment(updatedPayment);
                            print(
                                "Updated payment: ${updatedPayment.id}"); // Debugging
                          }
                          Navigator.of(context).pop(); // Navigate back
                        },
                        child: Text(
                            isAddMode ? 'Add' : 'Update'), // Change button text
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
