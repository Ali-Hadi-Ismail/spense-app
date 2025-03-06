import 'dart:async';
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
  List<spense.Transaction> transaction = [];

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

  List<Map> incomeCategory = [];

  late Database mydatabase;
  final Completer<void> _dbReadyCompleter = Completer<void>();

  String time = "All Time";

//income screen

  int bodyType = 0;

  Future<void> createDatabase() async {
    mydatabase = await openDatabase(
      'spense.db',
      version: 3,
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE record (id INTEGER PRIMARY KEY, category TEXT, amount INTEGER, title TEXT, date INTEGER, type TEXT)');
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

  Future<void> insertDatabase({
    required String category,
    required int amount,
    required String title,
    required int date,
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

  // last month
  Future<List<Map>> getAllRecordThisMonth(Database database) async {
    DateTime now = DateTime.now();
    int firstDay = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
    int lastDay =
        DateTime(now.year, now.month + 1, 0, 23, 59, 59).millisecondsSinceEpoch;

    return await database.rawQuery("""
   SELECT * FROM record 
   WHERE date BETWEEN ? AND ?
    ORDER BY id DESC
   """, [firstDay, lastDay]);
  }

  // 7 day
  Future<List<Map>> getAllRecordLast7Days(Database database) async {
    DateTime now = DateTime.now();
    int sevenDaysAgo =
        now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;
    int today = now.millisecondsSinceEpoch;

    return await database.rawQuery("""
   SELECT * FROM record 
   WHERE date BETWEEN ? AND ?
    ORDER BY id DESC
   """, [sevenDaysAgo, today]);
  }

  Future<List<Map>> getIncomeCategoryPrice(Database database) async {
    return await database.rawQuery("""
    SELECT category, SUM(amount) AS totalAmount
    FROM record
    WHERE type = "Income"
    GROUP BY category
    ORDER BY totalAmount DESC;
  """);
  }

  Future<List<Map>> getExpenseCategoryPrice(Database database) async {
    return await database.rawQuery("""
    SELECT category, SUM(amount) AS totalAmount
    FROM record
    WHERE type = "Expense"
    GROUP BY category
    ORDER BY totalAmount DESC;
  """);
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

  Future<void> insertPredefinedRecords() async {
    await _dbReadyCompleter.future; // Wait until the database is ready
    await mydatabase.transaction((txn) async {
      DateTime now = DateTime(2025, 3, 2); // Today is March 2, 2025

      // 3 records for the last 7 days
      List<Map<String, dynamic>> last7DaysRecords = [
        {
          "category": "Groceries",
          "amount": 150,
          "title": "Grocery Shopping",
          "type": "Expense"
        },
        {
          "category": "Salary",
          "amount": 3000,
          "title": "Freelance Payment",
          "type": "Income"
        },
        {
          "category": "Entertainment",
          "amount": 50,
          "title": "Concert Ticket",
          "type": "Expense"
        },
      ];

      for (int i = 0; i < 3; i++) {
        DateTime date = now.subtract(Duration(days: i + 1)); // Last 7 days
        await txn.rawInsert(
          'INSERT INTO record(category, amount, title, date, type) VALUES (?, ?, ?, ?, ?)',
          [
            last7DaysRecords[i]['category'],
            last7DaysRecords[i]['amount'],
            last7DaysRecords[i]['title'],
            date.millisecondsSinceEpoch,
            last7DaysRecords[i]['type']
          ],
        );
      }

      // 3 records from last month (February 2025)
      List<Map<String, dynamic>> lastMonthRecords = [
        {
          "category": "Utilities",
          "amount": 200,
          "title": "Water Bill",
          "type": "Expense"
        },
        {
          "category": "Dining Out",
          "amount": 60,
          "title": "Dinner with Friends",
          "type": "Expense"
        },
        {
          "category": "Transportation",
          "amount": 80,
          "title": "Gas Refill",
          "type": "Expense"
        },
      ];

      for (int i = 0; i < 3; i++) {
        DateTime date = DateTime(2025, 2, i + 10); // Days in February 2025
        await txn.rawInsert(
          'INSERT INTO record(category, amount, title, date, type) VALUES (?, ?, ?, ?, ?)',
          [
            lastMonthRecords[i]['category'],
            lastMonthRecords[i]['amount'],
            lastMonthRecords[i]['title'],
            date.millisecondsSinceEpoch,
            lastMonthRecords[i]['type']
          ],
        );
      }

      // 5 records from last year (March 2, 2024 - March 1, 2025)
      List<Map<String, dynamic>> lastYearRecords = [
        {
          "category": "Rent",
          "amount": 1200,
          "title": "Apartment Rent",
          "type": "Expense"
        },
        {
          "category": "Salary",
          "amount": 3200,
          "title": "Monthly Salary",
          "type": "Income"
        },
        {
          "category": "Bonus",
          "amount": 500,
          "title": "Performance Bonus",
          "type": "Income"
        },
        {
          "category": "Groceries",
          "amount": 180,
          "title": "Monthly Grocery Shopping",
          "type": "Expense"
        },
        {
          "category": "Subscription",
          "amount": 30,
          "title": "Streaming Service",
          "type": "Expense"
        },
      ];

      for (int i = 0; i < 5; i++) {
        DateTime date = now
            .subtract(Duration(days: (i + 1) * 60)); // Spread across last year
        await txn.rawInsert(
          'INSERT INTO record(category, amount, title, date, type) VALUES (?, ?, ?, ?, ?)',
          [
            lastYearRecords[i]['category'],
            lastYearRecords[i]['amount'],
            lastYearRecords[i]['title'],
            date.millisecondsSinceEpoch,
            lastYearRecords[i]['type']
          ],
        );
      }

      print("Predefined records from the last 365 days inserted successfully");
    });
  }
}
