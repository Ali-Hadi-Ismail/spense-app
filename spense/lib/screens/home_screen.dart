import 'package:flutter/material.dart';
import 'package:spense/widgets/pie_chart_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Column(
          children: [
            Divider(
              thickness: 0.2, // Adjust thickness for a thinner line
              color: Colors.black, // Choose the color of the line
              indent: 0, // Set the indentation from the start
              endIndent: 0, // Set the indentation from the end
            ),
            Text(
              "Net Balance",
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: "SpaceMono",
                  fontWeight: FontWeight.bold),
            ),
            PieChartWithLabels(),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("data"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Spense",
        style: TextStyle(
          fontSize: 24, // Font size (adjust as needed)
          fontWeight: FontWeight.bold, // Bold for emphasis
          letterSpacing: 1.2,
          fontFamily: 'SpaceMono',
        ),
      ),
    );
  }
}
