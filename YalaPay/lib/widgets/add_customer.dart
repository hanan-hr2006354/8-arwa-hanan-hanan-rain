import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yala_pay/constants.dart';
import 'package:yala_pay/router/app_router.dart';

class AddCustomer extends StatelessWidget {
  const AddCustomer({super.key, required this.customersLength});
  final int customersLength;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: green,
        foregroundColor: white,
        fixedSize: const Size(130, 47),
        textStyle: const TextStyle(fontSize: 14),
        padding: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        context.pushNamed(AppRouter.customerEditor.name,
            pathParameters: {'customerId': (customersLength + 1).toString()});
      },
      child: const Row(
        children: [
          Icon(Icons.add_rounded),
          Text('Add Customer'),
        ],
      ),
    );
  }
}
