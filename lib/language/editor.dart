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

// grey scale
peekingColorLabel(int language) {
  switch (language) {
    case 0:
      return "Peeking color";
    case 1:
      return "Seleccionando color";
  }
}

// grey scale
peekingFileLabel(int language) {
  switch (language) {
    case 0:
      return "Peek a file";
    case 1:
      return "Seleccione un archivo";
  }
}
