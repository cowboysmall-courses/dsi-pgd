
library(gmodels)


test_data <- read.csv("../../../data/si/live_class/Recruitment\ Source.csv", header = TRUE)

head(test_data)
summary(test_data)

CrossTable(test_data$performance, test_data$source, chisq = TRUE)
