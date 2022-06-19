
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

library(shinyDMDMenu)
#library(shinythemes)

shinyUI(fluidPage(
  singleton( tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href ="custom.css" )
  )),
  dmdMenuBarPage(
    menuBarId='mytop',
    menuItem("Appricot"),
    menuItem("Bannana"),
    menuItem("Cherry"),
    menuDropdown(
     "More Fruit",
     #id='fruit',
     menuItem("oranges"),
     menuItem("pears")
    ),
    menuDropdown(
     "Great Men",
     subMenuDropdown("China",
        subMenuDropdown("Xian",
          menuItem("Kungfu Panda")
        ),
        subMenuDropdown("Hongkong",
          menuItem("Bruce Lee")
        )
     ),
     subMenuDropdown("UnitedStates",
            subMenuDropdown("Califoria",
            menuItem("Howard Hughes"),
            menuItem("Grateful Dead"),
            menuItem("Mickey Mouse")
          ),
          subMenuDropdown("Illinois",
            menuItem("Abe Lincoln"),
            menuItem("Al Capone")
          )
     ),
     subMenuDropdown(
       "United Kingdom",
       menuItem("Ireland"),
       menuItem("Scotland"),
       subMenuDropdown("England",
                    menuItem("Shakespear"),
                    menuItem("Sherlock Holmes"),
                    menuItem("Dr. Who")
       ),
       menuItem("Wales")
     )
    )
  ),

  wellPanel( style="margin-top:50px",
        verbatimTextOutput("menuChoice"),
        radioButtons("bannanaDisable","Bannana", choices=c("enable","disable"),inline = TRUE),
        radioButtons("usDisable","UnitedStates", choices=c("enable","disable"),inline=TRUE),
        radioButtons("shakespearDisable","Shakespear", choices=c("enable","disable"),inline=TRUE),
        radioButtons("firstfruit","FirstFruit", choices=c('Apple','Appricot'), inline=TRUE),
        radioButtons("otherfruit","Fruits", choices=c('Other Fruit','More Fruit'), inline=TRUE)
  )
))
