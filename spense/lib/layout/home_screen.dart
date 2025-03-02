import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:spense/shared/cubit/states.dart';
import 'package:spense/shared/cubit/transaction_cubit.dart';
import 'package:spense/modules/add_transaction.dart';
import 'package:spense/shared/widgets/function.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TransactionCubit cubit = TransactionCubit.get(context);
        Widget body(int income, int expense) {
          if (cubit.income == 0 && cubit.expense == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/animation/noData.json", height: 300),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
          return SingleChildScrollView(child: Body(cubit, context));
        }

        return Scaffold(
          key: scaffoldKey, // Assign the scaffoldKey here
          endDrawer: endDrawer(context),
          appBar: appBar(),
          body: body(cubit.income, cubit.expense),
          drawer: appDrawer(),
          floatingActionButton: (cubit.income == 0 && cubit.expense == 0)
              ? FloatingActionButton(
                  heroTag: "addTransaction",
                  backgroundColor: Colors.grey.shade100,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTransaction()));
                  },
                  child: Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
