import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:spense/shared/cubit/states.dart';
import 'package:spense/shared/cubit/transaction_cubit.dart';
import 'package:spense/models/transaction.dart';
import 'package:spense/shared/services/currency_exchange_rate.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  bool isExpense = false;
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String? currency = 'USD';
  late Future<List<String>> currencyOptions;

  @override
  void initState() {
    super.initState();
    currencyOptions = getCurrencyCodes();
  }

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
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      fillTransactionText(),
                      const SizedBox(height: 20),
                      typeOfTransactionToggel(),
                      const SizedBox(height: 40),
                      titleInput(),
                      const SizedBox(height: 40),
                      categoryInput(),
                      const SizedBox(height: 40),
                      valueInput(),
                      const SizedBox(height: 10),
                      const SizedBox(
                        height: 30,
                      ),
                      const Divider(color: Colors.black38, thickness: 1),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          cancelButton(context),
                          acceptButton(context),
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

  ElevatedButton acceptButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        double value = double.parse(_valueController.text);

        DateTime now = DateTime.now();
        String formatedDate =
            "${now.hour}:${now.minute}  ${now.day}-${now.month}-${now.year}";
        TransactionCubit.get(context).insertDatabase(
            category: _categoriesController.text,
            value: value.toInt(),
            title: _titleController.text,
            type: (isExpense) ? "Expense" : "Income",
            date: formatedDate);

        // using cubit
        Transaction transactionToBeAdded = Transaction(
            id: "a",
            value: value.toInt(),
            category: _categoriesController.text,
            title: _titleController.text,
            date: DateTime.now(),
            type: (isExpense) ? "Expense" : "Income");

        TransactionCubit.get(context).addTransaction(transactionToBeAdded);

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

  Row currencyInput(Color c) {
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
          child: FutureBuilder<List<String>>(
              future: currencyOptions,
              builder: (context, snapshot) {
                List<String> currencyOptions = [
                  "USD",
                  "EUR",
                  "GBP",
                  "JPY",
                  "AUD",
                  "CAD",
                  "CHF",
                  "CNY",
                  "SEK",
                  "NZD"
                ];

                return DropdownButtonFormField<String>(
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
                );
              }),
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
