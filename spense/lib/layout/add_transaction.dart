import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Transaction",
          style: TextStyle(fontFamily: "Spacemono"),
        ),
        backgroundColor: isExpense
            ? Colors.red.shade400 // Green for Income
            : Colors.green.shade400, // Red for Expense
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            height: 550,
            width: 340,
            decoration: BoxDecoration(
              gradient: isExpense
                  ? LinearGradient(
                      colors: [Colors.red.shade100, Colors.red.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.green.shade100, Colors.green.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Type of transaction Switcher

                  SizedBox(height: 20),

                  const Text(
                    "Fill Transaction Info",
                    style: TextStyle(
                      fontFamily: "Spacemono",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
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
                  ),
                  SizedBox(height: 20),
                  // Title TextFormField
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Title     :",
                        style: TextStyle(
                          fontFamily: "Spacemono",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          style:
                              TextStyle(fontSize: 12, fontFamily: "Spacemono"),
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: "Enter title",
                            hintStyle: TextStyle(
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
                  ),
                  SizedBox(height: 20),

                  // Categories TextFormField
                  Row(
                    children: [
                      Text(
                        "Categories:",
                        style: TextStyle(
                          fontFamily: "Spacemono",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          style:
                              TextStyle(fontSize: 12, fontFamily: "Spacemono"),
                          controller: _categoriesController,
                          decoration: InputDecoration(
                            hintText: "Enter categories",
                            hintStyle: TextStyle(
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
                  ),
                  SizedBox(height: 20),

                  // Value with Dollar Sign (Inside Text Field)
                  Row(
                    children: [
                      Text(
                        "Value     :",
                        style: TextStyle(
                          fontFamily: "Spacemono",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style:
                              TextStyle(fontSize: 12, fontFamily: "Spacemono"),
                          controller: _valueController,
                          decoration: InputDecoration(
                            hintText: "Enter value",
                            hintStyle: TextStyle(
                              fontFamily: "Spacemono",
                              fontSize: 12,
                            ),
                            prefixText:
                                '\$', // Dollar sign inside the text field
                            prefixStyle: TextStyle(
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
                  ),
                  SizedBox(height: 20),

                  // Currency Dropdown (Outside Text Field)
                  Row(
                    children: [
                      Text(
                        "Currency   :",
                        style: TextStyle(
                          fontFamily: "Spacemono",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FlutterSwitch typeSwitcher() {
    return FlutterSwitch(
      width: 100,
      height: 40,
      toggleSize: 30,
      value: isExpense,
      borderRadius: 20,
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
