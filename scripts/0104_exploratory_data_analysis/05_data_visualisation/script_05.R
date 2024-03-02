
tx_data <- read.csv("./data/0104_exploratory_data_analysis/05_data_visualisation/TelecomData_WeeklyData.csv", header = TRUE)

tx_trend <- aggregate(Calls ~ Week, data = tx_data, FUN = sum)

plot(tx_trend, main = "Total Calls", xlab = "Week", ylab = "No. Of Calls", type = "o", col = "red")
