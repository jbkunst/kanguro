$(function() {

  console.log("ready");
  
  $.material.init();
  
  /* Remove .navbar-header*/
  $(".navbar-header").remove();
  
  $("body").on("click", ".prodbox", function() {
    
    console.log("I'm a product! you click me! ah?");
    
    console.log($(this).attr("id"));
    
    $(window).scrollTop(0);
    
    Shiny.onInputChange("prod_id", $(this).attr("id"));
    
    $("#tabset > li:nth-child(2) > a").tab("show");
    
    $("#tabset > li:nth-child(2)").fadeIn();
    
  });
  
  /* Product Detail hide */
  $("#tabset > li:nth-child(2)").fadeOut();
    
  $("#tabset > li:nth-child(1)").click(function(){
    $("#tabset > li:nth-child(2)").fadeOut();
  });
  
  $("#tabset > li:nth-child(3)").click(function(){
    $("#tabset > li:nth-child(2)").fadeOut();
  });
  
  $("body").on("click", "#category > .shiny-options-group > .radio", function() {
    
    console.log("I'm a category! you click me! ah?");
    
    $("#tabset > li:nth-child(2)").fadeOut()
          
  });
  
  /* Reset keywords
  $("#keyword_reset").click(function(){
    
  });
  
  Reset prices 
  $("#price_reset").click(function(){
    
    console.log("I'm reset price! you click me! ah?");
    
    var slider = $("#price_range").data("ionRangeSlider");
    
    slider.update({ from: 0, to: slider.options.max });
    
  });
  */
  
});