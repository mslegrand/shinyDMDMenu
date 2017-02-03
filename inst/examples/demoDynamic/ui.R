
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

library(shinyDMDMenu)
library(shinythemes)

menuBarId<-'addDelDemo'

shinyUI(fluidPage(
  tags$head(
    tags$script('Shiny.addCustomMessageHandler("showClick",function(message) {alert(JSON.stringify(message));}); '),
    tags$style(HTML("div.well{padding-top:10px; padding-bottom:0;}")
  )),
  div(style="margin-bottom:50px",
      dmdMenuBarPage( title='Main Menu: (A Dynamic Multi-level Dropdown Menu)',
                        theme=shinytheme( "united" ),
                        id=menuBarId,
                          subMenu(
                            "Dropdown 1",
                            menuItem("menu 1-1"),
                            menuItem("menu 1-2"),
                            subMenu("Dropdown 2",
                                    menuItem("menu 2-1"),
                                    menuItem("menu 2-2"),
                                    menuItem("menu 2-3")
                                    )
                          ),
                          menuItem("menu 2")
  )),
  sidebarLayout(
    sidebarPanel(
      wellPanel( 
                 fluidRow(
                   column(width=6,offset=0,h4('Last item clicked')),
                   column(width=6,offset=0, verbatimTextOutput("menuChoice"))
                 )
      ),
      wellPanel(
      h4(tags$b("Adding")),
      fluidRow(
        h5("What to add"),
        column(width=6,offset=0,
               textInput("level1", label="Adding",
                         value = "", width = 200)
        ),
        column(width=6,offset=0,
               textAreaInput("level2", label="with children (optional)",width = 200,rows = 3)
        )
      ),
      h5("Where to add"),
        fluidRow(
          column(width=6,offset=0, actionButton("appendToEvent","Append to Dropdown", width="180px")),
          column(width=6,offset=0, selectInput("droppdownTarget", NULL, 
                                               choices="")) 
        ),
        fluidRow(
          column(width=6,offset=0, actionButton("beforeEvent","Before Dropdown/Item", width="180px")),
          column(width=6,offset=0, 
            selectInput("beforeTarget", NULL, choices="")) 
        ),
        fluidRow(
          column(width=6,offset=0, actionButton("afterEvent","After Dropdown/Item", width="180px")), 
          column(width=6,offset=0, 
            selectInput("afterTarget", NULL, choices="")) 
        )
      ),
      wellPanel(
        h4(tags$b("Deleting")),
        fluidRow(
          column(width=6,offset=0, actionButton("deleteEvent","Delete Dropdown/Item", width="180px")), 
          column(width=6,offset=0, 
                 selectInput("deleteTarget", NULL, choices="")) 
      )),
      wellPanel(
        h4(tags$b("Enable / Disable")),
        fluidRow(
          column(width=6,offset=0, actionButton("disableEvent","Disable Dropdown/Item", width="180px")), 
          column(width=6,offset=0, 
                 selectInput("disableTarget", NULL, choices="")) 
        ),
        fluidRow(
          column(width=6,offset=0, actionButton("enableEvent","Enable Dropdown/Item", width="180px")), 
          column(width=6,offset=0, 
                 selectInput("enableTarget", NULL, choices="")) 
        )
      ),
      wellPanel(
        h4(tags$b("Renaming")),
        fluidRow(column(width=1,offset=0, actionButton("renameToEvent","rename")),
          column(width=5,offset=1, 
                 selectInput("renameTarget", NULL, choices="")) ,
           
          column(width=5,offset=0, 
                 tags$b('to'),
                 textInput("renameTo", label=NULL, value = "")) 
        )
      )
    ),

    mainPanel(
      wellPanel( style="margin-top:20px;",
          fluidRow(
            column(width=6,offset=0, 
                   tags$img( src="https://cloud.githubusercontent.com/assets/5139775/22185259/2ef71c62-e0b0-11e6-872b-2eaa67843c92.png", width="350")
            ),
            column(width=6,offset=0, 
                   h4('About'),
                   p('This app demonstrates a dmdMenu package to provide dynamic menu having mulitlevel dropdowns'),
                   tags$ul(
                     tags$li( 'dmdMenu can add/delete,disable/enable and rename at run-time'),
                     tags$li( 'dmdMenu supports multilevel-dropdowns: ie dropdowns containing dropdowns'),
                     tags$li( 'dmdMenu supports bootstrap themes'),
                     tags$li( 'The dmdMenu package is available on github at', 
                              tags$a( 'https://github.com/mslegrand/shinyDMDMenu'))
                   )   
            )
          )
        ),
      #wellPanel( style="margin-top:20px",
        h4('Try to Editing the Above Main Menu as Follows:'),
        wellPanel( 
          h5('Adding to the Menu'),
          tags$ol( type='l',
            tags$li('Decide what to add:', 
              tags$ul(
                tags$li( 'For a single menu item: fill the "Adding" edit box with the menu item name'),
                tags$li( 'For a dropdown: fill the "Adding" edit box with the dropdown name then in "children" edit box add one or more menu items, placing each item on a seperate line.')
              )
            ),
            tags$li('Decide where to add:',
              tags$ul(
                tags$li( 'To append to an existing dropdown: use the first selection box to pick the drop down name and press the corresponding button'),
                tags$li( 'To insert before an existing entry: use the second selection box to pick the entry name and press the corresponding button'),
                tags$li( 'To after an an existing entry: use the third selection box to pick the entry name and press the corresponding button')
              )
            ) #end of where to add
          ), #end of adding list
          p(),
          strong("Note:"), 
          tags$ul(
            tags$li( "By 'entry' we mean either a dropdown name or a menu item name."),
            tags$li( "To avoid ambiguity on insertion and deletion, we keep the names unique"),
            tags$li( "The '_' (underscore) selection represents the menubar at the top of the 'Main Menu'.")
          )
        ), #endof adding to menu
        wellPanel( 
          h5('Deleting from the Menu'),
          tags$ul(type='l',
            tags$li('Decide what to remove: select from dropdown'), 
            tags$li('Remove: press delete button')
          )
        ) #endof remove
    ) #endof mainpanel
  ) #sidebar layout
))
