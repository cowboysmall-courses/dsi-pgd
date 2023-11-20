
library(boot)


data <- read.csv("../../../data/si/non_parametric_tests/boot\ data.csv", header = TRUE)

head(data)
summary(data)

f <- function(data, i) {
  
  d <- data[i,]
  m <- median(d)
  return(m)
}

boot_data <- boot(data = data, statistic = f, R = 1000) 

boot.ci(boot_data, type = "perc")
# BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
# Based on 1000 bootstrap replicates
# 
# CALL : 
#   boot.ci(boot.out = boot_data, type = "perc")
# 
# Intervals : 
#   Level     Percentile     
# 95%   ( 0.95,  1.90 )  
# Calculations and Intervals on Original Scale
