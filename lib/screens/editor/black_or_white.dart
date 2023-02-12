// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:calculator/main.dart';
import 'package:calculator/widgets/array_of_matrix.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlackOrWhite extends StatefulWidget {
  int matrixColumns;
  int matrixRows;
  int columns;
  int rows;
  double scale;

  BlackOrWhite({
    Key? key,
    required this.columns,
    required this.matrixColumns,
    required this.matrixRows,
    required this.rows,
    required this.scale,
  }) : super(key: key);

  @override
  State<BlackOrWhite> createState() => _BlackOrWhiteState();
}

class _BlackOrWhiteState extends State<BlackOrWhite> {
  int matrixColumns = 8;
  int matrixRows = 8;
  int columns = 1;
  int rows = 1;
  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsScreenNotifier>(
        builder: (context, notifier, child) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              arrayOfMatrix(
                notifier,
                rows,
                columns,
                matrixRows,
                matrixColumns,
                scale,
              ),
            ],
          ),
        ),
      );
    });
  }
}
