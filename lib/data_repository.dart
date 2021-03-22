import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/auth_repository.dart';
import 'package:expense_tracker/expense.dart';

final _firestore = FirebaseFirestore.instance;

CollectionReference get expensesCollection => _firestore.collection('expenses');

Stream<List<Expense>> get expenseStream => expensesCollection
    .where('uid', isEqualTo: currentUid)
    .snapshots()
    .map((snapshot) => snapshot.docs)
    .map((docs) => docs.map((doc) => Expense.fromDocument(doc)).toList());
