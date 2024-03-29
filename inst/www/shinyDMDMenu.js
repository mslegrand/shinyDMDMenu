
// read http://oddhypothesis.blogspot.com/2015/10/paging-widget-for-shiny-apps.html for usage example for  receiveMessage and initialize

(function(){ 
  
var dmdmBinding = new Shiny.InputBinding();
$.extend(dmdmBinding, {
  find: function(scope) {
    return $(scope).find("div.mm-menubar");
  },
  
  getValue: function(el) {
    var value ={item: $(el).attr("value"), indx: $(el).attr("indx")};
    return(value);
  },
  
  setValue: function(el, value) {
    $(el).attr("value",value);
  },
  
  subscribe: function(el, callback) {
    $(el).on('change.dmdmBinding', function(e) {
      callback(false);
    });
  },
  
  receiveMessage: function(el, data) {}, //to avoid exception
  
  unsubscribe: function(el) {
    $(el).off(".dmdmBinding");
  }, 
 
 //initialization 
 initialize: function initialize(el) {
  var $el = $(el);
  $el.attr("indx",0); 
  
  //trigger change at top-level on message from child dmdMenuItem
  $el.on("mssg", function(evt, param){
    $(this).attr("value", param);
    $(this).trigger("change");
    }
  );
    
  $el.find('.dmdm-dropdown-toggle').each( function(){
    $(this).on('click', function(e){
      var $parent = $(this).offsetParent(".dropdown-menu");
      $(this).parent("li").toggleClass('open');
      if(!$parent.parent().hasClass('nav')) {
        $(this).next().css(
          {
            "top": $(this)[0].offsetTop, 
            "left": $parent.outerWidth() - 4
            
          }
        );
      }
      $('.nav li.open').not($(this).parents("li")).removeClass("open");
      return false;
    });
  });
    
  $el.find(".dmdMenuItem").each( function(){
    $(this).on('click',function(evt){ 
      //console.log("click");
      //console.log($(this).attr("value"));
      $(this).trigger( "mssg", [$(this).attr("value")] ); 
      //just let it bubble
    });
  });
  //end of initializeMenu 
 },
 
 
  getRatePolicy: function(el){
    if (!el){
      console.log("Using an older version of Shiny, so unable to set the debounce rate policy.");
      return(null);
    }
    return ({policy: 'debounce', delay: $(el).data('debounce') || 1000 });
  }
});

Shiny.inputBindings.register(dmdmBinding);

})(); //close the object here



shinyDMDMenu=(function(){ // open object here

  var sheetX = (function() {
  	// Create the <style> tag
  	var style = document.createElement("style");
  	// WebKit hack :(
  	style.appendChild(document.createTextNode(""));
  	document.head.appendChild(style);
  	return style.sheet;
  })();

  var setStyleSheetAndRule= function( selector, index, rules ){
    var sheets = document.styleSheets;
    var sheet = sheets[index];
    
    if("insertRule" in sheetX) {
  		sheetX.insertRule(selector + "{" + rules + "}",0);
  	}
  	else if("addRule" in sheetX) {
  		sheetX.addRule(selector, rules, -1);
  	}
  };

  var getStyleRuleValue = function(style, selector, asheet) {
      var sheets = typeof asheet !== 'undefined' ? [asheet] : document.styleSheets;

      var rtv=null;
      for (var i = 0, l = sheets.length; i < l; i++) {
          var sheet = sheets[i];
          var rules = sheet.rules || sheet.cssRules;
          if( !rules){continue;}        
          for (var j = 0, k = rules.length; j < k; j++) {
              var rule = rules[j];
              if (rule.selectorText && rule.selectorText.split(', ').indexOf(selector) !== -1){
                  if(rule && rule.style && rule.style[style]){
                    rtv=rule.style[style];
                  } 
              }
          }
      }
      return rtv;
  };

  var reinitBootStrap = function(){
    var style="backgroundColor";
     var selector1 =".dropdown-menu > .active > a:focus";
     var selector2=".nav .open>a,.nav .open>a:hover,.nav .open>a:focus";
     var val = getStyleRuleValue("backgroundColor", selector1);
     if(val){
       var rule= "background-color" + ": " + val;
       setStyleSheetAndRule(selector2, 0, rule);
     }
  };

  var initializeSubMenu = function(pid, el){
    //.navbar is top level, a.dropdown-toggle are subsequent levels
    $(el).parent("li").find('.dmdm-dropdown-toggle').each( function(){
      $(this).on('click', function(e) {
        var $parent = $(this).offsetParent(".dropdown-menu");
        $(this).parent("li").toggleClass('open');
        if(!$parent.parent().hasClass('nav')) {
          $(this).next().css(
            {"top": $(this)[0].offsetTop, "left": $parent.outerWidth() - 4}
          );
        }
        $('.nav li.open').not($(this).parents("li")).removeClass("open");
        return false;
      });
    });
    //add trigger to send message from child dmdMenuItem
    $(el).parent().find(".dmdMenuItem").each( function(){
      $(this).on('click',function(evt){ 
        $(this).trigger( "mssg", [$(this).attr("value")] ); 
      });
    });
  };

  return{
    initSubMenu: initializeSubMenu,
    reinitBootStrap: reinitBootStrap
  };
})();

