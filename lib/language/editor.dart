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
peekingFileLabel(int language, {bool videoOrImage = true}) {
  // videoOrImage -> true: video   false: image
  switch (language) {
    case 0:
      return "Peek a${videoOrImage ? " video" : "n image"} file ";
    case 1:
      return "Seleccione un archivo de ${videoOrImage ? "video" : "imagen"}";
  }
}

generateCode(int language) {
  switch (language) {
    case 0:
      return "Generate code";
    case 1:
      return "Generar el código";
  }
}

generationProcess(int language, bool sucess) {
  switch (language) {
    case 0:
      return sucess ? "Code generated successfully" : "Error generating code";
    case 1:
      return sucess ? "Código generado correctamente" : "Error al generar el código";
  }
}

showCodeLabel(int language, bool showCode) {
  switch (language) {
    case 0:
      return !showCode ? "Show code" : "Hide code";
    case 1:
      return !showCode ? "Mostrar código" : "Ocultar código";
  }
}

copyToClipBoard(int language) {
  switch (language) {
    case 0:
      return "Copy to clipboard";
    case 1:
      return "Copiar al portapapeles";
  }
}

addBrightnessControl(int language) {
  switch (language) {
    case 0:
      return "Add brightness control";
    case 1:
      return "Agregar control de brillo";
  }
}

addBrightnessValue(int language) {
  switch (language) {
    case 0:
      return "Start value";
    case 1:
      return "Valor inicial";
  }
}

maxAdcValueLabel(int language) {
  switch (language) {
    case 0:
      return "Max. ADC value";
    case 1:
      return "Máximo valor del ADC";
  }
}
