.global <- new.env()

initResourcePaths <- function() {
  if (is.null(.global$loaded)) {
    shiny::addResourcePath(
      prefix = 'shinyDMDMenu',
      directoryPath = system.file('www', package='shinyDMDMenu'))
    .global$loaded <- TRUE
  }
  HTML("")
}