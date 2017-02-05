
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output, session) { 
  output$menuChoice<-renderText({
    paste("mytop choice:",  as.character(input$mytop ) )
  })
  
  observeEvent( input$bannanaDisable,{
      menuBarId<-"mytop"
      cmd<-input$bannanaDisable
      targetItem<-"Bannana"
      type<-"menuItem"
      updateDMDMenu(session, menuBarId, cmd, targetItem, type)
  }) 
  observeEvent( input$shakespearDisable,{
    menuBarId<-"mytop"
    cmd<-input$shakespearDisable
    targetItem<-"Shakespear"
    type<-"menuItem"
    updateDMDMenu(session, menuBarId, cmd, targetItem, type)
  }) 
  observeEvent( input$usDisable,{ 
    menuBarId<-"mytop"
    cmd<-input$usDisable
    targetItem<-"UnitedStates"
    type<-"dropDown"
    updateDMDMenu(session, menuBarId, cmd, targetItem, type)
  }) 
  
  observeEvent( input$firstfruit,{ 
    choices=c('Apple','Appricot')
    menuBarId<-"mytop"
    cmd<-"rename"
    tmp<-input$firstfruit
    targetItem<-choices[-which(choices==tmp)]
    type<-"menuItem"
    params<-c(tmp,tmp)
    updateDMDMenu(session, menuBarId, cmd, targetItem, type, param=params) 
  })  
  
  observeEvent( input$otherfruit,{ 
    choices=c('Other Fruit','More Fruit')
    menuBarId<-"mytop"
    cmd<-"rename"
    tmp<-input$otherfruit
    targetItem<-choices[-which(choices==tmp)]
    type<-"dropDown"
    params<-c(tmp,tmp)
    updateDMDMenu(session, menuBarId, cmd, targetItem, type, param=params) 
  })  
}) 
