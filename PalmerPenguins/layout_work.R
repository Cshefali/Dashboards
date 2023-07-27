library(shiny)
library(tidyverse)

# ui <- fluidPage(navbarPage(title = "Datos",
#                            tabPanel(title = "panel 1", 
#                                     sidebarLayout(
#                                       sidebarPanel(),
#                                       mainPanel())
#                            ), 
#                            tabPanel(title = "panel 2", 
#                                     sidebarLayout(
#                                       sidebarPanel(),
#                                       mainPanel()))
# ))

#------------

# ui <- fluidPage(navbarPage(title = "Datos",
#                            tabPanel(title = "panel 1", 
#                                     sidebarLayout(
#                                       sidebarPanel(),
#                                       mainPanel())
#                            ), 
#                            tabPanel(title = "panel 2", 
#                                     sidebarLayout(
#                                       sidebarPanel(),
#                                       mainPanel()))
# ),
# navbarPage(title = "shefali",
#            tabPanel(title = "shef1"),
#            tabPanel(title = "shef2"))
# )

#---------------

# ui <- navbarPage("App Title",
#                  tabPanel("Plot"),
#                  navbarMenu("More",
#                             tabPanel("Summary"),
#                             "----",
#                             "Section header",
#                             tabPanel("Table")
#                  )
# )
  

#--------

##Finally Desired UI !!!

ui <- fluidPage(
  
  titlePanel("Application Title"),
  
  navlistPanel(
    "Header",
    tabPanel("First",
             tabsetPanel(
             tabPanel("shef2"),
             tabPanel("shef2"))
             ),
    tabPanel("Second",
             tabsetPanel(
             tabPanel("shef3"),
             tabPanel("shef4")
                        )),
    tabPanel("Third",
             tabsetPanel(
             tabPanel("shef5"),
             tabPanel("shef6")
             )
            )
  )
)
  
  
server <- function(input, output){
  
}

shinyApp(ui = ui, server = server)

