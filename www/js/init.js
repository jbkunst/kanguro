$(function() {

  console.log("ready");
  
  $.material.init();
  
  // Shiny dont give option to add class to navigation bar
  $(".navbar").addClass("navbar-material-purple");
  
  // Imgs
  $("#category > .shiny-options-group > div.radio").click(function(){
    
    console.log("I'm reset price! you click me! ah?");
    
    $(".imgLiquid").imgLiquid();
    
  });
  
  $("#price_reset").click(function(){
    
    console.log("I'm reset price! you click me! ah?");
    
    var slider = $("#price_range").data("ionRangeSlider");
    
    slider.update({ from: 0, to: slider.options.max });
    
  });
    
});