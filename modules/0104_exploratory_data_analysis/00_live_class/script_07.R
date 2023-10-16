
library(ggplot2)
library(dplyr)



# 1
vas_data <- read.csv("../../../data/eda/live_class/VAS_DATA.csv", header = TRUE)
head(vas_data)



# 2
ggplot(vas_data, aes(x = Group, y = VAS_before)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Boxplot of VAS Before", y = "VAS Before")

boxplot(VAS_before ~ Group, data = vas_data, col = "cadetblue")



# 3
summary(vas_data)

func <- function(x) {
  c(
    n = length(x),
    mean = round(mean(x), 2),
    median = median(x),
    sd = round(sd(x), 2)
  )
}
aggregate(VAS_before ~ Group, data = vas_data, FUN = func)

vas_data %>%
  group_by(Group) %>%
  summarise(
    n = length(VAS_before),
    mean = round(mean(VAS_before), 2),
    median = round(median(VAS_before), 2),
    sd = round(sd(VAS_before), 2)
  ) %>%
  as.data.frame()



# 4
vas_data$Change <- vas_data$VAS_before - vas_data$VAS_after
head(vas_data)



# 5
ggplot(vas_data, aes(x = Group, y = Change)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Boxplot of Change by Group", y = "Change")

boxplot(Change ~ Group, data = vas_data, col = "cadetblue")



# 6
vas_data$Change_20 <- ifelse(vas_data$Change > 20, "Yes", "No")
head(vas_data)



# 7
table(vas_data$Change_20, vas_data$Group)



# 8
plot(
  vas_data$VAS_before, 
  vas_data$Change, 
  col = "cadetblue", 
  main = "Scatter Plot of VAS Before vs. Change", 
  xlab = "VAS Before", 
  ylab = "Change"
)



# 9 
cor(vas_data$VAS_before, vas_data$Change)
# 0.1296909 - weak positive correlation





