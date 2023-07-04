library(shiny)

#USER INTERFACE
ui <- fluidPage(
  #title of dashboard
  titlePanel(title = "censusVis"),
  
  #sidebar layout
  sidebarLayout(
    #side panel
    sidebarPanel(
      helpText("Create demographic maps with
               information from the 2010 US Census."),
      #drop down
      selectInput(inputId = "var",
                  label = "Choose a variable to display",
                  choices = list("Percent White", "Percent Hispanic",
                                 "Percent Black", "Percent Asian"),
                  selected = "Percent White"),
      
      #slider input
      sliderInput(inputId = "range",
                  label = "Range of interest",
                  min = 0, max = 100, value = c(0, 100))
    ), #end side bar panel
    
    #Main Panel
    mainPanel(
      textOutput(outputId = "selected_var"),
      textOutput(outputId = "selected_range")
    ) #end main panel
    
  )#end sidebar layout
)#end Fluid-Page

#SERVER

server <- function(input, output){
  
  #1. input- list-like object that stores all current values in the app.
  #2. output- is a list-like object that stores instructions
  #to build R objects in the app.
  
  #For variable selected
  output$selected_var <- renderText({
    paste("You have selected", input$var)
    })
  
  #For range of interest selected
  output$selected_range <- renderText({
    paste("You have chosen a range that goes from", input$range[1], 
          "to", input$range[2])
  })
  
}

#CALL TO SHINY APP
shinyApp(ui = ui, server = server)