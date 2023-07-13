#Shiny Dashboard for Movies DB from IMDB & Rotten Tomatoes
#Reference- https://shiny.posit.co/r/getstarted/build-an-app/hello-shiny/getting-started.html
#Author - Shefali C.

library(shiny)
library(tidyverse)
library(DT)

# working_dir <- paste0(getwd(),"/movies-database")
# setwd(working_dir)

# 
# #Fetch data
# data_url <- "https://github.com/rstudio-education/shiny-course/raw/main/movies.RData"
# destination_path <- paste0(working_dir,"/data")
# 
# #download the file from URL
# download.file(url = data_url, 
#               destfile = paste0(destination_path,"/movies.RData"))

#load data.
load("data/movies.Rdata")

#select relevant columns for the data-table in dashboard.
movies_table <- movies %>% 
                  select(title, title_type, genre, runtime,
                         mpaa_rating, studio, thtr_rel_date)

##USER INTERFACE
ui <- fluidPage(
        
        #title of the dashboard window
        titlePanel(title = "Movie browser"),
        
        #sidebar Layout
        sidebarLayout(
          #side panel
          sidebarPanel(
            #Drop-down selection for Y-axis variable
            selectInput(inputId = "y", label = "Y-axis:",
                        choices = list("IMDB rating",
                                       "IMDB number of votes",
                                       "Critics Score",
                                       "Audience Score",
                                       "Runtime"),
                        selected = "Audience Score"),
            
            #Drop-down selection for X-axis variable
            selectInput(inputId = "x", label = "X-axis:",
                        choices = list("IMDB rating",
                                       "IMDB number of votes",
                                       "Critics Score",
                                       "Audience Score",
                                       "Runtime"),
                        selected = "Critics Score"),
            
            #Drop-down box to select group for scatter plot color
            selectInput(inputId = "color", label = "Color by:",
                        choices = list("Title Type", "Genre", "MPAA Rating",
                                       "Critics Rating", "Audience Rating"),
                        selected = "MPAA Rating"),
            
            #Slider bar for color transparency 'alpha'
            sliderInput(inputId = "alpha", label = "Alpha:",
                        min = 0, max = 1, value = 0.5, step = 0.1),
            
            #Slider bar for Size of points
            sliderInput(inputId = "size", label = "Size:",
                        min = 0, max = 5, value = 2, step = 1),
            
            #Check box for data table
            checkboxInput(inputId = "show_table", label = "Show data table",
                          value = TRUE),
            
            #Text input to set the title of plot
            textInput(inputId = "title", label = "Plot title",
                      value = "Audience Score vs. IMDB Rating"),
            
            #Checkbox group for selecting movie type
            checkboxGroupInput(inputId = "movie_type", label = "Select movie type(s)",
                               choices = list("Documentary", "Feature Film", "TV Movie"),
                               selected = "Feature Film"),
            
            #box for numeric input
            numericInput(inputId = "sample_size", label = "Sample size:",
                         value = 300),
            
            #Action button to save as csv file
            actionButton(inputId = "write_file", label = "Write CSV")
            
          ),
          
          #Main Panel
          mainPanel(
            #scatter plot
            plotOutput(outputId = "scatterplot"),
            textOutput(outputId = "text"),
            br(),
            DT::dataTableOutput(outputId = "dtable"),
            br(),
            DT::dataTableOutput(outputId = "static_table")
          )
        )
        
    
)#fluidpage

#SERVER 
server <- function(input, output){
  
  output$scatterplot <- renderPlot({
    
    data_x <- switch (input$x,
                      "IMDB rating" = movies$imdb_rating,
                      "IMDB number of votes" = movies$imdb_num_votes,
                      "Critics Score" = movies$critics_score,
                      "Audience Score" = movies$audience_score,
                      "Runtime" = movies$runtime
    )
    
    data_y <- switch(input$y,
                     "IMDB rating" = movies$imdb_rating,
                     "IMDB number of votes" = movies$imdb_num_votes,
                     "Critics Score" = movies$critics_score,
                     "Audience Score" = movies$audience_score,
                     "Runtime" = movies$runtime)
    
    point_color <- switch (input$color,
                           "Title Type" = movies$title_type, 
                           "Genre" = movies$genre, 
                           "MPAA Rating" = movies$mpaa_rating,
                           "Critics Rating" = movies$critics_rating, 
                           "Audience Rating" = movies$audience_rating)
    
    ggplot(data = movies, aes(x = data_x, y = data_y))+
      geom_point(aes(col = point_color), alpha = input$alpha)+
      labs(x = input$x, y = input$y,
           title = paste(input$y, " vs.", input$x))
  })
  
  output$text <- renderText({
    paste("There are ", input$sample_size, " ", input$movie_type, " movies in this dataset.")
  })
  
  
  output$dtable <- DT::renderDataTable(
    if(input$show_table){
      DT::datatable(data = movies_table %>% filter(title_type %in% input$movie_type),
                    options = list(pageLength = 10))
    }
  )
  
  #Static table
  output$static_table <- DT::renderDataTable(
    DT::datatable(data = movies[1:3, 1:5])
  )
}

#CALL TO SHINY APP
shinyApp(ui = ui, server =server)