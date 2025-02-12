import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:spense/cubit/transaction_cubit.dart';
import 'package:spense/cubit/states.dart';

class PieChartWithLabels extends StatelessWidget {
  const PieChartWithLabels({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionStates>(
      builder: (context, state) {
        // Get the latest values from the Cubit
        var cubit = TransactionCubit.get(context);
        int income = cubit.getIncome();
        int expense = cubit.getExpense();
        int totalPrice = cubit.totalPrice;

        List<ChartData> chartData = [
          ChartData("Income", income.toDouble(), Colors.green),
          ChartData("Expense", expense.toDouble(), Colors.red),
        ];

        return SizedBox(
          height: 350,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SfCircularChart(
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: chartData,
                    animationDuration: 500,
                    enableTooltip: true,
                    xValueMapper: (ChartData data, _) => data.label,
                    yValueMapper: (ChartData data, _) => data.value,
                    pointColorMapper: (ChartData data, _) => data.color,
                    innerRadius: '75%', // Adjusted for better space
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                      alignment: ChartAlignment.center,
                      connectorLineSettings: ConnectorLineSettings(
                        length: "10%",
                        type: ConnectorType.curve,
                      ),
                    ),
                    dataLabelMapper: (ChartData data, _) {
                      int percentage =
                          ((data.value / (income + expense)) * 100).toInt();
                      return '${percentage}%';
                    },
                  ),
                ],
              ),
              Text(
                "$totalPrice\$",
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: "SpaceMono",
                  color: (totalPrice >= 0 ? Colors.green.shade600 : Colors.red),
                ),
              )
            ],
          ),
        );
      },
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
