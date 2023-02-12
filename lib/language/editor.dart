// black or white
allTo(int language, int blackOrWhite) {
  List en = ["All to black", "All to white"];
  List es = ["Todo a negro", "Todo a blanco"];

  switch (language) {
    case 0:
      return en[blackOrWhite];
    case 1:
      return es[blackOrWhite];
  }
}
