
library(arules)
library(arulesViz)

data("Groceries")

rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.15, minlen = 2), appearance = list(default = "rhs", lhs = "whole milk"), control = list(verbose = FALSE))

rules <- sort(rules, by = "confidence", decreasing = TRUE)

inspect(rules[1:5])
#     lhs             rhs                support confidence coverage lift count
# [1] {whole milk} => {other vegetables} 0.075   0.29       0.26     1.5  736  
# [2] {whole milk} => {rolls/buns}       0.057   0.22       0.26     1.2  557  
# [3] {whole milk} => {yogurt}           0.056   0.22       0.26     1.6  551  
# [4] {whole milk} => {root vegetables}  0.049   0.19       0.26     1.8  481  
# [5] {whole milk} => {tropical fruit}   0.042   0.17       0.26     1.6  416 

rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.15, minlen = 2), appearance = list(default = "rhs", lhs = "whole milk"), control = list(verbose = FALSE))

plot(rules, method = "graph", interactive = TRUE)
