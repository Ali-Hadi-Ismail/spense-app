import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spense/shared/cubit/states.dart';
import 'package:spense/shared/cubit/transaction_cubit.dart';
import 'package:spense/shared/widgets/pie_chart_incomeScreen.dart';
import 'package:spense/shared/widgets/record_card.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TransactionCubit cubit = TransactionCubit.get(context);
        cubit.getAllIncomeRecordFromDatabase(cubit.mydatabase).then((amount) {
          cubit.recordsIncome = amount;
        });
        return Scaffold(
          appBar: customAppBar(),
          body: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: screenTypeOfBody(cubit),
              ),
              const Divider(),
              Expanded(
                // Wrap with Expanded
                child: incomeDataVisualization(cubit),
              ),
            ],
          ),
        );
      },
    );
  }

  Expanded listOfIncome(TransactionCubit cubit) {
    return Expanded(
      child: ListView.builder(
        itemCount: cubit.recordsIncome.length,
        itemBuilder: (context, index) {
          final record = cubit.recordsIncome[index];
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

  SizedBox listFilter(TransactionCubit cubit) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilterChip(
              label: const Text("By date"),
              onSelected: (amount) async {
                cubit.getIncomeRecordByDate(cubit.mydatabase).then((amounts) {
                  cubit.recordsIncome = amounts;
                });
              }),
          FilterChip(
              label: const Text("By amount"),
              onSelected: (amount) async {
                cubit.getIncomeRecordByAmount(cubit.mydatabase).then((amounts) {
                  cubit.recordsIncome = amounts;
                });
              }),
          FilterChip(
              label: const Text("By Category"),
              onSelected: (amount) async {
                cubit
                    .getIncomeRecordByCategory(cubit.mydatabase)
                    .then((amounts) {
                  cubit.recordsIncome = amounts;
                });
              }),
        ],
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
            selectedColor: Colors.greenAccent,
            avatar: const Icon(
              Icons.list,
              color: Colors.black54,
            ),
            autofocus: true,
            label: const Text("List"),
            onSelected: (amount) async {
              cubit.bodyType = 0;
              cubit
                  .getAllIncomeRecordFromDatabase(cubit.mydatabase)
                  .then((amounts) {
                cubit.recordsIncome = amounts;
              });
            }),
        FilterChip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            checkmarkColor: Colors.blueGrey,
            selected: (cubit.bodyType == 1),
            showCheckmark: false,
            selectedColor: Colors.greenAccent,
            avatar: const Icon(
              Icons.donut_large_rounded,
              color: Colors.black54,
            ),
            autofocus: true,
            label: const Text("Chart"),
            onSelected: (amount) async {
              cubit.bodyType = 1;
              cubit
                  .getAllIncomeRecordFromDatabase(cubit.mydatabase)
                  .then((amounts) {
                cubit.recordsIncome = amounts;
              });
            }),
        FilterChip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            checkmarkColor: Colors.blueGrey,
            selected: (cubit.bodyType == 2),
            showCheckmark: false,
            selectedColor: Colors.greenAccent,
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
      backgroundColor: Colors.green.shade300,
      title: const Text(
        "Income Records",
        style: TextStyle(fontFamily: "Spacemono"),
      ),
    );
  }

  Widget incomeDataVisualization(TransactionCubit cubit) {
    switch (cubit.bodyType) {
      case 0:
        return Column(
          children: [
            listFilter(cubit),
            listOfIncome(cubit),
          ],
        );
      case 1:
        return const PieChartIncomeScreen();
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
