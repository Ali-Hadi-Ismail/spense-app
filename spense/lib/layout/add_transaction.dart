import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:spense/cubit/states.dart';
import 'package:spense/cubit/transaction_cubit.dart';
import 'package:spense/models/transaction.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  bool isExpense = false; // Default: Income
  TextEditingController _valueController = TextEditingController();
  TextEditingController _categoriesController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  String? currency = 'USD'; // Default value for currency
  List<String> currencyOptions = ['USD', 'LBP']; // Options for currency

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TransactionCubit cubit = TransactionCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Add Transaction",
              style: TextStyle(fontFamily: "Spacemono"),
            ),
            backgroundColor: isExpense
                ? Colors.red.shade400 // Green for Income
                : Colors.green.shade400, // Red for Expense
            elevation: 10,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Goes back to the previous screen
              },
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Container(
                height: 575,
                width: 340,
                decoration: BoxDecoration(
                  gradient: isExpense
                      ? LinearGradient(
                          colors: [Colors.red.shade100, Colors.red.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [
                            Colors.green.shade100,
                            Colors.green.shade300
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      fillTransactionText(),
                      const SizedBox(height: 20),
                      typeOfTransactionToggel(),
                      const SizedBox(height: 20),
                      titleInput(),
                      const SizedBox(height: 20),
                      categoryInput(),
                      const SizedBox(height: 20),
                      valueInput(),
                      const SizedBox(height: 20),
                      currencyInput(),
                      const SizedBox(
                        height: 30,
                      ),
                      Divider(color: Colors.black38, thickness: 1),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          cancelButton(context),
                          acceptButton(cubit, context),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ElevatedButton acceptButton(TransactionCubit cubit, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // using database directly
        int value;
        if (currency == "USD") {
          value = int.parse(_valueController.text);
        } else {
          value = (int.parse(_valueController.text) / 89000).toInt();
        }
        DateTime now = DateTime.now();
        String formatedDate = "${now.year}-${now.month}-${now.day}";
        cubit.insertDatabase(
            category: _categoriesController.text,
            value: value,
            title: _titleController.text,
            type: (isExpense) ? "Expense" : "Income",
            date: formatedDate);

        // using cubit
        Transaction transactionToBeAdded = Transaction(
            id: "a",
            value: value,
            category: _categoriesController.text,
            title: _titleController.text,
            date: DateTime.now(),
            type: (isExpense) ? "Expense" : "Income");

        cubit.addTransaction(
            transactionToBeAdded); // Use the addTransaction method

        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text(
        "Accept",
        style: TextStyle(
          fontFamily: "Spacemono",
          fontSize: 14,
        ),
      ),
    );
  }

  ElevatedButton cancelButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 7,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text(
        "Cancel",
        style: TextStyle(fontFamily: "Spacemono", fontSize: 14),
      ),
    );
  }

  Row typeOfTransactionToggel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Type of transaction:",
          style: TextStyle(
            fontFamily: "Spacemono",
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            shadowColor: (isExpense) ? Colors.red : Colors.green,
            elevation: 8,
            child: typeSwitcher()),
      ],
    );
  }

  Row currencyInput() {
    return Row(
      children: [
        const Text(
          "Currency  :",
          style: TextStyle(
            fontFamily: "Spacemono",
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: currency,
            items: currencyOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                currency = newValue;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row valueInput() {
    return Row(
      children: [
        const Text(
          "Value     :",
          style: TextStyle(
            fontFamily: "Spacemono",
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 12, fontFamily: "Spacemono"),
            controller: _valueController,
            decoration: InputDecoration(
              hintText: "Enter value",
              hintStyle: const TextStyle(
                fontFamily: "Spacemono",
                fontSize: 12,
              ),
              prefixStyle: const TextStyle(
                fontFamily: "Spacemono",
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row categoryInput() {
    return Row(
      children: [
        const Text(
          "Categories:",
          style: TextStyle(
            fontFamily: "Spacemono",
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            style: const TextStyle(fontSize: 12, fontFamily: "Spacemono"),
            controller: _categoriesController,
            decoration: InputDecoration(
              hintText: "Enter categories",
              hintStyle: const TextStyle(
                fontFamily: "Spacemono",
                fontSize: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row titleInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          "Title     :",
          style: TextStyle(
            fontFamily: "Spacemono",
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            style: const TextStyle(fontSize: 12, fontFamily: "Spacemono"),
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "Enter title",
              hintStyle: const TextStyle(
                fontFamily: "monospace",
                fontSize: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Text fillTransactionText() {
    return const Text(
      "Fill Transaction Info",
      style: TextStyle(
        fontFamily: "Spacemono",
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  FlutterSwitch typeSwitcher() {
    return FlutterSwitch(
      width: 125,
      height: 40,
      toggleSize: 29,
      value: isExpense,
      borderRadius: 18,
      inactiveIcon: Icon(
        FontAwesomeIcons.arrowTrendUp,
        color: Colors.green.shade700,
        size: 14,
      ),
      activeIcon: Icon(
        FontAwesomeIcons.arrowTrendDown,
        size: 14,
        color: Colors.red.shade700,
      ),
      padding: 4,
      activeText: "Expense",
      inactiveText: "Income",
      activeColor: Colors.red,
      inactiveColor: Colors.green,
      showOnOff: true,
      onToggle: (val) {
        setState(() {
          isExpense = !isExpense;
        });
      },
    );
  }
}
