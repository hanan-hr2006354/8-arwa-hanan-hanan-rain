import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/constants.dart';
import 'package:yala_pay/model/address.dart';
import 'package:yala_pay/model/contact_details.dart';
import 'package:yala_pay/model/customer.dart';
import 'package:yala_pay/providers/customers_provider.dart';
import 'package:yala_pay/widgets/error_alert.dart';

class CustomerEditor extends ConsumerStatefulWidget {
  const CustomerEditor({super.key, required this.customerId});
  final String? customerId;

  @override
  ConsumerState<CustomerEditor> createState() => _CustomerEditorState();
}

class _CustomerEditorState extends ConsumerState<CustomerEditor> {
  bool validData = true;
  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerNotifierProvider);
    final index = customers.indexWhere((c) => c.id == widget.customerId);
    final customer = index == -1 ? null : customers[index];
    final TextEditingController firstNameController =
        TextEditingController(text: customer?.contactDetails.firstName);
    final TextEditingController lastNameController =
        TextEditingController(text: customer?.contactDetails.lastName);
    final TextEditingController companyNameController =
        TextEditingController(text: customer?.companyName);
    final TextEditingController phoneController =
        TextEditingController(text: customer?.contactDetails.mobile);
    final TextEditingController emailController =
        TextEditingController(text: customer?.contactDetails.email);
    final TextEditingController streetController =
        TextEditingController(text: customer?.address.street);
    final TextEditingController cityController =
        TextEditingController(text: customer?.address.city);
    final TextEditingController countryController =
        TextEditingController(text: customer?.address.country);

    List<Map<String, dynamic>> items = [
      {'label': 'First Name', 'controller': firstNameController},
      {'label': 'Last Name', 'controller': lastNameController},
      {'label': 'Company Name', 'controller': companyNameController},
      {'label': 'Street', 'controller': streetController},
      {'label': 'City', 'controller': cityController},
      {'label': 'Country', 'controller': countryController},
      {'label': 'Mobile', 'controller': phoneController},
      {'label': 'Email', 'controller': emailController},
    ];

    return Scaffold(
      backgroundColor: white,
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
                  for (var item in items)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        TextField(
                          controller: item['controller'],
                          decoration: InputDecoration(
                            fillColor: lightGrey,
                            filled: true,
                            labelText: item['label'],
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: green, width: 1.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!validData)
                    const Column(
                      children: [
                        SizedBox(height: 12),
                        ErrorAlert(message: 'All field are required.'),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: red, foregroundColor: white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 10),
                      if (customer != null)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: blue, foregroundColor: white),
                          onPressed: () {
                            ref
                                .read(customerNotifierProvider.notifier)
                                .updateCustomer(
                                  Customer(
                                    customer.id,
                                    companyNameController.text,
                                    Address(
                                        streetController.text,
                                        cityController.text,
                                        countryController.text),
                                    ContactDetails(
                                        firstNameController.text,
                                        lastNameController.text,
                                        phoneController.text,
                                        emailController.text),
                                  ),
                                );
                            Navigator.of(context).pop();
                          },
                          child: const Text('Update'),
                        ),
                      if (customer == null)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: green, foregroundColor: white),
                          onPressed: () {
                            if (firstNameController.text.isEmpty ||
                                lastNameController.text.isEmpty ||
                                companyNameController.text.isEmpty ||
                                streetController.text.isEmpty ||
                                cityController.text.isEmpty ||
                                countryController.text.isEmpty ||
                                phoneController.text.isEmpty ||
                                emailController.text.isEmpty) {
                              setState(() {
                                validData = false;
                              });
                            } else {
                              ref
                                  .read(customerNotifierProvider.notifier)
                                  .addCustomer(
                                    Customer(
                                      (customers.length + 1).toString(),
                                      companyNameController.text,
                                      Address(
                                          streetController.text,
                                          cityController.text,
                                          countryController.text),
                                      ContactDetails(
                                          firstNameController.text,
                                          lastNameController.text,
                                          phoneController.text,
                                          emailController.text),
                                    ),
                                  );
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Add'),
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
}
