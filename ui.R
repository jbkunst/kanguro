fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"),
    tags$link(rel = "stylesheet", href = "css/roboto.min.css"),
    tags$link(rel = "stylesheet", href = "css/material.min.css"),
    tags$link(rel = "stylesheet", href = "css/ripples.css"),
    tags$link(rel = "stylesheet", href = "css/imgLiquid.js.css"),
    tags$link(rel = "stylesheet", href = "css/style.css"),
    tags$link(rel = "stylesheet", href = "css/style_theme.css")
    ),
  navbarPage(
    title = "KanguroVentas", id = "navigabar",
    position="fixed-top", fluid = TRUE, collapsible = TRUE,
    tabPanel(h5("Inicio"),
             fluidRow(
               column(12,
                      hr(),
                      tags$a(href="#", class="btn btn-success", "Success"),
                      tags$button(class="btn btn-fab btn-raised btn-material-green",
                                  tags$i(class="mdi-action-add-shopping-cart"),
                                  div(class="ripple-wrapper")),
                      tags$a(class="btn btn-success btn-fab btn-raised mdi-action-grade")
                      )
               )
             ),
    tabPanel(h5("Tienda"),
             fluidRow(
               id = "main",
               column(class = "clearfix",
                 width = 3, id = "filters",
                 hr(),
                 radioButtons("category", "Categorías", choices = unique(data$category)),
                 sliderInput("price_range", "Precio",  min = 0, max = 1e9, value = c(0, 1e9), pre="$", sep = ".", width = "100%"),
                 actionButton("price_reset", "resetear precios", class = "btn-xs small pull-right btn-material-purple"),
                 br(),
                 br(),
                 selectInput("sortby", "Ordenar según", selectize = FALSE, width = "100%",
                             choices = c("Tiempo: Nuevos" = "tr",
                                         "Precio: Menor Precio" = "pl",
                                         "Precio: Mayor Precio" = "ph",
                                         "Stock: Menor Stock" = "sl",
                                         "Stock: Mayor Stock" = "sh")),
                 textInput("keywords", "Palabras claves"),
                 actionButton("keywords_reset", "limpiar palabras", class = "btn-xs small pull-right btn-material-purple")
               ),
               column(width = 9, id = "contentbar", hr(),
                      tabsetPanel(
                        id="tabset", type = "pills",
                        tabPanel(uiOutput("tabcategorytitle"), value = "tabcategory", hr(), uiOutput("categorytab")),
                        tabPanel(uiOutput("detailtabtitle"), value = "tabdetail", hr(), uiOutput("producttab")),
                        tabPanel(uiOutput("carttabtitle"), id ="cartta," ,value = "tabcart",  hr(), uiOutput("carttab"))
                        )
                      )
               )
             ),
    tabPanel(h5("Acerca"), hr(), p("content contact"), hr() )
    ),
  fluidRow(
    column(id="prefooter", class="bg-theme", 12, "hi!"),
    column(id="footer", 12, p(class = "text-center","KanguroVentas | Joshua Kunst 2015")),
    column(id="bottom", 12)
    ),
  tags$script(src = "js/imgLiquid-min.js"),
  tags$script(src = "js/material.min.js"),
  tags$script(src = "js/ripples.min.js"),
  tags$script(src = "js/init.js")
)