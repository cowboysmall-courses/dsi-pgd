
library(dplyr)
library(purrr)
library(ggplot2)
library(factoextra)


data <- read.csv("./data/0604_unsupervised_multivariate_methods/00_live_class/Customer\ Segments.csv", header = TRUE)
head(data)
#   Cust_ID Age BillAmt_Product BillAmt_Service BillAmt_Pre Vintage
# 1   82078  49        81128.27        48203.10    62975.45       5
# 2   57215  34        59480.20        17263.19    23633.58       5
# 3   66970  58        65363.07        30660.67    45888.87       6
# 4   77319  48        84073.28        47181.46    43186.04       7
# 5   29564  26        10541.03         3550.96    12753.15       1
# 6   40744  30        54889.43        17371.42    32344.42       3


dim(data)
# 24024     6


data <- na.omit(data)


dim(data)
# 24019     6


data_cl <- subset(data, select = -Cust_ID)
head(data_cl)
#   Age BillAmt_Product BillAmt_Service BillAmt_Pre Vintage
# 1  49        81128.27        48203.10    62975.45       5
# 2  34        59480.20        17263.19    23633.58       5
# 3  58        65363.07        30660.67    45888.87       6
# 4  48        84073.28        47181.46    43186.04       7
# 5  26        10541.03         3550.96    12753.15       1
# 6  30        54889.43        17371.42    32344.42       3


data_cl <- scale(data_cl) %>% as.data.frame()
head(data_cl)
#          Age BillAmt_Product BillAmt_Service  BillAmt_Pre    Vintage
# 1  0.7545411       1.1928128       1.8349670  1.654465212  0.5574361
# 2 -0.4604792       0.4661426      -0.1644493 -0.478878917  0.5574361
# 3  1.4835533       0.6636155       0.7013302  0.727931849  0.9703218
# 4  0.6735398       1.2916693       1.7689460  0.581368747  1.3832075
# 5 -1.1084900      -1.1766199      -1.0505687 -1.068878870 -1.0941067
# 6 -0.7844846       0.3120422      -0.1574552 -0.006526703 -0.2683353


wss <- function(k) { 
  kmeans(data_cl, k, iter.max = 1000)$tot.withinss
}

k_values <- 1:15

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


set.seed(123)


CL <- kmeans(data_cl, 4)
CL$size
# 4000 8051 7895 4073


data$segment <- CL$cluster
head(data)
#   Cust_ID Age BillAmt_Product BillAmt_Service BillAmt_Pre Vintage segment
# 1   82078  49        81128.27        48203.10    62975.45       5       3
# 2   57215  34        59480.20        17263.19    23633.58       5       1
# 3   66970  58        65363.07        30660.67    45888.87       6       3
# 4   77319  48        84073.28        47181.46    43186.04       7       3
# 5   29564  26        10541.03         3550.96    12753.15       1       2
# 6   40744  30        54889.43        17371.42    32344.42       3       4


allmean <- aggregate(cbind(Age, BillAmt_Product, BillAmt_Service, BillAmt_Pre, Vintage) ~ segment, data = data, FUN = mean)
allmean <- allmean %>% map(round, 2) %>% as.data.frame()
allmean
#   segment   Age BillAmt_Product BillAmt_Service BillAmt_Pre Vintage
# 1       1 37.51        42544.33        16038.35    30257.02    4.50
# 2       2 26.99        12576.65         3761.71    12575.10    1.00
# 3       3 54.97        82354.48        40049.61    55064.95    6.50
# 4       4 37.28        42594.78        15992.31    30140.83    2.52


ggplot(allmean, aes(x = segment, y = Age)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = Age), vjust = -0.5, color = "black", size = 3) +
  labs(x = "Cluster", y = "Age")

ggplot(allmean, aes(x = segment, y = BillAmt_Product)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = BillAmt_Product), vjust = -0.5, color = "black", size = 3) +
  labs(x = "Cluster", y = "BillAmt_Product")

ggplot(allmean, aes(x = segment, y = BillAmt_Pre)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = BillAmt_Pre), vjust = -0.5, color = "black", size = 3) +
  labs(x = "Cluster", y = "BillAmt_Pre")

ggplot(allmean, aes(x = segment, y = Vintage)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = Vintage), vjust = -0.5, color = "black", size = 3) +
  labs(x = "Cluster", y = "Vintage")
