# input <- list(category = "drinks", price_range = c(0, 100), sortby = "pl")
# values <- list(prod_id = "prod_34", cart = c(1, 4, 5, 6, 6 ,6))

shinyServer(function(input, output, session) {
  
  session$cart <- c()
  
  values <- reactiveValues(cart = c(), prod_id = 1)
  
  observeEvent(input$prod_id, {
    values$prod_id <- input$prod_id
  })

  observeEvent(input$addtocart, {
    session$cart  <- c(session$cart, isolate(str_extract(input$prod_id, "\\d+")))
    values$cart <- session$cart
  })
  
  observeEvent(input$makeorder, {
    print(data_cart())
  })
  
  
  #### Reactive Datas
  data_category <- reactive({
    
    data_category <- data %>% filter(category == input$category)
    
    updateSliderInput(session, "price_range", min = 0, max = max(data_category$price))
    
    data_category
    
  })
  
  data_sort <- reactive({
    
    data_sort <- data_category()
    
    if(input$sortby == "pl"){
      data_sort <- data_sort  %>% arrange(price)
    } else if (input$sortby == "ph"){
      data_sort <- data_sort  %>% arrange(desc(price))
    }
    
    data_sort
    
  })
  
  data_price <- reactive({
    
    data_price <- data_sort()
    
    data_price <- data_price %>% filter(price %>% between(input$price_range[1], input$price_range[2]))
    
    data_price
    
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
  
  #### TabPanels
  output$category_breadcrum <- renderUI({
    ls <- list("Categoría", input$category)
    output <- lapply(ls, tags$li)
    output <- do.call(function(...){ tags$ol(class="breadcrumb", ...)}, output)
    output
  })
  
  output$category <- renderUI({
    
    products <- data_price()
    
    if(nrow(products)==0){
      output <- template_info_quote("No existen productos con tales criterios de búsqueda.")
    } else {     
      output <- llply(seq(nrow(products)), function(x){
        product_template_grid(products[x,])
        })
      
      output <- do.call(function(...){ div(class="row-fluid", ..., tags$script("$(\".imgLiquid\").imgLiquid();"))}, output)
    }
    
    output
    
  })
  
  output$product_breadcrum <- renderUI({
    ls <- list("Categoría", input$category, "Producto", data[data$id==str_extract(values$prod_id, "\\d+"), "name"])
    output <- lapply(ls, tags$li)
    output <- do.call(function(...){ tags$ol(class="breadcrumb", ...)}, output)
    output
  })
  
  output$product <- renderUI({
    
    if(!is.null(values$prod_id)){
      product <- data_product()
      output <- product_detail_template(product)
    } else {
      output <- div()
    }
    
    output
    
  })
  
})



