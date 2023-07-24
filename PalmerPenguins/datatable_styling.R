#Dashboard for Palmer penguins
#Author- Shefali C.
#Last Update- July 24, 2023

##Blog Help- https://clarewest.github.io/blog/post/making-tables-shiny/

##Font-awesome icon library Help:
#https://stackoverflow.com/questions/66014722/why-are-the-icons-not-displaying-in-a-dtdatatable-in-shiny-app#:~:text=The%20font%2Dawesome%20library%20is,the%20icon%20does%20not%20display.&text=If%20you%20really%20want%20a,in%20your%20app%2C%20without%20as.

##Formattable library help- 
#https://www.r-bloggers.com/2018/11/make-beautiful-tables-with-the-formattable-package/

library(tidyverse)
library(shiny)
library(DT)
library(palmerpenguins)
library(formattable)


penguins <- palmerpenguins::penguins
penguins$icon <- as.character(icon(name = "crow", lib = "font-awesome"))
#rearrange all columns
penguins <- penguins[,c(9,1:8)]

ui <- fluidPage(titlePanel("DT table in Shiny"),
                mainPanel(width = 12,
                          #if the style = display arg is not given,
                          #a small tag-symbol appears above "Show entries" box in the app
                          tags$span(icon("tag"),style = "display: none;"),
                          h3("Table using DT"),
                          DT::dataTableOutput("mytable1"),
                          h3("Table using formattable"),
                          tags$span(icon("tag"),style = "display: none;"),
                          DT::dataTableOutput("mytable2")
                          )#MainPanel
                )#fluidPage

server <- function(input, output) {
  output$mytable1 <- DT::renderDataTable(
                        datatable(penguins,
                                        options = list(scrollX = TRUE),
                                        rownames = FALSE,
                                        escape = FALSE))
  output$mytable2 <- DT::renderDataTable({
    formattable(penguins, 
                align = c(rep("c",ncol(penguins))))
  })
}

# Run the application
shinyApp(ui = ui, server = server)