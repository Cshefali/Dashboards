#Demo of simple fluidRow() layout with 2 columns
#Author- Shefali C.
#last updated- August 3, 2023

#Source- https://shiny.posit.co/r/articles/build/layout-guide/

library(shiny)
library(dplyr)
library(ggplot2)

data1 <- data.frame(HairEyeColor)

#User Interface
ui <- fluidPage(
  titlePanel("Hair-Eye color of Statistics Students"),
  
  fluidRow(
    br(),
    
    #column 1
    column(4, offset = 0,
           wellPanel(selectInput(inputId = "hair_color",
                       label = "Select hair color",
                       choices = unique(data1$Hair))
           )#wellPanel
           ),#column 1
    #column 2
    column(8,
           h3(textOutput(outputId = "title_line")),
           plotOutput(outputId = "hair")
           )#column 2
  )#fluidRow
)#fluidPage

#server 
server <- function(input, output){
  title <- reactive({input$hair_color})
  
  output$title_line <- renderText(
    paste0("Number of students with ", title(), " hair.")
  )
  
  data_summary <- reactive({
    data1 %>% 
      filter(Hair == input$hair_color) %>% 
      group_by(Eye) %>% 
      summarize(total_students = sum(Freq))
  })
  
  output$hair <- renderPlot(
    ggplot(data = data_summary(), aes(x = Eye, y = total_students))+
      geom_bar(stat = "identity", width = 0.5, fill = "lightblue")+
      theme_bw()
  )
}

#call to shiny App
shinyApp(ui = ui, server = server)