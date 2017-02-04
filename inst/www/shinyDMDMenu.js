
(function(){ // begin object here


var initializeMenu = function(){
  var pid;
  //.navbar is top level, a.dropdown-toggle are subsequent levels
  $('.mm-menubar a.dmdm-dropdown-toggle').on('click', function(e) {
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
    $(this).attr("indx",0);
    //trigger change on message from child dmdMenuItem
    $(this).on("mssg", function(evt, param){
      //console.log("initializeMenu .mm-menubar mssg: " + param);
      
      $(this).attr("value", param);
      $(this).trigger("change");
    });
    //add trigger to send message from child dmdMenuItem
    $(this).find(".dmdMenuItem").each( function(){
       $(this).attr("aid",pid);
        $(this).on('click',function(evt){ 
          $("#" + $(this).attr("aid")).trigger( "mssg", [$(this).attr("value")] ); 
        });
    });
  });
};

$(document).ready(function(){
  initializeMenu();
});
    
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
  
  unsubscribe: function(el) {
    $(el).off(".dmdmBinding");
  }, 
  
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('reset')){
      var nindx = parseInt($(el).attr("indx"));
      $(el).attr('indx', nindx+1 ) ;
    }
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

MultiLevelMenu=(function(){ // open object here

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
      //console.log("insertRule");
      //console.log( selector + "{" + rules + "}" );
  		sheetX.insertRule(selector + "{" + rules + "}",0);
  	}
  	else if("addRule" in sheetX) {
  	  //console("addRule");
  		sheetX.addRule(selector, rules, -1);
  	}
  };

  var getStyleRuleValue = function(style, selector, asheet) {
      var sheets = typeof asheet !== 'undefined' ? [asheet] : document.styleSheets;
      //console.log("sheets.length=" + sheets.length);
      
      var rtv=null;
      for (var i = 0, l = sheets.length; i < l; i++) {
          var sheet = sheets[i];
          var rules = sheet.rules || sheet.cssRules;
          //if( !sheet.cssRules ) { continue; }
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

  var initializeSubMenu = function(pid, searchStr){
    //.navbar is top level, a.dropdown-toggle are subsequent levels
    $(searchStr).find('a.dmdm-dropdown-toggle').each( function(){
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
    //add trigger to send message from child dmdMenuItem
    $(searchStr).parent().find(".dmdMenuItem").each( function(){
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

Shiny.addCustomMessageHandler('DMDMenu', function(data) {
  var id = data.id;
  var type =data.type;
  var target = data.target; // values of the items
  var cmd = data.cmd;  //cmd: disable, enable, remove, addto, rename (label, value),
  
  
  var $el = $('#' + id);
  
  var srchStr="";
  var nid=null;
  
  //console.log(JSON.stringify(data));
  //pid is the menu id
// searchStr points to the node of the newly created submenu
  if(type==="id" && data.id!==target){
    srchStr="#" + target;
  }
  if(type=='dropdown'){ //applies to rename, disable/enable
    srchStr="a.dmdm-dropdown-toggle[value='" + target + "']";
  }
  if(type=='actionItem'){
    srchStr=".dmdMenuItem[value='" + target + "']";
  }
  if(type=='dropdownList'){ // used to append submenu to dropdown
    srchStr="li.drop-down-list[value='"+target+"']"+">.dropdown-menu";
  }
  if(target=='_'){ //kludge to add to top navbar
    srchStr="ul.nav.navbar-nav";
    cmd="addSubmenu";
    type=='dropdownList';
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
  
  if(cmd=="disable" && type=='dropdown'){
    if( ! $el.find(srchStr).parent("li").hasClass("disabled") ){
      $el.find(srchStr).off('click');
      $el.find(srchStr).prop("disabled", true);
      $el.find(srchStr).parent("li").addClass("disabled");
    }
  }
  
  if(cmd=="enable" && type=='dropdown'){
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
      //console.log("rename item to" +data.param[0]);
      $el.find(srchStr).text(data.param[0]);
      $el.find(srchStr).attr("value", data.param[1]);
    }
  }
  
  if(cmd=="rename" && type=='dropdown'){
    if(data.param && data.param.length>1) {
      //console.log("rename dropdown to" +data.param[0]);
      $el.find(srchStr).text(data.param[0]);
      $el.find(srchStr).attr("value", data.param[1]);
    }
  }
  
  
  if(cmd=="add" && type=='dropdownList'){
    if(data.param) {
      var label=data.param.label, 
      gid=data.param.gid, 
      key=data.param.value;
      
      var $newEle=$("<li><a href='#' value='" + key +"' aid='"
        + id +"' id='"+ gid +"' class='dmdMenuItem' " +
        ">" + label+"</a></li>");
      $el.find(srchStr).append($newEle);
      $el.find(".dmdMenuItem[value='" + key + "']").each( function(){
        $(this).on('click',function(evt){ 
          $("#" + $(this).attr("aid")).trigger( "mssg", [$(this).attr("value")]); 
        });
      });
    }
  }
  
  if(cmd=="delete" && ( type=='actionItem' || type=='dropdown')){
    //console.log(srchStr);
    //console.log($el.find(srchStr).parent());
    $el.find(srchStr).parent().empty();
  }
  
  if(cmd=="after" && ( type=='actionItem' || type=='dropdown')){
    //console.log(srchStr);
    //console.log($el.find(srchStr).parent());
    if(data.param) {
      nid = '#' + data.param.nid;
      $el.find(srchStr).parent().after( $("" + data.param.submenu));
      MultiLevelMenu.initSubMenu(id, nid);
    }
  }
  
  if(cmd=="before" && ( type=='actionItem' || type=='dropdown')){
    //console.log(type);
    //console.log(srchStr);
    //console.log('parent');
    //console.log($el.find(srchStr).parent());
    if(data.param) {
      nid = '#' + data.param.nid;
      $el.find(srchStr).parent().before( $("" + data.param.submenu));
      
      MultiLevelMenu.initSubMenu(id, nid);
    }
  }

  
  //need to add submenu
  if(cmd=="addSubmenu" && type=='dropdownList'){
    if(data.param) {
      nid = '#' + data.param.nid;
      //console.log(nid);
      $el.find(srchStr).append( $("" + data.param.submenu));
      MultiLevelMenu.initSubMenu(id, nid);
    }
  }
  
 
}); //End Messagehadler


