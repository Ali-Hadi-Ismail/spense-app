import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spense/cubit/states.dart';
import 'package:spense/cubit/transaction_cubit.dart';
import 'package:spense/models/transaction.dart';
import 'package:spense/widgets/record_card.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TransactionCubit cubit = TransactionCubit.get(context);
        // Fetch income records when the screen is initialized
        cubit.getAllIncomeRecordFromDatabase(cubit.mydatabase).then((value) {
          cubit.recordsIncome = value;
          cubit.emit(TransactionUpdated(cubit.income, cubit.expense,
              cubit.totalPrice, cubit.transaction));
        }).then((value) {
          cubit.calculateIncomeAndExpense();
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Income Records",
              style: TextStyle(fontFamily: "Spacemono"),
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: ListView.builder(
              itemCount: cubit.recordsIncome.length,
              itemBuilder: (context, index) {
                final record = cubit.recordsIncome[index];
                return RecordCard(
                  id: record['id'],
                  title: record['title'],
                  date: record['date'],
                  category: record['category'],
                  value: 10,
                  type: record['type'],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
