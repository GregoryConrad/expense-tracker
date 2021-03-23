import 'package:expense_tracker/model/auth_repository.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('You need to be signed in to use this application'),
          TextButton.icon(
            onPressed: signIn,
            icon: Icon(Icons.person),
            label: Text('GOOGLE SIGN IN'),
          ),
        ]),
      ),
    );
  }
}
