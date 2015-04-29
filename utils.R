to_title <- function(...) stri_trans_totitle(...)

trim <- function(...) str_trim

first_upper <- function(string){
  paste(toupper(substring(string, 1, 1)), substring(string, 2, nchar(string)), sep = "")
}

str_rm_ws <- function(string){
  gsub("\\s+", " ", string)
}

price_format <- function(x){
  paste("$", prettyNum(x, big.mark = ".", decimal.mark = ","))
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
#   data <- register_ss("KanguroProds") %>%
#     get_via_csv(fileEncoding = "UTF-8") %>%
  data  <- "https://docs.google.com/spreadsheets/d/1g7l4DOy_lyjAFSQaqzbZtOuTuh6x-vZCPIPAWfL0yJ0/export?format=csv&id=1g7l4DOy_lyjAFSQaqzbZtOuTuh6x-vZCPIPAWfL0yJ0&gid=0" %>% 
    read_csv() %>% 
    mutate(image = ifelse(is.na(image),
                          sprintf("http://placehold.it/200x200&text=%s", name),
                          image),
           description = ifelse(is.na(description),
                                "Sin descripción.",
                                description)) %>%
    mutate(name        = name         %>% to_title  %>% str_trim %>% str_rm_ws,
           category    = category     %>% to_title  %>% str_trim %>% str_rm_ws,
           description = description  %>% first_upper  %>% str_rm_ws) %>%
    filter(!is.na(name)) %>%    
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
                 column(12, img(class="imgthumb img-responsive", src=x$image))
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
                                     "  Agregar al Carrito", tags$i(class="fa fa-cart-plus"))
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

cart_template <- function(dcart){
  
  cart_total <- dcart$subtotal %>% sum %>% price_format
  
  products_template_tr <- llply(seq(nrow(dcart)), function(y){
    x <- dcart[y,]
    tags$tr(
      tags$td(class="text-center",
              img(class="imgthumb img-responsive", src=sprintf("http://placehold.it/40x40&text=%s", x$name))),
      tags$td(x$product),
      tags$td(class="text-right", x$price),
      tags$td(class="text-right", x$amount),
      tags$td(class="text-right", x$subtotal_format)
    )
  })
  
  products_template_tr <- do.call(function(...){ tags$tbody(...)},  products_template_tr)
  
  div(class="row-fluid",
      div(class="table-responsive",
          tags$table(class="table table-hover",
                     tags$thead(
                       tags$tr(
                         tags$th(),
                         tags$th("Producto"),
                         tags$th(class="text-right", "Precio"),
                         tags$th(class="text-right", "Cantidad"),
                         tags$th(class="text-right", "Subtotal")
                       )
                     ),
                     products_template_tr,
                     tags$tfoot(
                       tags$tr(
                         tags$th(),
                         tags$th(),
                         tags$th(),
                         tags$th(class="text-right", "Total"),
                         tags$th(class="text-right", cart_total)
                       )
                     )
          )
      ),
      actionButton("checkout", class="pull-right btn-success btn-material-green",
                   "  Realizar compra", tags$i(class="fa fa-money"))
  )
}

