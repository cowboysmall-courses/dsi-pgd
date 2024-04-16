
# Cluster Analysis Assignment
# 
# BACKGROUND:
# 
#   Marketing team of ABC Bank is running a campaign for credit card on the
#   existing customers. Marketing team wants to understand the segments of
#   the customers to target based on the Minimum and Maximum Balances,
#   Monthly Income, age of the customer, association of the customer with
#   bank (in years).


library(purrr)
library(fpc)



# 1. Import Customer data in R.
data <- read.csv("./data/0604_unsupervised_multivariate_methods/03_assignment/Customer\ data.csv", header = TRUE)
data <- na.omit(data)
head(data)
#   Cust_Id   City age MonthlyIncome MinBal MaxBal Age.with.Bank
# 1   10015 Mumbai  27         12880   2742  11425             1
# 2   10016   Pune  25         11612   2982  12370             1
# 3   10017 Mumbai  28         15614   3510  14144             1
# 4   10018 Mumbai  29         19278   4088  10179             1
# 5   10019 Nashik  27         15281   4134  10051             1
# 6   10020 Nashik  28         19230   2779  11457             1



# 2. Subset the data excluding Customer id and City.
data_cl <- subset(data, select = -c(Cust_Id, City))



# 3. Scale the variables.
data_cl <- scale(data_cl)



# 4. Run kmeans on the scaled variable with 3 clusters.
model_cl <- kmeans(data_cl, 3)

data$segment <- model_cl$cluster
head(data)
#   Cust_Id   City age MonthlyIncome MinBal MaxBal Age.with.Bank segment
# 1   10015 Mumbai  27         12880   2742  11425             1       2
# 2   10016   Pune  25         11612   2982  12370             1       2
# 3   10017 Mumbai  28         15614   3510  14144             1       2
# 4   10018 Mumbai  29         19278   4088  10179             1       2
# 5   10019 Nashik  27         15281   4134  10051             1       2
# 6   10020 Nashik  28         19230   2779  11457             1       2



# 5. Obtain mean of original variables for each cluster.
aggregate(cbind(age, MonthlyIncome, MinBal, MaxBal, Age.with.Bank) ~ segment, data = data, FUN = mean)
#   segment      age MonthlyIncome    MinBal   MaxBal Age.with.Bank
# 1       1 27.01120      12499.41  3744.163 12547.47      1.000333
# 2       2 37.45155      42471.37 15995.790 30039.13      3.502184
# 3       3 54.96779      82430.55 39981.618 54980.39      6.499173



# 6. Interpret the clusters.
# 
# Three clusters:
# 
#   Cluster 1: age ~27, the lowest average monthly income, minimum balance, 
#              maximum balance, and are with the bank the shortest time
#   Cluster 2: age ~37, the middle average monthly income, minimum balance, 
#              maximum balance, and are with the bank for approximately 3.5 years
#   Cluster 3: age ~54, the highest average monthly income, minimum balance, 
#              maximum balance, and are with the bank the longest average time
# 
#   Cluster 3 look like the most relevant segment due to their high incomes 
#   and considerable minimum balance followed by Cluster 2. Cluster 1 may very
#   likely default on credit card debt due to the small amount of funds they 
#   seem to have on hand



# 7. Obtain plot of WSS (Within Sum of Squares) to check number of clusters.

# This function can cause resource issues:
# 
# fviz_nbclust(data_cl, kmeans, method = "wss")
# 
# so instead take the below approach 

wss <- function(k) {

  CL <- kmeans(data_cl, k, iter.max = 1000)
  CL$tot.withinss
}

k_values <- 1:10

wss_values <- map_dbl(k_values, wss)

plot(
  k_values,
  wss_values,
  type = "b",
  pch = 19,
  frame = FALSE,
  xlab = "Number of clusters K",
  ylab = "Total within-clusters sum of squares"
)

# We can see from the plot that the appropriate number of clusters is around 3.


cl <- kmeansruns(data_cl, krange = 2:10)
cl$bestk
# 3

# The above function runs kmeans over the specified range to evaluate the best
# number of clusters - and the result agrees with what we have seen from the
# above plot.

