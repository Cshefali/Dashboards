#Shiny App for US 2010 Census data.
#Author- Shefali C.
#Date- July 4, 2023

library(maps)
library(mapproj)
library(shiny)

#set working directory to app's location
#setwd(paste0(getwd(),"/census-app"))

#sourcing the helper.R script to use percent_map() function.
source("helper.R")

#fetch data file
census_data <- readRDS(file = "data/counties.rds")



#USER INTERFACE
ui <- fluidPage(
  #title of the dashboard
  titlePanel(title = "US Census 2010"),
  
  #sidebar layout
  sidebarLayout(
    #side panel
    sidebarPanel(
      helpText("Create demographic maps with 
               information from the 2010 US Census."),
      #selecting Race (White, black, asian, hispanic)
      selectInput(inputId = "var",
                  label = "Choose a variable to display",
                  choices = list("Percent White", "Percent Black",
                                 "Percent Asian", "Percent Hispanic"),
                  selected = "Percent White"),
      
      #selecting range
      sliderInput(inputId = "range",
                  label = "Population % range:",
                  min = 0, max = 100, value = c(0,100))
    ),#end sidebar panel
    
    #main panel
    mainPanel(
      #plotting of map
      plotOutput(outputId = "map")
    )#end main panel
    
  )#end sidebar layout
)#end fluid page

#SERVER LOGIC
server <- function(input, output){
  
            output$map <- renderPlot({
              #create the user specific data variable
              data <- switch (input$var,
                              "Percent White" = census_data$white,
                              "Percent Black" = census_data$black,
                              "Percent Hispanic" = census_data$hispanic,
                              "Percent Asian" = census_data$asian
              )

              #setting color for each choice
              color_choice <- switch (input$var,
                                      "Percent White" = "midnightblue",
                                      "Percent Black" = "black",
                                      "Percent Hispanic" = "darkgreen",
                                      "Percent Asian" = "darkred"
              )

              #set legend titles for each option
              legend <- switch(input$var,
                               "Percent White" = "% White",
                               "Percent Black" = "% Black",
                               "Percent Asian" = "% Asian",
                               "Percent Hispanic" = "% Hispanic")
              
              #create map
              percent_map(var = data, legend.title = legend, color = color_choice,
                          min = input$range[1], max = input$range[2])
              
              ##SHORT VERSION OF ALL 3 ARGUMENTS ABOVE--
              
              # args <- switch(input$var,
              #                "Percent White" = list(census_data$white, "midnightblue", "% White"),
              #                "Percent Black" = list(census_data$black, "black", "% Black"),
              #                "Percent Asian" = list(census_data$asian, "darkorange", "% Asian"),
              #                "Percent Hispanic" = list(census_data$hispanic, "darkgreen", "% Hispanic"))
              # #for minimum and maximum range inputs
              # args$min <- input$range[1]
              # args$max <- input$range[2]
              # 
              # #call the function
              # do.call(percent_map, args)
              
  })
}

#CALL TO SHINY APP
shinyApp(ui = ui, server = server)
