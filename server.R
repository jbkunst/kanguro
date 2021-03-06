# input <- list(category = "Vestuario", price_range = c(0, 1000000), sortby = "pl", "keyword" = "aro")
# values <- list(prod_id = "prod_34", cart = c(1, 4, 5, 6, 6 ,6))

shinyServer(function(input, output, session) {
  
  data <- get_data_real()
  
  values <- reactiveValues(cart = c(), prod_id = 1)
  
  #### Observe events
  observeEvent(input$prod_id, {
    values$prod_id <- input$prod_id
    updateTabsetPanel(session, "tabset", selected = "tabdetail")
  })

  observeEvent(input$addtocart, {
    message(sprintf("LOG time: %s | action: %s | element: %s"
                    , Sys.time(), "Click add to cart", input$prod_id))
    values$cart <- c(values$cart, input$prod_id)
    print(values$cart)
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
    
    if(input$sortby == "pl") {
      data_sort <- data_sort  %>% arrange(price)
    } else if (input$sortby == "ph") {
      data_sort <- data_sort  %>% arrange(desc(price))
    } else if (input$sortby == "lh") {
      data_sort <- data_sort  %>% arrange(stock)
    } else if (input$sortby == "sh") {
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
  output$carrousel <- renderUI({
    
    output <- div(class = "main-gallery js-flickity row",
                  div(id = "cont1", class = "gallery-cell col-md-8",           style = "height:400px", "lasldalsda"),
                  div(id = "cont2", class = "gallery-cell col-md-8 bg-theme",  style = "height:400px", "lasldalsdasda"),
                  div(id = "cont3", class = "gallery-cell col-md-8 col-theme", style = "height:400px", "lasldalsdaa"),
                  div(id = "cont4", class = "gallery-cell col-md-8",           style = "height:400px", "lasldalsada"),
                  div(id = "cont5", class = "gallery-cell col-md-8 bg-theme",  style = "height:400px", "lasldasadlsda"),
                  div(id = "cont6", class = "gallery-cell col-md-8",           style = "height:400px", "asdasdasdasd"),
                  div(id = "cont7", class = "gallery-cell col-md-8 bg-theme",  style = "height:400px", "last")
                 )
    list(output, tags$script("$('.main-gallery').flickity({cellAlign: 'left', contain: true, autoPlay: true, resize: false, cellAlign: 'center', wrapAround: true});"))

  })
  
  output$wc <- renderD3wordcloud({
    
    corpus <- Corpus(VectorSource(data$description))
    
    corpus <- corpus %>%
      tm_map(removePunctuation) %>%
      tm_map(function(x){ removeWords(x, stopwords(kind = "es")) })
    
    d <- TermDocumentMatrix(corpus) %>%
      as.matrix() %>%
      rowSums() %>%
      sort(decreasing = TRUE) %>%
      data.frame(word = names(.), freq = .) %>%
      tbl_df() %>%
      arrange(desc(freq))
    
    d3wordcloud(d$word, d$freq, font = "Impact", rotate.min = 45, rotate.max = 45)
  })
  
  #### Titles tabpanel ####
  output$tabcategorytitle <- renderUI({
    list(input$category, tags$small("(", nrow(data_price()), ")"))
  })
  
  output$detailtabtitle <- renderUI({
    list(data_product()$name)
  })
  
  output$carttabtitle <- renderUI({
    list("Mi Carrito", tags$i(class = "fa fa-shopping-cart"), tags$small("(", length(values$cart), ")"))
  })
  
  #### TabPanels
  output$categorytab <- renderUI({
    
    products <- data_keyword()
    
    if (nrow(products) == 0) {
      output <- template_info_quote("No existen productos con tales criterios de búsqueda.")
    } else {     
      output <- llply(seq(nrow(products)), function(x){
        product_template_grid(products[x,])
        })
      
      output <- do.call(function(...){ div(class = "row-fluid", ...)}, output)
    }
    list(output, tags$script("$(\".imgLiquid\").imgLiquid();"))
  })
  
  output$producttab <- renderUI({
    
    if (!is.null(values$prod_id)) {
      product <- data_product()
      output <- product_detail_template(product)
    } else {
      output <- div()
    }
    list(output, tags$script("$.material.init();"))
  })
  
  output$carttab <- renderUI({
    
    if (length(values$cart) == 0) {
      output <- template_info_quote("Todavía no hechas nada al carrito!")
    } else {     
      dcart <- data_cart()
      output <- cart_template(dcart)
    }
    list(output, tags$script("$.material.init();"))
  })
  
})



