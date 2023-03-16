String allTo(int language, int blackOrWhite) => [
      ["All to black", "All to white"][blackOrWhite],
      ["Todo a negro", "Todo a blanco"][blackOrWhite],
    ][language];

String peekingColorLabel(int language) => [
      "Peeking color",
      "Seleccionando color",
    ][language];

String peekingFileLabel(int language, {bool videoOrImage = true}) => [
      "Peek a${videoOrImage ? " video" : "n image"} file ",
      "Seleccione un archivo de ${videoOrImage ? "video" : "imagen"}",
    ][language];

String generateCode(int language) => [
      "Generate code",
      "Generar el código",
    ][language];

String hideCode(int language) => [
      "Hide code",
      "Ocultar código",
    ][language];

String backToVideo(int language) => [
      "Back to video",
      "Volver al video",
    ][language];

String generationProcess(int language, bool sucess) => [
      sucess ? "Code generated successfully" : "Error generating code",
      sucess ? "Código generado correctamente" : "Error al generar el código",
    ][language];

String showCodeLabel(int language, bool showCode) => [
      !showCode ? "Show code" : "Hide code",
      !showCode ? "Mostrar código" : "Ocultar código",
    ][language];

String copyToClipBoard(int language) => [
      "Copy to clipboard",
      "Copiar al portapapeles",
    ][language];

String saveToFile(int language) => [
      "Save to file",
      "Guardar en archivo",
    ][language];

String selectFileToSave(int language) => [
      "Please select an output file:",
      "Seleccione un archivo de salida:",
    ][language];

String copiedToClipBoard(int language) => [
      "Copied to clipboard",
      "Copiado al portapapeles",
    ][language];

String addBrightnessControl(int language) => [
      "Add brightness control",
      "Agregar control de brillo",
    ][language];

String addBrightnessValue(int language) => [
      "Start value",
      "Valor inicial",
    ][language];

String maxAdcValueLabel(int language) => [
      "Max. ADC value",
      "Máximo valor del ADC",
    ][language];

String fromVideoFpsSelectorLable(int language) => [
      "FPS to show:",
      "FPS a mostrar:",
    ][language];

String ouputMatrixInformationTable(int language) => [
      "Matrix information",
      "Información de la matriz",
    ][language];

String ouputVideoInformationTable(int language) => [
      "Video information",
      "Información del video",
    ][language];

String ouputStartAndEnd(int language) => [
      "Start and end",
      "Inicio y fin",
    ][language];

String ouputGenerateFramesButton(int language) => [
      "Generate frames",
      "Generar frames",
    ][language];

String ouputCreateCodeButton(int language) => [
      "Create code",
      "Crear código",
    ][language];

String ouputLoadingVideoInfo(int language) => [
      "Loading video info",
      "Cargando información de video",
    ][language];

String showMatrixLabel(int language) => [
      "Show matrix array joined",
      "Mostrar matrices unidas unido",
    ][language];
