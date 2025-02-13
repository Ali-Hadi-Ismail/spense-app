import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:spense/cubit/states.dart';
import 'package:spense/cubit/transaction_cubit.dart';
import 'package:spense/layout/add_transaction.dart';
import 'package:spense/widgets/pie_chart_home.dart';
import 'package:spense/widgets/record_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TransactionCubit cubit = TransactionCubit.get(context);
        return Scaffold(
          appBar: appBar(),
          body: SafeArea(
            child: Column(
              children: [
                const Divider(
                  thickness: 0.2,
                  color: Colors.black,
                  indent: 0,
                  endIndent: 0,
                ),
                const Text(
                  "Net Balance",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: "SpaceMono",
                      fontWeight: FontWeight.bold),
                ),
                SafeArea(child: PieChartWithLabels()),
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Income: ${cubit.income} ",
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddTransaction()));
                      },
                      backgroundColor: Colors.grey.shade100,
                      elevation: 7,
                      child: Icon(Icons.add),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shadowColor: Colors.red,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                SizedBox(height: 20),
                Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    elevation: 10,
                    color: Colors.white70.withOpacity(0.7),
                    child: Container(
                      margin: EdgeInsets.all(10),
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
                              children: cubit.transaction.map((transaction) {
                                return RecordCard(
                                  category: transaction.category ?? '',
                                  date: transaction.date,
                                  title: transaction.title ?? '',
                                  id: transaction.id ?? '',
                                  value: transaction.value,
                                  type: transaction.type ?? '',
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Spense",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontFamily: 'SpaceMono',
        ),
      ),
    );
  }
}
