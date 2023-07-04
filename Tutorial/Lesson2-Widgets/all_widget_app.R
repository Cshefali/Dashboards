#Topic- Adding Widgets
#URL- https://shiny.posit.co/r/getstarted/shiny-basics/lesson3/
#Author- Shefali C.
#Date- July 4, 2023

library(shiny)

#USER INTERFACE
ui <- fluidPage(
  
  #title
  titlePanel(title = "Basic Widgets"),
  
  ##ROW 1
  fluidRow(
    #COLUMN 1
    column(width = 3,
           h3("Buttons"),
           #button with label "Action"
           actionButton(inputId = "action", label = "Action"),
           #creates space between Action and submit button
           br(),
           br(),
           #button with label "Submit"
           actionButton(inputId = "submit", label = "Submit")
           ), #column 1
    
    #COLUMN 2- one checkbox
    column(width = 3,
           h3("Single checkbox"),
           checkboxInput(inputId = "choice", label = "Choice A", value = TRUE)
           ),
    #COLUMN 3- group of checkboxes
    column(width = 3, 
           checkboxGroupInput(inputId = "check_group",
                              label = h3("Checkbox group"),
                              choices = list("Choice 1" = 1, 
                                             "Choice 2" = 2, 
                                             "Choice 3" = 3),
                              selected = 1)),
    #COLUMN 4
    column(width = 3,
           dateInput(inputId = "single_date", label = h3("Date input"),
                     value = "2000-01-01"))
  ),
  
  #ROW 2
  fluidRow(
    #COLUMN 1
    column(width = 3,
           dateRangeInput(inputId = "date_range",
                          label = h3("Date range"),
                          start = "2000-01-01",
                          startview = "year")
           ),
    #COLUMN 2
    column(width = 3,
           fileInput(inputId = "file_input",
                     label = h3("File input"),
                     #multiple files can be selected same time
                     multiple = TRUE,
                     buttonLabel = "Browse")
           ),
    #COLUMN 3
    column(width = 3,
           helpText(
           h3("Help text", style = "color:black"),
           "Note: help text isn't a true
            widget, but it provides an easy
            way to add text to accompany
                    other widgets.", style = "color:black")
           ),
    #COLUMN 4
    column(width = 3,
           numericInput(inputId = "num_input",
                        label = h3("Numeric input"),
                        value = 0)
           )
  ),#row 2 ends
  
  #ROW 3
  fluidRow(
    #COLUMN 1
    column(width = 3,
           radioButtons(inputId = "radio_buttons",
                        label = h3("Radio buttons"),
                        choices = list("Choice 1" = 1,
                                       "Choice 2" = 2,
                                       "Choice 3" = 3),
                        selected = 1)
           #buttons can be placed in same line using inline = T
           ),
    #COLUMN 2
    column(width = 3,
           selectInput(inputId = "state",
                       label = h3("Choose a state:"),
                       choices = list(
                         `North India` = list("J&K", "HP", "UK"),
                         `South India` = list("TN", "MH", "AP"),
                         `East India` = list("MZ", "NG", "ASM")
                       ))
          ),#column 2 ends
    
    #COLUMN 3
    column(width = 3,
           h3("Sliders"),
           #only one movable end
           sliderInput(inputId = "slider1",
                       label = NULL,
                       min = 0,
                       max = 100,
                       value = 20
                       ),
           #slider with both movable ends
           sliderInput(inputId = "slider2",
                       label = NULL,
                       min = 0,
                       max = 100,
                       value = c(20, 75)
                       )
    ),#column ends
    
    #COLUMN 4
    column(width = 3,
           textInput(inputId = "text",
                     label = h3("Text input"),
                     value = "Enter text...")
           )#column ends
    )#row ends

  )#fluid page layout ends
server <- function(input, output){
  
}

shinyApp(ui = ui, server = server)