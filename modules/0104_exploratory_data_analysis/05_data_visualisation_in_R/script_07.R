
library(ggplot2)

telecom <- read.csv("../../../data/eda/data_visualisation/telecom.csv", header = TRUE)
telecom$Age_Group <- factor(telecom$Age_Group, levels = c("18-30", "30-45", ">45"))
head(telecom)

class(telecom$Calls)
class(telecom$Age_Group)


# Simple Bar Chart
ggplot(telecom, aes(x = Age_Group, y = Calls)) + 
  geom_bar(stat = "identity", fill = "darkorange") + 
  labs(x = "Age Group", y = "Total Calls", title = "Simple Bar Chart - Age Group")

# Horizontal Bar Chart
ggplot(telecom, aes(x = Gender, y = Calls)) + 
  geom_bar(stat = "identity", fill = "cadetblue") + 
  labs(x = "Gender", y = "Total Calls", title = "Horizontal Bar Chart - Gender") + 
  coord_flip()

# Stacked Bar Chart
ggplot(telecom, aes(x = Age_Group)) + 
  geom_bar(aes(fill = Gender)) + 
  labs(x = "Age Group", y = "No. of Customers", title = "Stacked Bar Chart - Gender") + 
  scale_fill_manual(values = c("darkorange", "cadetblue"))

# Multiple Bar Chart 
ggplot(telecom, aes(x = Age_Group)) + 
  geom_bar(aes(fill = Gender), position = "dodge") + 
  labs(x = "Age Group", y = "No. of Customers", title = "Multiple Bar Chart - Age Group") + 
  scale_fill_manual(values = c("yellowgreen", "cadetblue"))

# Pie Chart
ggplot(telecom, aes(x = "", fill = Age_Group)) + 
  geom_bar(width = 1) + 
  coord_polar(theta = "y", start = pi / 3) + 
  labs(fill = "Age Group", title = "Pie Chart - Age Group") + 
  scale_fill_manual(values = c("darkorange", "yellowgreen", "cadetblue"))

# Box Plot
ggplot(telecom, aes(x = Age_Group, y = Calls)) + 
  geom_boxplot(fill = "darkorange", outlier.color = "midnightblue", outlier.size = 2.5) + 
  labs(x = "Age Group", y = "Total Calls", title = "Box Plot")

# Horizontal Boxplot 
ggplot(telecom, aes(x = Age_Group, y = Calls)) + 
  geom_boxplot(aes(fill = Gender)) + 
  labs(x = "Age Group", y = "Total Calls", title = "Horizontal Box Plot") + 
  scale_fill_manual(values = c("cadetblue", "yellowgreen")) + 
  coord_flip()

# Histogram
ggplot(telecom, aes(x = Calls)) + 
  geom_histogram(binwidth = 2, fill = "darkorange") + 
  labs(x = "Total Calls", y = "No. of Customers", title = "Histogram")

# Histogram
ggplot(telecom, aes(x = Calls)) + 
  geom_histogram(binwidth = 10, aes(fill = Age_Group)) + 
  labs(x = "Total Calls", y = "Age Group", title = "Histogram - Age Group", colour = "Age Group") + 
  scale_fill_manual(values = c("cadetblue", "yellowgreen", "darkorange"))


