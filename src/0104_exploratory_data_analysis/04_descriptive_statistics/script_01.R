
retail_data <- read.csv("./data/0104_exploratory_data_analysis/descriptive_statistics/Retail_Data.csv", header = TRUE)
summary(retail_data)

boxplot(retail_data$Perindex, data = retail_data, main = "Boxplot (Perindex)", ylab = "Perindex", col = "red")
boxplot(retail_data$Growth, data = retail_data, main = "Boxplot (Growth)", ylab = "Growth", col = "blue")

mean(retail_data$Perindex, na.rm = TRUE)
mean(retail_data$Growth, na.rm = TRUE)

mean(retail_data$Perindex, 0.05, na.rm = TRUE)
mean(retail_data$Growth, 0.05, na.rm = TRUE)

mean(retail_data$Perindex, 0.10, na.rm = TRUE)
mean(retail_data$Growth, 0.10, na.rm = TRUE)

median(retail_data$Perindex, na.rm = TRUE)
median(retail_data$Growth, na.rm = TRUE)

table(retail_data$Zone)

range_p <- range(retail_data$Perindex, na.rm = TRUE)
diff(range_p)

range_g <- range(retail_data$Growth, na.rm = TRUE)
diff(range_g)

IQR(retail_data$Perindex, na.rm = TRUE)
IQR(retail_data$Growth, na.rm = TRUE)

sd(retail_data$Perindex, na.rm = TRUE)
sd(retail_data$Growth, na.rm = TRUE)

var(retail_data$Perindex, na.rm = TRUE)
var(retail_data$Growth, na.rm = TRUE)

sd(retail_data$Perindex, na.rm = TRUE) / mean(retail_data$Perindex, na.rm = TRUE)
sd(retail_data$Growth, na.rm = TRUE) / mean(retail_data$Growth, na.rm = TRUE)
