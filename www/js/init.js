$(function() {

  console.log("ready");
  
  $.material.init();
  
  $("body").on("click", ".prodbox", function() {
    
    $('body').animate({scrollTop:0}, '250', 'swing');
        
    console.log("I'm a product! you click me! ah?");
    
    console.log($(this).attr("id"));

    setTimeout(function(){
      
      Shiny.onInputChange("prod_id", $(this).attr("id"));
      $("#tabset > li:nth-child(2) > a").tab("show");
      $("#tabset > li:nth-child(2)").fadeIn();

    }, 250);
    
  });
  
  /* Product Detail hide */
  $("#tabset > li:nth-child(2)").fadeOut();
    
  $("#tabset > li:nth-child(1)").click(function(){
    $("#tabset > li:nth-child(2)").fadeOut();
  });
  
  $("#tabset > li:nth-child(3)").click(function(){
    $("#tabset > li:nth-child(2)").fadeOut();
  });
  
  
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