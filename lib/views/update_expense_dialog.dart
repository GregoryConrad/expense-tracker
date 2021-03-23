import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class UpdateExpenseDialog extends StatefulWidget {
  final Expense expense;

  const UpdateExpenseDialog({Key? key, required this.expense})
      : super(key: key);

  @override
  _UpdateExpenseDialogState createState() => _UpdateExpenseDialogState(expense);
}

class _UpdateExpenseDialogState extends State<UpdateExpenseDialog> {
  final Expense expense;
  String name, description, amount;
  _UpdateState currState = _UpdateState.name;

  _UpdateExpenseDialogState(this.expense)
      : name = expense.name,
        description = expense.description,
        amount = expense.amount.toStringAsFixed(2);

  String get currField {
    switch (currState) {
      case _UpdateState.name:
        return name;
      case _UpdateState.description:
        return description;
      case _UpdateState.amount:
        return amount;
    }
  }

  set currField(String s) {
    switch (currState) {
      case _UpdateState.name:
        name = s;
        break;
      case _UpdateState.description:
        description = s;
        break;
      case _UpdateState.amount:
        amount = s;
        break;
    }
  }

  ChoiceChip _createChoice(_UpdateState type) {
    return ChoiceChip(
      label: Text(type.label),
      selected: currState == type,
      onSelected: (selected) {
        if (selected) setState(() => currState = type);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modify ${expense.name}'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 256),
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: [
              _createChoice(_UpdateState.name),
              _createChoice(_UpdateState.description),
              _createChoice(_UpdateState.amount),
            ],
          ),
        ),
        TextFormField(
          key: ValueKey(currState),
          initialValue: currField,
          onChanged: (s) => currField = s,
          decoration: InputDecoration(labelText: currState.label),
          maxLines: currState.maxLines,
        ),
      ]),
      actions: [
        TextButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('SAVE'),
          onPressed: () {
            Navigator.pop(context);
            expense.updateWith(
              name: name,
              description: description,
              amount: double.tryParse(amount) ?? expense.amount,
            );
          },
        ),
      ],
    );
  }
}

enum _UpdateState { name, description, amount }

extension _ on _UpdateState {
  int get maxLines => this == _UpdateState.description ? 3 : 1;

  String get label {
    switch (this) {
      case _UpdateState.name:
        return 'Name';
      case _UpdateState.description:
        return 'Description';
      case _UpdateState.amount:
        return 'Amount';
    }
  }
}
