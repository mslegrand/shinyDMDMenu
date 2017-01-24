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

#' Disable a menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param item the identifier(value) of the item to be diabled
#' @import shiny
#' @export
disableMenuItem<-function(session, menuBarId, item){
  updateMultiLevelMenu(session, menuBarId, item, "actionItem")
}

#' Disable a dropdown
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param dropdown the identifier(value) of the dropdownto be diabled
#' @import shiny
#' @export
disableMenuDropdown<-function(session, menuBarId, dropdown){
  updateMultiLevelMenu(session, menuBarId, dropdown, "dropDown")
}

#' Enable a menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param item the identifier(value) of the item to be enabled
#' @import shiny
#' @export
enableMenuItem<-function(session, menuBarId, item){
  updateMultiLevelMenu(session, menuBarId, item, "actionItem")
}

#' Enable a dropdown
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param dropdown the identifier(value) of the dropdownto be enabled
#' @import shiny
#' @export
enableMenuDropdown<-function(session, menuBarId, dropdown){
  updateMultiLevelMenu(session, menuBarId, item, "dropDown")
}

#' Rename a menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param item the identifier(value) of the item to be renamed
#' @param newLabel the new name
#' @import shiny
#' @export
renameMenuItem<-function(session, menuBarId, item, newLabel ){
  updateMultiLevelMenu(session, menuBarId, item, "actionItem", param=c(newLabel, newLabel))
}

renameMenuDropdow<-function(session, menuBarId, item, newLabel ){
  updateMultiLevelMenu(session, menuBarId, item, "dropdown", param=c(newLabel, newLabel))
}


#To do-------------Dynamicalls Add/Remove to the menu-----------------

#' Add a new menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param parent the identifier(value) of the parent (dropdown)
#' @param label the label of the new menu item
#' @param value the return value when this item is clicked
#' @import shiny
#' @export
addMenuItem<-function(session, menuBarId, parent, label, value=label){
  updateMultiLevelMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="add",
                       targetItem=parent,
                       type= "dropDownList", 
                       param=list(
                         label=label,
                         value=value,
                         gid=gid()
                      )
  )
}

#' removes a  menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param value the return value when this item is clicked
#' @import shiny
#' @export
removeMenuItem<-function(session, menuBarId,  value){
  updateMultiLevelMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="delete",
                       targetItem=value,
                       type= "actionItem"
  )
}

#removeSubMenu<-function(session, menuBarId, parent){}


