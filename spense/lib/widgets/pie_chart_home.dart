import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartWithLabels extends StatelessWidget {
  const PieChartWithLabels({super.key});

  @override
  Widget build(BuildContext context) {
    // Creating a list of data points for the chart
    List<ChartData> chartData = [
      ChartData("Income", 100, Colors.green), // green border for Income
      ChartData("Expense", 10, Colors.red), // red border for Expense
    ];
    int totalPrice = 110 - 10;
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SfCircularChart(
            series: <CircularSeries>[
              DoughnutSeries<ChartData, String>(
                dataSource: chartData,
                animationDuration: 1000,
                enableTooltip: true,
                xValueMapper: (ChartData data, _) => data.label,
                yValueMapper: (ChartData data, _) => data.value,
                pointColorMapper: (ChartData data, _) => data.color,
                innerRadius: '80%',
                dataLabelMapper: (ChartData data, _) {
                  double percentage = (data.value / 100) * 100;
                  return '${data.label}: ${percentage.toStringAsFixed(1)}%';
                },
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  alignment: ChartAlignment.near,
                  borderColor:
                      Colors.grey, // Dynamic color assignment for label border
                  borderRadius: 20,
                  borderWidth: 1.2,
                  connectorLineSettings: ConnectorLineSettings(
                    length: "20%",
                    type: ConnectorType.curve,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "$totalPrice \$",
            style: TextStyle(
              fontSize: 20,
              fontFamily: "SpaceMono",
            ),
          )
        ],
      ),
    );
  }
}

class ChartData {
  final String label;
  final double value;
  final Color color;

  // Constructor with necessary fields
  ChartData(this.label, this.value, this.color);
}
