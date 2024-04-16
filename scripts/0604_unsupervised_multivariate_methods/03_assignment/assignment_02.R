
# Principal Component Analysis Assignment
#
# BACKGROUND:
#
#   Birds belonging to different ecological groups have different appearances:
#   flying birds have strong wings and wading birds have long legs. Their
#   living habits are somewhat reflected in their bones' shapes.
#
#   As data scientists we may think of examining the underlying relationship
#   between sizes of bones and ecological groups , and recognising birds'
#   ecological groups by their bones' shapes.
#
#   Each bird is represented by 10 measurements (features):
#
#     - Length and Diameter of Humerus
#     - Length and Diameter of Ulna
#     - Length and Diameter of Femur
#     - Length and Diameter of Tibiotarsus
#     - Length and Diameter of Tarsometatarsus
#
#   All measurements are continuous float numbers (mm). The skeletons of this
#   dataset are collections of Natural History Museum of Los Angeles County.
#   They belong to 21 orders, 153 genera, 245 species.
#
#   Each bird has a label for its ecological group:
#     SW: Swimming Birds
#     W:  Wading Birds
#     T:  Terrestrial Birds
#     R:  Raptors
#     P:  Scansorial Birds
#     SO: Singing Birds



# 1. Import ‘Bird’ data in R.
data <- read.csv("./data/0604_unsupervised_multivariate_methods/03_assignment/Bird.csv", header = TRUE)
head(data)
#   id  huml humw ulnal ulnaw  feml femw  tibl tibw  tarl tarw type
# 1  0 80.78 6.68 72.01  4.88 41.81 3.70  5.50 4.03 38.70 3.84   SW
# 2  1 88.91 6.63 80.53  5.59 47.04 4.30 80.22 4.51 41.50 4.01   SW
# 3  2 79.97 6.37 69.26  5.28 43.07 3.90 75.35 4.04 38.31 3.34   SW
# 4  3 77.65 5.70 65.76  4.77 40.04 3.52 69.17 3.40 35.78 3.41   SW
# 5  4 62.80 4.84 52.09  3.73 33.95 2.72 56.27 2.96 31.88 3.13   SW
# 6  5 61.92 4.78 50.46  3.47 49.52 4.41 56.95 2.73 29.07 2.83   SW

sub_data <- subset(data, select = -c(id, type))

# it may not be necessary to scale the data - it may be managed by the 
# princomp function below
sub_data <- data.frame(scale(sub_data))



# 2. Summarise bird type using Principal Component Analysis. How many principal
#    components are required toexplain maximum variation in the data? Interpret
#    the component.
pc <- princomp(formula = ~., data = sub_data, cor = TRUE)
summary(pc)
# Importance of components:
#                           Comp.1     Comp.2     Comp.3     Comp.4      Comp.5      Comp.6      Comp.7      Comp.8     Comp.9      Comp.10
# Standard deviation     2.9228043 0.80949520 0.65251123 0.35234470 0.300755078 0.265592826 0.190599495 0.168596166 0.13784374 0.0852529498
# Proportion of Variance 0.8542785 0.06552825 0.04257709 0.01241468 0.009045362 0.007053955 0.003632817 0.002842467 0.00190009 0.0007268065
# Cumulative Proportion  0.8542785 0.91980673 0.96238382 0.97479850 0.983843865 0.990897820 0.994530637 0.997373104 0.99927319 1.0000000000

# looking at the above summary we can see that the 1st principal component
# explains 85% of variation, the 2nd principal component explains 6%, the 3rd
# principal component explains 4%, and so on. The 1st principal component
# explains most of the variation.

plot(pc, type = "lines")

# from the scree plot we can visually see that the 1st principal component is
# sufficient to explain most of the variation.

