#Demo of fluidRow() with a bit more complexity.
#Author- Shefali C.
#Last modified- August 3, 2023

#Source- https://shiny.posit.co/r/articles/build/layout-guide/
#Image template in the folder- complex_fluidrow_template.png

library(shiny)
library(dplyr)
library(ggplot2)

data1 <- diamonds

#User interface
ui <- fluidPage(
  #titlePanel(title = "Diamonds Dataset"),
  
    #facet grid plot
    plotOutput(outputId = "diamond"),
    #fluidRow section
    fluidRow(
      column(3,
             h4(strong("Diamonds Explorer")),
             
             sliderInput(inputId = "sample_size",
                         label = "Sample Size",
                         min = 1,
                         max = nrow(diamonds),
                         value = 1000,
                         step = 500),
             
             #checkbox for Jitter plot
             checkboxInput(inputId = "jitter_plot",
                           label = "Jitter",
                           value = F),
             
             #checkbox for Smooth
             checkboxInput(inputId = "smooth_plot",
                           label = "Smooth",
                           value = F)
             ),#column 1
      column(4, 
             selectInput(inputId = "var1", label = "X",
                         label = "X",
                         choices = colnames(diamonds)),
             selectInput(inputId = "var2", label = "Y",
                         choices = colnames(diamonds), selected = "cut"),
             selectInput(inputId = "color", label = "Color",
                         selected = c('None',names(diamonds)))
             ),#column 2
      column(4,
             selectInput())
    )#fluidRow
    
  
)