
library(ggplot2)

demo_data <- read.csv("./data/0104_exploratory_data_analysis/05_data_visualisation/TelecomData_CustDemo.csv", header = TRUE)
tx_data <- read.csv("./data/0104_exploratory_data_analysis/05_data_visualisation/TelecomData_WeeklyData.csv", header = TRUE)

w_data <- merge(demo_data, tx_data, by = ("CustID"), all = TRUE)
head(w_data)

w_data$Age_Group <- cut(w_data$Age, breaks = c(0, 30, 45, Inf), labels = c("18-30", "30-45", ">45"))
t_data <- aggregate(Calls ~ Week + Age_Group, data = w_data, FUN = sum)

ggplot(t_data, aes(x = Week, y = Calls, colour = Age_Group)) + 
  geom_line(linewidth = 1) + 
  geom_point(size = 3) + 
  labs(y = "Calls", title = "Trend Line")
