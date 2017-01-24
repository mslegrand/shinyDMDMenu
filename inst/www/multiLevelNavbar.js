
(function(){ // open object here


var initializeMenu = function(){
  var pid;

  //.navbar is top level, a.dropdown-toggle are subsequent levels
  $('.mm-menubar a.mm-dropdown-toggle').on('click', function(e) {
        var $el2 = $(this);
        var $parent = $(this).offsetParent(".dropdown-menu");
        $(this).parent("li").toggleClass('open');
        if(!$parent.parent().hasClass('nav')) {
          $el2.next().css({"top": $el2[0].offsetTop, "left": $parent.outerWidth() - 4});
        }
        $('.nav li.open').not($(this).parents("li")).removeClass("open");
        return false;
  });
  $(".mm-menubar").each(function(){ 
    pid=$(this).attr("id"); 
    //trigger change on message from child menuActionItem
    $(this).on("mssg", function(evt, param){
      $(this).attr("value", param);
      $(this).trigger("change");
    });
    //add trigger to send message from child menuActionItem
    $(this).find(".menuActionItem").each( function(){
       $(this).attr("aid",pid);
        $(this).on('click',function(evt){ 
          $("#" + $(this).attr("aid")).trigger( "mssg", [$(this).attr("value")] ); 
        });
    });
  });
};

$(document).ready(function(){
  initializeMenu("mytop");
});
    
var mmbarBinding = new Shiny.InputBinding();
$.extend(mmbarBinding, {
  find: function(scope) {
    //console.log("find: " +  JSON.stringify($(scope).find("div.mm-menubar")));
    return $(scope).find("div.mm-menubar");
  },
  
  getValue: function(el) {
    var value = $(el).attr("value");
    return(value);
  },
  setValue: function(el, value) {
    //Not sure if setting the value makes sense
  },
  
  subscribe: function(el, callback) {
    $(el).on('change.mmbarBinding', function(e) {
      callback(false);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".mmbarBinding");
  }, 
  getRatePolicy: function(el){
    if (!el){
      console.log("Using an older version of Shiny, so unable to set the debounce rate policy.");
      return(null);
    }
    return ({policy: 'debounce', delay: $(el).data('debounce') || 1000 });
  }
  
});

Shiny.inputBindings.register(mmbarBinding);

})(); //close the object here


Shiny.addCustomMessageHandler('multiLevelMenuBar', function(data) {
  var id = data.id;
  var $el = $('#' + id);
  
  var type =data.type;
  var targetItem = data.targetItem; // values of the items
  var cmd = data.cmd;  //cmd: disable, enable, remove, addto, rename (label, value)
  var srchStr="";
  
  if(type=='dropDown'){
    scrhStr="a.dropdown-toggle[value='" + targetItem + "']";
  }
  if(type=='actionItem'){
    scrhStr=".menuActionItem[value='" + targetItem + "']";
  }
  
  if(cmd=="disable" && type=='actionItem'){
    if( ! $el.find(scrhStr).hasClass("disabled") ){
      //console.log( "disabling");
      $el.find(scrhStr).prop("disabled", true);
      $el.find(scrhStr).addClass("disabled");
      $el.find(scrhStr).off("click");
    }
  }
  
  if(cmd=="enable" && type=='actionItem'){
    if( $el.find(scrhStr).hasClass("disabled") ){
      //console.log( "enabling");
      $el.find(scrhStr).prop("disabled", false);
      $el.find(scrhStr).removeClass("disabled");
      $el.find(scrhStr).on('click',function(evt){ 
            $("#" + $(this).attr("aid")).trigger( "mssg", [$(this).attr("value")] ); 
      });
    }
  }
  
  if(cmd=="disable" && type=='dropDown'){
    if( ! $el.find(scrhStr).parent("li").hasClass("disabled") ){
      $el.find(scrhStr).off('click');
      $el.find(scrhStr).prop("disabled", true);
      $el.find(scrhStr).parent("li").addClass("disabled");
      
    }
  }
  
  if(cmd=="enable" && type=='dropDown'){
    if( $el.find(scrhStr).parent("li").hasClass("disabled") ){
      
      $el.find(scrhStr).prop("disabled", false);
      $el.find(scrhStr).parent("li").removeClass("disabled");
      $el.find(scrhStr).on('click',function(evt) {
          var $el = $(this);
          var $parent = $(this).offsetParent(".dropdown-menu");
          $(this).parent("li").toggleClass('open');
          if(!$parent.parent().hasClass('nav')) {
            $el.next().css({"top": $el[0].offsetTop, "left": $parent.outerWidth() - 4});
          }
          $('.nav li.open').not($(this).parents("li")).removeClass("open");
          return false;
      });
    }
  }
  
  
  if(cmd=="rename" && type=='actionItem'){
    if(data.param && data.param.length>1) {
      //console.log(data.param[0]);
      $el.find(scrhStr).text(data.param[0]);
      $el.find(scrhStr).attr("value", data.param[1]);
    }
  }
  
  if(cmd=="rename" && type=='dropDown'){
    if(data.param){
      $el.find(scrhStr).text(data.param[0]);
      $el.find(scrhStr).attr("value", data.param[1]);
    }
  }
  
}); //End Messagehadler


