import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/providers/deposits_provider.dart';
import 'package:quickmart/models/cheque.dart';
import 'package:quickmart/repo/cheque_repository.dart';

class ChequeDepositsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deposits = ref.watch(depositsProvider);
    final chequeRepository = ref.read(chequeRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cheque Deposits'),
        backgroundColor: Colors.brown[400],
      ),
      body: deposits.isEmpty
          ? Center(child: Text("No deposits available"))
          : ListView.builder(
              itemCount: deposits.length,
              itemBuilder: (context, index) {
                final deposit = deposits[index];
                final chequeNos = List<int>.from(deposit['chequeNos'] ?? []);

                // Format the deposit date manually to "dd/MM/yyyy"
                final depositDateRaw = deposit["depositDate"];
                final DateTime parsedDate = DateTime.parse(depositDateRaw);
                final String depositDate = "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";

                return FutureBuilder<List<Cheque>>(
                  future: Future.wait(chequeNos.map((no) => chequeRepository.getChequeByNumber(no))),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final cheques = snapshot.data ?? [];
                    final totalAmount = cheques.fold(0.0, (sum, cheque) => sum + cheque.amount);

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: ExpansionTile(
                        title: Text(
                          'Deposit ID: ${deposit["id"]}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[800]),
                        ),
                        subtitle: Text(
                          'Date: $depositDate\n' // Use formatted deposit date here
                          'Total Amount: \$${totalAmount.toStringAsFixed(2)} - Cheques Count: ${cheques.length}',
                          style: TextStyle(color: Colors.brown[600]),
                        ),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cheques.length,
                            itemBuilder: (context, chequeIndex) {
                              final cheque = cheques[chequeIndex];
                              return ListTile(
                                leading: cheque.chequeImageUri != null
                                    ? Image.asset(
                                        'assets/data/cheques/${cheque.chequeImageUri}',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(Icons.image_not_supported, color: Colors.grey),
                                title: Text('Cheque No: ${cheque.chequeNo}'),
                                subtitle: Text('Amount: \$${cheque.amount}'),
                              );
                            },
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Update logic here
                                },
                                icon: Icon(Icons.edit),
                                label: Text('Update'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await ref.read(depositsProvider.notifier).deleteDeposit(deposit["id"]);
                                },
                                icon: Icon(Icons.delete),
                                label: Text('Delete'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
