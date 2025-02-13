class Transaction {
  String? id;
  int value;
  String category;
  String title;
  DateTime date;
  String type;

  Transaction({
    this.id,
    required this.value,
    required this.category,
    required this.title,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
      'category': category,
      'title': title,
      'date': date.toIso8601String(),
      'type': type
    };
  }
}
