
library(arules)
library(arulesViz)

trans <- read.transactions("./data/0804_machine_learning_02/03_association_rule/data_mba.csv", format = "single", sep = ",", cols = c("id", "item"), header = TRUE)

itemFrequencyPlot(trans, topN = 5, type = "absolute")

rules <- apriori(trans, parameter = list(supp = 0.001, conf = 0.8))
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
# Absolute minimum support count: 0 
# 
# set item appearances ...[0 item(s)] done [0.00s].
# set transactions ...[5 item(s), 100 transaction(s)] done [0.00s].
# sorting and recoding items ... [5 item(s)] done [0.00s].
# creating transaction tree ... done [0.00s].
# checking subsets of size 1 2 3 4 5 done [0.00s].
# writing ... [5 rule(s)] done [0.00s].
# creating S4 object  ... done [0.00s].

inspect(rules[1:5])
#     lhs             rhs support confidence coverage lift     count
# [1] {A, D}       => {C} 0.25    0.8064516  0.31     1.260081 25   
# [2] {A, D, E}    => {C} 0.11    0.8461538  0.13     1.322115 11   
# [3] {A, B, E}    => {C} 0.10    0.8333333  0.12     1.302083 10   
# [4] {A, B, D}    => {C} 0.16    0.8421053  0.19     1.315789 16   
# [5] {A, B, D, E} => {C} 0.06    1.0000000  0.06     1.562500  6


