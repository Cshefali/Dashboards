#Demo of Sidebar layout 
#Author- Shefali C.
#Last Updated- Aug 3, 2023

#Source- https://shiny.posit.co/r/articles/build/layout-guide/

library(shiny)
library(dplyr)
library(ggplot2)

data1 <- data.frame(HairEyeColor)

ui <- fluidPage(
  titlePanel("Hair and Eye color of Statistics Students"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "hair_color",
                  label = "Select hair color",
                  choices = unique(data1$Hair),
                  selected = NULL)#sidebarpanel
    ),#sidebarLayout
    
    mainPanel(
      h3(textOutput(outputId = "title_line")),
      plotOutput(outputId = "hair")
    )#mainpanel
  )#sidebarLayout
)#ui

server <- function(input, output){
  
  data_summary <- reactive({
                    data1 %>% 
                    filter(Hair %in% input$hair_color) %>% 
                    group_by(Eye) %>% 
                    summarize(total_students = sum(Freq))
                    })
  
  selected_hair <- reactive({input$hair_color})
  
  output$title_line <- renderText(
    paste0("Number of students with ", selected_hair(), " hair.")
  )
  output$hair <- renderPlot({
    ggplot(data = data_summary(), aes(x = Eye, y = total_students))+
      geom_bar(stat = "identity", fill = "lightblue", width = 0.5)+
      theme_bw()
  })
}

#call to shiny app
shinyApp(ui = ui, server = server)