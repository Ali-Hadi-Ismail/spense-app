import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spense/layout/home_screen.dart';
import 'package:spense/cubit/transaction_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TransactionCubit transactionCubit = TransactionCubit();
  await transactionCubit.createDatabase(); // Ensure the database is created

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

/*  

  Notes :
    



  Difficulties: 
    1 - cubit blocProvider vs blocConsumer vs blocBuilder 
    2 - fl_chart  syncfunction chart 
    3 - upgrading flutter SDK and graddel 
    4 - sqflite in cubit aliasing 
    5 - chart label 
*/