$(document).ready(function(){
  shinyDMDMenu.reinitBootStrap();
});

Shiny.addCustomMessageHandler('DMDMenu', function(data) {
  //console.log(JSON.stringify(data));
  var id = data.id; // the menubar id
  var type =data.type;
  var target = data.target; // values or id of the items/dropdown
  var cmd = data.cmd;  
  
  var $el = $('#' + id);
  
  var srchStr="";
  var nid=null;
  
// searchStr points to the node of the newly created submenu
  if(type==="id" && data.id!==target){
    srchStr="#" + target;
  }
  if(type=='dropdown'){ //applies to rename, disable/enable
    srchStr="a.dmdm-dropdown-toggle[value='" + target + "']"+
    ", span.dmdm-dropdown-toggle[value='" + target + "']";
  }
  if(type=='menuItem'){
    srchStr=".dmdMenuItem[value='" + target + "']";
  }
  
  if(type=='*'){
    srchStr=".dmdMenuItem[value='" + target + "']" +
    ", a.dmdm-dropdown-toggle[value='" + target + "']"+
    ", span.dmdm-dropdown-toggle[value='" + target + "']";
  }
  
  if(target=='_'){ //kludge to add to top navbar (ignore type)
    srchStr="ul.nav.navbar-nav";
    cmd="appendSubmenuToBar";
  }
  
  if (cmd=="reset"){
      var nindx = parseInt($el.attr("indx"));
      $el.attr('value',null);
      $el.attr('indx', nindx+1 ) ;
  }
  
  if(cmd=="disable"){ //type is irrelavant
    $el.find(srchStr).each(function(){
      if($(this).hasClass("dmdMenuItem")){
        if(!$(this).hasClass("disabled")){
          $(this).prop("disabled", true);
          $(this).addClass("disabled");
          $(this).off("click");          
        }
      } else {
        if( ! $(this).parent("li").hasClass("disabled") ){
          $(this).off('click');
          $(this).prop("disabled", true);
          $(this).parent("li").addClass("disabled");
        }        
      }
    });
  }
    
  if(cmd=="enable"){
    $el.find(srchStr).each(function(){
      if($(this).hasClass("dmdMenuItem")){
        if( $(this).hasClass("disabled") ){
          //console.log( "enabling");
          $(this).prop("disabled", false);
          $(this).removeClass("disabled");
          $(this).on('click',function(evt){ 
            $(this).trigger( "mssg", [$(this).attr("value")] ); //just let it bubble 
          });
        }
      } else {
        if( $(this).parent("li").hasClass("disabled") ){
          $(this).prop("disabled", false);
          $(this).parent("li").removeClass("disabled");
          $(this).on('click',function(evt) {
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
    });
  }
  
  if(cmd=="rename" ){
    if(data.param) {
      if(data.param.newLabel){
        $el.find(srchStr).text(data.param.newLabel);
      }
      if(data.param.newValue){
        $el.find(srchStr).attr("value", data.param.newValue);
      }
    }
  }

  if(cmd=="delete" ){
    $el.find(srchStr).parent().empty();
  }

  if(cmd=="after" ){
    if(data.param) {
      nid = '#' + data.param.nid;
      $el.find(srchStr).parent().after( $("" + data.param.submenu));
      shinyDMDMenu.initSubMenu(id, nid);
    }
  }
  
   if(cmd=="before"){
    if(data.param) {
      nid = '#' + data.param.nid;
      $el.find(srchStr).parent().before( $("" + data.param.submenu));
      shinyDMDMenu.initSubMenu(id, nid);
    }
  }
  

  if(cmd=="appendSubmenuToBar"){
    if(data.param) {
      nid = '#' + data.param.nid;
      $el.find(srchStr).append( $("" + data.param.submenu));
      shinyDMDMenu.initSubMenu(id, nid);
    }
  }
  
  if(cmd=="appendSubmenu" ){
    if(data.param) {
      nid = '#' + data.param.nid;
      $el.find(srchStr).each( function(){
        $(this).next("ul.dropdown-menu").append( $("" + data.param.submenu));
      });
      shinyDMDMenu.initSubMenu(id, nid);
    }
  }
  
}); //End Messagehadler


