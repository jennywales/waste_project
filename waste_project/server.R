server <- function(input, output) {
    
    #Create waste by time plot
    output$time_plot <- renderPlot({
        period_breakdown %>%
            filter(county_name == input$authority_time) %>%
            ggplot() +
            aes(x = period_ID, y = tonnes.by.material, fill = period_ID) +
            geom_col() +
            scale_y_continuous(labels = scales::comma) +
            scale_fill_brewer(palette = "Set1") +
            labs(title = "Material Processed over Time", 
                 x = "Period", y = "Material (tonnes)", fill = "Period") +
            theme(title = element_text(size = 20, face = "bold"),
                  axis.title = element_text(size = 15, face = "bold"),
                  axis.text = element_text(size = 13),
                  legend.text = element_text(size = 14))
         }, height = 600)
    
    #Create map with facilities and county selection
    output$county_map <- renderLeaflet({
        
        waste_new %>%
            filter(county_name == input$authority) %>%
            filter(is.leaf.level == FALSE) %>%
            filter(level == input$level) %>%
            leaflet() %>% 
            addTiles() %>% 
            addProviderTiles(providers$OpenStreetMap) %>% 
            addPolygons(data = wales[wales$name == input$authority, ], fill = input$authority, stroke = TRUE, color = "red") %>%
            addMarkers(clusterOptions = markerClusterOptions(), label = ~as.character(facility.name))
 
        
    })
    
    #Create map with material selection
    output$material_map <- renderLeaflet({
        leaflet() %>%
            # Adding Tiles
            addTiles() %>%
            
            addMarkers(data = comingled_recyclate, 
                       group = "Comingled recyclate", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>%
            addMarkers(data = food_waste, 
                       group = "Food waste", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>% 
            addMarkers(data = mixed_green_and_food_waste, 
                       group = "Mixed green & food waste", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>%
            addMarkers(data = green_waste, 
                       group = "Green waste", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>% 
            addMarkers(data = source_segregated_recyclate, 
                       group = "Source segregated recyclate", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>%
            addMarkers(data = residual_waste, 
                       group = "Residual waste", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>%  
            
            
            # Layers control
            addLayersControl(
                overlayGroups = c("Comingled recyclate",
                                  "Food waste",
                                  "Mixed green & food waste",
                                  "Green waste",
                                  "Source segregated recyclate",
                                  "Residual waste"),
                options = layersControlOptions(collapsed = FALSE)
            )
        
    })
    
    #Create outliers and boxplots
    output$outliers <- renderPlot({
        waste_postcodes_latlong %>%
            drop_na(county_name) %>%
            ggplot() + aes(reorder(county_name, tonnes.by.material, na.rm = TRUE), tonnes.by.material) + 
            geom_boxplot(outlier.size = 2) + 
            ylab("Tonnes") +
            xlab("Welsh Authority") +
            ggtitle("Waste Tonnage by Authority") +
            theme(plot.title = element_text(size = 20, face = "bold"),
                  axis.title = element_text(size = 17),
                  axis.text = element_text(size = 15)) +
            coord_flip()
    })
    
    output$outliers_three_authorities <- renderPlot({
        waste_postcodes_latlong %>%
        drop_na(material) %>%
        filter(county_name %in% c("Flintshire", "Wrexham", "Cardiff"),
               tonnes.by.material > quantile(tonnes.by.material, 0.95, na.rm = TRUE)) %>%
        ggplot() + aes(reorder(material, tonnes.by.material, na.rm = TRUE), tonnes.by.material, fill = county_name) + 
        geom_boxplot() +
        facet_wrap(~county_name) +
        scale_fill_brewer(palette = "Set1") +
        theme(legend.position = "none", 
              strip.text.x = element_text(size = 18, face = "bold"),
              panel.spacing = unit(2, "lines"),
              axis.title = element_text(size = 17, face = "bold"),
              axis.text = element_text(size = 15)) +
        xlab("Material Type") +
        ylab("Tonnes") +
        coord_flip()
        
    })
    
    #Create world map
    output$world_map <- renderPlot({
        mapCountryData(countries_map, nameColumnToPlot = "Name", catMethod = "categorical",
                       missingCountryCol = grey(.8), colourPalette = c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"))
    }, height = 700)
    
    #Create plot comparing waste to population for each county
    output$population_plot <- renderPlot({
        pop_and_waste %>%
            ggplot() +
            aes(x = reorder(county_name, total_tonnes_by_material),county_name, y = total_tonnes_by_material, total_tonnes_by_material, fill = population) +
            geom_col() +
            scale_y_continuous(labels = scales::comma) +
            scale_fill_continuous(labels = scales::comma) +
            coord_flip() +
            ggtitle("Comparison of council areas by waste and population") +
            labs(
                x = "\nCounty",
                y = "Tonnes by material",
                title = "Comparison of council areas by waste and population",
                fill = "Population",
                caption = "Population data taken from Office of Nation Statistics\n Estimates of the population for the UK, England and Wales, Scotland and Northern Ireland 2018") +
            theme(title = element_text(size = 20, face = "bold"),
            axis.title = element_text(size = 15, face = "bold"),
            axis.text = element_text(size = 13),
            legend.text = element_text(size = 14),
            plot.caption = element_text(size = 12))
        
    }, height = 600)
    
}





