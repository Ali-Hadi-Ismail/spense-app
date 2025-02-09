import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartHome extends StatelessWidget {
  const PieChartHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Set a fixed height
      width: double.infinity, // Full width
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 20,
              color: Colors.blue,
              title: "Income",
            ),
            PieChartSectionData(
              value: 20,
              color: Colors.red,
              title: "Expense",
            ),
          ],
        ),
      ),
    );
  }
}
