import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spense/shared/cubit/states.dart';
import 'package:spense/shared/cubit/transaction_cubit.dart';
import 'package:spense/shared/widgets/pie_chart_expenseScreen.dart'; // Update import
import 'package:spense/shared/widgets/record_card.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  void initState() {
    super.initState();
    TransactionCubit cubit = TransactionCubit.get(context);
    cubit.getAllExpenseRecordFromDatabase(cubit.mydatabase).then((amount) {
      setState(() {
        cubit.recordsExpense = amount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TransactionCubit cubit = TransactionCubit.get(context);
        return Scaffold(
          appBar: customAppBar(),
          body: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: expenseDataVisualization(cubit),
              ),
            ],
          ),
        );
      },
    );
  }

  SizedBox listFilter(TransactionCubit cubit) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilterChip(
            label: const Text("By date"),
            onSelected: (selected) async {
              cubit.getExpenseRecordByDate(cubit.mydatabase).then((records) {
                setState(() {
                  cubit.recordsExpense = records;
                });
              });
            },
          ),
          FilterChip(
            label: const Text("By amount"),
            onSelected: (selected) async {
              cubit.getExpenseRecordByAmount(cubit.mydatabase).then((records) {
                setState(() {
                  cubit.recordsExpense = records;
                });
              });
            },
          ),
          FilterChip(
            label: const Text("By category"),
            onSelected: (selected) async {
              cubit
                  .getExpenseRecordByCategory(cubit.mydatabase)
                  .then((records) {
                setState(() {
                  cubit.recordsExpense = records;
                });
              });
            },
          ),
        ],
      ),
    );
  }

  Expanded listOfExpense(TransactionCubit cubit) {
    return Expanded(
      child: ListView.builder(
        itemCount: cubit.recordsExpense.length,
        itemBuilder: (context, index) {
          final record = cubit.recordsExpense[index];
          return RecordCard(
            id: record['id'],
            title: record['title'],
            date: record['date'],
            category: record['category'],
            amount: record['amount'],
            type: record['type'],
          );
        },
      ),
    );
  }

  Row screenTypeOfBody(TransactionCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FilterChip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            checkmarkColor: Colors.blueGrey,
            selected: (cubit.bodyType == 0),
            showCheckmark: false,
            selectedColor: Colors.redAccent, // Changed to red
            avatar: const Icon(
              Icons.list,
              color: Colors.black54,
            ),
            autofocus: true,
            label: const Text("List"),
            onSelected: (amount) async {
              cubit.bodyType = 0;
              cubit
                  .getAllExpenseRecordFromDatabase(cubit.mydatabase)
                  .then((amounts) {
                cubit.recordsExpense = amounts;
              });
            }),
        FilterChip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            checkmarkColor: Colors.blueGrey,
            selected: (cubit.bodyType == 1),
            showCheckmark: false,
            selectedColor: Colors.redAccent, // Changed to red
            avatar: const Icon(
              Icons.donut_large_rounded,
              color: Colors.black54,
            ),
            autofocus: true,
            label: const Text("Chart"),
            onSelected: (amount) async {
              cubit.bodyType = 1;
              cubit
                  .getAllExpenseRecordFromDatabase(cubit.mydatabase)
                  .then((amounts) {
                cubit.recordsExpense = amounts;
              });
            }),
        FilterChip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            checkmarkColor: Colors.blueGrey,
            selected: (cubit.bodyType == 2),
            showCheckmark: false,
            selectedColor: Colors.redAccent, // Changed to red
            avatar: const Icon(
              Icons.bar_chart,
              color: Colors.black54,
            ),
            autofocus: true,
            label: const Text("Bar Chart"),
            onSelected: null),
      ],
    );
  }

  AppBar customAppBar() {
    return AppBar(
      backgroundColor: Colors.red.shade300, // Changed to red
      title: const Text(
        "Expense Records",
        style: TextStyle(fontFamily: "Spacemono"),
      ),
    );
  }

  Widget expenseDataVisualization(TransactionCubit cubit) {
    switch (cubit.bodyType) {
      case 0:
        return Column(
          children: [
            listFilter(cubit),
            listOfExpense(cubit),
          ],
        );
      case 1:
        return const PieChartExpenseScreen();
      default:
        return const Placeholder();
    }
  }
}

class ChartData {
  final String label;
  final int amount;
  final Color color;

  ChartData(this.label, this.amount, this.color);
}
