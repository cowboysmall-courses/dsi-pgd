
library(factoextra)
library(fpc)
library(flexclust)


data <- read.csv("./data/0604_unsupervised_multivariate_methods/02_cluster_analysis/K\ MEANS\ DATA.csv", header = TRUE)
head(data)
#   Custid     nsv n_brands n_bills growth region
# 1   1001 2119456        7      14  -1.79 Mumbai
# 2   1002 1460163       12      42  -1.73 Mumbai
# 3   1003  147976        4       6   2.81 Mumbai
# 4   1004 1350474       13      30  -0.99  Delhi
# 5   1005 1414461       15      29  13.56  Delhi
# 6   1006 2299185       21      49  11.07  Delhi


data_cl <- subset(data, select = c(-Custid, -region))


data_cl <- scale(data_cl)


CL <- kmeans(data_cl, 4)
CL
# K-means clustering with 4 clusters of sizes 210, 229, 405, 314
# 
# Cluster means:
#          nsv    n_brands    n_bills      growth
# 1  1.0589762  1.50534917  1.6219927  1.62282815
# 2  1.1863778 -0.02444231  0.3044816 -0.62581250
# 3 -0.8311329 -0.84045295 -0.7207329 -0.53153606
# 4 -0.5014544  0.09508729 -0.3772226  0.05665368
# 
# Within cluster sum of squares by cluster:
# [1] 732.8205 314.9123 166.3279 145.5306
#  (between_SS / total_SS =  70.6 %)
# 
# Available components:
# 
# [1] "cluster"      "centers"      "totss"        "withinss"     "tot.withinss"
# [6] "betweenss"    "size"         "iter"         "ifault"   


data$segment <- CL$cluster
head(data)
#   Custid     nsv n_brands n_bills growth region segment
# 1   1001 2119456        7      14  -1.79 Mumbai       2
# 2   1002 1460163       12      42  -1.73 Mumbai       2
# 3   1003  147976        4       6   2.81 Mumbai       3
# 4   1004 1350474       13      30  -0.99  Delhi       2
# 5   1005 1414461       15      29  13.56  Delhi       1
# 6   1006 2299185       21      49  11.07  Delhi       1


aggregate(cbind(nsv, n_brands, n_bills, growth) ~ segment, data = data, FUN = mean)
#   segment       nsv  n_brands   n_bills    growth
# 1       1 1875311.4 24.238095 48.619048 12.275762
# 2       2 1985624.2 11.532751 24.532751  1.836419
# 3       3  238729.4  4.755556  5.790123  2.274099
# 4       4  524186.9 12.525478 12.070064  5.004777


fviz_nbclust(data_cl, kmeans, method = "wss")


CL1 <- kmeansruns(data_cl,krange = 2:10)
CL1$bestk
# 2


kmedian <- kcca(data_cl, 3, family = kccaFamily("kmedian"))
kmedian
# kcca object of family ‘kmedians’ 
# 
# call:
# kcca(x = data_cl, k = 3, family = kccaFamily("kmedian"))
# 
# cluster sizes:
# 
#   1   2   3 
# 523 402 233 


data$seg_median <- kmedian@cluster
head(data)

