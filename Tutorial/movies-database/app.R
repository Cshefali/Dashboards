#Shiny Dashboard for Movies DB from IMDB & Rotten Tomatoes
#Reference- https://shiny.posit.co/r/getstarted/build-an-app/hello-shiny/getting-started.html
#Author - Shefali C.

##Add CSS file to update the template of the dashboard

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

#add a new variable- summary score = audience score/critics score
movies <- movies %>% 
            mutate(score_ratio = audience_score/critics_score)

##USER INTERFACE
ui <- fluidPage(
        # tags$head(
        #   tags$style(HTML("
        #     .table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {
        #       padding: 8px;
        #       line-height: 1.42857143;
        #       vertical-align: top;
        #       border-top: 2px solid black; 
        #     }
        #   "))
        # ),
        
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
                               #title_type variable is of type factor, hence levels() used.
                               choices = levels(movies$title_type),
                               selected = levels(movies$title_type)),
            
            #box for numeric input
            numericInput(inputId = "sample_size", label = "Sample size:",
                         value = 300),
            
            #Action button to save as csv file
            actionButton(inputId = "write_file", label = "Write CSV")
            
          ),
          
          #Main Panel
          mainPanel(
            #scatter plot
            #brushing allows user to create rectangle in the plot and drag it around
            plotOutput(outputId = "scatterplot", brush = "plot_brush"),
            textOutput(outputId = "text"),
            #state the correlation coeffcient between selected variables
            #textOutput(outputId = "correlation"),
            br(),
            #data table output for brushed area
            dataTableOutput(outputId = "brush_table"),
            h3(strong("Interactive table using DT package")),
            DT::dataTableOutput(outputId = "dtable"),
            br(),
            h3(strong("Static Table with some filter features using Shiny package")),
            DT::dataTableOutput(outputId = "static_table"),
            br(),
            #adding a basic HTML table
            h3(strong("Basic HTML table using Shiny package")),
            h5(strong("#Editing in progress")),
            shiny::tableOutput(outputId = "shiny_table"),
            #Summary table
            h3(strong("Summary Table")),
            shiny::tableOutput(outputId = "sum_table")
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
    if(length(input$movie_type) > 1){
      paste("There are ", input$sample_size, " ", paste(input$movie_type, collapse = ", "), " movies in this dataset.")
    }
    else{
    paste("There are ", input$sample_size, " ", input$movie_type, " movies in this dataset.")
    }
    })#renderText
  
  
  # output$dtable <- DT::renderDataTable(
  #   data <- reactive({movies %>% sample_n(input$sample_size) %>% 
  #             filter(title_type %in% input$movies_type)})
  #   
  #   if(input$show_table){
  #     DT::datatable(data = data(),
  #                   options = list(pageLength = 5))
  #   }
  # )
  
  #Static table
  output$static_table <- DT::renderDataTable(
    DT::datatable(data = movies[1:3, 1:5])
  )
  
  output$shiny_table <- shiny::renderTable(
    movies[1:3,1:4]
  )
  
  #Summary table
  output$sum_table <- shiny::renderTable(
    {
    movies %>% filter(title_type %in% input$movie_type) %>% 
      group_by(mpaa_rating) %>% 
      summarize(mean_score_ratio = mean(score_ratio),
                sd = sd(score_ratio),
                n = n())
    },
    #this makes color of alternate rows different, white & grey
    striped = T,
    #set the height of the rows, 'l'-large, 's'-small
    spacing = "l",
    #left-right-center alignment of each value in the column 
    align = "lccr",
    #keep upto 4 decimal places
    digits = 4,
    #total width of the table
    width = "50%",
    caption = "Score ratio (audience / critics' scores) summary statistics by MPAA rating."
  )
  
  #Correlation coefficient
  # output$correlation <- renderTable({
  #   cor_coeff <- round(cor(x = movies[,input$x], y = movies[,input$y], use = "pairwise"),3)
  #   paste("Correlation = ", cor_coeff,"\n If correlation is closer to 1 or -1, relationship between the variables is linear.")
  # })
  
  output$brush_table <- renderDataTable({
    
    
    brushedPoints(df = movies, brush = input$plot_brush, xvar = input$x, yvar = input$y) %>% 
      select(title, title_type, mpaa_rating)
  })
}

#CALL TO SHINY APP
shinyApp(ui = ui, server =server)