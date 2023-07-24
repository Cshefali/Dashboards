#Dashboard for Palmer penguins
#Author- Shefali C.
#Last Update- July 24, 2023

##Blog Help- https://clarewest.github.io/blog/post/making-tables-shiny/
##Font-awesome icon library Help:
#https://stackoverflow.com/questions/66014722/why-are-the-icons-not-displaying-in-a-dtdatatable-in-shiny-app#:~:text=The%20font%2Dawesome%20library%20is,the%20icon%20does%20not%20display.&text=If%20you%20really%20want%20a,in%20your%20app%2C%20without%20as.

#load libraries
library(tidyverse)
library(shiny)
library(DT)
library(palmerpenguins)

#data
penguins <- palmerpenguins::penguins

#User INterface
ui <- basicPage(
  h3("Palmer Penguins table using DT and Formattable packages"),
  DT::dataTableOutput(outputId = "group_view")
  
)

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
