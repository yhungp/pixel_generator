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