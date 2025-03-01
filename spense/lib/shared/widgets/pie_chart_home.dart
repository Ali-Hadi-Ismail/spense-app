import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:spense/shared/cubit/transaction_cubit.dart';
import 'package:spense/shared/cubit/states.dart';

class PieChartWithLabels extends StatelessWidget {
  const PieChartWithLabels({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionStates>(
      buildWhen: (prev, curr) {
        if (curr is! TransactionUpdated) return false;
        if (prev is! TransactionUpdated) return true;
        return prev.income != curr.income || prev.expense != curr.expense;
      },
      builder: (context, state) {
        if (state is TransactionUpdated) {
          var cubit = TransactionCubit.get(context);

          int income = state.income;
          int expense = state.expense;
          int totalPrice = state.totalPrice;

          List<ChartData> chartData = [
            ChartData("Income", income, Colors.green),
            ChartData("Expense", expense, Colors.red),
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
                      animationDuration: 800,

                      enableTooltip: true,
                      xValueMapper: (ChartData data, _) => data.label,
                      yValueMapper: (ChartData data, _) => data.amount,
                      pointColorMapper: (ChartData data, _) => data.color,
                      innerRadius: '75%', // Adjusted for better space
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        alignment: ChartAlignment.center,
                        connectorLineSettings: ConnectorLineSettings(
                          length: "10%",
                          type: ConnectorType.curve,
                        ),
                      ),
                      dataLabelMapper: (ChartData data, _) {
                        if (income + expense == 0) {
                          return '0%';
                        }
                        int percentage =
                            ((data.amount / (income + expense)) * 100).toInt();
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
                    color:
                        (totalPrice >= 0 ? Colors.green.shade600 : Colors.red),
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ChartData {
  final String label;
  final int amount;
  final Color color;

  // Constructor with necessary fields
  ChartData(this.label, this.amount, this.color);
}
