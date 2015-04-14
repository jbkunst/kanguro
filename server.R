shinyServer(function(input, output, session) {
  
  output$title <- renderUI({
    letters %>% sample(4) %>% paste0(collapse = "")
  })

})



