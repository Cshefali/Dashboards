library(shiny)

ui <- fluidPage(
  
  #title of panel
  titlePanel(title = "censusVis"),
  
  #sidebar layout
  sidebarLayout(
    #side panel
    sidebarPanel(
      #put entire content inside grey box
        helpText("Create demographic maps with
                 information from the 2010 US Census."),
        
        #drop down list
        selectInput(inputId = "var",
                    label = "Choose a variable to display",
                    choices = list("Percent White", "Percent Black",
                                "Percent Hispanic", "Percent Asian"),
                    selected = "Percent White"),
        
        #slider input
        sliderInput(inputId = "range",
                    label = "Range of interest:",
                    min = 0,
                    max = 100,
                    value = c(0,100))
    ),#end side-bar panel
    
    #main panel
    mainPanel()
  )
)#end Fluid-Page

#SERVER
server <- function(input, output){
  
}

#Call to shiny app
shinyApp(ui = ui, server = server)