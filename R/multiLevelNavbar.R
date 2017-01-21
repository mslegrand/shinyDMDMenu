#Derived from boot snippet: fontenele/bootstrap-navbar-dropdowns
#
# see also 
# http://www.w3schools.com/bootstrap/bootstrap_navbar.asp


newIdGen<-function(prefix="ML"){ #may remove this in the future
  idNum<-100
  function(){
    idNum<<-idNum+1
    paste0(prefix,idNum)
  }
}

gid<-newIdGen()


mmHeader<-function(navBarBrand=""){
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
    if(navBarBrand!="")
      a( class='navbar-brand', href="#",navBarBrand)
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
#' @param title the displayed label for the menu item
#' @param value return value upon clicking
#' @import shiny
#' @export
lineItem<-function(  title, value=title ){  
  href='#'
  if(missing(title)){
    stop("title not provided")
  }
  if(missing(value)){
    value=title
  }
  
  tag('li', 
    list(a(href=href, id=gid(), "value"=value,
           class='menuActionItem', title))
  )
} 

dropDownListTitle<-function(title){
  a(href='#',  id=gid(),
    class="dropdown-toggle mm-dropdown-toggle",
    "data-toggle"="dropdown",
    value=title,
    title,
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

#' Creates a drop-down menu
#' 
#' @param the label of the drop down
#' @param ... any number of menu items or dropdowns
#' @import shiny
#' @export
dropDownList<-function(title,  ...){
  value=title
  tag('li', 
    list(
      id=gid(),
      class="drop-down-list",
      value=value,
      dropDownListTitle(title),
      dropDownListContents(...) 
    )
  )
}

#' Creates the top level menu bar
#' 
#' @param navBarBrand (optional)
#' @param ... any number of menu items or dropdowns
#' @param id the id to be associated with this menubar
#' @import shiny
#' @export
multiLevelNavBarPage<-function(  ..., navBarBrand="", id=NULL){
  if(is.null(id)){
    stop("id should not be null")
  }
  #print(paste("id=",id))
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
        mmHeader(navBarBrand),
        mmCollapse(pid=id, ...)
      )
    ) #,
    # we might put here a js to run an update immediately after loading 
    # tags$script(type="text/javascript", HTML(js))
  )
}



