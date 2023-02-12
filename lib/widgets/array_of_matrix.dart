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
  double scale, {
  Function? onClick,
  List<List<List<List<Color>>>>? colors,
}) {
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
                            onClick: onClick,
                            colors: colors,
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
  int rowsCount,
  int columnsCount,
  int matrixRowsTextCount,
  int matrixColumnsTextCount,
  double scale, {
  Function? onClick,
  List<List<List<List<Color>>>>? colors,
}) {
  if (onClick == null) {
    print("object");
  }

  List<Widget> widgets = List.generate(
    rowsCount,
    (rowsCountIndex) => Row(
      children: List.generate(
        columnsCount,
        (columnsCountIndex) => Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Column(
            children: List.generate(
              matrixRowsTextCount,
              (matrixRowsTextCountIndex) => Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Row(
                  children: List.generate(
                    matrixColumnsTextCount,
                    (matrixColumnsTextCountIndex) => onClick == null
                        ? Container(
                            width: 10 * scale,
                            height: 10 * scale,
                            color: matrixCellColor(darkTheme),
                            margin: EdgeInsets.all(2),
                          )
                        : GestureDetector(
                            onTap: () => onClick(
                              rowsCountIndex,
                              columnsCountIndex,
                              matrixRowsTextCountIndex,
                              matrixColumnsTextCountIndex,
                            ),
                            child: Container(
                              width: 10 * scale,
                              height: 10 * scale,
                              color: colors![rowsCountIndex][columnsCountIndex]
                                      [matrixRowsTextCountIndex]
                                  [matrixColumnsTextCountIndex],
                              margin: EdgeInsets.all(2),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  return widgets;
}
