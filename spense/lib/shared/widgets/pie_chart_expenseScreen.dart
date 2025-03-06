import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:spense/shared/cubit/transaction_cubit.dart';
import 'package:spense/shared/cubit/states.dart';

class PieChartExpenseScreen extends StatefulWidget {
  const PieChartExpenseScreen({super.key});

  @override
  _PieChartExpenseScreenState createState() => _PieChartExpenseScreenState();
}

class _PieChartExpenseScreenState extends State<PieChartExpenseScreen> {
  Future<List<ChartData>>? chartDataFuture;

  @override
  void initState() {
    super.initState();
    final cubit = TransactionCubit.get(context);
    chartDataFuture = _getChartData(cubit);
  }

  Future<List<ChartData>> _getChartData(TransactionCubit cubit) async {
    final List<ChartData> chartD = [];
    final result = await cubit
        .getExpenseCategoryPrice(cubit.mydatabase); // Updated to expense
    for (int i = 0; i < result.length; i++) {
      String category =
          "${result[i]["category"]} ${result[i]["totalAmount"]}\$ ";
      int total = int.parse(result[i]["totalAmount"].toString());
      Color color = redColors[i % redColors.length]; // Updated to red colors

      chartD.add(ChartData(category, color, total));
    }
    return chartD;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return FutureBuilder<List<ChartData>>(
          future: chartDataFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            List<ChartData> chartData = snapshot.data!;
            double categoryTotal = chartData.fold(
                0, (prev, element) => prev + element.totalAmount);

            return SizedBox(
              width: double.infinity,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SfCircularChart(
                      legend: Legend(
                        borderWidth: 2,
                        borderColor: Colors.blueGrey,
                        isResponsive: true,
                        isVisible: true,
                        title: const LegendTitle(
                          text: "Categories",
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontFamily: "SpaceMono",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        position: LegendPosition.top,
                        overflowMode: LegendItemOverflowMode.wrap,
                        legendItemBuilder: (String name, dynamic series,
                            dynamic point, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color:
                                        chartData[index].color, // Legend color
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(
                                    width: 8), // Spacing between color and text
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "SpaceMono",
                                    color: Color.fromARGB(255, 8, 8, 8),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<ChartData, String>(
                          dataSource: chartData,
                          animationDuration: 800,
                          enableTooltip: true,
                          xValueMapper: (ChartData data, _) =>
                              data.categoryLabel,
                          yValueMapper: (ChartData data, _) => data.totalAmount,
                          pointColorMapper: (ChartData data, _) => data.color,
                          innerRadius: '75%',
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                            alignment: ChartAlignment.far,
                            showCumulativeValues: true,
                            showZeroValue: false,
                            connectorLineSettings: ConnectorLineSettings(
                                length: "5%",
                                type: ConnectorType.curve,
                                width: 1),
                          ),
                          dataLabelMapper: (ChartData data, _) {
                            if (categoryTotal == 0) {
                              return '0%';
                            }
                            int percentage =
                                ((data.totalAmount / categoryTotal) * 100)
                                    .toInt();
                            return '$percentage%';
                          },
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 195,
                      left: 135,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${categoryTotal.toInt()}\$",
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: "SpaceMono",
                              color: Colors.red.shade600, // Updated to red
                            ),
                          ),
                          Text(
                            "Total Expense", // Updated to Expense
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "SpaceMono",
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChartData {
  final String categoryLabel;
  final Color color;
  final int totalAmount;

  ChartData(this.categoryLabel, this.color, this.totalAmount);
}

const List<Color> redColors = [
  Color(0xFFDC143C), // Crimson
  Color(0xFFFF0000), // Red
  Color(0xFFB22222), // Firebrick
  Color(0xFF8B0000), // Dark Red
  Color(0xFFFF6347), // Tomato
  Color(0xFFFF4500), // Orange Red
  Color(0xFFFF7F50), // Coral
  Color(0xFFCD5C5C), // Indian Red
  Color(0xFFF08080), // Light Coral
  Color(0xFFE9967A), // Dark Salmon
  Color(0xFFFA8072), // Salmon
  Color(0xFFFFA07A), // Light Salmon
  Color(0xFFFF8C00), // Dark Orange
  Color(0xFFFFA500), // Orange
  Color(0xFFFFD700), // Gold
  Color(0xFFB8860B), // Dark Goldenrod
  Color(0xFFDAA520), // Goldenrod
  Color(0xFFFF69B4), // Hot Pink
  Color(0xFFFF1493), // Deep Pink
  Color(0xFFC71585), // Medium Violet Red
];
