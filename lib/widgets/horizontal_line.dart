import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      color: dividerLine(),
      margin: const EdgeInsets.all(5),
    );
  }
}
