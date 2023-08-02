#Demo of fluidRow() with a bit more complexity.
#Author- Shefali C.
#Last modified- August 3, 2023

#Source- https://shiny.posit.co/r/articles/build/layout-guide/
#Image template in the folder- complex_fluidrow_template.png

library(shiny)
library(dplyr)
library(ggplot2)

data1 <- diamonds