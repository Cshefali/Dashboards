#Dashboard for Palmer penguins
#Author- Shefali C.
#Start Date- July 17, 2023

#load libraries
library(tidyverse)
library(shiny)
library(DT)
library(palmerpenguins)

#data
penguins <- palmerpenguins::penguins

#User Interface
ui <- fluidPage(
  #set title
  titlePanel(title = "Palmer Penguins"),
  
  #Side bar panel
  sidebarLayout(
    #side bar layout
    sidebarPanel(
      selectInput(inputId = "select_species",
                  label = "Select species",
                  choices = list("Adelie", "Gentoo", "Chinstrap"),
                  selected = "Gentoo")
    ),#sidebar layout
    
    
    #main panel
    mainPanel(
      dataTableOutput(outputId = "dtable")
    )
  )
)

#server
server <- function(input, output){
  output$dtable <- renderDataTable(
    datatable(penguins %>% filter(species == input$select_species))
  )
}

#call shiny app
shinyApp(ui = ui, server = server)