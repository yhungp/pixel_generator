// ignore_for_file: prefer_const_constructors

import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

Expanded arrayOfMatrix(
  SettingsScreenNotifier notifier,
  int rowsTextCount,
  int columnsTextCount,
  int matrixRowsTextCount,
  int matrixColumnsTextCount,
  double scale,
) {
  final ScrollController horizontal = ScrollController();
  final ScrollController vertical = ScrollController();

  return Expanded(
    child: Scrollbar(
      controller: vertical,
      thumbVisibility: true,
      trackVisibility: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
              controller: horizontal,
              thumbVisibility: true,
              trackVisibility: true,
              notificationPredicate: (notif) => notif.depth == 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: vertical,
                      child: SingleChildScrollView(
                        controller: horizontal,
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: matrixGenerator(
                            notifier.darkTheme,
                            rowsTextCount,
                            columnsTextCount,
                            matrixRowsTextCount,
                            matrixColumnsTextCount,
                            scale,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

matrixGenerator(
  bool darkTheme,
  int rowsTextCount,
  int columnsTextCount,
  int matrixRowsTextCount,
  int matrixColumnsTextCount,
  double scale,
) {
  List<Widget> widgets = List.generate(
      rowsTextCount,
      (index) => Row(
            children: List.generate(
                columnsTextCount,
                (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        children: List.generate(
                            matrixRowsTextCount,
                            (index) => Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Row(
                                    children: List.generate(
                                        matrixColumnsTextCount,
                                        (index) => Container(
                                              width: 10 * scale,
                                              height: 10 * scale,
                                              color: matrixCellColor(darkTheme),
                                              margin: EdgeInsets.all(2),
                                            )),
                                  ),
                                )),
                      ),
                    )),
          ));

  return widgets;
}
