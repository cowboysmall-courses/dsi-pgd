
retail_data <- read.csv("../../../data/eda/descriptive_statistics/Retail_Data.csv", header = TRUE)

library(e1071)

skewness(retail_data$Growth, type = 2)
kurtosis(retail_data$Growth, type = 2)

f <- function(x) c(skew = skewness(x, type = 2), kurt = kurtosis(x, type = 2))
aggregate(Growth ~ Zone, data = retail_data, FUN = f)
