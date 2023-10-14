
telecom <- read.csv("../../../data/eda/data_visualisation/telecom.csv", header = TRUE)
telecom$Age_Group <- factor(telecom$Age_Group, levels = c("18-30", "30-45", ">45"))


boxplot(
  telecom$Calls, 
  main = "Total Calls", 
  ylab = "Total Calls", 
  col = "cadetblue3"
)

boxplot(
  Calls ~ Age_Group, 
  data = telecom, 
  main = "Total Calls ~ Age Group", 
  xlab = "Age Group", 
  ylab = "Total Calls", 
  col = c("orange", "green", "cadetblue")
)

hist(
  telecom$AvgTime,
  breaks = 12,
  main = "Average Call Time",
  xlab = "Average Call Time",
  ylab = "No. of Customers",
  col = "darkorange"
)

telecom_d <- density(telecom$Amt)
head(telecom_d)

plot(
  telecom_d, 
  main = "Amount Density"
)
polygon(telecom_d, col = "yellowgreen")

stem(telecom$Calls)


library(RColorBrewer)
library(qcc)

telecom_s <- aggregate(Calls ~ Age_Group, data = telecom, FUN = sum)

pareto.chart(
  telecom_s$Calls, 
  main = "Pareto Chart: Age Group",
  xlab = "Age Groups",
  ylab = "Total Calls",
  col = brewer.pal(3, "Blues"),
  names = telecom_s$Age_Group
)
