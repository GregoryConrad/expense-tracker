import 'package:expense_tracker/model/auth_repository.dart';
import 'package:expense_tracker/model/data_repository.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData.dark(),
      home: StreamBuilder<bool>(
        initialData: false,
        stream: authSteam,
        builder: (context, snapshot) {
          final signedIn = snapshot.data ?? false;
          return signedIn ? HomeWidget() : LoginWidget();
        },
      )));
}

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('You need to be signed in to use this application'),
        TextButton.icon(
          onPressed: signIn,
          icon: Icon(Icons.person_pin),
          label: Text('GOOGLE SIGN IN'),
        ),
      ]),
    );
  }
}

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
              ),
              IconButton(icon: Icon(Icons.person_pin), onPressed: signOut),
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
        content: Column(children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            onChanged: (s) => name = s,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            onChanged: (s) => description = s,
          ),
          TextFormField(
            initialValue: amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
            onChanged: (s) => amount = s,
          )
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

class BodyWidget extends StatelessWidget {
  static const topCardHeight = 56.0;
  static const fabPadding = 2 * 16 + 56.0;

  final List<Expense> expenses;

  BodyWidget({Key? key, required this.expenses}) : super(key: key);

  double get totalAmount =>
      expenses.fold<double>(0.0, (acc, e) => acc + e.amount);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox.expand(
        child: ListView.separated(
          padding: EdgeInsets.only(
            top: topCardHeight + 4,
            bottom: fabPadding,
          ),
          itemBuilder: (_, i) => ExpenseListTile(expense: expenses[i]),
          separatorBuilder: (_, __) => Divider(),
          itemCount: expenses.length,
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: double.infinity,
          height: topCardHeight,
          child: Card(
            child: Center(
              child: Text(
                'There are ${totalAmount.toStringAsFixed(2)} total expenses',
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

class ExpenseListTile extends StatelessWidget {
  final Expense expense;

  ExpenseListTile({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(expense.id),
      background: Container(
        color: Colors.teal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          child: Icon(Icons.edit),
          alignment: Alignment.centerLeft,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          child: Icon(Icons.delete),
          alignment: Alignment.centerRight,
        ),
      ),
      confirmDismiss: (direction) async {
        switch (direction) {
          case DismissDirection.endToStart:
            return await _openDeleteConfirmation(context);
          case DismissDirection.startToEnd:
            _openUpdateDialog(context);
            break;
          default:
            print('Unhandled dismiss of an ExpenseListTile: $direction');
            break;
        }
        return false;
      },
      onDismissed: (_) => expense.delete(),
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade300.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.attach_money, color: expense.iconColor),
        ),
        title: Text(expense.name),
        subtitle:
            expense.description.isEmpty ? null : Text(expense.description),
        trailing: Text(NumberFormat.simpleCurrency().format(expense.amount)),
        onLongPress: () => _openInfoDialog(context),
      ),
    );
  }

  Future<bool> _openDeleteConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete ${expense.name}?'),
        actions: [
          TextButton(
            child: Text('CANCEL'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text('DELETE'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  Future<void> _openInfoDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${expense.name} Options'),
        content: expense.description.isEmpty
            ? null
            : Text('Description: ${expense.description}'),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('MODIFY'),
            onPressed: () {
              Navigator.pop(context);
              _openUpdateDialog(context);
            },
          ),
          TextButton(
            child: Text('DELETE'),
            onPressed: () async {
              Navigator.pop(context);
              if (await _openDeleteConfirmation(context)) {
                expense.delete();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openUpdateDialog(BuildContext context) {
    // todo
    return showDialog(
      context: context,
      builder: (_) => Container(),
    );
  }
}
