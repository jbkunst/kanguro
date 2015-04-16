$(function() {

  console.log("ready");
  
  $.material.init();
  
  /* Reset prices */
  $("#price_reset").click(function(){
    
    console.log("I'm reset price! you click me! ah?");
    
    var slider = $("#price_range").data("ionRangeSlider");
    
    slider.update({ from: 0, to: slider.options.max });
    
  });
  
  $("body").on("click", ".prodbox", function() {
    
    console.log("I'm product! you click me! ah?");
    
    console.log($(this).attr("id"));
    
    Shiny.onInputChange("prod_id", $(this).attr("id"));
    
    $(window).scrollTop(0);
    
    $(".category").hide();
    
    $(".product").show();
  
    
  });
  
  $("body").on("click", "#category > .shiny-options-group > .radio", function() {

    $(".category").show();
    
    $(".product").hide();
    
  });
  
  /* disabling right click */
  $('img').bind('contextmenu', function(e) {
    return false
  }); 
    
});