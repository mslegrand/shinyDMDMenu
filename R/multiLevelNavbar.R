#Dropdown derived from boot snippet: fontenele/bootstrap-navbar-dropdowns
#
# see also 
# http://www.w3schools.com/bootstrap/bootstrap_navbar.asp

library(stringr)

newIdGen<-function(prefix="ML"){ #may remove this in the future
  idNum<-100
  function(){
    idNum<<-idNum+1
    paste0(prefix,idNum)
  }
}

gid<-newIdGen()


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

#' Creates a menu action item
#' 
#' @param label the displayed label for the menu item
#' @param value return value upon clicking
#' @import shiny
#' @export
menuItem<-function(  label, value=label ){  
  href='#'
  if(missing(label)){
    stop("label not provided")
  }
  if(missing(value)){
    value=label
  }
  
  tag('li', 
    list(a(href=href, id=gid(), value=value,
           class='menuActionItem', label))
  )
} 

dropDownListlabel<-function(label){ ### !!! should we allow a value or id specification?
  a(href='#',  id=gid(),
    class="dropdown-toggle mm-dropdown-toggle",
    "data-toggle"="dropdown",
    value=label, 
    label,
    tag('b', list(class='caret'))
  )
}

dropDownListContents<-function(...){
  tag('ul', 
    list(
      id=gid(),
      class='dropdown-menu',
      ...
    )
  )
}

#' Create a drop-down menu
#' 
#' @param label the label of the drop down
#' @param ... any number of menu items or dropdowns
#' @import shiny
#' @export
subMenu<-function(label,  ...){ ### !!! should we allow a value or id specification?
  value=label ### !!! should we allow a value or id specification?
  tag('li', 
    list(
      id=gid(),
      class="drop-down-list",
      value=value,
      dropDownListlabel(label),
      dropDownListContents(...) 
    )
  )
}

#' Creates the top level menu bar
#' 
#' @param title (optional) the title of the menubar
#' @param ... any number of menu items or dropdowns
#' @param id the id to be associated with this menubar
#' @param theme the name of a shiny bootstrap theme. (requires shinythemes package)
#' @import shiny
#' @export
multiLevelNavBarPage<-function(..., title="", id=NULL, theme=NULL){
  if(is.null(id)){
    stop("id should not be null")
  }
  pid=id
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
      tags$script(src = "https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"),
      tags$script(src = "https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"),
      if (!is.null(theme)) {
        tags$head(tags$link(rel = "stylesheet", type = "text/css", href = theme))
      },
      tags$script(src = "multilevelMenu/multiLevelNavbar.js"),
      tags$link(rel = "stylesheet", type = "text/css", href ="multilevelMenu/multiLevelNavbar.css" )
    )), 
    div(
      id=id,
      class="mm-menubar navbar navbar-default navbar-fixed-top",
      role="navigation",
      pid=pid,
      style = "padding-left:20px; padding-top:0px; height: 40px;",
      requestor="NULL",
      div(
        class= 'row text-nowrap', #'row', #'container'
        mmHeader(title),
        mmCollapse(pid=id, ...)
      )
    ) 
  )
}





