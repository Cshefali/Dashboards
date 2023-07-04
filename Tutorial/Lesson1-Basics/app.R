#Topic- HTML tags in Shiny
#URL- https://shiny.posit.co/r/getstarted/shiny-basics/lesson2/
#Author- Shefali C.
#Date- July 3, 2023

library(shiny)

#USER INTERFACE
ui <- fluidPage(
  
  #title of the app
  titlePanel(title = "My Shiny App"),
  
  #layout of the dashboard
  sidebarLayout(
    sidebarPanel(
      h2("Installation"),
      p("Shiny is available on CRAN, so you can install it in the usual way from the R console:"),
      p(),
      code("install.packages(\"shiny\")"),
      p(),
      p(),
      img(src = "rstudio.png", height = 70, width = 200),
      br(),
      "Shiny is a product of ", 
      span("RStudio", style = "color:blue")
      
    ),
    mainPanel(
      h2(strong("Introducing Shiny")),
      p("Shiny is a new package from RStudio that makes it ",
      em("incredibly easy"), 
      "to build interactive web applications with R."),
      br(),
      p("For an introduction and live examples, visit the", 
        a(href = "https://shiny.posit.co/r/", "Shiny Homepage.")),
      br(),
      br(),
      h3(strong("Features")),
      p("-Build useful web applications with only a few lines of code--no Javascript required."),
      p("-Shiny applications are automatically 'live' in the same way that", 
      strong("spreadsheets"), 
      "are live. Outputs change instantly as users modify inputs, without requiring a reload of the browser.")
    )
  )
)



# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
