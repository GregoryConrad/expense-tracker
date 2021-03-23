import 'package:expense_tracker/model/auth_repository.dart';
import 'package:expense_tracker/model/data_repository.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/views/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: expenseStream,
      builder: (context, snapshot) {
        final expenses = snapshot.data ?? [];
        return Scaffold(
          appBar: AppBar(
            title: Text('Expense Tracker'),
            actions: [
              IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () => _showRemoveAllConfirmation(context, expenses),
                tooltip: 'Delete All Expenses',
              ),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: signOut,
                tooltip: 'Sign Out',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddExpenseDialog(context),
            tooltip: 'Add Expense',
            child: Icon(Icons.add),
          ),
          body: snapshot.hasData
              ? BodyWidget(expenses: expenses)
              : LinearProgressIndicator(),
        );
      },
    );
  }

  Future<bool> _showAddExpenseDialog(BuildContext context) async {
    String name = '', description = '', amount = '0';
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Expense'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            onChanged: (s) => name = s,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
            onChanged: (s) => description = s,
          ),
          TextFormField(
            initialValue: amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
            onChanged: (s) => amount = s,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.-]')),
            ],
          ),
        ]),
        actions: [
          TextButton(
            child: Text('CANCEL'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text('CREATE'),
            onPressed: () async {
              Navigator.pop(context, true);
              final added = await createExpense(
                  name, description, double.tryParse(amount) ?? 0);
              if (!added) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create the expense')));
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showRemoveAllConfirmation(
      BuildContext context, List<Expense> expenses) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Remove All Expenses?'),
        content: Text('Are you sure you want to remove all expenses?'),
        actions: <Widget>[
          TextButton(
            child: Text('NO'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('YES'),
            onPressed: () {
              Navigator.pop(context);
              expenses.forEach((expense) => expense.delete());
            },
          ),
        ],
      ),
    );
  }
}
