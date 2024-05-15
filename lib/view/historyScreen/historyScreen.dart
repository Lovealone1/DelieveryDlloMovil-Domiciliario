import 'package:flutter/material.dart';
import 'package:food_delievery_domiciliario/utils/textStyles.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'History Screen',
          style: AppTextStyles.body14,
        ),
      ),
    );
  }
}