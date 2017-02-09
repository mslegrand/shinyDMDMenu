
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
menuBarId<-"mytop"

shinyServer(function(input, output, session) { 
  output$menuChoice<-renderText({
    paste("mytop choice:",  as.character(input$mytop ) )
  })
  
  observeEvent( input$bannanaDisable,{
      cmd<-input$bannanaDisable
      if(cmd=="disable"){
        disableDMDM(session, menuBarId=menuBarId, entry="Bannana")
      } else {
        enableDMDM(session, menuBarId=menuBarId, entry="Bannana")
      }
        
  }) 
  observeEvent( input$shakespearDisable,{
    cmd<-input$shakespearDisable
    if(cmd=="disable"){
      disableDMDM(session, menuBarId=menuBarId, entry="Shakespear")
    } else {
      enableDMDM(session, menuBarId=menuBarId, entry="Shakespear")
    }
  }) 
  
  observeEvent( input$usDisable,{ 
    cmd<-input$usDisable
    if(cmd=="disable"){
      disableDMDM(session, menuBarId=menuBarId, entry="UnitedStates")
    } else {
      enableDMDM(session, menuBarId=menuBarId, entry="UnitedStates")
    }
  }) 
  
  observeEvent( input$firstfruit,{ 
    choices=c('Apple','Appricot')
    tmp<-input$firstfruit
    targetItem<-choices[-which(choices==tmp)]
    renameDMDM(session, menuBarId=menuBarId, entry=targetItem,  newLabel=tmp) 
  })  
  
  observeEvent( input$otherfruit,{ 
    choices=c('Other Fruit','More Fruit')
    tmp<-input$otherfruit
    targetItem<-choices[-which(choices==tmp)]
    renameDMDM(session, menuBarId=menuBarId,  entry=targetItem,  newLabel=tmp) 
  })  
}) 
