import 'dart:convert';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  @override
  State<Wallet> createState() => _CSVViewerPageState();
}

class _CSVViewerPageState extends State<Wallet> {
  List<dynamic> expenses = [];
  List<String> hashtags = [];
  String selectedHashtag = 'All';

  @override
  void initState() {
    super.initState();
    // Parse JSON data and populate the expenses list
    String jsonData = '''
      {"expenses":[{"name":"recharge ","currency":1800.0,"time":"2023-07-02T23:43:13.577","type":"expense","accountId":0,"categoryId":2,"superId":1,"description":null,"fromAccountId":null,"toAccountId":null,"transferAmount":0.0},{"name":"god","currency":500.0,"time":"2023-07-02T23:43:36.157","type":"expense","accountId":0,"categoryId":2,"superId":2,"description":"","fromAccountId":null,"toAccountId":null,"transferAmount":0.0},{"name":"paytmadd","currency":5000.0,"time":"2023-07-03T23:36:05.374","type":"expense","accountId":0,"categoryId":3,"superId":3,"description":null,"fromAccountId":null,"toAccountId":null,"transferAmount":0.0},{"name":"peer","currency":200.0,"time":"2023-07-04T22:02:03.821","type":"expense","accountId":0,"categoryId":0,"superId":4,"description":null,"fromAccountId":null,"toAccountId":null,"transferAmount":0.0},{"name":"rent","currency":9000.0,"time":"2023-07-05T23:42:47.377","type":"expense","accountId":0,"categoryId":1,"superId":5,"description":null,"fromAccountId":null,"toAccountId":null,"transferAmount":0.0}]}
    ''';
    Map<String, dynamic> data = json.decode(jsonData);
    expenses = data['expenses'];

    // Extract hashtags from expenses
    for (var expense in expenses) {
      if (expense['type'] != null && !hashtags.contains(expense['type'])) {
        hashtags.add(expense['type']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Viewer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedHashtag,
              onChanged: (String? newValue) {
                setState(() {
                  selectedHashtag = newValue!;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: 'All',
                  child: Text('All'),
                ),
                for (var hashtag in hashtags)
                  DropdownMenuItem<String>(
                    value: hashtag,
                    child: Text(hashtag),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> expense = expenses[index];

                if (selectedHashtag == 'All' ||
                    expense['type'] == selectedHashtag) {
                  return ListTile(
                    title: Text(expense['name']),
                    subtitle: Text(expense['currency'].toString()),
                    trailing: Text(expense['time']),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showExpenseFormDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showExpenseFormDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController currencyController = TextEditingController();
    String? selectedType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: currencyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Currency',
                ),
              ),
              DropdownButton<String>(
                value: selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: 'expense',
                    child: Text('Expense'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'income',
                    child: Text('Income'),
                  ),
                ],
                hint: Text('Select Type'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  String name = nameController.text;
                  double currency = double.parse(currencyController.text);

                  expenses.add({
                    'name': name,
                    'currency': currency,
                    'time': DateTime.now().toString(),
                    'type': selectedType,
                  });

                  Navigator.pop(context);
                });
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
