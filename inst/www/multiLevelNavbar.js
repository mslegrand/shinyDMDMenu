
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
   //getStyleRuleValue("backgroundColor", ".nav");
};


//pid is the menu id
// searchStr points to the node of the newly created submenu
var initializeSubMenu = function(pid, searchStr){
  //.navbar is top level, a.dropdown-toggle are subsequent levels
  $(searchStr).find('a.mm-dropdown-toggle').each( function(){
    $(this).on('click', function(e) {
        var $el2 = $(this);
        var $parent = $(this).offsetParent(".dropdown-menu");
        $(this).parent("li").toggleClass('open');
        if(!$parent.parent().hasClass('nav')) {
          $el2.next().css({"top": $el2[0].offsetTop, "left": $parent.outerWidth() - 4});
        }
        $('.nav li.open').not($(this).parents("li")).removeClass("open");
        return false;
    });
  });
  //add trigger to send message from child menuActionItem
  $(searchStr).find.find(".menuActionItem").each( function(){
     $(this).attr("aid",pid);
      $(this).on('click',function(evt){ 
        $("#" + $(this).attr("aid")).trigger( "mssg", [$(this).attr("value")] ); 
      });
  });
};


$(document).ready(function(){
  initializeMenu();
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

MultiLevelMenu=(function(){ // open object here
console.log(document.styleSheets.length);

var sheetX = (function() {
	// Create the <style> tag
	var style = document.createElement("style");
	// WebKit hack :(
	style.appendChild(document.createTextNode(""));
	document.head.appendChild(style);
	return style.sheet;
})();

console.log(document.styleSheets.length);

var rgb2hex=function(rgb){
 rgb = rgb.match(/^rgb((d+),s*(d+),s*(d+))$/);
 return "#" +
  ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
  ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
  ("0" + parseInt(rgb[3],10).toString(16)).slice(-2);
};

var getStyleSheetAndRule = function(style, selector, asheet) {
  var sheets =  document.styleSheets;
  var rtv=null;
  for (var i = 0, l = sheets.length; i < l; i++) {
        var sheet = sheets[i];
        var rules = sheet.rules || sheet.cssRules;
        if( !rules){continue;}  
        for (var j = 0, k = rules.length; j < k; j++) {
          var rule = rules[j];
          if( rule.selectorText && rule.selectorText.split(', ').indexOf(selector) !== -1 && rule.style[style]){
            rtv={ 
              index: i, 
              value: rule.style[style] 
            };
          }
        }
    }
  return rtv;
};
 
 //selector = ".nav .open > .a, .nav .ope > a:hover, .nav .open > a:focus"          
var setStyleSheetAndRule= function( selector, index, rules ){
  var sheets = document.styleSheets;
  var sheet = sheets[index];
  
  if("insertRule" in sheetX) {
    console.log("insertRule");
    console.log( selector + "{" + rules + "}" );
		sheetX.insertRule(selector + "{" + rules + "}",0);
	}
	else if("addRule" in sheetX) {
	  console("addRule");
		sheetX.addRule(selector, rules, -1);
	}
};

var getStyleRuleValue = function(style, selector, asheet) {
    var sheets = typeof asheet !== 'undefined' ? [asheet] : document.styleSheets;
    console.log("sheets.length=" + sheets.length);
    //var total=0;
    var rtv=null;
    for (var i = 0, l = sheets.length; i < l; i++) {
        var sheet = sheets[i];
        var rules = sheet.rules || sheet.cssRules;
        //if( !sheet.cssRules ) { continue; }
        if( !rules){continue;}        
        //console.log("sheets number =" + i +" ruleCount=" + sheet.cssRules.length);
        //console.log("rules.length=" +  rules.length);
        for (var j = 0, k = rules.length; j < k; j++) {
            var rule = rules[j];
            
            //if (rule.selectorText ){
              //console.log(JSON.stringify(rule));
                //console.log("Rule= \n" + JSON.stringify(rule));
            if (rule.selectorText && rule.selectorText.split(', ').indexOf(selector) !== -1){
            //if (j>-1){
                //console.log(selector);
                //console.log(rule.selectorText);
                //console.log(rule.style.length);
                //console.log(Object.getOwnPropertyNames(rule).sort()); 
                //console.log(JSON.stringify(rule.style));
                //console.log(rule.style[style]);
                //var sheets = typeof asheet !== 'undefined' ? [asheet] : document.styleSheets;
                if(rule && rule.style && rule.style[style]){
                  rtv=rule.style[style];
                } // else {
                  //rtv="";
                //}
                
                //if(rtv && rtv!==""){
                //rtv=rule.style[style];
                //console.log("sheetNo: " + i);
                //console.log("selector: " + rule.selectorText);
                //console.log("style:" + style);
                //console.log("rule.style");
                //console.log(JSON.stringify(rule.style));
                 // console.log("attr: " + rtv);
                //}
              //}
            }
        }
    }
    return rtv;
};

var reinitBootStrap = function(){
  var style="backgroundColor";
   var selector1 =".dropdown-menu > .active > a:focus";
   //var selector2 =".dropdown-menu >  a:focus";
   //var selector2=".nav > .open > a, .nav > .open > a:hover, .nav > .open > a:focus";
   var selector2=".nav .open>a,.nav .open>a:hover,.nav .open>a:focus";
   
   //var selector2=".dropdown-menu>li>a:hover, .dropdown-menu>li>a:hover, .dropdown-list.open>li>a";
   //var selector2="a.dropdown-menu>li>a:hover, .dropdown-menu>li>a:hover, .dropdown-list.open>li>a";
   //var selector1 =".dropdown-menu > .active > a:focus";
   //var selector2="li.drop-down-list.open";
   //var selector2="a.mm-dropdown-toggle.dropdown-toggle"; //highlight whole menu
   // var selector2="a.mm-dropdown-toggle.dropdown-toggle:active"; //highlight whole menu
   //var value=getStyleRuleValue("backgroundColor", ".dropdown-menu > .active > a:focus");
   //console.log(value);
   
   
   //var val = getStyleSheetAndRule("backgroundColor", selector1);
   var val = getStyleRuleValue("backgroundColor", selector1);
   if(val){
     var rule= "background-color" + ": " + val;
     setStyleSheetAndRule(selector2, 0, rule);
     //console.log(rule);
     
     //setStyleSheetAndRule(selector2, rule.index, rules);
   }
   
   //var rules= "background-color" + ": " + " #FF0088;";
   //console.log(rules);
   //setStyleSheetAndRule(selector2, 0, rules);
   //console.log("rules set");
   
   //var sheets = document.styleSheets;
   //getStyleRuleValue( 'backgroundColor', selector2, sheetX);
   
   //getStyleRuleValue( 'backgroundColor', selector2);
   //getStyleRuleValue("backgroundColor", ".nav .open > a:hover");
   //getStyleRuleValue("backgroundColor", ".nav .open > a:focus");
};



  var initializeSubMenu = function(pid, searchStr){
    //.navbar is top level, a.dropdown-toggle are subsequent levels
    $(searchStr).find('a.mm-dropdown-toggle').each( function(){
      $(this).on('click', function(e) {
          var $el2 = $(this);
          var $parent = $(this).offsetParent(".dropdown-menu");
          $(this).parent("li").toggleClass('open');
          if(!$parent.parent().hasClass('nav')) {
            $el2.next().css({"top": $el2[0].offsetTop, "left": $parent.outerWidth() - 4});
          }
          $('.nav li.open').not($(this).parents("li")).removeClass("open");
          return false;
      });
    });
    //add trigger to send message from child menuActionItem
    $(searchStr).find(".menuActionItem").each( function(){
       $(this).attr("aid",pid);
        $(this).on('click',function(evt){ 
          $("#" + $(this).attr("aid")).trigger( "mssg", [$(this).attr("value")] ); 
        });
    });
  };
  
return{
  initSubMenu: initializeSubMenu,
  reinitBootStrap: reinitBootStrap
};

})();

MultiLevelMenu.reinitBootStrap();

Shiny.addCustomMessageHandler('multiLevelMenuBar', function(data) {
  var id = data.id;
  var $el = $('#' + id);
  
  var type =data.type;
  var targetItem = data.targetItem; // values of the items
  var cmd = data.cmd;  //cmd: disable, enable, remove, addto, rename (label, value)
  var srchStr="";
  
  console.log(JSON.stringify(data));
  //pid is the menu id
// searchStr points to the node of the newly created submenu

  if(type=='dropDown'){
    srchStr="a.dropdown-toggle[value='" + targetItem + "']";
  }
  if(type=='actionItem'){
    srchStr=".menuActionItem[value='" + targetItem + "']";
  }
  if(type=='dropDownList'){
    srchStr="li.drop-down-list[value='"+targetItem+"']"+">.dropdown-menu";
  }
  
  if(cmd=="disable" && type=='actionItem'){
    if( ! $el.find(srchStr).hasClass("disabled") ){
      //console.log( "disabling");
      $el.find(srchStr).prop("disabled", true);
      $el.find(srchStr).addClass("disabled");
      $el.find(srchStr).off("click");
    }
  }
  
  if(cmd=="enable" && type=='actionItem'){
    if( $el.find(srchStr).hasClass("disabled") ){
      //console.log( "enabling");
      $el.find(srchStr).prop("disabled", false);
      $el.find(srchStr).removeClass("disabled");
      $el.find(srchStr).on('click',function(evt){ 
            $("#" + $(this).attr("aid")).trigger( "mssg", [$(this).attr("value")] ); 
      });
    }
  }
  
  if(cmd=="disable" && type=='dropDown'){
    if( ! $el.find(srchStr).parent("li").hasClass("disabled") ){
      $el.find(srchStr).off('click');
      $el.find(srchStr).prop("disabled", true);
      $el.find(srchStr).parent("li").addClass("disabled");
      
    }
  }
  
  if(cmd=="enable" && type=='dropDown'){
    if( $el.find(srchStr).parent("li").hasClass("disabled") ){
      
      $el.find(srchStr).prop("disabled", false);
      $el.find(srchStr).parent("li").removeClass("disabled");
      $el.find(srchStr).on('click',function(evt) {
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
      $el.find(srchStr).text(data.param[0]);
      $el.find(srchStr).attr("value", data.param[1]);
    }
  }
  
  if(cmd=="rename" && type=='dropDown'){
    if(data.param){
      $el.find(srchStr).text(data.param[0]);
      $el.find(srchStr).attr("value", data.param[1]);
    }
  }
  
  //console.log('cmd='+ cmd +"; type=" + type);
  if(cmd=="add" && type=='dropDownList'){
    if(data.param) {
      var label=data.param.label, 
      gid=data.param.gid, 
      key=data.param.value;
      
      var $newEle=$("<li><a href='#' value='" + key +"' aid='"
        + id +"' id='"+ gid +"' class='menuActionItem' " +
        ">" + label+"</a></li>");
      $el.find(srchStr).append($newEle);
      $el.find(".menuActionItem[value='" + key + "']").each( function(){
        $(this).on('click',function(evt){ 
          $("#" + $(this).attr("aid")).trigger( "mssg", [$(this).attr("value")]); 
        });
      });
    }
  }
  
  if(cmd=="delete" && type=='actionItem'){
    //console.log(srchStr);
    //console.log($el.find(srchStr).parent());
      $el.find(srchStr).parent().empty();

  }
  
  //need to add submenu
  if(cmd=="addSubmenu" && type=='dropDownList'){
    if(data.param) {
      var nid = '#' + data.param.nid;
      //console.log(nid);
      //console.log(data.param.submenu)
      $el.find(srchStr).append( $("" + data.param.submenu));
      //now need to fix submenu to be used
      // what is the search path for $newEle?, what is the id of
      MultiLevelMenu.initSubMenu(id, nid);
    }
  }
}); //End Messagehadler


