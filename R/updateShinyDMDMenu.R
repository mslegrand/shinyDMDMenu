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
#' @param target the identifier(value) of dropdown/selection 
#' @param type one of c('menuItem', 'dropdown', '_', '*')
#' @param ... additional params
#' @import shiny
#' @export
updateDMDMenu<-function(session, menuBarId, 
                          command, 
                          target, 
                          type, ...){
  mia<-c( session=missing(session), menuBarId=missing(menuBarId),
          command=missing(command), target=missing(target), type=missing(type)
  )
  
  
  if(any(mia)){ 
    stop("To update must provide", paste( names(mia)[mia==TRUE]), sep=", ")
  }
  
  theList <- list(id=menuBarId,  target=target, cmd=command, type=type)
  theList <- c(theList, list(...))
  session$sendCustomMessage("DMDMenu", theList)
}

#' Disable a menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param item the identifier(value) of the item to be diabled
#' @import shiny
#' @export
disableMenuItem<-function(session, menuBarId, item){
  updateDMDMenu(session, menuBarId, "disable", item, "menuItem")
}

#' Disable a dropdown
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param dropdown the identifier(value) of the dropdownto be diabled
#' @import shiny
#' @export
disableMenuDropdown<-function(session, menuBarId, dropdown){
  updateDMDMenu(session, menuBarId, "disable",  dropdown,  "dropdown")
}


#' @param session The session.
#' @param menuBarId The id of this menubar (top level menu).
#' @param entry The identifier for the target entry(ies). 
#' This can be the value of the entry value in the case that the entry
#' is a menuItem, or the title of in the case that the entry is a dropdown,
#' or if an id was specified when creating the entry, the entry id. Which 
#' case is specified by the "type" specification parameter.
#' @param type Type specification parameter of the entry identifier.
#' The type is one of  "id", "*", menuItem", "dropdown". 
#' Type is used to determine how to interpret "entry" when searching for the
#' that entry. Specifically:
#' \describe{
#' \item{if type=="id"}{ then \emph{entry} specifies the id of the target element}
#' \item{if type=="menuItem"}{then \emph{entry} specifies the value of target element(s) that are menuitems}
#' \item{if type=="dropdown"}{then \emph{entry} specifies the title of target element(s) that are dropdowns} 
#' \item{if type=="*"}{combines both types \emph{menuItem} and \emph{dropdown} to search for the target element}
#' } 
#' the default for type is "*"
#' @name typeParams
NULL


#' Enable/Disable a menu entry (a menu item or dropdown with descendants)
#' 
#' 
#' @rdname typeParams
#' 
#' @import shiny
#' @export
disableEntry<-function(session, menuBarId, entry,  type="*"){
  updateDMDMenu(session, menuBarId, "disable", entry, "menuItem")
}

#' @rdname typeParams
#' @export
enableEntry<-function(session, menuBarId, entry,  type="*"){
  updateDMDMenu(session, menuBarId, "enable", entry, "menuItem")
}


#' Enable a menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param item the identifier(value) of the item to be enabled
#' @import shiny
#' @export
enableMenuItem<-function(session, menuBarId, item){
  updateDMDMenu(session, menuBarId, "enable", item, "menuItem")
}

#' Enable a dropdown
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param dropdown the identifier(value) of the dropdownto be enabled
#' @import shiny
#' @export
enableMenuDropdown<-function(session, menuBarId, dropdown){
  updateDMDMenu(session, menuBarId, "enable", dropdown, "dropdown")
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
  updateDMDMenu(session, menuBarId, 
                       command="rename", 
                       target=item, 
                       type="menuItem", 
                       param=c(newLabel, newLabel))
}


#' Rename a menu item
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param dropdown the identifier(value) of the item to be renamed
#' @param newLabel the new name
#' @import shiny
#' @export
renameMenuDropdown<-function(session, menuBarId, dropdown, newLabel ){
  updateDMDMenu(session, menuBarId, 
                       command="rename", 
                       target=dropdown, 
                       type="dropdown", 
                       param=c(newLabel, newLabel))
} #Must provide session, menuBarId, command, target, type to update.


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
  updateDMDMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="add",
                       target=parent,
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
  updateDMDMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="delete",
                       target=value,
                       type= "menuItem"
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
  updateDMDMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="delete",
                       target=label,
                       type= "dropdown"
  )
}

#removeSubMenu<-function(session, menuBarId, parent){}

#todo add item for topnav bar (currently adds on target which is a dropdown)
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
appendToDropdown<-function(session, menuBarId,  dropdown, submenu){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateDMDMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="addSubmenu",
                       target=dropdown,
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
#' @param entry the identifier(value) of the parent (dropdown)
#' @param submenu  the new menu entries
#' @import shiny
#' @import stringr
#' @export
insertBeforeMenuItem<-function(session, menuBarId,  entry, submenu){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateDMDMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="before",
                       target=entry,
                       type= "menuItem", 
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
#' @param entry the identifier(value) of the parent (dropdown)
#' @param submenu  the new menu entries
#' @import shiny
#' @export
insertAfterMenuItem<-function(session, menuBarId,  entry, submenu){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateDMDMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="after",
                       target=entry,
                       type= "menuItem", 
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
#' @param entry the identifier(value) of the parent (dropdown)
#' @param submenu  the new menu entries
#' @import shiny
#' @export
insertBeforeDropdown<-function(session, menuBarId,  entry, submenu){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateDMDMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="before",
                       target=entry,
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
#' @param entry the identifier(value) of the parent (dropdown)
#' @param submenu  the new menu entries
#' @import shiny
#' @export
insertAfterDropdown<-function(session, menuBarId,  entry, submenu){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateDMDMenu(session=session, 
                       menuBarId=menuBarId, 
                       command="after",
                       target=entry,
                       type= "dropdown", 
                       param=list(
                         submenu=paste(submenu, collapse=" "),
                         nid=nid
                       )
  )
} 


