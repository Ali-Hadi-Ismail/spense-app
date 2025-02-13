import 'package:spense/models/transaction.dart';

abstract class TransactionStates {}

class TransactionInitialize extends TransactionStates {}

class TransactionUpdated extends TransactionStates {
  final int income;
  final int expense;
  final int totalPrice;
  final List<Transaction> transactions; // Add the transaction list

  TransactionUpdated(
      this.income, this.expense, this.totalPrice, this.transactions);
}
