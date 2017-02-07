
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
#source("multiLevelNavbar.R")
library(shiny)


shinyServer(function(input, output, session) { 
  
  customMenu<-reactiveValues( 
    childParent=data.frame(
      child=c('menu 1-1','menu 1-2', 'menu 2', 'Dropdown 2', 'menu 2-1','menu 2-2', 'menu 2-3'),
      parent=c('Dropdown 1','Dropdown 1', '_', 'Dropdown 1', 'Dropdown 2', 'Dropdown 2', 'Dropdown 2'),
      stringsAsFactors=FALSE
    ),
    titleId=data.frame(
      title=c('_',        'Dropdown 1',  'Dropdown 2',  'menu 1-1',    'menu 1-2',     'menu 2',     'menu 2-1',    'menu 2-2',    'menu 2-3'),
      id=c('demoDMDM001', 'demoDMDM002', 'demoDMDM003', 'demoDMDM004', 'demoDMDM005', 'demoDMDM006', 'demoDMDM007', 'demoDMDM008', 'demoDMDM009'),
      stringsAsFactors=FALSE
    ), 
    disabled=c()
  )
                
  addChildParent<-function(ch,pa){
    customMenu$childParent<-rbind(customMenu$childParent, c(ch,pa) )
  }
  
  addNewEntry<-function(entry){
    id<-newId()
    customMenu$titleId <- rbind(customMenu$titleId, c(entry, id))
  }
  
  
  isOk<-function(x){
    allEntries<-c(items(), dropdowns())
    nchar(x)>0 && length(allEntries)>0 && !( x %in%  allEntries ) 
  }
  
    
  getParent<-function(child){
    customMenu$childParent[child==customMenu$childParent$child,]$parent
  }
  
  getId<-function(entry){
    if(entry=="_"){
      "_"
    } else {
      customMenu$titleId[entry==customMenu$titleId$title,]$id
    }
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
      entryId=getId(entry)
      disableDMDM(session, menuBarId, entry=entryId, type="id")
      customMenu$disabled<-c(customMenu$disabled, entry)
    }
  })
  
  observeEvent(input$enableEvent,{
    entry<-input$enableTarget
    if(entry!=""){
      entryId=getId(entry)
      enableDMDM(session, menuBarId, entryId, type="id")
      customMenu$disabled<-setdiff(customMenu$disabled, entry)
    }
  })
  
  output$menuChoice<-renderText({
    tmp<-input[[menuBarId]] 
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
    dirtyDMDM(session, menuBarId)
  })
  
  observeEvent(input$appendToEvent,{
    dropdown<-trimws(input$droppdownTarget)
    label<-trimws(input$level1)
    if(nchar(dropdown)>0 && nchar(label)>0 && isOk(label)){
      addNewEntry(label)
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
      labelId<-getId(label)
      dropdownId<-getId(dropdown)
      if(hasKids){
        lapply(kids, function(k){
          addChildParent(k,label)
          addNewEntry(k)
        })
        appendDMDM(
          session, 
          menuBarId= menuBarId,  
          entry=dropdownId, 
          type="id",
          submenu=
            do.call(
              function(...){ menuDropdown(label,..., id=labelId) },
              lapply(kids, function(k){
                  menuItem(k,id=getId(k))
                })
            )
        )
      } else {
        appendDMDM(
          session, 
          menuBarId= menuBarId,  
          entry=dropdownId, 
          type="id",
          submenu=menuItem(label, id=labelId)
        )
      }
      addChildParent(label,dropdown)
    }
  })
  
  updateBeforeAfter<-function(entry, direction='before'){
    label<-trimws(input$level1)
    if(nchar(entry)>0 && nchar(label)>0 && isOk(label)){
      parent<-getParent(entry) # used to update childParent data.frame
      entryId<-getId(entry)
      insertFn<-if(direction=='before'){ 
        insertBeforeDMDM 
      }else{
        insertAfterDMDM
      }
      type<-ifelse( (entry %in% dropdowns() ), "dropdown", "menuItem")
      #add id for parent
      
      addNewEntry(label)
      labelId<-getId(label)
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
        lapply(kids, function(k){
          addChildParent(k,label)
          addNewEntry(k)
        })
        insertFn(
          session, 
          menuBarId= menuBarId,  
          entry=entryId,
          type="id",
          submenu=
            do.call(
              function(...){ menuDropdown(label,id=labelId, ...) },
              lapply(kids, function(k){
                menuItem(k, id=getId(k))
              })
            )
        )
      } else {
        insertFn(
          session, 
          menuBarId= menuBarId,  
          entry=entryId, 
          type="id",
          submenu=menuItem(label, id=labelId)
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
      entryId<-getId(entry)
      removeDMDM(session, menuBarId, entry=entryId, type="id")
      df<-customMenu$childParent
      df<-removeEntries(entry, df)
      ti<-customMenu$titleId
      customMenu$titleId<-ti[ti$title %in% c(df$parent,df$child),]
      customMenu$childParent<-df
    }
  })
  
  observeEvent(input$renameToEvent,{
    target<-trimws(input$renameTarget)
    renameTo<-trimws(input$renameTo)
    if(nchar(target)>0 && nchar(renameTo)>0 && isOk(renameTo)){
      targetId<-getId(target)
      renameDMDM(session, menuBarId, targetId, newLabel=renameTo, type="id")
      disabled<-customMenu$disabled
      df<-customMenu$childParent
      
      disabled<-gsub(target,renameTo, disabled)
      df$child<-gsub(target,renameTo, df$child)
      df$parent<-gsub(target,renameTo, df$parent)
      customMenu$childParent<-df
      customMenu$disabled<-disabled
      dff<-customMenu$titleId
      dff$title<-gsub(target,renameTo, dff$title)
      customMenu$titleId<-dff$titleId
      updateTextInput(session, "renameTo", value="")
    }
  })
}) 
