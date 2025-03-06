import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordCard extends StatelessWidget {
  final int id;
  final int amount;
  final String category;
  final String title;
  final int date;
  final String type;

  const RecordCard({
    required this.id,
    required this.amount,
    required this.category,
    required this.title,
    required this.date,
    required this.type,
  });

  Color colorGR() {
    if (type == "Expense") {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formatTimestamp(int timestamp) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat('HH:mm  dd-MM-yyyy').format(date);
    }

    return SingleChildScrollView(
      child: GestureDetector(
        onLongPress: () {
          _showOptions(context);
        },
        child: Card(
          elevation: 4,
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
                    const Text("Title                : ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: colorGR(),
                      ),
                    ), // Example type
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Category          : ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(category,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Transaction ID : ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(id.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Date                  : ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(formatTimestamp(date),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500)), // Example date
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Amount            : ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "\$$amount",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: colorGR(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Type                 : ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      type,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: colorGR(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox(
        height: 100,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete"),
              onTap: () {},
            ),
          ],
        ),
      );
    },
  );
}
