import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:spense/shared/cubit/states.dart';
import 'package:spense/shared/cubit/transaction_cubit.dart';
import 'package:spense/modules/add_transaction.dart';
import 'package:spense/modules/expense_screen.dart';
import 'package:spense/modules/income_screen.dart';
import 'package:spense/models/transaction.dart';
import 'package:spense/shared/widgets/pie_chart_home.dart';
import 'package:spense/shared/widgets/record_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TransactionCubit cubit = TransactionCubit.get(context);
        // Fetch all records when the screen is initialized
        cubit.getAllRecordFromDatabase(cubit.mydatabase).then((value) {
          cubit.records = value;
          cubit.emit(TransactionUpdated(cubit.income, cubit.expense,
              cubit.totalPrice, cubit.transaction));

          cubit.calculateIncomeAndExpense();
        });
        Widget body(int income, int expense) {
          if (cubit.income == 0 && cubit.expense == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/noRecord.svg",
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No Records Found",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(child: Body(cubit, context));
        }

        return Scaffold(
          key: scaffoldKey, // Assign the scaffoldKey here
          endDrawer: endDrawer(context),
          appBar: appBar(),
          body: body(cubit.income, cubit.expense),
          drawer: appDrawer(),
          floatingActionButton: (cubit.income == 0 && cubit.expense == 0)
              ? FloatingActionButton(
                  heroTag: "addTransaction",
                  backgroundColor: Colors.grey.shade100,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTransaction()));
                  },
                  child: Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  SafeArea Body(TransactionCubit cubit, BuildContext context) {
    return SafeArea(
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
              expenseButton(cubit, context),
            ],
          ),
          const SizedBox(height: 10),
          recordHistoryCard(cubit),
        ],
      ),
    );
  }

  Drawer endDrawer(BuildContext context) {
    return Drawer(
      elevation: 60,
      shadowColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(1000),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE6E6), // Very Light Red
              Color(0xFFFFCCCC), // Softer Red
            ],
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                child: Text(
                  "Edit",
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
            drawerListLite("Edit Record ", Icons.edit, () {}),
            const SizedBox(
              height: 20,
            ),
            drawerListLite(
              "Delete Record",
              Icons.delete,
              () {
                TextEditingController _id = TextEditingController();
                Navigator.pop(context);
                showDialog(
                    barrierColor: Colors.black45.withOpacity(0.7),
                    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
                    useSafeArea: true,
                    context: context,
                    builder: (context) => AlertDialog(
                          shadowColor: Colors.black,
                          elevation: 20,
                          scrollable: true,
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  "   id  :  ",
                                  style: TextStyle(
                                    fontFamily: "Spacemono",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    style: const TextStyle(
                                        fontSize: 12, fontFamily: "Spacemono"),
                                    controller: _id,
                                    decoration: InputDecoration(
                                      hintText:
                                          "Enter Record Id , to delete record",
                                      hintStyle: const TextStyle(
                                        fontFamily: "monospace",
                                        fontSize: 10,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      TransactionCubit.get(context)
                                          .deleteRecord(int.parse(_id.text));
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStatePropertyAll(Colors.red)),
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ),
                          ],
                          title: const Text("Delete Record "),
                          titleTextStyle: const TextStyle(
                              fontFamily: "Spacemono",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            drawerListLite(
              "Reset App",
              Icons.restore_rounded,
              () {
                Navigator.pop(context);
                TransactionCubit.get(context).deleteAllDatabaseRecord();
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Drawer appDrawer() {
    return Drawer(
      elevation: 60,
      shadowColor: Colors.black,
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
            drawerListLite("Risk Management ",
                Icons.align_vertical_bottom_outlined, () {}),
            const SizedBox(
              height: 20,
            ),
            drawerListLite(
                "Economic Reports", Icons.account_balance_outlined, () {}),
            const SizedBox(
              height: 20,
            ),
            drawerListLite("Financial Statements", Icons.savings, () {}),
            const SizedBox(
              height: 20,
            ),
            drawerListLite("Setting", Icons.settings, () {}),
            const SizedBox(
              height: 20,
            ),
            drawerListLite("About Us", FontAwesomeIcons.userGroup, () {}),
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
                children: cubit.records.map((record) {
                  return RecordCard(
                    id: record['id'],
                    title: record['title'],
                    date: record['date'],
                    category: record['category'],
                    value: record['value'],
                    type: record['type'],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton expenseButton(TransactionCubit cubit, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpenseScreen()));
      },
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
            "Expense: ${cubit.expense} \$  ",
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.grey.shade100,
      elevation: 10,
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
            "Income: ${cubit.income} \$  ",
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Icon(FontAwesomeIcons.arrowTrendUp,
              color: Colors.white, size: 18),
        ],
      ),
    );
  }

  ListTile drawerListLite(String text, IconData listIcon, VoidCallback f,
      {cubit}) {
    return ListTile(
      onTap: f,
      dense: true,
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
      actions: [
        Container(
            margin: const EdgeInsets.only(right: 5, top: 5),
            child: IconButton(
              alignment: Alignment.center,
              icon: const Icon(Icons.edit),
              onPressed: () {
                scaffoldKey.currentState?.openEndDrawer();
              },
            ))
      ],
    );
  }
}
