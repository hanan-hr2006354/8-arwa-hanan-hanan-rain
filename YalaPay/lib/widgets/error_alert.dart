import 'package:flutter/material.dart';
import 'package:yala_pay/constants.dart';

class ErrorAlert extends StatelessWidget {
  const ErrorAlert({super.key, this.message = 'invalid data.'});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: lightRed),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: red,
        ),
      ),
    );
  }
}
