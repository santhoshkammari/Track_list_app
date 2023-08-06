import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class WalletMain extends StatefulWidget {
  @override
  State<WalletMain> createState() => _WalletHomePageState();
}

// class _WalletHomePageState extends State<WalletMain> {
//   double balance = 1000.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Wallet App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Current Balance:',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 10),
//             Text(
//               '\$$balance',
//               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Add logic to handle top-up or money transfer
//               },
//               child: Text('Top-up'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Add logic to handle transaction history
//               },
//               child: Text('Transaction History'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

enum TransactionType {
  expense,
  income,
}

class Transaction {
  final TransactionType type;
  final String description;
  final double amount;
  final String hashtag;
  final DateTime date;

  Transaction({
    required this.type,
    required this.description,
    required this.amount,
    required this.hashtag,
    required this.date,
  });
}

class _WalletHomePageState extends State<WalletMain> {
  double balance = 1000.0;
  String bankCardName = '';
  List<Transaction> transactions = [];

  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController hashtagController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    hashtagController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void addTransaction() {
    final String description = descriptionController.text.trim();
    final double amount = double.tryParse(amountController.text) ?? 0.0;
    final String hashtag = hashtagController.text.trim();
    final DateTime date = DateTime.parse(dateController.text);

    if (description.isEmpty || amount <= 0 || date == null) {
      return; // Invalid input, do not add transaction
    }

    final TransactionType type =
        amount < 0 ? TransactionType.expense : TransactionType.income;
    final Transaction transaction = Transaction(
      type: type,
      description: description,
      amount: amount.abs(),
      hashtag: hashtag,
      date: date,
    );

    setState(() {
      transactions.add(transaction);
      balance += type == TransactionType.expense ? -amount : amount;
    });

    // Clear the input fields
    descriptionController.clear();
    amountController.clear();
    hashtagController.clear();
    dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16.0),
            ),
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Current Balance',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  '\$$balance',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add Expense/Income'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                            ),
                          ),
                          TextField(
                            controller: amountController,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: hashtagController,
                            decoration: InputDecoration(
                              labelText: 'Hashtag',
                            ),
                          ),
                          TextField(
                            controller: dateController,
                            decoration: InputDecoration(
                              labelText: 'Date (yyyy-mm-dd)',
                            ),
                          ),
                          DropdownButtonFormField<TransactionType>(
                            value: TransactionType.expense,
                            onChanged: (TransactionType? newValue) {
                              setState(() {
                                if (newValue != null) {
                                  // Update the selected type
                                  final double amount =
                                      double.tryParse(amountController.text) ??
                                          0.0;
                                  if (newValue == TransactionType.expense) {
                                    balance -= amount;
                                  } else if (newValue ==
                                      TransactionType.income) {
                                    balance += amount;
                                  }
                                  // Assign newValue to a variable or use it directly as needed
                                }
                              });
                            },
                            items: TransactionType.values
                                .map((TransactionType type) {
                              return DropdownMenuItem<TransactionType>(
                                value: type,
                                child: Text(type.toString().split('.').last),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Expense/Income',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            appState.addTransaction(23);
                            Navigator.of(context).pop();
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Expense/Income'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = transactions[index];
                return ListTile(
                  leading: Icon(
                    transaction.type == TransactionType.expense
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                  ),
                  title: Text(transaction.description),
                  subtitle: Text(transaction.hashtag),
                  trailing: Text(
                    '\$${transaction.amount.toStringAsFixed(2)}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
