import 'package:flutter/material.dart';
import 'package:spense/widgets/pie_chart_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Container(
          child: PieChartHome(),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Spense",
        style: TextStyle(
          fontSize: 24, // Font size (adjust as needed)
          fontWeight: FontWeight.bold, // Bold for emphasis
          letterSpacing: 1.2,
          fontFamily: 'SpaceMono',
        ),
      ),
    );
  }
}
