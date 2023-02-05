import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class VerticalLine extends StatelessWidget {
  const VerticalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: double.infinity,
      color: verticalLine(),
      margin: const EdgeInsets.all(5),
    );
  }
}
