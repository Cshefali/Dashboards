library(shiny)
library(tidyverse)
library(palmerpenguins)
library(shinyjqui)
library(DT)

#data
penguins <- palmerpenguins::penguins
colnames(penguins) <- gsub(pattern = "_mm",replacement = "",colnames(penguins))

##Custom options in table--to be passed to JS() 

#make column header borders dark
#version 1
# headerCallback <- c(
#   "function(thead, data, start, end, display){",
#   "  $('th', thead).css('border-block', '2px solid grey');
#      $('th', thead).css('border-inline', '2px solid grey');
#      $('th', thead).css('border-right', '0.5px solid grey');
#      $('th', thead).css('border-left', '0.5px solid grey');",
#   "}"
# )

#version 2
headerCallback <- c(
  "function(thead, data, start, end, display){",
  "  $('th', thead).css('border-block', '1.5px solid black');",
  "}"
)

#BACKGROUND COLOR OF COLUMN HEADER
# headerBGcolor <- JS(
#   "function(settings, json) {",
#   "$(this.api().table().header()).css({'background-color': '#fff', 'color': '#000'});",
#   "}")

#User interface
ui <- fluidPage(
  #title
  titlePanel(title = "Table Layout options for Palmer Penguins Dataset"),
  
  #Navigation menu list
  navlistPanel(widths = c(3,9),
               #list of tabs for different themes
               tabPanel(title = "Table Theme",
                        tabsetPanel(
                          tabPanel(title = "Theme 1",
                                   DT::DTOutput(outputId = "table11",
                                                       width = "80%")
                                   ),
                          tabPanel(title = "Theme 2",
                                   DT::DTOutput(outputId = "table12",
                                                width = "80%")),
                          tabPanel(title = "Theme 3",
                                   DT::DTOutput(outputId = "table13",
                                                width = "80%")),
                          tabPanel(title = "Theme 4",
                                   DT::DTOutput(outputId = "table14",
                                                width = "80%"))
                        )#tabsetPanel
                        ),#main tabPanel
               #list of tabs for backgroud color of column header
               tabPanel(title = "BG color of column header",
                        tabsetPanel(
                          tabPanel(title = "Default-White",
                                   DT::DTOutput(outputId = "table21",
                                                width = "80%")),
                          tabPanel(title = "Black",
                                   DT::DTOutput(outputId = "table22",
                                                width = "80%")),
                          tabPanel(title = "Grey",
                                   DT::DTOutput(outputId = "table23",
                                                width = "80%"))
                        ))
    
  )#navlistPanel
)#fluidPage

#SERVER
server <- function(input, output){
  
  #Global settings applied to all tables
  options(DT.options = list(columnDefs = list(list(className = 'dt-center', targets = "_all")),
                            headerCallback = JS(headerCallback)))
  ##Menu-Table Theme
  
  #Theme 1
  output$table11 <- DT::renderDT({
    datatable(penguins,
              class = 'cell-border stripe hover',
              rownames = FALSE)
    })#datatable

  #Theme 2
  output$table12 <- DT::renderDT({
    datatable(penguins,
              #class = 'row-border stripe hover')
              class = 'row-border stripe hover',
              rownames = FALSE)
  })
  #Theme 3
  output$table13 <- DT::renderDT({
    datatable(penguins,
              class = 'compact row-border stripe cell-border hover',
              rownames = FALSE)
  })
  #Theme 4
  output$table14 <- DT::renderDT({
    datatable(penguins,
              class = 'compact row-border stripe hover',
              rownames = FALSE
              )
  })
  
  #Menu- background color of column header
  #BG- White
  output$table21 <- DT::renderDT({
    datatable(penguins,
              class = 'compact row-border stripe cell-border hover',
              rownames = FALSE,
              options = list(
                initComplete = JS(
                  "function(settings, json) {",
                  "$(this.api().table().header()).css({'background-color': '#fff', 'color': '#000'});",
                  "}")
              ))#datatable
        })#renderDT
    #BG- Black
    output$table22 <- DT::renderDT({
      datatable(penguins,
                class = 'compact row-border stripe cell-border hover',
                rownames = FALSE,
                options = list(
                  initComplete = JS(
                    "function(settings, json) {",
                    "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                    "}")
                ))
  })#renderDT
    #BG- Grey
    output$table23 <- DT::renderDT({
      datatable(penguins,
                class = 'compact row-border stripe cell-border hover',
                rownames = FALSE,
                options = list(
                  initComplete = JS(
                    "function(settings, json) {",
                    "$(this.api().table().header()).css({'background-color': '#E8E8E8', 'color': '#000'});",
                    "}")
                ))
    })#renderDT
  
  
  
  
  
  
}#server




#CALL TO SHINY
shinyApp(ui = ui, server = server)