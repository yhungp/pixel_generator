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

backToVideo(int language) {
  switch (language) {
    case 0:
      return "Back to video";
    case 1:
      return "Volver al video";
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

saveToFile(int language) {
  switch (language) {
    case 0:
      return "Save to file";
    case 1:
      return "Guardar en archivo";
  }
}

selectFileToSave(int language) {
  switch (language) {
    case 0:
      return "Please select an output file:";
    case 1:
      return "Seleccione un archivo de salida:";
  }
}

copiedToClipBoard(int language) {
  switch (language) {
    case 0:
      return "Copied to clipboard";
    case 1:
      return "Copiado al portapapeles";
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

fromVideoFpsSelectorLable(int language) {
  switch (language) {
    case 0:
      return "FPS to show:";
    case 1:
      return "FPS a mostrar:";
  }
}

ouputMatrixInformationTable(int language) {
  switch (language) {
    case 0:
      return "Matrix information";
    case 1:
      return "Información de la matriz";
  }
}

ouputVideoInformationTable(int language) {
  switch (language) {
    case 0:
      return "Video information";
    case 1:
      return "Información del video";
  }
}

ouputStartAndEnd(int language) {
  switch (language) {
    case 0:
      return "Start and end";
    case 1:
      return "Inicio y fin";
  }
}

ouputGenerateFramesButton(int language) {
  switch (language) {
    case 0:
      return "Generate frames";
    case 1:
      return "Generar frames";
  }
}

ouputCreateCodeButton(int language) {
  switch (language) {
    case 0:
      return "Create code";
    case 1:
      return "Crear código";
  }
}
