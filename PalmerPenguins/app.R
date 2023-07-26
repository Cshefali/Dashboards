#Dashboard for Palmer penguins
#Author- Shefali C.
#Last Update- July 26, 2023

##Blog Help- https://clarewest.github.io/blog/post/making-tables-shiny/
##Font-awesome icon library Help:
#https://stackoverflow.com/questions/66014722/why-are-the-icons-not-displaying-in-a-dtdatatable-in-shiny-app#:~:text=The%20font%2Dawesome%20library%20is,the%20icon%20does%20not%20display.&text=If%20you%20really%20want%20a,in%20your%20app%2C%20without%20as.

#Highlighted row color-
#https://datatables.net/blog/2022-05-13#Row-colouring-improvements

#load libraries
library(tidyverse)
library(shiny)
library(DT)
library(palmerpenguins)

if(!require(shinyjqui)) { install.packages("shinyjqui")}

library(shinyjqui)

#data
penguins <- palmerpenguins::penguins
colnames(penguins) <- gsub(pattern = "_mm",replacement = "",colnames(penguins))

#User INterface
# ui <- basicPage(
#   h3("Palmer Penguins table using DT and Formattable packages"),
#   DT::dataTableOutput(outputId = "group_view")
#   
# )


##Source of js below:
#https://stackoverflow.com/questions/65424976/r-shiny-getting-information-from-datatable-with-js-in-shiny

# js <- c(
#   "table.on('column-reorder', function (e, settings, details) {",
#   "  Shiny.setInputValue('order', details.mapping);",
#   "});"
# )

ui <- fluidPage(
  #title panel
  titlePanel(title = "Table Styling"),
  #change color of selected row to pink
  #tags$style(HTML('table.dataTable tr.selected td, table.dataTable tr.selected {box-shadow: inset 0 0 0 9999px pink !important;}')),
  #mainPanel
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      h3("Palmer Penguins table using DT and Formattable packages"),
      DT::dataTableOutput(outputId = "group_view")
    )
  )
)

server <- function(input, output){
  output$group_view <- DT::renderDataTable({
    datatable(data = penguins,
              #class = 'cell-border stripe',
              #class = 'row-border',
              class = 'compact row-border stripe cell-border hover',
              #class = 'compact row-border stripe hover',
              options = list(
                #function to change color of the column header
                initComplete = JS(
                  "function(settings, json) {",
                  "$(this.api().table().header()).css({'background-color': '#fff', 'color': '#000'});",
                  "}"),
                #change bill_depth row to currency format.
                rowCallback = JS(
                  "function(row, data) {",
                  "var num = '$' + data[5].toString().replace(/\\B(?=(\\d{5})+(?!\\d))/g, ',');",
                  "$('td:eq(5)', row).html(num);",
                  "}"),
                #change font to georgia--NOt working
                initComplete = JS(
                  "function(settings, json) {",
                  "$('body').css({'font-family': 'Georgia'});",
                  "}"
                ),
                #function for column reordering
                #callback = JS(js),
                paging = TRUE,
                #default length of each page
                pageLength = 10,
                #option for number of rows to display- 5, 10, 15 or 20 rows.
                lengthMenu = c(5,10,15,20),
                scrollX = TRUE,
                scrollY = TRUE,
                #keeping autowidth false solves the problem of 
                #mis-aligned column header and table body
                autoWidth = FALSE,
                server = TRUE,
                dom = 'lfrtBip',
                #dom = 'Bfrtip',
                #change seach box title from "Search" to "Filter"
                language = list(search = 'Filter:'),
                buttons = list('print',
                               #Download button with 3 format options
                               list(extend = 'collection',
                                    buttons = c('csv','excel','pdf'),
                                    text = 'Download'),
                               #button for column visibility; columns 1 and 2 fixed
                               list(extend = 'colvis',
                                    columns = 2:7)),
                #Column visibility button
                #buttons = I('colvis'),
                #order the table in descending order of bill length
                order = list(list(6,'desc')),
                #highlight search results
                searchHighlight = TRUE,
                #user can reorder the columns
                ColReorder = TRUE,
                #fixing some columns (another argument--rightColumns = xx)
                fixedColumns = list(leftColumns = 2),
                #fix the column headers when scrolling down
                fixedHeader = TRUE,
                #enable moving around cells using keys
                keys = TRUE,
                #Remove the sorting arrows--Does not work, both
                #ordering = F,
                #bSort = F,
                #create a scroller for large tables
                #deferRender = TRUE,
                #scroller = TRUE,
                #applying some column options, make all columns center aligned
                columnDefs = list(
                                  #center adjust values in all columns
                                  list(targets = '_all', className = 'dt-center'),
                                  #set width of columns 3 to 6.
                                  list(targets = c(3,4,5,6), width = "30px"))
                                  #list(targets = c(0, 8, 9), visible = FALSE))
            ),#options
            callback = JS("table.order([5, 'desc']).draw();"),
            #adds 'csv' and 'excel' download buttons.
            #Responsive collapses the columns when window size reduced.
            extensions = c('Buttons','ColReorder','FixedHeader','KeyTable',
                           'Responsive'),
            #adds capability of click & select any row; default- 'multiple'
            selection = 'single',
            #add/remove a search box below/above ('top', 'bottom') each column of table
            filter = 'none',
            #removes the row index or name, if any from LHS
            rownames = FALSE
            )   #datatable
      ##below fomratStyles do not work!!
      #formatStyle(fontWeight = "bold")
      #formatCurrency(columns = 'body_mass_g')
  })#output$dtable
  
}#server

shinyApp(ui = ui, server = server)
