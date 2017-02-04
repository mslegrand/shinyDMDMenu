
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
#source("multiLevelNavbar.R")
library(shiny)

menuBarId<-'addDelDemo'
shinyServer(function(input, output, session) { 
  
  customMenu<-reactiveValues( 
    childParent=data.frame(
      child=c('menu 1-1','menu 1-2', 'menu 2', 'Dropdown 2', 'menu 2-1','menu 2-2', 'menu 2-3'),
      parent=c('Dropdown 1','Dropdown 1', '_', 'Dropdown 1', 'Dropdown 2', 'Dropdown 2', 'Dropdown 2'), 
      stringsAsFactors=FALSE
    ),
    disabled=c()
  )
                
  addChildParent<-function(ch,pa){
    customMenu$childParent<-rbind(customMenu$childParent, c(ch,pa) )
  }
  
  isOk<-function(x){
    allEntries<-c(items(), dropdowns())
    nchar(x)>0 && length(allEntries)>0 && !( x %in%  allEntries ) 
  }
  
    
  getParent<-function(child){
    customMenu$childParent[child==customMenu$childParent$child,]$parent
  }
    
  dropdowns<-reactive({
    dd<-customMenu$childParent$parent 
    dd<-unique(c(dd,'_'))
  })
  
  items<-reactive({
    setdiff(customMenu$childParent$child, customMenu$childParent$parent) 
  })
  
  observeEvent( customMenu$childParent, {
    choices<-dropdowns()
    updateSelectInput(session,"droppdownTarget", choices= sort(choices, decreasing=TRUE) )
    choices=sort( c(items(), choices ), decreasing=TRUE) 
    updateSelectInput(session,"renameTarget", choices=choices)
    updateSelectInput(session,"beforeTarget", choices=choices )
    updateSelectInput(session,"afterTarget", choices=choices )
    updateSelectInput(session,"deleteTarget", choices=setdiff(choices,"_") )
    updateTextInput(session, "level1", value = "")
    updateTextInput(session, "level2", value = "")
    customMenu$disabled<-intersect(customMenu$disabled, choices)
  })
  
  observeEvent( c(customMenu$childParent,customMenu$disabled), {
    disabled<-customMenu$disabled
    updateSelectInput(session,"enableTarget", choices=disabled )
    df<-customMenu$childParent
    df<-removeEntries(disabled, df)
    enabled<-sort(setdiff(unique(c(df$child,df$parent)),"_"), decreasing = TRUE);
    updateSelectInput(session,"disableTarget", choices=enabled )
  })
  
  observeEvent(input$disableEvent,{
    entry<-input$disableTarget
    if(entry!=""){
      if(entry %in% dropdowns() ){
        disableMenuDropdown(session, menuBarId, entry)
      } else {
        disableMenuItem(session, menuBarId, entry)
      }
      customMenu$disabled<-c(customMenu$disabled, entry)
    }
  })
  
  observeEvent(input$enableEvent,{
    entry<-input$enableTarget
    if(entry!=""){
      if(entry %in% dropdowns() ){
        enableMenuDropdown(session, menuBarId, entry)
      } else {
        enableMenuItem(session, menuBarId, entry)
      }
      customMenu$disabled<-setdiff(customMenu$disabled, entry)
    }
  })
  
  output$menuChoice<-renderText({
    tmp<-input[[menuBarId]] #input$addDelDemo
    if(!is.null(tmp$item))
      paste("", tmp$item )
    else
      ""
  })
  
  observeEvent( input[[menuBarId]],{
    tmp<-input[[menuBarId]]
    if(!is.null(tmp$item))
      session$sendCustomMessage(type = 'showClick',
        message = paste0("",tmp[1]," was clicked")
    )
    dirtyMenu(session, menuBarId)
  })
  
  observeEvent(input$appendToEvent,{
    dropdown<-trimws(input$droppdownTarget)
    label<-trimws(input$level1)
    if(nchar(dropdown)>0 && nchar(label)>0 && isOk(label)){
      kids<-input$level2
      hasKids<-FALSE
      if(nchar(kids)>0){
        kids<-trimws(strsplit(kids,"\n")[[1]])
        #next check that kids are valid
        tfs<-sapply(kids, isOk)
        kids<-kids[tfs]
        if(length(kids)>0){
          hasKids<-TRUE
        }
      }
      if(hasKids){
        lapply(kids, function(k)addChildParent(k,label))
        appendToDropdown(
          session, 
          menuBarId= menuBarId,  
          dropdown=dropdown, 
          submenu=
            do.call(
              function(...){ menuDropdown(label,...) },
              lapply(kids, menuItem)
            )
        )
      } else {
        appendToDropdown(
          session, 
          menuBarId= menuBarId,  
          dropdown=dropdown, 
          submenu=menuItem(label)
        )
      }
      addChildParent(label,dropdown)
    }
  })
  
  updateBeforeAfter<-function(entry, direction='before'){
    label<-trimws(input$level1)
    if(nchar(entry)>0 && nchar(label)>0 && isOk(label)){
      parent<-getParent(entry) # used to update childParent data.frame
      
      if(direction=='before'){
        if(entry %in% dropdowns() ){
          insertFn<-insertBeforeDropdown
        } else {
          insertFn<-insertBeforeMenuItem
        }
      } else {
        if(entry %in% dropdowns() ){
          insertFn<-insertAfterDropdown
        } else {
          insertFn<-insertAfterMenuItem
        }
      }
      
      
      kids<-input$level2
      hasKids<-FALSE
      if(nchar(kids)>0){
        kids<-trimws(strsplit(kids,"\n")[[1]])
        #next check that kids are valid
        tfs<-sapply(kids, isOk)
        kids<-kids[tfs]
        if(length(kids)>0){
          hasKids<-TRUE
        }
      }
      if(hasKids){
        lapply(kids, function(k)addChildParent(k,label))
        insertFn(
          session, 
          menuBarId= menuBarId,  
          entry=entry, 
          submenu=
            do.call(
              function(...){ menuDropdown(label,...) },
              lapply(kids, menuItem)
            )
        )
      } else {
        insertFn(
          session, 
          menuBarId= menuBarId,  
          entry=entry, 
          submenu=menuItem(label)
        )
      }
      addChildParent(label,parent)
    }
    
  }
  
  observeEvent(input$beforeEvent,{
      entry<-trimws(input$beforeTarget)
      updateBeforeAfter(entry,'before')
  })
  
  observeEvent(input$afterEvent,{
    entry<-trimws(input$afterTarget)
    updateBeforeAfter(entry, 'after')
  })
  
  removeEntries<-function(x, df){
    
    df<-df[!(df$child %in% x),]
    x<-df[df$parent %in% x,]$child
    if(length(x)>0){
      df<-removeEntries(x,df)
    }
    df   
  }
  
  observeEvent(input$deleteEvent,{
    entry<-input$deleteTarget
    if(nchar(entry)>0){
      if(entry %in% dropdowns() ){
        removeMenuDropdown( session, menuBarId, entry)
      } else {
        removeMenuItem( session, menuBarId, entry)
      }
      df<-customMenu$childParent
      df<-removeEntries(entry, df)
      customMenu$childParent<-df
    }
  })
  
  observeEvent(input$renameToEvent,{
    target<-trimws(input$renameTarget)
    renameTo<-trimws(input$renameTo)
    if(nchar(target)>0 && nchar(renameTo)>0 && isOk(renameTo)){
      if(target %in% customMenu$childParent$parent){
        renameMenuDropdown(session, menuBarId, target, renameTo)
      } else {
        renameMenuItem(session, menuBarId, target, renameTo)
      }
      disabled<-customMenu$disabled
      df<-customMenu$childParent
      disabled<-gsub(target,renameTo, disabled)
      df$child<-gsub(target,renameTo, df$child)
      df$parent<-gsub(target,renameTo, df$parent)
      customMenu$childParent<-df
      customMenu$disabled<-disabled
      updateTextInput(session, "renameTo", value="")
    }
  })
}) 
