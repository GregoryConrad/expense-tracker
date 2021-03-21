class Expense {
  final double amount;
  final String name, description;

  Expense._fromMap(Map<String, dynamic> data)
      : amount = data['amount'] ?? 0,
        name = data['name'] ?? '',
        description = data['description'] ?? '';

  // TODO from document
}
