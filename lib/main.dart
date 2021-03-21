import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Expense Tracker',
    theme: ThemeData.dark(),
    home: Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          // todo if signed in, sign out
          // todo if not logged in, google sign in prompt
          // todo default to anonymous sign in
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
      body: Body(),
    ),
  ));
}

class Body extends StatelessWidget {
  static const topCardHeight = 56.0;
  static const fabPadding = 2 * 16 + 56.0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox.expand(
        child: ListView.separated(
          padding: EdgeInsets.only(
            top: topCardHeight + 4,
            bottom: fabPadding,
          ),
          itemBuilder: (_, index) => Container(),
          separatorBuilder: (_, __) => Divider(),
          itemCount: 0,
        ),
      )
    ]);
  }
}
