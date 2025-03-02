import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:spense/shared/cubit/states.dart';
import 'package:spense/shared/cubit/transaction_cubit.dart';
import 'package:spense/models/transaction.dart';
import 'package:spense/shared/services/currency_exchange_rate.dart';

final _formKey = GlobalKey<FormState>();

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final TextEditingController _amountController = TextEditingController();
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
        ElevatedButton acceptButton(BuildContext context) {
          return ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                double amount = double.parse(_amountController.text);

                int formatedDate = DateTime.now().millisecondsSinceEpoch;

                TransactionCubit.get(context).insertDatabase(
                    category: _categoriesController.text,
                    amount: amount.toInt(),
                    title: _titleController.text,
                    type: (cubit.isExpense) ? "Expense" : "Income",
                    date: formatedDate);

                // using cubit
                Transaction transactionToBeAdded = Transaction(
                    id: "a",
                    amount: amount.toInt(),
                    category: _categoriesController.text,
                    title: _titleController.text,
                    date: formatedDate,
                    type: (cubit.isExpense) ? "Expense" : "Income");

                TransactionCubit.get(context)
                    .addTransaction(transactionToBeAdded);

                Navigator.pop(context);
              } else {}
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

        TextFormField customTextFormField(
            TextEditingController controller, String type,
            [TextInputType inputType = TextInputType.text]) {
          return TextFormField(
            style: const TextStyle(fontSize: 12, fontFamily: "Spacemono"),
            controller: controller,
            validator: (value) {
              if (type == "Title" && controller.text.length == 0) {
                return "Required Title";
              } else if (type == "Category" && controller.text.length == 0) {
                return "Required Category";
              } else if (type == "Amount") {
                if (controller.text.length == 0) {
                  return "Required Amount";
                } else if (controller.text.length > 6) {
                  return "Amount is too big , please enter lower amount ";
                }
              }
            },
            cursorErrorColor: Colors.red,
            maxLines: 1,
            keyboardType: inputType,
            maxLengthEnforcement: MaxLengthEnforcement.none,
            mouseCursor: MouseCursor.defer,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: Colors.black54,
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusColor: (cubit.isExpense)
                  ? Colors.red.shade900
                  : Colors.green.shade900,
              hintText: "Enter title",
              hintStyle: const TextStyle(
                fontFamily: "monospace",
                fontSize: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: (cubit.isExpense)
                      ? Colors.red.shade900
                      : Colors.green.shade900,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black54),
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

        FlutterSwitch typeSwitcher() {
          return FlutterSwitch(
            width: 125,
            height: 40,
            toggleSize: 29,
            value: cubit.isExpense,
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
              cubit.isExpense = !(cubit.isExpense);
            },
          );
        }

        Row typeOfTransactionToggle() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
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
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  shadowColor: cubit.colorGR(),
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
                        items: currencyOptions.map((String amount) {
                          return DropdownMenuItem<String>(
                            value: amount,
                            child: Text(amount),
                          );
                        }).toList(),
                        onChanged: (String? newamount) {
                          setState(() {
                            currency = newamount;
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

        Row amountInput() {
          return Row(
            children: [
              const Text(
                "amount     :",
                style: TextStyle(
                  fontFamily: "Spacemono",
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: customTextFormField(
                    _amountController, "Amount", TextInputType.number),
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
                child: customTextFormField(_categoriesController, "Category"),
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
                child: customTextFormField(_titleController, "Title"),
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

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Add Transaction",
              style: TextStyle(fontFamily: "Spacemono"),
            ),
            backgroundColor: cubit.isExpense
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
                  gradient: cubit.isExpense
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        fillTransactionText(),
                        const SizedBox(height: 20),
                        typeOfTransactionToggle(),
                        const SizedBox(height: 40),
                        titleInput(),
                        const SizedBox(height: 40),
                        categoryInput(),
                        const SizedBox(height: 40),
                        amountInput(),
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
          ),
        );
      },
    );
  }
}
