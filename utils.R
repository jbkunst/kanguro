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
           details = text_sample(),
           price = round(runif(nrow(.))*100)*100) %>%
    select(id, name, category, price, description, details) %>%
    tbl_df   
  
}

text_sample <- function(){
  "Bitters Helvetica whatever tousled, fanny pack roof party master cleanse paleo freegan iPhone sriracha. Williamsburg forage freegan narwhal leggings trust fund. Meditation freegan tote bag viral. Farm-to-table keytar biodiesel Schlitz paleo readymade, roof party retro lo-fi mumblecore Intelligentsia Banksy"
}

product_template_grid <- function(x){
  
  # x <- sample_n(data, 1)
  
  column(3, class="prodbox", id = sprintf("prod_%s", x$id),
         div(class="prodboxinner",
             img(class="imgthumb img-responsive center-block",
                 src=sprintf("http://placehold.it/600x600&text=%s", x$name))
         ),
         div(class="prodboxinner",
             h5(x$name)
         ),
         div(class="prodboxinner",
             span(class="pull-left", price_format(x$price)),
             span(class="pull-right", tags$i(class="fa fa-arrow-circle-right")),
             div(class="clearfix")
             )
         )
}

simple_text_template <- function(...){
  h3(...)
}