
library(ggplot2)
library(GGally)
library(dplyr)


data <- read.csv("./data/0604_unsupervised_multivariate_methods/04_case_study/Sporting\ Goods\ Sales\ Data.csv", header = TRUE)
head(data)
#   Region City_Code Sales_B1 Growth_B1 Sales_B2 Growth_B2 Sales_B3 Growth_B3
# 1   EAST       281    45.46      5.87    52.71      5.79    40.18      4.70
# 2   EAST       282    46.15      6.38    53.54      4.97    41.68      4.11
# 3   EAST       283    21.83      3.71    26.66      1.78    20.68      1.79
# 4   EAST       284    49.64      7.04    59.05      4.98    43.00      4.70
# 5   EAST       285    37.55      5.32    40.22      3.99    34.75      3.30
# 6   EAST       286    38.37      5.99    44.61      4.75    36.16      3.35
#   Sales_B4 Growth_B4 Sales_B5 Growth_B5
# 1    56.87      4.71    31.81      3.14
# 2    57.26      5.17    31.63      4.59
# 3    29.28      1.73    16.32      2.77
# 4    54.31      3.12    27.33      3.10
# 5    42.96      3.74    25.48      3.58
# 6    49.32      3.77    27.64      3.05


dim(data)
# 384  12


sub_data <- subset(data, select = -c(Region, City_Code))
cor(sub_data)
#            Sales_B1 Growth_B1  Sales_B2 Growth_B2  Sales_B3 Growth_B3  Sales_B4
# Sales_B1  1.0000000 0.9035556 0.9766930 0.8504517 0.7675832 0.8154070 0.8259007
# Growth_B1 0.9035556 1.0000000 0.8878535 0.9083478 0.8501619 0.8813590 0.8043728
# Sales_B2  0.9766930 0.8878535 1.0000000 0.8397925 0.7551729 0.8027523 0.7578874
# Growth_B2 0.8504517 0.9083478 0.8397925 1.0000000 0.8013830 0.8390718 0.7721576
# Sales_B3  0.7675832 0.8501619 0.7551729 0.8013830 1.0000000 0.9081431 0.8590093
# Growth_B3 0.8154070 0.8813590 0.8027523 0.8390718 0.9081431 1.0000000 0.8277393
# Sales_B4  0.8259007 0.8043728 0.7578874 0.7721576 0.8590093 0.8277393 1.0000000
# Growth_B4 0.8314605 0.8640162 0.7802320 0.8206764 0.8671611 0.8963683 0.8950528
# Sales_B5  0.6932055 0.6582148 0.6465255 0.6211279 0.8314281 0.7417905 0.9207339
# Growth_B5 0.7353399 0.8506590 0.7243517 0.8272188 0.8493350 0.8424836 0.7205446
#           Growth_B4  Sales_B5 Growth_B5
# Sales_B1  0.8314605 0.6932055 0.7353399
# Growth_B1 0.8640162 0.6582148 0.8506590
# Sales_B2  0.7802320 0.6465255 0.7243517
# Growth_B2 0.8206764 0.6211279 0.8272188
# Sales_B3  0.8671611 0.8314281 0.8493350
# Growth_B3 0.8963683 0.7417905 0.8424836
# Sales_B4  0.8950528 0.9207339 0.7205446
# Growth_B4 1.0000000 0.7907915 0.8047264
# Sales_B5  0.7907915 1.0000000 0.5908798
# Growth_B5 0.8047264 0.5908798 1.0000000


ggpairs(sub_data)


sub_data <- data.frame(scale(sub_data))
pc <- princomp(formula = ~., data = sub_data, cor = T)
summary(pc)
# Importance of components:
#                           Comp.1     Comp.2     Comp.3     Comp.4     Comp.5
# Standard deviation     2.8811426 0.81393075 0.66197987 0.39586981 0.37945612
# Proportion of Variance 0.8300983 0.06624833 0.04382173 0.01567129 0.01439869
# Cumulative Proportion  0.8300983 0.89634658 0.94016831 0.95583961 0.97023830
#                            Comp.6      Comp.7      Comp.8      Comp.9
# Standard deviation     0.34961613 0.269059690 0.237440198 0.187720349
# Proportion of Variance 0.01222314 0.007239312 0.005637785 0.003523893
# Cumulative Proportion  0.98246144 0.989700755 0.995338540 0.998862433
#                            Comp.10
# Standard deviation     0.106656783
# Proportion of Variance 0.001137567
# Cumulative Proportion  1.000000000


