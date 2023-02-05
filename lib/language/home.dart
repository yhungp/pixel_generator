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
      return "No hay proyectos recientes para mostrar";
  }
}

createNewProject(int language) {
  switch (language) {
    case 0:
      return "New project";
    case 1:
      return "Nuevo proyecto";
  }
}

openExistingProject(int language) {
  switch (language) {
    case 0:
      return "Open project";
    case 1:
      return "Abrir proyecto";
  }
}

fileEmpty(int language) {
  switch (language) {
    case 0:
      return "File is empty";
    case 1:
      return "El archivo está vacío";
  }
}

errorLoadingFile(int language) {
  switch (language) {
    case 0:
      return "Error loading file";
    case 1:
      return "Error cargando el archivo";
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
