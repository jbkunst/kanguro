fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "css/roboto.min.css"),
    tags$link(rel = "stylesheet", href = "css/material.min.css"),
    tags$link(rel = "stylesheet", href = "css/ripples.css"),
    tags$link(rel = "stylesheet", href = "//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"),
    tags$link(rel = "stylesheet", href = "http://www.jqueryscript.net/demo/Resize-Images-To-Fit-In-A-Container-imgLiquid/src/css/imgLiquid.js.css"),
    tags$link(rel = "stylesheet", href = "css/style.css"),
    tags$link(rel = "stylesheet", href = "css/style_theme.css")
    ),
  navbarPage(
    title = NULL, id = "navigabar",
    position="fixed-top", inverse=FALSE, fluid = TRUE,
    tabPanel(h5(strong("KanguroVentas")),
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
               column(
                 width = 3, id = "filters",
                 hr(),
                 radioButtons("category", NULL, choices = unique(data$category)),
                 hr(),
                 sliderInput("price_range", "Precio",  min = 0, max = 1e9, value = c(0, 1e9), pre="$", sep = ".", width = "100%"),
                 actionButton("price_reset", "resetear precios", class = "btn-xs small pull-right btn-material-purple"),
                 br(),
                 br(),
                 hr(),
                 selectInput("sortby", "Ordenar",
                             choices = c("Tiempo: Nuevos" = "tr", "Precio: Menor Precio" = "pl", "Precio: Mayor Precio" = "ph"),
                             selectize = FALSE, width = "100%")
               ),
               column(width = 9, id = "contentbar", hr(),
                      tabsetPanel(
                        id="tabset",
                        tabPanel(uiOutput("tabcategorytitle"), value = "tabcategory", hr(), uiOutput("category")),
                        tabPanel(uiOutput("detailtabtitle"), value = "tabdetail", hr(), uiOutput("product")),
                        tabPanel(uiOutput("carttabtitle"), id ="cartta," ,value = "tabcart",  hr(), uiOutput("cart"))
                        )
                      )
               )
             ),
    tabPanel(h5("Acerca de Kanguro"),
             hr(),
             p("content contact"))
    ),
  fluidRow(id="footer", column(12, p(class="text-center", "Footer"))),
  tags$script(src = "js/ripples.min.js"),
  tags$script(src = "js/material.min.js"),
  tags$script(src = "http://www.jqueryscript.net/demo/Resize-Images-To-Fit-In-A-Container-imgLiquid/src/js/imgLiquid-min.js"),
  tags$script(src = "js/init.js")
)