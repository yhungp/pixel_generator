recentProjects(int language) {
  switch (language) {
    case 0:
      return "Recent projects";
    case 1:
      return "Proyectos recientes";
  }
}

noRecentProjectsToShow(int language) {
  switch (language) {
    case 0:
      return "No recent projects to show";
    case 1:
      return "No hayroyectos recientes para mostrar";
  }
}


fileLocation(int language) {
  switch (language) {
    case 0:
      return "File location:";
    case 1:
      return "Localización de archivo:";
  }
}

fileDoNotExist(int language) {
  switch (language) {
    case 0:
      return "Project file don't exist.";
    case 1:
      return "El archivo de programa no existe.";
  }
}


fileSizeLabel(int language) {
  switch (language) {
    case 0:
      return "File Size:";
    case 1:
      return "Tamaño de archivo:";
  }
}
