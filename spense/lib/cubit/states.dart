abstract class TransactionStates {}

class TransactionInitialize extends TransactionStates {}

class TransactionUpdated extends TransactionStates {
  TransactionUpdated(int income, int expense, int totalPrice);
}

class TransactionLoadingState extends TransactionStates {}

class TransactionLoadedState extends TransactionStates {
  final int income;
  final int expense;
  final int totalPrice;

  TransactionLoadedState({
    required this.income,
    required this.expense,
    required this.totalPrice,
  });
}

class TransactionErrorState extends TransactionStates {
  final String message;

  TransactionErrorState({required this.message});
}
