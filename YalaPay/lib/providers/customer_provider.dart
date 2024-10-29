import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/customer.dart';

class CustomerNotifier extends Notifier<List<Customer>> {
  @override
  List<Customer> build() {
    initializeState();
    return [];
  }

  // Initialize the state by loading data from JSON
  Future<void> initializeState() async {
    final data = await rootBundle.loadString('assets/data/customers.json');
    final List<dynamic> usersMap = jsonDecode(data); // Use dynamic list
    for (var userMap in usersMap) {
      addUser(Customer.fromJson(userMap));
    }
  }

  void addUser(Customer user) {
    state = [...state, user];
  }
}

final customerNotifierProvider =
    NotifierProvider<CustomerNotifier, List<Customer>>(
  () => CustomerNotifier(),
);
