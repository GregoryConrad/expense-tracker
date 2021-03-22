import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final double amount;
  final String name, description;
  final DocumentReference document;

  Expense._fromMap(Map<String, dynamic> data, this.document)
      : amount = data['amount'] ?? 0,
        name = data['name'] ?? '',
        description = data['description'] ?? '';

  Expense.fromDocument(DocumentSnapshot document)
      : this._fromMap(document.data() ?? {}, document.reference);

  Future<void> delete() {
    return document.delete();
  }

  Future<void> updateWith({double? amount, String? name, String? description}) {
    return document.update({
      if (amount != null) 'amount': amount,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
  }
}
