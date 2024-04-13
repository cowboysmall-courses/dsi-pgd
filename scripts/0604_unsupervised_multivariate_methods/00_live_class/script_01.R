
library(factoextra)
library(fpc)


data <- read.csv("./data/0604_unsupervised_multivariate_methods/00_live_class/K\ MEANS\ DATA.csv", header = TRUE)
head(data)
#   Custid     nsv n_brands n_bills growth region
# 1   1001 2119456        7      14  -1.79 Mumbai
# 2   1002 1460163       12      42  -1.73 Mumbai
# 3   1003  147976        4       6   2.81 Mumbai
# 4   1004 1350474       13      30  -0.99  Delhi
# 5   1005 1414461       15      29  13.56  Delhi
# 6   1006 2299185       21      49  11.07  Delhi


data_cl  <- scale(subset(data, select = c(-Custid, -region)))
clusters <- kmeans(data_cl, 4)


data$segment <- clusters$cluster
head(data)
#   Custid     nsv n_brands n_bills growth region segment
# 1   1001 2119456        7      14  -1.79 Mumbai       1
# 2   1002 1460163       12      42  -1.73 Mumbai       1
# 3   1003  147976        4       6   2.81 Mumbai       2
# 4   1004 1350474       13      30  -0.99  Delhi       1
# 5   1005 1414461       15      29  13.56  Delhi       4
# 6   1006 2299185       21      49  11.07  Delhi       4


aggregate(cbind(nsv, n_brands, n_bills, growth) ~ segment, data = data, FUN = mean)
#   segment       nsv  n_brands   n_bills    growth
# 1       1 1985624.2 11.532751 24.532751  1.836419
# 2       2  238729.4  4.755556  5.790123  2.274099
# 3       3  524186.9 12.525478 12.070064  5.004777
# 4       4 1875311.4 24.238095 48.619048 12.275762


fviz_nbclust(data_cl, kmeans, method = "wss")


clusters <- kmeansruns(data_cl, krange = 2:10)
clusters$bestk

