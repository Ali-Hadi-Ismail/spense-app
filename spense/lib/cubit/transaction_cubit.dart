import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spense/cubit/states.dart';
import 'package:spense/models/transaction.dart' as spense;
import 'package:sqflite/sqflite.dart' hide Transaction;

class TransactionCubit extends Cubit<TransactionStates> {
  TransactionCubit() : super(TransactionInitialize());

  static TransactionCubit get(context) => BlocProvider.of(context);

  int income = 2;
  int expense = 10;
  List<spense.Transaction> transaction = [
    spense.Transaction(
        value: 10,
        category: "Personal Care",
        title: "Hair Cut",
        id: "0",
        date: DateTime.now(),
        type: "Expense"),
    spense.Transaction(
        value: 50,
        id: "1",
        category: "Freelance",
        title: "Spense Project",
        date: DateTime.now(),
        type: "Income"),
  ];

  int get totalPrice => income - expense;

  void addTransaction(spense.Transaction transactionToBeAdded) {
    transaction.add(transactionToBeAdded);
    if (transactionToBeAdded.type == "Expense") {
      expense += transactionToBeAdded.value;
    } else {
      income += transactionToBeAdded.value;
    }
    emit(TransactionUpdated(
        income, expense, totalPrice, transaction)); // Emit a new state!
  }

  int getIncome() => income;

  int getExpense() => expense;

  late Database mydatabase;
  Future<void> createDatabase() async {
    mydatabase = await openDatabase(
      'spernse.db',
      version: 1,
      onCreate: (database, version) {
        // id    int
        // category string
        // value int
        // title string
        // date dateString
        // type string

        database
            .execute(
                'CREATE TABLE record ( id INTEGER PRIMARY KEY , category TEXT, value INTEGER, title TEXT, date TEXT, type TEXT)')
            .then(
              (value) => print("Table is created"),
            )
            .catchError((onError) {
          print("Error when creating table ${onError.toString()}");
        });

        print("Database Created");
      },
      onOpen: (database) {
        print("Database Opened");
      },
    );
  }

  Future<void> insertDatabase() {
    // using transaction I can insert database
    return mydatabase.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO record(category , value , title ,date ,type) VALUES ("Food","10","Shartouni Sandwish","02-14-2025 12:23","Expense")')
          .then((value) {
        print("${value} inserted successfully");
      }).catchError((error) {
        print(error.toString());
      });
    });
  }

  void deleteDatabase() {}
  void updateDatabase() {}
}


//Crud operation 