pc$loadings
# 
# Loadings:
#       Comp.1 Comp.2 Comp.3 Comp.4 Comp.5 Comp.6 Comp.7 Comp.8 Comp.9 Comp.10
# huml   0.317  0.228  0.476         0.205  0.145  0.193  0.151  0.321  0.628 
# humw   0.329  0.264               -0.205 -0.170  0.451 -0.687  0.186 -0.189 
# ulnal  0.308  0.308  0.479  0.405         0.152 -0.213        -0.316 -0.491 
# ulnaw  0.320  0.303        -0.414 -0.623 -0.163 -0.340  0.315               
# feml   0.320 -0.193 -0.323  0.561 -0.207 -0.179  0.380  0.451  0.124        
# femw   0.333        -0.219  0.150  0.236 -0.464 -0.288 -0.233 -0.488  0.416 
# tibl   0.315 -0.391  0.156 -0.467         0.160  0.433  0.148 -0.515        
# tibw   0.331 -0.129        -0.289  0.561 -0.298 -0.175  0.151  0.432 -0.377 
# tarl   0.281 -0.663  0.183  0.143 -0.280  0.221 -0.374 -0.314  0.238        
# tarw   0.305  0.212 -0.571         0.172  0.700 -0.112                      
# 
# Comp.1 Comp.2 Comp.3 Comp.4 Comp.5 Comp.6 Comp.7 Comp.8 Comp.9 Comp.10
# SS loadings       1.0    1.0    1.0    1.0    1.0    1.0    1.0    1.0    1.0     1.0
# Proportion Var    0.1    0.1    0.1    0.1    0.1    0.1    0.1    0.1    0.1     0.1
# Cumulative Var    0.1    0.2    0.3    0.4    0.5    0.6    0.7    0.8    0.9     1.0

# the loadings for the 1st principal component are very similar, which would
# imply that the 1st principal component is a general measure of the size of
# the bird's bones, resulting in a score - we are interested in this measure
# or score in relationship to the bird's environment.




# 3. Store the principal component scores as a new variable.
data$score <- pc$score[, 1]
head(data)
#   id  huml humw ulnal ulnaw  feml femw  tibl tibw  tarl tarw type       score
# 1  0 80.78 6.68 72.01  4.88 41.81 3.70  5.50 4.03 38.70 3.84   SW  0.47894708
# 2  1 88.91 6.63 80.53  5.59 47.04 4.30 80.22 4.51 41.50 4.01   SW  1.60694597
# 3  2 79.97 6.37 69.26  5.28 43.07 3.90 75.35 4.04 38.31 3.34   SW  1.04338307
# 4  3 77.65 5.70 65.76  4.77 40.04 3.52 69.17 3.40 35.78 3.41   SW  0.57431981
# 5  4 62.80 4.84 52.09  3.73 33.95 2.72 56.27 2.96 31.88 3.13   SW -0.32867154
# 6  5 61.92 4.78 50.46  3.47 49.52 4.41 56.95 2.73 29.07 2.83   SW  0.03533605



# 4. Find average values of the new variable for each bird type and interpret
#    the results.
score_by_type <- aggregate(score ~ type, data = data, FUN = mean)
score_by_type <- score_by_type[order(-score_by_type$score), ]
score_by_type
#   type      score
# 2    R  2.4179824
# 4   SW  1.8423457
# 6    W  0.4048822
# 5    T  0.1393812
# 1    P -1.6150454
# 3   SO -2.3993690

# the aggregation of average score by ecological group is ordered by the
# average score.

barplot(
  score_by_type$score,
  main = "average score by ecological group",
  names.arg = score_by_type$type,
  xlab = "ecological group",
  ylab = "average score",
  col = "cadetblue"
)

# the bar plot shows the average score by ecological group. We can see
# that raptors score the highest general score with respect to bone size,
# and singing birds score the lowest - raptors (or birds of prey) would
# need to be muscular in order to hunt and kill their prey, and hence
# would need larger and stronger bones (than a singing bird for example)
# to support such muscles.

round(cor(pc$scores))
#         Comp.1 Comp.2 Comp.3 Comp.4 Comp.5 Comp.6 Comp.7 Comp.8 Comp.9 Comp.10
# Comp.1       1      0      0      0      0      0      0      0      0       0
# Comp.2       0      1      0      0      0      0      0      0      0       0
# Comp.3       0      0      1      0      0      0      0      0      0       0
# Comp.4       0      0      0      1      0      0      0      0      0       0
# Comp.5       0      0      0      0      1      0      0      0      0       0
# Comp.6       0      0      0      0      0      1      0      0      0       0
# Comp.7       0      0      0      0      0      0      1      0      0       0
# Comp.8       0      0      0      0      0      0      0      1      0       0
# Comp.9       0      0      0      0      0      0      0      0      1       0
# Comp.10      0      0      0      0      0      0      0      0      0       1

# as expected, the correlation between principal components is 0, and the
# correlation of the principla component to itself is 1.

