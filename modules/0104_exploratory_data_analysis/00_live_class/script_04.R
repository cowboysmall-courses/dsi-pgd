
library(tidyverse)


emp_data <- read.csv("../../../data/live_class/EMPLOYEE\ ENGAGEMENT\ DATA.csv", header = TRUE)


head(emp_data)
dim(emp_data)


boxplot(emp_data$EESCORE)


ggplot(emp_data, aes(y = EESCORE)) + 
  geom_boxplot(fill = "skyblue") + 
  labs(title = "Boxplot of EESCORE Summary Statistics", y = "EESCORE")


ggplot(emp_data, aes(x = GENDER, y = EESCORE)) + 
  geom_boxplot(fill = "skyblue") + 
  labs(title = "Boxplot of EESCORE Summary Statistics by GENDER", x = "GENDER", y = "EESCORE")


ggplot(emp_data, aes(x = DEPT, y = EESCORE)) + 
  geom_boxplot(aes(fill = GENDER)) + 
  labs(title = "Boxplot of EESCORE Summary Statistics by GENDER & DEPT", x = "DEPT", y = "EESCORE")


hist(emp_data$EESCORE, main = "Overall Distribution of EESCORE")


mean_GD  <- aggregate(EESCORE ~ GENDER + DEPT, data = emp_data, FUN = mean)
ggplot(mean_GD, aes(GENDER, DEPT, fill = EESCORE)) + 
  geom_tile() + 
  geom_text(aes(label = round(EESCORE, 2)), vjust = 1) + 
  scale_fill_gradient(low = "lightgreen", high = "darkgreen") + 
  labs(title = "")


plot(emp_data$EESCORE, emp_data$EXP)


ggplot(emp_data, aes(x = EXP, y = EESCORE)) + geom_point() + geom_smooth()


qplot(EXP, EESCORE, data = emp_data, color = GENDER)


median_FB <- emp_data %>% group_by(DEPT) %>% summarise(FEEDBACK = median(FEEDBACK)) 
ggplot(median_FB, aes(x = DEPT, y = FEEDBACK)) + geom_bar(stat = "identity", fill = "skyblue")


ggplot(median_FB, aes(x = DEPT, y = FEEDBACK)) + geom_col(fill = "skyblue")






