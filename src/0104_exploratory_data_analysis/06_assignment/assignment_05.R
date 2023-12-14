
# Jerry Kiely
# Data Science Institute
# Data Visualisation in R 
# EDA T5 Assignment




library(plotly)
library(ggplot2)




# 1 Import data and merge it by POLICY_NO
Premiums <- read.csv("../../../data/0104_exploratory_data_analysis/assignment/Premiums.csv", header = TRUE)
Claims <- read.csv("../../../data/0104_exploratory_data_analysis/assignment/Claims.csv", header = TRUE)
Insurance <- merge(Premiums, Claims, by = ("POLICY_NO"), all = TRUE)

head(Insurance)

# Turn ZONE_NAME, Plan, and Sub_Plan into factors
Insurance$ZONE_NAME <- factor(Insurance$ZONE_NAME, level = unique(Insurance$ZONE_NAME))
Insurance$Plan <- factor(Insurance$Plan, level = unique(Insurance$Plan))
Insurance$Sub_Plan <- factor(Insurance$Sub_Plan, level = unique(Insurance$Sub_Plan))




# 2 Bar Chart of Mean Premium by Zone
i_data <- aggregate(Premium ~ ZONE_NAME, data = Insurance, FUN = mean)

ggplot(i_data, aes(x = ZONE_NAME, y = Premium)) + 
  geom_bar(stat = "identity", fill = "darkorange") + 
  labs(x = "Zone", y = "Mean Premiums", title = "Bar Chart - Mean Premiums by Zone")




# 3 Stacked Bar Chart of Zone over Sub Plan 
ggplot(Insurance, aes(x = Sub_Plan)) + 
  geom_bar(aes(fill = ZONE_NAME)) + 
  labs(x = "Sub Plan", y = "Premium Counts", title = "Stacked Bar Chart - Zone over Sub Plan") + 
  scale_fill_manual(values = c("darkorange", "cadetblue", "yellowgreen"))

# 3.1 Stacked Bar Chart of Sub Plan over Zone 
ggplot(Insurance, aes(x = ZONE_NAME)) + 
  geom_bar(aes(fill = Sub_Plan)) + 
  labs(x = "Zone", y = "Premium Counts", title = "Stacked Bar Chart - Sub Plan over Zone") + 
  scale_fill_manual(values = c("darkorange", "cadetblue", "yellowgreen", "lightblue"))




# 4 Heat Map of Plan and Zone with mean Premium
j_data <- aggregate(Premium ~ Plan + ZONE_NAME, data = Insurance, FUN = mean)

plot_ly(
  j_data, 
  x = j_data$Plan, 
  y = j_data$ZONE_NAME, 
  z = j_data$Premium, 
  type = "heatmap",
  connectgaps = FALSE,
  showscale = TRUE
)




# 5 Pie Chart of Premium counts across Sub Plans
ggplot(Insurance, aes(x = "", fill = Sub_Plan)) + 
  geom_bar(width = 1) + 
  coord_polar(theta = "y", start = pi / 3) + 
  labs(fill = "Sub Plan", title = "Pie Chart - Sub Plan") + 
  scale_fill_manual(values = c("darkorange", "yellowgreen", "cadetblue", "lightblue"))
