import 'package:flutter/material.dart';

class MatrixPainterWithScaler extends CustomPainter {
  bool touched;
  double posx;
  double posy;
  int matrixColumns;
  int matrixRows;
  int columns;
  int rows;
  bool matrixTouched;
  Color color;
  List<List<List<List<Color>>>> colors;
  Function editPixel;

  MatrixPainterWithScaler(
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
      this.editPixel,
      double scale);

  empty() {}

  @override
  void paint(Canvas canvas, Size size) async {
    List points = [
      [posx - 6, posy - 6],
      [
        posx + matrixColumns * 13.0 * columns + (columns - 1) * 5 - 2,
        posy - 6,
      ],
      [
        posx + matrixColumns * 13.0 * columns + (columns - 1) * 5 - 2,
        posy + matrixRows * 13.0 * rows + (rows - 1) * 5 - 2,
      ],
      [
        posx - 6,
        posy + matrixRows * 13.0 * rows + (rows - 1) * 5 - 2,
      ],
    ];

    for (var point in points) {
      canvas.drawCircle(
        Offset(point[0], point[1]),
        5,
        Paint()..color = Colors.white,
      );
    }

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        for (int x = 0; x < matrixRows; x++) {
          for (int y = 0; y < matrixColumns; y++) {
            double dx = (j + 2 * x) * 13 + posx;
            double dy = (i + 2 * y) * 13 + posy;

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
  bool shouldRepaint(covariant MatrixPainterWithScaler oldDelegate) {
    return true;
  }
}
