import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spense/cubit/states.dart';
import 'package:spense/cubit/transaction_cubit.dart';
import 'package:spense/models/transaction.dart';
import 'package:spense/widgets/pie_chart_home.dart';
import 'package:spense/widgets/record_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

int? x;

class _IncomeScreenState extends State<IncomeScreen> {
  @override
  initState() {
    TransactionCubit cubit = TransactionCubit.get(context);
    x = 0;
    super.initState();
    cubit.getAllExpenseRecordFromDatabase(cubit.mydatabase).then((value) {
      cubit.recordsExpense = value;
      cubit.emit(TransactionUpdated(
          cubit.income, cubit.expense, cubit.totalPrice, cubit.transaction));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TransactionCubit cubit = TransactionCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green.shade300,
            title: Text(
              "Income Records",
              style: TextStyle(fontFamily: "Spacemono"),
            ),
          ),
          body: Column(
            children: [
              SizedBox(height: 10),
              Container(
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterChip(
                        label: Text("List"),
                        onSelected: (value) async {
                          setState(() {
                            cubit
                                .getAllIncomeRecordFromDatabase(
                                    cubit.mydatabase)
                                .then((values) {
                              cubit.recordsIncome = values;
                            });
                          });
                        }),
                    FilterChip(
                        label: Text("Chart"),
                        onSelected: (value) {
                          setState(() {
                            x = 2;
                          });
                        }),
                    FilterChip(
                        label: Text("Bar Chart"), onSelected: (value) {}),
                  ],
                ),
              ),
              Divider(
                indent: 40,
                endIndent: 40,
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterChip(
                        label: Text("By date"),
                        onSelected: (value) async {
                          setState(() {
                            cubit
                                .getIncomeRecordByDate(cubit.mydatabase)
                                .then((values) {
                              cubit.recordsIncome = values;
                            });
                          });
                        }),
                    FilterChip(
                        label: Text("By value"),
                        onSelected: (value) async {
                          setState(() {
                            cubit
                                .getIncomeRecordByValue(cubit.mydatabase)
                                .then((values) {
                              cubit.recordsIncome = values;
                            });
                          });
                        }),
                    FilterChip(
                        label: Text("By Category"),
                        onSelected: (value) async {
                          setState(() {
                            cubit
                                .getIncomeRecordByCategory(cubit.mydatabase)
                                .then((values) {
                              cubit.recordsIncome = values;
                            });
                          });
                        }),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cubit.recordsIncome.length,
                  itemBuilder: (context, index) {
                    final record = cubit.recordsIncome[index];
                    return RecordCard(
                      id: record['id'],
                      title: record['title'],
                      date: record['date'],
                      category: record['category'],
                      value: record['value'],
                      type: record['type'],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Expanded incomeDataVisualization(TransactionCubit cubit) {
    switch (x) {
      case 0:
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
                value: record['value'],
                type: record['type'],
              );
            },
          ),
        );
      case 1:
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
                value: record['value'],
                type: record['type'],
              );
            },
          ),
        );

      case 2:
      default:
        Expanded(
          child: ListView.builder(
            itemCount: cubit.recordsIncome.length,
            itemBuilder: (context, index) {
              final record = cubit.recordsIncome[index];
              return RecordCard(
                id: record['id'],
                title: record['title'],
                date: record['date'],
                category: record['category'],
                value: record['value'],
                type: record['type'],
              );
            },
          ),
        );
    }
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
            value: record['value'],
            type: record['type'],
          );
        },
      ),
    );
  }
}

class ChartData {
  final String label;
  final int value;
  final Color color;

  // Constructor with necessary fields
  ChartData(this.label, this.value, this.color);
}
