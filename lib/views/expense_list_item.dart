import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/model/extensions.dart';
import 'package:flutter/material.dart';

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
            await _openUpdateDialog(context);
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
        trailing: Text(expense.amount.toCurrency()),
        onLongPress: () => _openInfoDialog(context),
      ),
    );
  }

  Future<bool> _openDeleteConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
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

  Future<void> _openInfoDialog(BuildContext context) async {
    return await showDialog(
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
