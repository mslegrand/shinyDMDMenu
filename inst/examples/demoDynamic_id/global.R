
menuBarId<-'DMDMainMenuID'

newId<-(function(prefix="demoDMDM"){ 
  idNum<-100
  function(){
    idNum<<-idNum+1
    paste0(prefix,idNum)
  }
})()

