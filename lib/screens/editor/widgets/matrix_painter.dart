import 'package:flutter/material.dart';

class MatrixPainter extends CustomPainter {
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
    this.editPixel,
  );

  empty() {}

  @override
  void paint(Canvas canvas, Size size) async {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        for (int x = 0; x < matrixRows; x++) {
          for (int y = 0; y < matrixColumns; y++) {
            double dx = (j + x) * 13 + 13.0 * j * matrixColumns - 5 * j;
            double dy = (i + y) * 13 + 13.0 * i * matrixRows - 5 * i;

            var rect = Offset(dx, dy) & const Size(10, 10);
            Paint paint = Paint();
            paint.color = colors[i][j][x][y];

            // if (matrixTouched) {
            //   bool pixelTouched =
            //       posx > dx && posx < dx + 10 && posy > dy && posy < dy + 10;

            //   if (pixelTouched) {
            //     print("touched  $i  $j  $x  $y");
            //     editPixel(i, j, x, y, color);
            //   } else {
            //     print("");
            //   }
            // }

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
