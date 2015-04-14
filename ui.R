fluidPage(
  tags$head(
    tags$style(rel = "stylesheet", type = "text/css", href = "css/style.css")
    ),
  fluidRow(id="header",
           h2("Header")
           ),
  fluidRow(id="content",
           tabsetPanel(
             type = "pills", position = "left",
             tabPanel(h4("Home"), p("content home")),
             tabPanel(h4("Shop"), p("content shope")),
             tabPanel(h4("Cart"), p("content cart")),
             tabPanel(h4("Contact"), p("content contact"))
             )
           ),
  fluidRow(id="footer",
           p("footer")
           )
)