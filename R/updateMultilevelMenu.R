#--------------updates------------------------------------

#' dirty the menu 
#' 
#' @param session the session
#' @param menuBarId the id of the menubar to be reset
#' @import shiny
#' @export
dirtyMenu<-function(session, menuBarId){
  message<-list(reset="true")
  session$sendInputMessage(menuBarId, message)
}

#' Update the Menu
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param command one of c('disable','enable', 'rename')
#' @param targetItem the identifier(value) of dropdown/selection 
#' @param type one of c('actionItem', 'dropdown')
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
  updateMultiLevelMenu(session, menuBarId, "disable", item, "actionItem")
}

#' Disable a dropdown
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param dropdown the identifier(value) of the dropdownto be diabled
#' @import shiny
#' @export
disableMenuDropdown<-function(session, menuBarId, dropdown){
  updateMultiLevelMenu(session, menuBarId, "disable",  dropdown,  "dropdown")
}

#' Enable a menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param item the identifier(value) of the item to be enabled
#' @import shiny
#' @export
enableMenuItem<-function(session, menuBarId, item){
  updateMultiLevelMenu(session, menuBarId, "enable", item, "actionItem")
}

#' Enable a dropdown
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param dropdown the identifier(value) of the dropdownto be enabled
#' @import shiny
#' @export
enableMenuDropdown<-function(session, menuBarId, dropdown){
  updateMultiLevelMenu(session, menuBarId, "enable", dropdown, "dropdown")
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

#' Rename a menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param item the identifier(value) of the item to be renamed
#' @param newLabel the new name
#' @import shiny
#' @export
renameMenuDropdown<-function(session, menuBarId, dropdown, newLabel ){
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
                       type= "dropdownList", 
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

#' removes a  menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param label the label of the dropdown
#' @import shiny
#' @export
removeMenuDropdown<-function(session, menuBarId,  label){
  updateMultiLevelMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="delete",
                       targetItem=label,
                       type= "dropdown"
  )
}

#removeSubMenu<-function(session, menuBarId, parent){}

#todo add item for topnav bar (currently adds on targetItem which is a dropdown)
#additem2bar<-function(){

#' Add a new menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param dropdown the value that was assigned to the dropdown
#' @param submenu  the new menu entries
#' 
#' @import shiny
#' @export
addSubMenu<-function(session, menuBarId,  dropdown, submenu){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateMultiLevelMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="addSubmenu",
                       targetItem=dropdown,
                       type= "dropdownList", 
                       param=list(
                         submenu=paste(submenu, collapse=" "),
                         nid=nid
                       )
  )
}


#' Add a new item/submenu before given entry
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param parent the identifier(value) of the parent (dropdown)
#' @param submenu  the new menu entries
#' 
#' @import shiny
#' @export
insertBeforeMenuItem<-function(session, menuBarId,  entry, submenu){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateMultiLevelMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="before",
                       targetItem=entry,
                       type= "actionItem", 
                       param=list(
                         submenu=paste(submenu, collapse=" "),
                         nid=nid
                       )
  )
}

#' Add a new item/submenu before given entry
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param parent the identifier(value) of the parent (dropdown)
#' @param submenu  the new menu entries
#' 
#' @import shiny
#' @export
insertBeforeMenuItem<-function(session, menuBarId,  entry, submenu){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateMultiLevelMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="before",
                       targetItem=entry,
                       type= "actionItem", 
                       param=list(
                         submenu=paste(submenu, collapse=" "),
                         nid=nid
                       )
  )
}

#' Add a new item/submenu before given entry
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param parent the identifier(value) of the parent (dropdown)
#' @param submenu  the new menu entries
#' 
#' @import shiny
#' @export
insertAfterMenuItem<-function(session, menuBarId,  entry, submenu){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateMultiLevelMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="after",
                       targetItem=entry,
                       type= "actionItem", 
                       param=list(
                         submenu=paste(submenu, collapse=" "),
                         nid=nid
                       )
  )
}

#' Add a new item/submenu before given entry
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param parent the identifier(value) of the parent (dropdown)
#' @param submenu  the new menu entries
#' 
#' @import shiny
#' @export
insertBeforeDropdown<-function(session, menuBarId,  entry, submenu){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateMultiLevelMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="before",
                       targetItem=entry,
                       type= "dropdown", 
                       param=list(
                         submenu=paste(submenu, collapse=" "),
                         nid=nid
                       )
  )
}


#' Add a new item/submenu after given entry
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param parent the identifier(value) of the parent (dropdown)
#' @param submenu  the new menu entries
#' 
#' @import shiny
#' @export
insertAfterDropdown<-function(session, menuBarId,  entry, submenu){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateMultiLevelMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="after",
                       targetItem=entry,
                       type= "dropdown", 
                       param=list(
                         submenu=paste(submenu, collapse=" "),
                         nid=nid
                       )
  )
}


