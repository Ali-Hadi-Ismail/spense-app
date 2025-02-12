import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:spense/cubit/states.dart';
import 'package:spense/cubit/transaction_cubit.dart';
import 'package:spense/widgets/pie_chart_home.dart';
import 'package:spense/widgets/record_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //1 when making cubit we first work with stl
    //2 make BlocProvider

    return BlocProvider(
      create: (BuildContext context) => TransactionCubit(),
      child: BlocConsumer<TransactionCubit, TransactionStates>(
        listener: (context, state) {},
        builder: (context, state) {
          TransactionCubit c = BlocProvider.of(context);
          TransactionCubit cubit = TransactionCubit.get(context);
          return Scaffold(
            appBar: appBar(),
            body: SafeArea(
              child: Column(
                children: [
                  const Divider(
                    thickness: 0.2, // Adjust thickness for a thinner line
                    color: Colors.black, // Choose the color of the line
                    indent: 0, // Set the indentation from the start
                    endIndent: 0, // Set the indentation from the end
                  ),
                  const Text(
                    "Net Balance",
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: "SpaceMono",
                        fontWeight: FontWeight.bold),
                  ),
                  SafeArea(child: PieChartWithLabels()),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shadowColor: Colors.green,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12), // Adds spacing
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceAround, // Keeps button size compact
                          children: [
                            Text(
                              "Income: ${c.income} ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Spacemono",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(FontAwesomeIcons.arrowTrendUp,
                                color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: Colors.grey.shade100,
                        elevation: 7,
                        child: Icon(Icons.add),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shadowColor: Colors.red,
                          // Background color
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12), // Adds spacing
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceAround, // Keeps button size compact
                          children: [
                            Text(
                              "Expense: ${cubit.expense} ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Spacemono",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(FontAwesomeIcons.arrowTrendDown,
                                color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 10,
                      color: Colors.white70,
                      child: Column(
                        children: [
                          Text(
                            "Record History",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Spacemono",
                                fontWeight: FontWeight.bold),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                RecordCard(
                                  category: "Personal Care",
                                  date: DateTime.now(),
                                  title: "Hair cut",
                                  id: "21234124",
                                  value: 10,
                                  type: "Expense",
                                ),
                                // Add some space between cards
                                RecordCard(
                                  category: "Personal Care",
                                  date: DateTime.now(),
                                  title: "Hair cut",
                                  id: "21234124",
                                  value: 10,
                                  type: "Expense",
                                ),
                                // Add more RecordCards here as needed
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
