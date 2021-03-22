import 'package:expense_tracker/auth_repository.dart';
import 'package:flutter/material.dart';

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
    )
  ));
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
  static const topCardHeight = 56.0;
  static const fabPadding = 2 * 16 + 56.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(icon: Icon(Icons.person_pin), onPressed: signOut),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
      body: Stack(children: [
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
      ]),
    );
  }
}
