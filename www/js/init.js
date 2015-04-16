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
    
    console.log("I'm a product! you click me! ah?");
    
    console.log($(this).attr("id"));
    
    $(window).scrollTop(0);
    
    Shiny.onInputChange("prod_id", $(this).attr("id"));
    
    /*
    $('.category').fadeOut(function(){
      $('.product').fadeIn();
    });
    */
    
  });
  
  $("body").on("click", "#category > .shiny-options-group > .radio", function() {
    
    console.log("I'm a category! you click me! ah?");
    /*
    $('.product').fadeOut(function(){
       $('.category').fadeIn();
    });
    */
      
  });
  
});