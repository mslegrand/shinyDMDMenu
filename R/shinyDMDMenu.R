#Dropdown derived from boot snippet: fontenele/bootstrap-navbar-dropdowns
#
# see also 
# http://www.w3schools.com/bootstrap/bootstrap_navbar.asp

library(stringr)

gid<-(function(prefix="DMDM"){ #may remove this in the future
  idNum<-100
  function(){
    idNum<<-idNum+1
    paste0(prefix,idNum)
  }
})()


mmHeader<-function(title=""){
  div(
    class="navbar-header",
    tag("button", 
        list(
          type='button',
          class='navbar-toggle',
          'data-toggle'='collapse',
          'data-target'='.navbar-collapse',
          span(class='sr-only', 'Toggle navigation'),
          span(class='icon-bar'),
          span(class='icon-bar'),
          span(class='icon-bar')
        )
    ),
    if(title!="")
      a( class='navbar-brand', href="#",title)
  )  
}

#' Creates a menu seperator
#' 
#' @return a menu seperator
#' @import shiny
#' @export
lineDivider<-function(){
  tag('li', list(class='divider'))
}

#' Creates a menu  item
#' 
#' @param label the displayed label for the menu item
#' @param value return value upon clicking
#' @param id optional id (can be used for selecting)
#' @import shiny
#' @export
menuItem<-function(label, value=label, id=gid() ){  
  href='#'
  if(missing(label)){
    stop("label not provided")
  }
  if(missing(value)){
    value=label
  }
  tag('li', 
    list(a(href=href, id=id, value=value,
           class='dmdMenuItem', label))
  )
} 

dropDownListlabel<-function(label, id){ ### !!! should we allow a value or id specification?
  a(href='#', id=id  ,
    class="dropdown-toggle dmdm-dropdown-toggle",
    "data-toggle"="dropdown",
    value=label, 
    label,
    tag('b', list(class='caret'))
  )
}

dropDownListContents<-function(...){
  tag('ul', 
    list(
      #id=gid(),
      class='dropdown-menu',
      ...
    )
  )
}

#' Create a drop-down menu
#' 
#' @param label the label of the drop down
#' @param ... any number of menu items or dropdowns
#' @param id  id of the element (optional, can be used for selection)
#' @import shiny
#' @export
menuDropdown<-function(label,  ..., id=gid() ){ ### !!! should we allow a value or id specification?
  value=label ### !!! should we allow a value or id specification?
  tag('li', 
    list(
      #id=gid(),
      class="drop-down-list",
      value=value,
      dropDownListlabel(label, id),
      dropDownListContents(...) 
    )
  )
}

#' Creates the top level menu bar
#' 
#' @param title (optional) the title of the menubar
#' @param ... any number of menu items or dropdowns
#' @param menuBarId the id to be associated with this menubar
#' @param theme the name of a shiny bootstrap theme. (requires shinythemes package)
#' @import shiny
#' @export
dmdMenuBarPage<-function(..., title="", menuBarId=NULL, theme=NULL){
  if(is.null(menuBarId)){
    stop("menuBarId should not be null")
  }
  pid=menuBarId
  mmCollapse<-function(pid,...){
    div(
      class='collapse navbar-collapse',
      tag('ul', 
          list( 
            id=gid(),
            class='nav navbar-nav',
            ...
          )
      )
    )  
  }
  
  tagList(   
    singleton(tags$head(
      initResourcePaths(),
      if (!is.null(theme)) {
        tags$head(tags$link(rel = "stylesheet", type = "text/css", href = theme))
      },
      tags$script(src = "shinyDMDMenu/shinyDMDMenu.js"),
      tags$link(rel = "stylesheet", type = "text/css", href ="shinyDMDMenu/shinyDMDMenu.css" )
    )), 
    div(
      id=menuBarId,
      class="mm-menubar navbar navbar-default navbar-fixed-top",
      role="navigation",
      pid=pid,
      style = "padding-left:20px; padding-top:0px; height: 40px;",
      requestor="NULL",
      div(
        class= 'row text-nowrap', #'row', #'container'
        mmHeader(title),
        mmCollapse(pid=menuBarId, ...)
      )
    ) 
  )
}





