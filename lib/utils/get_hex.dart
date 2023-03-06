getHex(int val) {
  String out = val.toRadixString(16);

  out = "0" * (2 - out.length) + out;
  return out;
}
