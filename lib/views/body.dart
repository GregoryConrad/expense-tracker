import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/model/extensions.dart';
import 'package:expense_tracker/views/expense_list_item.dart';
import 'package:flutter/material.dart';

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
                'There are ${totalAmount.toCurrency()} total expenses',
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
