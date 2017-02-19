#--------------updates------------------------------------


#' dirty the menu 
#' 
#' @param session the session
#' @param menuBarId the id of the menubar to be reset
#' @import shiny
#' @export
dirtyDMDM<-function(session, menuBarId){
  #message<-list(reset="true")
  #session$sendInputMessage(menuBarId, message)
  updateDMDMenu(session, menuBarId=menuBarId, command='reset', target="", type="")
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



#' Enable/Disable a menu entry (a menu item or dropdown with descendants)
#' 
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
#' @name enable_disable
#' 
#' @import shiny
#' @export
disableDMDM<-function(session, menuBarId, entry,  type="*"){
  if(!(type %in% c("id","menuItem","dropdown","*"))){
    stop(paste0("Invalid type ",type))
  }
  updateDMDMenu(session, menuBarId, "disable", entry, type)
}

#' @rdname enable_disable
#' @export
enableDMDM<-function(session, menuBarId, entry,  type="*"){
  if(!(type %in% c("id","menuItem","dropdown","*"))){
    stop(paste0("Invalid type ",type))
  }
  updateDMDMenu(session, menuBarId, "enable", entry, type)
}

#' Rename an entry (menu item or dropdown title)
#' 
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
#' @param newLabel A null value or new Label for the given entry. A null value for newLabel, will leave the label unchanged.
#' @param newValue A null value or new Value for the given entry. The default value is newLabel. A null value for newLabel, will leave the label unchanged.
#' @export
renameDMDM<-function(session, menuBarId, entry, newLabel, newValue=newLabel, type="*"){
  if(!(type %in% c("id","menuItem","dropdown","*"))){
    stop(paste0("Invalid type ",type))
  }
  updateDMDMenu(session, menuBarId, 
                command="rename",  target= entry, type=type,
                param=list(newLabel=newLabel, newValue=newValue))
} 


#' Removes a  menu item or a dropdown and its children
#' 
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
#' @export
removeDMDM<-function(session, menuBarId,  entry, type="*"){
  if(!(type %in% c("id","menuItem","dropdown","*"))){
    stop(paste0("Invalid type ",type))
  }
  
  updateDMDMenu(session=session, 
                menuBarId=menuBarId, 
                command="delete",
                target=entry,
                type= type
  )
}

#' Add a new item/submenu before given entry
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
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
#' @param submenu  the new menu entries
#' @import shiny
#' @import stringr
#' @export
insertBeforeDMDM<-function(session, menuBarId,  entry, submenu, type="*"){
  if(!(type %in% c("id","menuItem","dropdown","*"))){
    stop(paste0("Invalid type ",type))
  }
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateDMDMenu(session=session, 
                menuBarId=menuBarId, 
                command="before",
                target=entry,
                type= type, 
                param=list(
                  submenu=paste(submenu, collapse=" "),
                  nid=nid
                )
  )
}


#' Add a new item/submenu before after an entry
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
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
#' @param submenu  the new menu entries
#' @import shiny
#' @import stringr
#' @export
insertAfterDMDM<-function(session, menuBarId,  entry, submenu, type="*"){
  if(!(type %in% c("id","menuItem","dropdown","*"))){
    stop(paste0("Invalid type ",type))
  }
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateDMDMenu(session=session, 
                menuBarId=menuBarId, 
                command="after",
                target=entry,
                type= type, 
                param=list(
                  submenu=paste(submenu, collapse=" "),
                  nid=nid
                )
  )
}

#' Appends a new menu item or dropdown with descendants to a dropdown or top menu bar
#' 
#' @param session the session 
#' @param menuBarId the id of the menubar to be updated
#' @param entry Entry is either the value or the id that was assigned to the dropdown which is to be appended to.
#' @param submenu  the new menu entries
#' @param type The type can be any of "*", "dropdown", "id"
#' @import shiny
#' @export
appendDMDM<-function(session, menuBarId, entry, submenu, type="dropdown"){
  nid<-str_match(submenu, regex('id="([:alnum:]+)"'))[,2]
  updateDMDMenu(session=session, 
                menuBarId=menuBarId, 
                command="appendSubmenu",
                target=entry,
                type=type, 
                param=list(
                  submenu=paste(submenu, collapse=" "),
                  nid=nid
                )
  )
}

