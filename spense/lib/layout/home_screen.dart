import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:spense/cubit/states.dart';
import 'package:spense/cubit/transaction_cubit.dart';
import 'package:spense/layout/add_transaction.dart';
import 'package:spense/layout/income_screen.dart';
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
                const SafeArea(child: PieChartWithLabels()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    incomeButton(cubit, context),
                    addTransactionButton(context),
                    expenseButton(cubit),
                  ],
                ),
                const SizedBox(height: 20),
                recordHistoryCard(cubit),
              ],
            ),
          ),
          drawer: appDrawer(),
        );
      },
    );
  }

  Drawer appDrawer() {
    return Drawer(
      elevation: 20,
      shadowColor: Colors.green,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(1000),
        ),
      ),
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE6FFE6), // Very Light Green
              Color(0xFFCCFFCC), // Softer Green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                child: Text(
                  "Spense",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ),
            ),
            drawerListLite(
                "Risk Management ", Icons.align_vertical_bottom_outlined),
            const SizedBox(
              height: 20,
            ),
            drawerListLite("Economic Reports", Icons.account_balance_outlined),
            const SizedBox(
              height: 20,
            ),
            drawerListLite("Financial Statements", Icons.savings),
            const SizedBox(
              height: 20,
            ),
            drawerListLite("Setting", Icons.settings),
            const SizedBox(
              height: 20,
            ),
            drawerListLite("About Us", FontAwesomeIcons.userGroup),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Card recordHistoryCard(TransactionCubit cubit) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      elevation: 10,
      color: Colors.white70.withOpacity(0.7),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
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
    );
  }

  ElevatedButton expenseButton(TransactionCubit cubit) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shadowColor: Colors.red,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Expense: ${cubit.expense} ",
            style: const TextStyle(
                fontSize: 16,
                fontFamily: "Spacemono",
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          const Icon(FontAwesomeIcons.arrowTrendDown, color: Colors.white),
        ],
      ),
    );
  }

  FloatingActionButton addTransactionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddTransaction()));
      },
      backgroundColor: Colors.grey.shade100,
      elevation: 7,
      child: const Icon(Icons.add),
    );
  }

  ElevatedButton incomeButton(TransactionCubit cubit, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => IncomeScreen()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shadowColor: Colors.green,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Income: ${cubit.income} ",
            style: const TextStyle(
                fontSize: 16,
                fontFamily: "Spacemono",
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          const Icon(FontAwesomeIcons.arrowTrendUp,
              color: Colors.white, size: 20),
        ],
      ),
    );
  }

  ListTile drawerListLite(String text, IconData listIcon) {
    return ListTile(
      trailing: Icon(listIcon, color: Colors.grey[800]),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: "SpaceMono",
          fontWeight: FontWeight.bold,
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
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontFamily: 'SpaceMono',
        ),
      ),
    );
  }
}
