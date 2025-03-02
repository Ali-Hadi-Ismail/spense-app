import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:spense/shared/cubit/transaction_cubit.dart';
import 'package:spense/shared/cubit/states.dart';

class PieChartIncomeScreen extends StatefulWidget {
  const PieChartIncomeScreen({Key? key}) : super(key: key);

  @override
  _PieChartIncomeScreenState createState() => _PieChartIncomeScreenState();
}

class _PieChartIncomeScreenState extends State<PieChartIncomeScreen> {
  Future<List<ChartData>>? chartDataFuture;

  @override
  void initState() {
    super.initState();
    final cubit = TransactionCubit.get(context);
    chartDataFuture = _getChartData(cubit);
  }

  Future<List<ChartData>> _getChartData(TransactionCubit cubit) async {
    final List<ChartData> chartD = [];
    final result = await cubit.getIncomeCategoryPrice(cubit.mydatabase);
    for (int i = 0; i < result.length; i++) {
      String category =
          "${result[i]["category"]} ${result[i]["totalAmount"]}\$ ";
      int total = int.parse(result[i]["totalAmount"].toString());
      Color color = greenColors[i % greenColors.length];

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
              height: 335,
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
                            padding:
                                EdgeInsets.all(4), // Padding inside the border
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
                                SizedBox(
                                    width: 8), // Spacing between color and text
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "SpaceMono",
                                    color: const Color.fromARGB(255, 8, 8, 8),
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
                              color: Colors.green.shade600,
                            ),
                          ),
                          Text(
                            "Total Income",
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

const List<Color> greenColors = [
  Color(0xFF50C878), // Emerald Green
  Color(0xFF228B22), // Forest Green
  Color(0xFF32CD32), // Lime Green
  Color(0xFF808000), // Olive Green
  Color(0xFF98FF98), // Mint Green
  Color(0xFF2E8B57), // Sea Green
  Color(0xFF00FF7F), // Spring Green
  Color(0xFF355E3B), // Hunter Green
  Color(0xFF01796F), // Pine Green
  Color(0xFF009E4F), // Shamrock Green
  Color(0xFFD0F0C0), // Tea Green
  Color(0xFF8A9A5B), // Moss Green
  Color(0xFF00A86B), // Jade Green
  Color(0xFF7FFF00), // Chartreuse
  Color(0xFFFF7F50), // Coral
  Color(0xFF40E0D0), // Turquoise
  Color(0xFFF5F5DC), // Beige
  Color(0xFFFFDAB9), // Peach
  Color(0xFFE6E6FA), // Lavender
  Color(0xFFDAA520), // Goldenrod
];
