import 'package:flutter/material.dart';

class MatrixPainter extends CustomPainter {
  bool touched;
  double posx;
  double posy;
  double scale;
  int matrixColumns;
  int matrixRows;
  int columns;
  int rows;
  bool matrixTouched;
  bool showSpaceBetweenMatrix;
  Color color;
  List<List<List<List<Color>>>> colors;

  MatrixPainter(
    this.posx,
    this.posy,
    this.touched,
    this.columns,
    this.matrixColumns,
    this.matrixRows,
    this.rows,
    this.matrixTouched,
    this.color,
    this.colors,
    this.scale, {
    this.showSpaceBetweenMatrix = true,
  });

  empty() {}

  @override
  void paint(Canvas canvas, Size size) async {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        for (int x = 0; x < matrixRows; x++) {
          for (int y = 0; y < matrixColumns; y++) {
            double dx = showSpaceBetweenMatrix
                ? (j + x) * 13 + 13.0 * j * matrixColumns - 5 * j
                : y * 13 * scale + 13.0 * scale * j * matrixColumns + posx;
            double dy = showSpaceBetweenMatrix
                ? (i + y) * 13 + 13.0 * i * matrixRows - 5 * i
                : x * 13 * scale + 13.0 * scale * i * matrixRows + posy;

            var rect = Offset(dx, dy) & const Size(10, 10);
            Paint paint = Paint();
            paint.color = colors[i][j][x][y];

            canvas.drawRect(rect, paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant MatrixPainter oldDelegate) {
    return true;
  }
}
