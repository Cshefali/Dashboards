#load libraries
library(tidyverse)
library(shiny)
library(DT)
library(palmerpenguins)

#data
penguins <- palmerpenguins::penguins

#User interface
ui <- fluidPage(
  #title
  titlePanel(title = "Penguin Tables using NavlistPanel()"),
  navlistPanel(widths = c(3,9),
    tabPanel(title = "Islands view", tags$h3("Palmer Penguins by Island")),
    tabPanel(title = "Species view", tags$h3("Palmer Penguins by Species"))
  ),#navlistPanel
  
  #mainpanel
  mainPanel(
    DT::dataTableOutput(outputId = "group_view")
  )
)

#server
server <- function(input, output){
  output$group_view <- DT::renderDataTable({
    datatable(data = penguins,
              options = list(
                paging = TRUE,
                pageLength = 5,
                scrollX = TRUE,
                scrollY = TRUE,
                autoWidth = TRUE,
                server = TRUE,
                dom = 'Bfrtip',
                buttons = c('csv','excel'),
                #applying some column options, make all columns center aligned
                columnDefs = list(list(targets = '_all', className = 'dt-center'))
                #                   list(targets = c(0, 8, 9), visible = FALSE))
              ),#options
              #adds 'csv' and 'excel' download buttons.
              extensions = 'Buttons',
              #adds capability of click & select any row; default- 'multiple'
              selection = 'single',
              #add/remove a search box below/above ('top', 'bottom') each column of table
              filter = 'none',
              #removes the row index or name, if any from LHS
              rownames = FALSE
    )#datatable
  })
}


shinyApp(ui = ui, server = server)