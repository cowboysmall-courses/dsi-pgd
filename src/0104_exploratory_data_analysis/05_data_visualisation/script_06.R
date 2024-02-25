
# this will not work as no browsers support flash

library(googleVis)

sales_data <- read.csv("./data/0104_exploratory_data_analysis/data_visualisation/Sales\ Data\ (Motion\ Chart).csv", header = TRUE)

sales_mchart <- gvisMotionChart(sales_data, idvar = "Region", timevar = "Year")
plot(sales_mchart)
