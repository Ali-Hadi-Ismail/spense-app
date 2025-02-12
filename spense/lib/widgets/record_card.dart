import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordCard extends StatelessWidget {
  String? id;
  int value;
  String category;
  String title;
  DateTime date;
  String type;

  RecordCard({
    this.id,
    required this.value,
    required this.category,
    required this.title,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MM-dd-yyyy hh:mm').format(date);
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Category          : ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(category, style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Transaction ID : ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(id!, style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date                  : ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(formattedDate,
                    style:
                        TextStyle(fontWeight: FontWeight.w500)), // Example date
              ],
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amount            : ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("\$${value}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: (type == "Expense")
                            ? Colors.red
                            : Colors.green)), // Example amount
              ],
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Type                 : ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Expense",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red)), // Example type
              ],
            ),
          ],
        ),
      ),
    );
  }
}
