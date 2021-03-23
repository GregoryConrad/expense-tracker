import 'package:expense_tracker/model/auth_repository.dart';
import 'package:expense_tracker/views/home.dart';
import 'package:expense_tracker/views/login.dart';
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
    ),
  ));
}
