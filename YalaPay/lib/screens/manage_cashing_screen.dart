// lib/screens/manage_cashings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/repo/cheque_repository.dart';
import 'package:quickmart/models/cheque.dart';
import 'package:quickmart/providers/bank_account_provider.dart';
import 'package:quickmart/models/bank_account.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/widgets/custom_app_bar.dart';

class ManageCashingsScreen extends ConsumerStatefulWidget {
  @override
  _ManageCashingsScreenState createState() => _ManageCashingsScreenState();
}

class _ManageCashingsScreenState extends ConsumerState<ManageCashingsScreen> {
  Set<int> selectedChequeNumbers = {};
  BankAccount? selectedBankAccount;

  @override
  Widget build(BuildContext context) {
    final chequeRepository = ref.read(chequeRepositoryProvider);
    final bankAccounts = ref.watch(bankAccountProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFF7),
      appBar: CustomAppBar(
        titleText: 'Manage Caching',
        subtitleText: 'Manage caching data',
      ),
      body: FutureBuilder<List<Cheque>>(
        future: chequeRepository.loadCheques(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading cheques"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No cheques available"));
          }

          final cheques = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cheques.length,
                  itemBuilder: (context, index) {
                    final cheque = cheques[index];
                    final daysRemaining =
                        cheque.dueDate.difference(DateTime.now()).inDays;

                    return CheckboxListTile(
                      title: Text(
                        "Cheque No: ${cheque.chequeNo}",
                        style: TextStyle(
                          color: Color(0xFF915050),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Status: ${cheque.status}\nDue Date: ${cheque.dueDate.toLocal()} (${daysRemaining >= 0 ? '+' : ''}$daysRemaining days)",
                        style: TextStyle(
                          color: cheque.status == "Deposited"
                              ? Colors.grey
                              : (daysRemaining >= 0
                                  ? Colors.green
                                  : Colors.red),
                        ),
                      ),
                      value: selectedChequeNumbers.contains(cheque.chequeNo),
                      onChanged: cheque.status == "Deposited"
                          ? null
                          : (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedChequeNumbers.add(cheque.chequeNo);
                                } else {
                                  selectedChequeNumbers.remove(cheque.chequeNo);
                                }
                              });
                            },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
              DropdownButton<BankAccount>(
                hint: Text("Select Bank Account"),
                value: selectedBankAccount,
                onChanged: (BankAccount? newAccount) {
                  setState(() {
                    selectedBankAccount = newAccount;
                  });
                },
                items: bankAccounts.map((account) {
                  return DropdownMenuItem(
                    value: account,
                    child: Text('${account.bank} - ${account.accountNo}'),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: selectedBankAccount == null ||
                            selectedChequeNumbers.isEmpty
                        ? null
                        : () async {
                            final selectedCheques = cheques
                                .where((cheque) => selectedChequeNumbers
                                    .contains(cheque.chequeNo))
                                .toList();
                            await chequeRepository.createDeposit(
                              selectedCheques,
                              selectedBankAccount!.accountNo,
                            );
                            setState(() {
                              selectedChequeNumbers.clear();
                            });
                            ref.refresh(chequeRepositoryProvider);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[400],
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Create Deposit",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 250, 250, 250),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).go('/chequeDeposits');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[400],
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "View Deposits",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 250, 250, 250),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
