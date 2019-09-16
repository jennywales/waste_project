library(shiny)

ui <- fluidPage(
    
    theme = shinytheme("readable"),
    
    titlePanel("Team Waste Dashboard"),
    
    tabsetPanel(
        
        tabPanel("UK Map of Facilities", 
                 
                 fluidRow("This tab allows users to select an authority and examine which facilities
                          each county sends its waste to. Users can also select which level of
                          facility to examine, with each level indicating how many facilites waste
                          has travelled to. For example facilities at level 7 recieve waste
                          which has been at 6 other facilities before being processed there."),
                 
                    fluidRow(
                        column(6, selectInput("authority", "Which authority?", 
                                           choices = all_authority_names)),
                 
                    column(6, checkboxGroupInput("level", "Which levels of facility?", 
                                       choices = all_facility_levels, 
                                       selected = 1:7, inline = TRUE)),
                     
                     leafletOutput("county_map", height = 700)
                     
                 )),
        
        tabPanel("UK Map of Materials", 
                 
                 fluidRow("This tab allows users to examine where different types of
                          waste materials are being processed."),
                 
                 leafletOutput("material_map", height = 700)),
        
        tabPanel("Waste vs Population (Welsh Authorities)",
                 
                 fluidRow("This tab plots the waste produced by each authority against 
                          the population of each authority. While Cardiff has both the
                          highest population and waste produced, other authorities have 
                          differing levels, demonstrating that population may not entirely
                          effect how much waste is produced."),
                 
                 plotOutput("population_plot")),
                
        tabPanel("Waste by Quarter", 
                 
                 fluidRow("This tab allows users to select a county and see the amount
                          of waste produced over time. The time period of the data ranges
                          from April 2017 to March 2018."),
                 
                 fluidRow(
                     column(3, selectInput("authority_time", "Which authority?", 
                                           choices = all_authority_names)),
                     
                     column(9, plotOutput("time_plot"))
                 )
                ),
        
        tabPanel("Material Outliers by Welsh Authorities",
                 
                fluidRow("This tab shows boxplots of waste produced for each authority,
                         so that users can see outliers. There are also boxplots divided 
                         by material type for the three authorities with significant outliers,
                         so that users can see trends in material type."),
                 
                fluidRow(plotOutput("outliers")),
                 
                 
                fluidRow(plotOutput("outliers_three_authorities"))
                 ),
        
        tabPanel("Waste Destinations outside the UK",
                 
                 fluidRow("This tab shows a map of the countries where waste is sent
                          from Wales to be processed."),
                 
                 plotOutput("world_map"))

        )
    
)     
       
        
        
        


        



