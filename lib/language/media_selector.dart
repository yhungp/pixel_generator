peekFile(int language) {
  switch (language) {
    case 0:
      return "Peek a file to show";
    case 1:
      return "Seleccione un archivo a reproducir";
  }
}

nextButton(int language) {
  switch (language) {
    case 0:
      return "Next";
    case 1:
      return "Siguiente";
  }
}

backToMatrixCreation(int language) {
  switch (language) {
    case 0:
      return "Back to matrix creation";
    case 1:
      return "Volver a la creación de la matriz";
  }
}

acceptVideo(int language) {
  switch (language) {
    case 0:
      return "Accept";
    case 1:
      return "Aceptar";
  }
}
