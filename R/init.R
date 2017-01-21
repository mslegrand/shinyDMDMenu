.global <- new.env()

initResourcePaths <- function() {
  if (is.null(.global$loaded)) {
    shiny::addResourcePath(
      prefix = 'multilevelMenu',
      directoryPath = system.file('www', package='shinyMultilevelMenu'))
    .global$loaded <- TRUE
  }
  HTML("")
}