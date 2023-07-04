#helper.R script- Used to create Chloropleth maps in Shiny app.
#URL- https://shiny.posit.co/r/getstarted/shiny-basics/lesson5/
#Date- July 4, 2023

##CHANGES MADE-
#cex = 0.8 is added to legend() function to scale down the legend size.
#Earlier, it overlapped with the US Map toward bottom left.

# Note: percent map is designed to work with the counties data set
# It may not work correctly with other data sets if their row order does 
# not exactly match the order in which the maps package plots counties


percent_map <- function(var, color, legend.title, min = 0, max = 100) {
  
  # generate vector of fill colors for map
  shades <- colorRampPalette(c("white", color))(100)
  
  # constrain gradient to percents that occur between min and max
  var <- pmax(var, min)
  var <- pmin(var, max)
  percents <- as.integer(cut(var, 100, 
                             include.lowest = TRUE, ordered = TRUE))
  fills <- shades[percents]
  
  # plot choropleth map
  map("county", fill = TRUE, col = fills, 
      resolution = 0, lty = 0, projection = "polyconic", 
      myborder = 0, mar = c(0,0,0,0))
  
  # overlay state borders
  map("state", col = "white", fill = FALSE, add = TRUE,
      lty = 1, lwd = 1, projection = "polyconic", 
      myborder = 0, mar = c(0,0,0,0))
  
  # add a legend
  inc <- (max - min) / 4
  legend.text <- c(paste0(min, " % or less"),
                   paste0(min + inc, " %"),
                   paste0(min + 2 * inc, " %"),
                   paste0(min + 3 * inc, " %"),
                   paste0(max, " % or more"))
  
  legend("bottomleft", 
         legend = legend.text, 
         fill = shades[c(1, 25, 50, 75, 100)], 
         title = legend.title,
         #adding this argument. In original script, the legend created 
         #overlapped with lower left of US map. Hence, the modification.
         #cex is used to scale up/down the legend size.
         cex = 0.8)
}