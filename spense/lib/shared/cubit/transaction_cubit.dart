import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spense/shared/cubit/states.dart';
import 'package:spense/models/transaction.dart' as spense;
import 'package:sqflite/sqflite.dart' hide Transaction;

class TransactionCubit extends Cubit<TransactionStates> {
  TransactionCubit() : super(TransactionInitialize());

  static TransactionCubit get(context) => BlocProvider.of(context);

  int income = 0;
  int expense = 0;
  List<spense.Transaction> transaction = [
    spense.Transaction(
        amount: 10,
        category: "Personal Care",
        title: "Hair Cut",
        id: "0",
        date: DateTime.now(),
        type: "Expense"),
    spense.Transaction(
        amount: 50,
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
      expense += transactionToBeAdded.amount;
    } else {
      income += transactionToBeAdded.amount;
    }
    emit(TransactionUpdated(
        income, expense, totalPrice, transaction)); // Emit a new state!
  }

  bool isExpense = false;
  Color colorGR() {
    if (isExpense) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  int getIncome() => income;

  int getExpense() => expense;

  List<Map> records = [];
  List<Map> recordsIncome = [];
  List<Map> recordsExpense = [];

  late Database mydatabase;
  final Completer<void> _dbReadyCompleter = Completer<void>();

  Future<void> createDatabase() async {
    mydatabase = await openDatabase(
      'spense.db',
      version: 3,
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE record (id INTEGER PRIMARY KEY, category TEXT, amount INTEGER, title TEXT, date TEXT, type TEXT)');
        print("Table is created");
      },
      onOpen: (database) async {
        print("Database Opened");

        getAllRecordFromDatabase(database).then((amount) {
          records = amount;
          calculateIncomeAndExpense();
          emit(TransactionUpdated(income, expense, totalPrice, transaction));
        });
        _dbReadyCompleter.complete(); // Signal that the database is ready
      },
    );
  }

  Future<void> insertInitialRecords() async {
    await _dbReadyCompleter.future;

    await insertDatabase(
        category: "Salary",
        amount: 500,
        title: "Full-time Job",
        date: "09:30 15-02-2025",
        type: "Income");

    await insertDatabase(
        category: "Freelance",
        amount: 200,
        title: "Side Project",
        date: "10:00 15-02-2025",
        type: "Income");

    await insertDatabase(
        category: "Food",
        amount: 50,
        title: "Groceries",
        date: "11:30 15-02-2025",
        type: "Expense");

    await insertDatabase(
        category: "Transport",
        amount: 30,
        title: "Bus Ticket",
        date: "12:00 15-02-2025",
        type: "Expense");
  }

  Future<void> insertDatabase({
    required String category,
    required int amount,
    required String title,
    required String date,
    required String type,
  }) async {
    await _dbReadyCompleter.future; // Wait until the database is ready
    await mydatabase.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO record(category, amount, title, date, type) VALUES (?, ?, ?, ?, ?)',
          [category, amount, title, date, type]);
      print("Record inserted successfully");
    });
  }

  Future<List<Map>> getAllRecordFromDatabase(Database database) async {
    return await database.rawQuery('SELECT * FROM record ORDER BY id DESC');
  }

  Future<List<Map>> getAllIncomeRecordFromDatabase(Database database) async {
    return await database
        .rawQuery('SELECT * FROM record WHERE type = "Income"');
  }

  Future<List<Map>> getAllExpenseRecordFromDatabase(Database database) async {
    return await database
        .rawQuery('SELECT * FROM record WHERE type = "Expense"');
  }

  Future<List<Map>> getIncomeRecordByAmount(Database database) async {
    return await database.rawQuery(
        'SELECT * FROM record WHERE type = "Income" ORDER BY amount ');
  }

  Future<List<Map>> getIncomeRecordByDate(Database database) async {
    return await database
        .rawQuery('SELECT * FROM record WHERE type = "Income" ORDER BY id ');
  }

  Future<List<Map>> getIncomeRecordByCategory(Database database) async {
    return await database.rawQuery(
        'SELECT * FROM record WHERE type ="Income" ORDER BY category');
  }

  Future<List<Map>> getExpenseRecordByCategory(Database database) async {
    return await database.rawQuery(
        'SELECT * FROM record WHERE type ="Expense" ORDER BY category');
  }

  Future<List<Map>> getExpenseRecordByAmount(Database database) async {
    return await database.rawQuery(
        'SELECT * FROM record WHERE type = "Expense" ORDER BY amount ');
  }

  Future<List<Map>> getExpenseRecordByDate(Database database) async {
    return await database
        .rawQuery('SELECT * FROM record WHERE type = "Expense" ORDER BY id ');
  }

  Future<void> calculateIncomeAndExpense() async {
    income = 0;
    expense = 0;
    for (var record in records) {
      int amount = record['amount'] is int
          ? record['amount']
          : int.tryParse(record['amount'].toString()) ?? 0;
      if (record['type'] == "Income") {
        income += amount;
      } else {
        expense += amount;
      }
    }
    emit(TransactionUpdated(income, expense, totalPrice, transaction));
  }

  void deleteAllDatabaseRecord() async {
    await mydatabase.execute('DELETE FROM record');
    records = await getAllRecordFromDatabase(mydatabase);
    calculateIncomeAndExpense();
    emit(TransactionUpdated(income, expense, totalPrice, transaction));
  }

  void deleteRecord(int id) async {
    await mydatabase.execute('DELETE FROM record WHERE id = $id');
    records = await getAllRecordFromDatabase(mydatabase);
    calculateIncomeAndExpense();
    emit(TransactionUpdated(income, expense, totalPrice, transaction));
  }

  void updateRecord(int id, Map<String, dynamic> updatedData) async {
    await mydatabase.update(
      "record",
      updatedData,
      where: "id = ? ",
      whereArgs: [id],
    );
  }
}
