to_title <- function(...) stri_trans_totitle(...)

price_format <- function(x){
  paste("$", prettyNum(x, big.mark = "."))
}

get_data_sample <- function(){
  library("arules")
  data(Groceries)
  set.seed(1313)
  data <- Groceries@itemInfo %>%
    mutate(id = sample(nrow(.)),
           name = as.character(labels) %>% to_title,
           category = as.character(level1) %>% to_title,
           description = as.character(level2)  %>% to_title,
           image = sprintf("http://placehold.it/200x200&text=%s", name),
           price = round(runif(nrow(.))*100)*100) %>%
    select(id, name, category, price, description, image) %>%
    tbl_df   
}

get_data_real <- function(){
  data <- register_ss("KanguroProds") %>%
    get_via_csv(fileEncoding = "UTF-8") %>%
    mutate(name = to_title(name),
           category = to_title(category)) %>%
    tbl_df
}

product_template_grid <- function(x){
  
  # x <- sample_n(data, 1)
  
  column(3, class="prodbox", id = sprintf("prod_%s", x$id),
         div(class="photocontent imgLiquid",
             img(class="imgthumb img-responsive center-block",
                 src=x$image)
         ),
         div(class="prodboxinner",
             x$name  %>% h5()
         ),
         div(class="prodboxinner",
             x$price  %>% price_format %>% h5 %>% span(class="pull-left"),
             tags$i(class="fa fa-arrow-circle-right") %>% h5 %>% span(class="pull-right"),
             div(class="clearfix")
             )
         )
}

product_detail_template <- function(x){
  
  # x <- sample_n(data, 1)
  
  div(class="row-fluid",
      column(4,
             div(class="row-fluid",
                 column(6, img(class="imgthumb img-responsive", src=sprintf("http://placehold.it/200x200&text=%s", x$name))),
                 column(6, img(class="imgthumb img-responsive", src=sprintf("http://placehold.it/200x200&text=%s", x$name))),
                 column(6, img(class="imgthumb img-responsive", src=sprintf("http://placehold.it/200x200&text=%s", x$name))),
                 column(6, img(class="imgthumb img-responsive", src=sprintf("http://placehold.it/200x200&text=%s", x$name))),
                 column(6, img(class="imgthumb img-responsive", src=sprintf("http://placehold.it/200x200&text=%s", x$name))),
                 column(6, img(class="imgthumb img-responsive", src=sprintf("http://placehold.it/200x200&text=%s", x$name)))
             )
      ),
      column(8,
             h3(x$name),
             tags$dl(
               tags$dt("Descripcion"), tags$dd(x$description),
               tags$dt("Stock"), tags$dd(x$stock)
             ),
             hr(),
             div(class="row-fluid",
                 column(6,
                        tags$button(class="btn btn-success btn-lg", price_format(x$price))
                 ),
                 column(6,
                        actionButton("addtocart", class="pull-right btn-success btn-lg hvr-buzz-out", prodid = x$id,
                                     "  Add to cart", tags$i(class="fa fa-cart-plus"))
                 )
             )
      )
  )
}

template_simple_text <- function(...){
  h3(...)
}

template_info_quote <- function(text = "Este es un mensaje para informar",
                                icon = tags$i(class="fa fa-info-circle"),
                                type = c("info", "alert", "warning", "success")[1]){
  
  fluidRow(
    column(8, offset = 2, class = sprintf("alert alert-dismissable alert-%s", type),
           tags$button(type="button", class="close", 'data-dismiss'="alert", "x"),
           icon, text)
    )
    
}