pc$loadings
# Loadings:
#           Comp.1 Comp.2 Comp.3 Comp.4 Comp.5 Comp.6 Comp.7 Comp.8 Comp.9
# Sales_B1   0.320  0.227  0.473  0.108         0.215                0.185
# Growth_B1  0.329  0.270                             -0.791  0.318 -0.286
# Sales_B2   0.312  0.315  0.470  0.369                0.183 -0.199       
# Growth_B2  0.316  0.305        -0.547 -0.432 -0.474  0.251 -0.166       
# Sales_B3   0.323 -0.201 -0.305  0.427 -0.116 -0.275 -0.287 -0.437  0.461
# Growth_B3  0.326        -0.242  0.187  0.541 -0.422  0.360  0.443       
# Sales_B4   0.319 -0.386  0.163 -0.303 -0.138  0.215         0.433  0.543
# Growth_B4  0.326 -0.134        -0.444  0.572  0.284        -0.497 -0.110
# Sales_B5   0.285 -0.657  0.187  0.125 -0.275                      -0.580
# Growth_B5  0.303  0.212 -0.575  0.165 -0.289  0.581  0.230  0.101 -0.143
#           Comp.10
# Sales_B1   0.722 
# Growth_B1        
# Sales_B2  -0.606 
# Growth_B2        
# Sales_B3         
# Growth_B3        
# Sales_B4  -0.290 
# Growth_B4        
# Sales_B5   0.118 
# Growth_B5        

#                Comp.1 Comp.2 Comp.3 Comp.4 Comp.5 Comp.6 Comp.7 Comp.8 Comp.9
# SS loadings       1.0    1.0    1.0    1.0    1.0    1.0    1.0    1.0    1.0
# Proportion Var    0.1    0.1    0.1    0.1    0.1    0.1    0.1    0.1    0.1
# Cumulative Var    0.1    0.2    0.3    0.4    0.5    0.6    0.7    0.8    0.9
#                Comp.10
# SS loadings        1.0
# Proportion Var     0.1
# Cumulative Var     1.0


data$Performance <- pc$score[, 1]
head(data)
#   Region City_Code Sales_B1 Growth_B1 Sales_B2 Growth_B2 Sales_B3 Growth_B3
# 1   EAST       281    45.46      5.87    52.71      5.79    40.18      4.70
# 2   EAST       282    46.15      6.38    53.54      4.97    41.68      4.11
# 3   EAST       283    21.83      3.71    26.66      1.78    20.68      1.79
# 4   EAST       284    49.64      7.04    59.05      4.98    43.00      4.70
# 5   EAST       285    37.55      5.32    40.22      3.99    34.75      3.30
# 6   EAST       286    38.37      5.99    44.61      4.75    36.16      3.35
#   Sales_B4 Growth_B4 Sales_B5 Growth_B5   performance
# 1    56.87      4.71    31.81      3.14  3.279055e-05
# 2    57.26      5.17    31.63      4.59  1.463733e-01
# 3    29.28      1.73    16.32      2.77 -2.730300e+00
# 4    54.31      3.12    27.33      3.10 -1.958801e-01
# 5    42.96      3.74    25.48      3.58 -9.992057e-01
# 6    49.32      3.77    27.64      3.05 -7.466795e-01


plot(pc, type = "lines")


aggregate(Performance ~ Region, data = data, FUN = length)
#   Region Performance
# 1   EAST         147
# 2  NORTH         149
# 3  SOUTH          49
# 4   WEST          39


summary_pc_region <-  aggregate(Performance ~ Region, data = data, FUN = mean)
summary_pc_region
#   Region Performance
# 1   EAST  -1.8684400
# 2  NORTH   1.0270717
# 3  SOUTH   0.3352235
# 4   WEST   2.6974628

barplot(
  summary_pc_region$Performance, 
  main = "Average Performance by Region", 
  names.arg = summary_pc_region$Region, 
  xlab = "Region", 
  ylab = "Average Performance", 
  col = "cadetblue"
)



summary_pc_region <- data %>%
  group_by(Region) %>%
  summarize(Performance = round(mean(Performance), 3)) %>%
  as.data.frame()
summary_pc_region
#   Region Performance
# 1   EAST      -1.868
# 2  NORTH       1.027
# 3  SOUTH       0.335
# 4   WEST       2.697


ggplot(summary_pc_region, aes(x = Region, y = Performance, fill = Region)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Performance by Region", x = "Region", y = "Average Performance") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  scale_fill_brewer(palette = "Set2")

