import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spense/layout/home_screen.dart';
import 'package:spense/shared/cubit/transaction_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TransactionCubit transactionCubit = TransactionCubit();
  await transactionCubit.createDatabase();

  runApp(MyApp(transactionCubit: transactionCubit));
}

class MyApp extends StatelessWidget {
  final TransactionCubit transactionCubit;

  MyApp({required this.transactionCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => transactionCubit,
      child: const MaterialApp(
        title: 'Spense',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
