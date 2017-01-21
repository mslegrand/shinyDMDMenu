
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
                       lineItem("Appricot"),
                       lineItem("Bannana"),
                       lineItem("Cherry"),
                       dropDownList(
                         "More Fruit",
                         id='fruit',
                         lineItem("oranges"),
                         lineItem("pears")
                       ),
                       dropDownList(
                         "Great Men",
                         dropDownList("China",
                            dropDownList("Xian",
                              lineItem("First Emperor")
                            ),
                            dropDownList("Hongkong",
                              lineItem("Bruce Lee")
                            )
                         ),
                         dropDownList("UnitedStates",
                              dropDownList("Califoria",
                                lineItem("Howard Hughes"),
                                lineItem("Grateful Dead"),
                                lineItem("Mickey Mouse")
                              ),
                              dropDownList("Illinois",
                                lineItem("Abe Lincoln"),
                                lineItem("Al Capone"),
                                lineItem("Obama")
                              )
                         ),
                         dropDownList(
                           "United Kingdom",
                           lineItem("Ireland"),
                           lineItem("Scotland"),
                           dropDownList("England",
                                        lineItem("Shakespear"),
                                        lineItem("Sherlock Holmes"),
                                        lineItem("Dr. Who")
                           ),
                           lineItem("Wales")
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
