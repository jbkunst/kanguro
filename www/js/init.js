$(function() {

  console.log("ready");
  
  $.material.init();
  
  $(".navbar").addClass("navbar-material-purple");
  
  $("#price_reset").click(function(){
    
    console.log("I'm reset price! you click me! ah?");
    
    var slider = $("#price_range").data("ionRangeSlider");
    
    slider.update({ from: 0, to: slider.options.max });
    
  });
    
});