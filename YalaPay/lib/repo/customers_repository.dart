import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quickmart/models/customer.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

class CustomersRepository {
  List<Customer> customers = [];

  Future<List<Customer>> getAllCustomers() async {
    var response = await rootBundle.loadString('assets/data/customers.json');
    List<dynamic> jsonData = jsonDecode(response);
    customers = jsonData.map((item) => Customer.fromJson(item)).toList();
    return customers;
  }

  List<Customer> getCustomers(String query) {
    return customers
        .where((customer) =>
            customer.contactDetails.firstName
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            customer.contactDetails.lastName
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
  }

  List<Customer> addCustomer(Customer customer) {
    customers.add(customer);
    return customers;
  }

  List<Customer> updateCustomer(Customer customer) {
    int index = customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      var temp = customers;
      temp[index] = customer;
      customers = temp;
    }
    return customers;
  }

  List<Customer> removeCustomer(Customer customer) {
    customers = customers.where((c) => c.id != customer.id).toList();
    return customers;
  }
}
