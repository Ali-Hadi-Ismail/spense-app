import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spense/cubit/states.dart';
import 'package:spense/models/transaction.dart';

class TransactionCubit extends Cubit<TransactionStates> {
  TransactionCubit() : super(TransactionInitialize());

  static TransactionCubit get(context) => BlocProvider.of(context);

  int income = 2;
  int expense = 10;
  List<Transaction> transaction = [];

  int get totalPrice => income - expense;

  void incomeIncrement(int number) {
    income += number;
    emit(TransactionUpdated(income, expense, totalPrice));
  }

  void incomeDecrement(int number) {
    income -= number;
    emit(TransactionUpdated(income, expense, totalPrice));
  }

  void expenseIncrement(int number) {
    expense += number;
    emit(TransactionUpdated(income, expense, totalPrice));
  }

  void expenseDecrement(int number) {
    expense -= number;
    emit(TransactionUpdated(income, expense, totalPrice));
  }

  int getIncome() => income;

  int getExpense() => expense;
}
