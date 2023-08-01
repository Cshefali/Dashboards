library(tidyverse)
library(palmerpenguins)
library(shiny)
library(DT)

penguins <- palmerpenguins::penguins

#total missing values in each column
#View(rbind(colSums(is.na(penguins))))

#remove rows with missing values in sex column
penguins <- penguins[-which(is.na(penguins$sex)),]

#glimpse(penguins)

##--AGGREGATE DATA PER ISLAND----------

#total species per island
species_count <- penguins %>% 
  group_by(island, species) %>% 
  summarise(total = n())

#pivot the data wider
species_count_wide <- species_count %>% 
  pivot_wider(names_from = 'species',
              values_from = 'total',
              #substitue NA with 0
              values_fill = 0)

#total male and female penguins per island.
gender_count1 <- penguins %>% 
  group_by(island,sex) %>% 
  summarise(total = n())

#gender count per island in wide format
gender_count1_wide <- gender_count1 %>% 
  pivot_wider(names_from = 'sex',
              values_from = 'total')

#combining gender count & species count dataframes
island_summary <- left_join(species_count_wide, gender_count1_wide, by = 'island')

##AGGREGATE DATA PER SPECIES----

#total number of each species per island.
island_count <- penguins %>% 
  group_by(species, island) %>% 
  summarise(total = n())

#species per island count in wide format
island_count_wide <- island_count %>% 
  pivot_wider(names_from = 'island',
              values_from = 'total',
              values_fill = 0)

#gender count per species
gender_count2 <- penguins %>% 
  group_by(species, sex) %>% 
  summarise(total = n())

#gender count 2 wide
gender_count2_wide <- gender_count2 %>% 
  pivot_wider(names_from = 'sex',
              values_from = 'total')

#combine both dataframes
species_summary <- left_join(island_count_wide, gender_count2_wide,
                             by = 'species')

#summary statistics of body measurements for each species
species_aggregate <- penguins %>% 
                      select(-c(sex, island, year)) %>% 
                      group_by(species) %>% 
                      summarize_at(vars(bill_length_mm,bill_depth_mm,
                                        flipper_length_mm, body_mass_g),
                                   list(m = mean))

#renaming columns in species_aggregate
colnames(species_aggregate) <- c("species", 
                                 "mean bill length (mm)",
                                 "mean bill depth (mm)", 
                                 "mean flipper length (mm)",
                                 "mean body mass (g)"
                                 )

#Shiny app

#user interface
ui <- fluidPage(
  titlePanel(title = "Palmer Penguins Dashboard"),
  navbarPage("Navbar!",
             tabPanel("Plot",
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("plotType", "Plot type",
                                       c("Scatter"="p", "Line"="l")
                          )
                        ),
                        mainPanel(
                          plotOutput("plot")
                        )#mainPanel
                      )#sidebar layout
             ),#tabpanel 1
             tabPanel("Summary",
                      verbatimTextOutput("summary")
             ),#tabpanel 2
             navbarMenu("More",
                        tabPanel("Table",
                                 DT::dataTableOutput("table")
                        ),
                        tabPanel("About",
                                 fluidRow(
                                   column(6,
                                          includeMarkdown("about.md")
                                   ),
                                   column(3,
                                          img(class="img-polaroid",
                                              src=paste0("http://upload.wikimedia.org/",
                                                         "wikipedia/commons/9/92/",
                                                         "1919_Ford_Model_T_Highboy_Coupe.jpg")),
                                          tags$small(
                                            "Source: Photographed at the Bay State Antique ",
                                            "Automobile Club's July 10, 2005 show at the ",
                                            "Endicott Estate in Dedham, MA by ",
                                            a(href="http://commons.wikimedia.org/wiki/User:Sfoskett",
                                              "User:Sfoskett")
                                          )
                                   )
                                 )
                        )#last tabPanel
             )#navbarMenu
  )#Navbarpage
)#fluidpage


#server
server <- function(input, output){
  
}

#call to shiny App
shinyApp(ui = ui, server = server)