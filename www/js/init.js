$(function() {

  console.log("ready");
  
  $.material.init();
  
  $(window).resize(function(){
    
    $(".imgLiquid").imgLiquid();
    
  });
  
  $("body").on("click", ".prodbox", function() {
    
    $('body').animate({scrollTop:0}, '250', 'swing');
        
    console.log("I'm a product! you click me! ah?");
    
    prod_id = $(this).attr("id").replace( /^\D+/g, '');
    
    console.log(prod_id);
    
    history.pushState(null, null, '?prod='+prod_id);
    
    Shiny.onInputChange("prod_id", prod_id);
    
    $("#tabset > li:nth-child(2) > a").tab("show");
    
    $("#tabset > li:nth-child(2)").fadeIn();
    
  });
  
  
  $("#category > div > div > label").click(function(){
  
    thiz = this
    
    category = thiz.getElementsByTagName("span")[2].innerHTML;
    
    history.pushState(null, null, '?category='+category);
  
  });
  
  /* Product Detail hide */
  $("#tabset > li:nth-child(2)").fadeOut();
    
  $("#tabset > li:nth-child(1)").click(function(){
    $("#tabset > li:nth-child(2)").fadeOut();
  });
  
  $("#tabset > li:nth-child(3)").click(function(){
    $("#tabset > li:nth-child(2)").fadeOut();
  });
  
  $()
  
  /* https://github.com/twbs/bootstrap/issues/12852 */
  //Hamburger menu toggle
  $(".navbar-nav li a").click(function (event) {
    // check if window is small enough so dropdown is created
    var toggle = $(".navbar-toggle").is(":visible");
    if (toggle) {
      $(".navbar-collapse").collapse('hide');
    }
  });
  
  
});