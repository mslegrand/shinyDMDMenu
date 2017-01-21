
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinyMultilevelMenu)

shinyUI(fluidPage(
  multiLevelNavBarPage(
                       id='mytop',
                       menuItem("Appricot"),
                       menuItem("Bannana"),
                       menuItem("Cherry"),
                       subMenu(
                         "More Fruit",
                         id='fruit',
                         menuItem("oranges"),
                         menuItem("pears")
                       ),
                       subMenu(
                         "Great Men",
                         subMenu("China",
                            subMenu("Xian",
                              menuItem("First Emperor")
                            ),
                            subMenu("Hongkong",
                              menuItem("Bruce Lee")
                            )
                         ),
                         subMenu("UnitedStates",
                              subMenu("Califoria",
                                menuItem("Howard Hughes"),
                                menuItem("Grateful Dead"),
                                menuItem("Mickey Mouse")
                              ),
                              subMenu("Illinois",
                                menuItem("Abe Lincoln"),
                                menuItem("Al Capone"),
                                menuItem("Obama")
                              )
                         ),
                         subMenu(
                           "United Kingdom",
                           menuItem("Ireland"),
                           menuItem("Scotland"),
                           subMenu("England",
                                        menuItem("Shakespear"),
                                        menuItem("Sherlock Holmes"),
                                        menuItem("Dr. Who")
                           ),
                           menuItem("Wales")
                         )
                       )#,selectInput("sel","select",choices=letters)
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
