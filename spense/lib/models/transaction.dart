class Transaction {
  String? id;
  int amount;
  String category;
  String title;
  int date;
  String type;

  Transaction({
    this.id,
    required this.amount,
    required this.category,
    required this.title,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'title': title,
      'date': date,
      'type': type
    };
  }
}
