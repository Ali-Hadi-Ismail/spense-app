import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordCard extends StatelessWidget {
  int id;
  int value;
  String category;
  String title;
  String date;
  String type;

  RecordCard({
    required this.id,
    required this.value,
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
                    Text("Title                : ",
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
                    Text("Category          : ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(category,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Transaction ID : ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(id.toString(),
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date                  : ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(date,
                        style: TextStyle(
                            fontWeight: FontWeight.w500)), // Example date
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Amount            : ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      "\$${value}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: colorGR(),
                      ),
                    ), // Example amount
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Type                 : ",
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
      return Container(
        height: 100,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text("Delete"),
              onTap: () {},
            ),
          ],
        ),
      );
    },
  );
}
