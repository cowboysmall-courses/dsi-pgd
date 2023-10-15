
library(ggplot2)



# 1
demo_data <- read.csv("../../../data/eda/live_class/TelecomData_CustDemo.csv", header = TRUE)
weekly_data <- read.csv("../../../data/eda/live_class/TelecomData_WeeklyData.csv", header = TRUE)


head(demo_data)
head(weekly_data)


tx_data <- aggregate(Calls ~ CustID, data = weekly_data, FUN = sum)
head(tx_data)


work_data <- merge(demo_data, tx_data, by = ('CustID'), all = TRUE)
head(work_data)


work_data$age_group <- cut(work_data$Age, breaks = c(0, 30, 45, Inf), labels = c("18-30", "30-45", ">45"))
head(work_data)


ggplot(work_data, aes(x = age_group)) + geom_bar()



ggplot(work_data, aes(x = age_group, y = Calls)) +
  geom_bar(stat = "identity", fill = "orange") +
  labs(x = "Age Groups", y = "Total Calls", title = "Bar Chart") +
  coord_flip()


ggplot(work_data, aes(x = age_group)) +
  geom_bar(aes(fill = Gender)) +
  labs(x = "Gender", y = "No. of Customers", title = "Stacked Bar Chart")


ggplot(work_data, aes(x = age_group)) +
  geom_bar(aes(fill = Gender), position = "dodge") +
  labs(x = "Gender", y = "No. of Customers", title = "Multiple Bar Chart")


ggplot(work_data, aes(x = "", y = Calls)) +
  geom_boxplot() +
  labs(y = "Total Calls", title = "Box Plot")


ggplot(work_data, aes(x = age_group, y = Calls)) +
  geom_boxplot() +
  labs(x = "Age Group", y = "Total Calls", title = "Box Plot")


ggplot(work_data, aes(x = age_group, y = Calls)) +
  geom_boxplot(fill = 5, outlier.color = "blue", outlier.size = 2.5) +
  labs(x = "Age Group", y = "Total Calls", title = "Box Plot")


ggplot(work_data, aes(x = age_group, y = Calls)) +
  geom_boxplot(aes(fill = Gender)) +
  labs(x = "Age Group", y = "Total Calls", title = "Box Plot")


ggplot(work_data, aes(x = Calls)) +
  geom_histogram(binwidth = 40, fill = "maroon") +
  labs(x = "Total Calls", y = "No. of Customers", title = "Customer Usage")
