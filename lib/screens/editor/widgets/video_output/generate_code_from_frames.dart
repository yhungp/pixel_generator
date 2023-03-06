import 'dart:typed_data';

import 'package:calculator/main.dart';
import 'package:calculator/utils/get_hex.dart';
import 'package:image/image.dart' as image;

generateCodeFromFrames(
  SettingsScreenNotifier notifier,
  List<Uint8List> bytesList,
  int rows,
  int columns,
  int matrixColumns,
  int matrixRows,
) {
  List<List<String>> pixels = [];
  try {
    for (var pngBytes in bytesList) {
      image.Image img = image.decodeImage(pngBytes.buffer.asUint8List())!;

      List<image.Image> images = [];
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < columns; c++) {
          image.Image im = image.copyCrop(
            img,
            c * matrixColumns,
            r * matrixRows,
            matrixColumns,
            matrixRows,
          );

          images.add(im);
        }
      }

      List<String> matrixValues = [];
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < columns; c++) {
          bool invert = false;
          image.Image im = images[r * (rows - 1) + c];
          final decodedBytes = im.getBytes(format: image.Format.rgb);

          List<String> values = [];
          int loopLimit = matrixColumns * matrixRows;
          for (int x = 0; x < loopLimit; x++) {
            int red = decodedBytes[x * 3];
            int green = decodedBytes[x * 3 + 1];
            int blue = decodedBytes[x * 3 + 2];

            values.add("0x${getHex(red)}${getHex(green)}${getHex(blue)}");
          }

          for (int mr = 0; mr < matrixRows; mr++) {
            var row = values.sublist(
              mr * matrixColumns,
              mr * matrixColumns + matrixColumns,
            );

            if (!invert) {
              matrixValues.addAll(row);
              invert = true;
              continue;
            }

            row = row.reversed.toList();
            matrixValues.addAll(row);

            invert = false;
          }
        }
      }
      pixels.add(matrixValues);
    }

    return pixels;
  } catch (_) {
    return [];
  }
}
