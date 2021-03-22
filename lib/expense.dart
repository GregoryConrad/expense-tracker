import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final double amount;
  final String name, description;
  final DocumentReference _document;

  Expense._fromMap(Map<String, dynamic> data, this._document)
      : amount = data['amount'] ?? 0,
        name = data['name'] ?? '',
        description = data['description'] ?? '';

  Expense.fromDocument(DocumentSnapshot document)
      : this._fromMap(document.data() ?? {}, document.reference);

  String get id => _document.id;

  Future<void> delete() => _document.delete();

  Future<void> updateWith({double? amount, String? name, String? description}) {
    return _document.update({
      if (amount != null) 'amount': amount,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
  }

  Color get iconColor {
    const double expensiveCutoff = 100;
    final price = amount.round().abs();
    if (price > expensiveCutoff) return Color(0xFFFF0000);
    final colorFraction = price / expensiveCutoff;
    final colorAmount = (colorFraction * 255).floor();
    return Color.fromRGBO(colorAmount, 255 - colorAmount, 0, 1);
  }
}
