import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/customer.dart';
import 'package:quickmart/repo/customers_repository.dart';

class CustomersNotifier extends Notifier<List<Customer>> {
  final CustomersRepository _customersRepository = CustomersRepository();
  @override
  List<Customer> build() {
    loadCustomers();
    return [];
  }

  void loadCustomers() async {
    var customers = await _customersRepository.getAllCustomers();
    state = customers;
  }

  void getCustomers(String query) {
    state = _customersRepository.getCustomers(query);
  }

  void addCustomer(Customer customer) {
    var updatedCustomers = _customersRepository.addCustomer(customer);
    state = List.from(updatedCustomers);
  }

  void updateCustomer(Customer customer) {
    var updatesCustomers = _customersRepository.updateCustomer(customer);
    state = List.from(updatesCustomers);
  }

  void removeCustomer(Customer customer) {
    state = _customersRepository.removeCustomer(customer);
  }
}

final customerNotifierProvider =
    NotifierProvider<CustomersNotifier, List<Customer>>(
        () => CustomersNotifier());
