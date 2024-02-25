
library(plotly)

heatmap_data <- read.csv("./data/0104_exploratory_data_analysis/data_visualisation/Average\ Temperatures\ in\ NY.csv", header = TRUE)
heatmap_data$Month <- factor(heatmap_data$Month, level = unique(heatmap_data$Month))

plot_ly(
  heatmap_data, 
  x = heatmap_data$Month, 
  y = heatmap_data$Year, 
  z = heatmap_data$Temperature, 
  type = "heatmap",
  connectgaps = FALSE,
  showscale = TRUE
)
