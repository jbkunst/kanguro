# input <- list(category = "Vestuario", price_range = c(0, 1000000), sortby = "pl", "keyword" = "aro")
# values <- list(prod_id = "prod_34", cart = c(1, 4, 5, 6, 6 ,6))

shinyServer(function(input, output, session) {
  
  session$cart <- c()
  
  data <- get_data_real()
  
  values <- reactiveValues(cart = c(), prod_id = 1)
  
  #### Observe events
  observeEvent(input$prod_id, {
    values$prod_id <- input$prod_id
    updateTabsetPanel(session, "tabset", selected = "tabdetail")
  })

  observeEvent(input$addtocart, {
    session$cart  <- c(session$cart, isolate(str_extract(input$prod_id, "\\d+")))
    values$cart <- session$cart
  })
  
  observeEvent(input$makeorder, {
    print(data_cart())
  })
  
  observeEvent(input$price_reset, {
    data_category <- data_category()
    updateSliderInput(session, "price_range", value = c(0, max(data_category$price)))
  })
  
  observeEvent(input$keywords_reset, {
    updateTextInput(session, "keywords", value = "")
  })
  
  #### Reactive Datas
  data_category <- reactive({
    
    data_category <- data %>% filter(category == input$category)
    
    updateSliderInput(session, "price_range",
                      min = 0, max = max(data_category$price),
                      value = c(0, max(data_category$price)))
    
    updateTabsetPanel(session, "tabset", selected = "tabcategory")
        
    data_category
    
  })
  
  data_sort <- reactive({
    
    data_sort <- data_category()
    
    if(input$sortby == "pl"){
      data_sort <- data_sort  %>% arrange(price)
    } else if (input$sortby == "ph"){
      data_sort <- data_sort  %>% arrange(desc(price))
    } else if (input$sortby == "lh"){
      data_sort <- data_sort  %>% arrange(stock)
    } else if (input$sortby == "sh"){
      data_sort <- data_sort  %>% arrange(desc(stock))
    }
    
    data_sort
    
  })
  
  data_price <- reactive({
    
    data_price <- data_sort()
    
    data_price <- data_price %>%
      filter(price %>% between(input$price_range[1], input$price_range[2]))
    
    data_price
    
  })
  
  data_keyword <- reactive({

    data_keyword <- data_price()
    
    data_keyword <- data_keyword %>% filter(grepl(tolower(input$keywords), tolower(name)) | grepl(tolower(input$keywords), tolower(description)))

    data_keyword
    
  })
  
  data_product <- reactive({
    
    prod_id <- str_extract(input$prod_id ,"\\d+") %>% as.numeric
    
    product <- data %>% filter(id == prod_id)
    
  })
  
  data_cart <- reactive({
    data_cart <- data_frame(id = as.numeric((values$cart))) %>%
      group_by(id) %>%
      summarize(amount = n()) %>%
      left_join(data, by = "id") %>%
      mutate(subtotal = price*amount,
             subtotal_format = price_format(subtotal),
             product = name,
             price = price_format(price))
    data_cart
  })
  
  #### Home ####
  output$home <- renderUI({
    div(class="main-gallery js-flickity",
        div(class="gallery-cell col-md-12", "lasldalsda"),
        div(class="gallery-cell col-md-12 bg-theme", "lasldalsdasda"),
        div(class="gallery-cell col-md-12 col-theme", "lasldalsdaa"),
        div(class="gallery-cell col-md-12", "lasldalsada"),
        div(class="gallery-cell col-md-12 bg-theme", "lasldasadlsda"),
        div(class="gallery-cell col-md-12", "asdasdasdasd")
    )
    
  })
  
  #### Titles tabpanel ####
  output$tabcategorytitle <- renderUI({
    list(input$category, tags$small("(", nrow(data_price()),")"))
  })
  
  output$detailtabtitle <- renderUI({
    list(data_product()$name)
  })
  
  output$carttabtitle <- renderUI({
    list("Mi Carrito", tags$i(class="fa fa-shopping-cart"), tags$small("(", length(values$cart), ")"))
  })
  
  #### TabPanels
  output$categorytab <- renderUI({
    
    products <- data_keyword()
    
    if(nrow(products)==0){
      output <- template_info_quote("No existen productos con tales criterios de búsqueda.")
    } else {     
      output <- llply(seq(nrow(products)), function(x){
        product_template_grid(products[x,])
        })
      
      output <- do.call(function(...){ div(class="row-fluid", ...)}, output)
    }
    list(output, tags$script("$(\".imgLiquid\").imgLiquid();"))
  })
  
  output$producttab <- renderUI({
    
    if(!is.null(values$prod_id)){
      product <- data_product()
      output <- product_detail_template(product)
    } else {
      output <- div()
    }
    list(output, tags$script("$.material.init();"))
  })
  
  output$carttab <- renderUI({
    
    if(length(values$cart)==0){
      output <- template_info_quote("Todavía no hechas nada al carrito!")
    } else {     
      dcart <- data_cart()
      output <- cart_template(dcart)
    }
    list(output, tags$script("$.material.init();"))
  })
  
})



