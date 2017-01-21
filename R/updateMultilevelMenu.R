#--------------updates------------------------------------

#' Update the Menu
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param command one of c('disable','enable', 'rename')
#' @param targetItem the identifier(value) of dropDown/selection 
#' @type one of c('actionItem', 'dropDown')
#' @import shiny
#' @export
updateMultiLevelMenu<-function(session, menuBarId, command, targetItem, type, ...){
  
  if ( missing(session) || missing(menuBarId) || 
       missing(command) ||missing(targetItem) || missing(type)
  ){ 
    stop("Must provide session, menuBarId, command, target, type to update.")
  }
  
  theList <- list(id=menuBarId,  targetItem=targetItem, cmd=command, type=type)
  theList <- c(theList, list(...))
  session$sendCustomMessage("multiLevelMenuBar", theList)
}

disableMenuItem<-function(session, menuBarId, item){
  updateMultiLevelMenu(session, menuBarId, item, "actionItem")
}

disableMenuDropdown<-function(session, menuBarId, item){
  updateMultiLevelMenu(session, menuBarId, item, "dropDown")
}

enableMenuItem<-function(session, menuBarId, item){
  updateMultiLevelMenu(session, menuBarId, item, "actionItem")
}

enableMenuDropdown<-function(session, menuBarId, item){
  updateMultiLevelMenu(session, menuBarId, item, "dropDown")
}

renameMenuItem<-function(session, menuBarId, item, newLabel ){
  updateMultiLevelMenu(session, menuBarId, item, "actionItem", param=c(newLabel, newLabel))
}

renameMenuDropdow<-function(session, menuBarId, item, newLabel ){
  updateMultiLevelMenu(session, menuBarId, item, "dropdown", param=c(newLabel, newLabel))
}


#To do-------------Dynamicalls Add/Remove to the menu-----------------

#addSubMenu<-function(session, menuBarId, parent, submenu){}

#removeSubMenu<-function(session, menuBarId, parent){}


