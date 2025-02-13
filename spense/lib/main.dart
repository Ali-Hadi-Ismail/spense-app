import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spense/layout/home_screen.dart';
import 'package:spense/cubit/transaction_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCubit()..createDatabase(),
      child: MaterialApp(
        title: 'Spense',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

/*  1 - cubit blocProvider vs blocConsumer vs blocBuilder 
    2 - fl_chart  syncfunction chart 
    3 - upgrading flutter SDK and graddel 
    4 - sqflite in cubit aliasing 
    5 - chart label 
*/
