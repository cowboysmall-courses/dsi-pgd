
# library(dplyr)
# library(caret)
# library(ROCR)
# library(e1071)
# library(car)
# library(partykit)
# library(randomForest)

library(arules)
library(arulesViz)


data("Groceries")


itemFrequencyPlot(Groceries, topN = 10, type = "absolute", main = "Item Frequency")


itemFrequencyPlot(Groceries, topN = 10, type = "relative", col = "darkcyan", main = "Top Ten Items by Relative Frequency")


rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.8))
# Apriori
# 
# Parameter specification:
#  confidence minval smax arem  aval originalSupport maxtime support minlen maxlen target  ext
#         0.8    0.1    1 none FALSE            TRUE       5   0.001      1     10  rules TRUE
# 
# Algorithmic control:
#  filter tree heap memopt load sort verbose
#     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
# 
# Absolute minimum support count: 9 
# 
# set item appearances ...[0 item(s)] done [0.00s].
# set transactions ...[169 item(s), 9835 transaction(s)] done [0.00s].
# sorting and recoding items ... [157 item(s)] done [0.00s].
# creating transaction tree ... done [0.00s].
# checking subsets of size 1 2 3 4 5 6 done [0.01s].
# writing ... [410 rule(s)] done [0.00s].
# creating S4 object  ... done [0.00s].

options(digits = 2)
inspect(rules[1:5])
#     lhs                         rhs            support confidence coverage lift count
# [1] {liquor, red/blush wine} => {bottled beer} 0.0019  0.90       0.0021   11.2 19   
# [2] {curd, cereals}          => {whole milk}   0.0010  0.91       0.0011    3.6 10   
# [3] {yogurt, cereals}        => {whole milk}   0.0017  0.81       0.0021    3.2 17   
# [4] {butter, jam}            => {whole milk}   0.0010  0.83       0.0012    3.3 10   
# [5] {soups, bottled beer}    => {whole milk}   0.0011  0.92       0.0012    3.6 11   


rules <- sort(rules, by = "lift", decreasing = TRUE)
inspect(rules[1:5])
#     lhs                                                              rhs               support confidence coverage lift count
# [1] {liquor, red/blush wine}                                      => {bottled beer}    0.0019  0.90       0.0021   11.2 19   
# [2] {citrus fruit, other vegetables, soda, fruit/vegetable juice} => {root vegetables} 0.0010  0.91       0.0011    8.3 10   
# [3] {tropical fruit, other vegetables, whole milk, yogurt, oil}   => {root vegetables} 0.0010  0.91       0.0011    8.3 10   
# [4] {citrus fruit, grapes, fruit/vegetable juice}                 => {tropical fruit}  0.0011  0.85       0.0013    8.1 11   
# [5] {other vegetables, whole milk, yogurt, rice}                  => {root vegetables} 0.0013  0.87       0.0015    8.0 13   




rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.15, minlen = 2), appearance = list(default = "rhs", lhs = "whole milk"), control = list(verbose = FALSE))

rules <- sort(rules, by = "confidence", decreasing = TRUE)
inspect(rules[1:5])
#     lhs             rhs                support confidence coverage lift count
# [1] {whole milk} => {other vegetables} 0.075   0.29       0.26     1.5  736  
# [2] {whole milk} => {rolls/buns}       0.057   0.22       0.26     1.2  557  
# [3] {whole milk} => {yogurt}           0.056   0.22       0.26     1.6  551  
# [4] {whole milk} => {root vegetables}  0.049   0.19       0.26     1.8  481  
# [5] {whole milk} => {tropical fruit}   0.042   0.17       0.26     1.6  416  


plot(rules, method = "graph", engine = "interactive")




