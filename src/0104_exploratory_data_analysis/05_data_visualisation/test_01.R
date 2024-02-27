

telecom <- read.csv("./data/0104_exploratory_data_analysis/05_data_visualisation/telecom.csv", header = TRUE)


library(ggplot2)


# a class mate had an issue with the below code:
# ggplot(telecom, aes(x - Age_Group, y = Calls)) +
#   geom_bar(stat = "identity", fill = "darkorange") +
#   labs(x = "Age Groups", y = "Total Calls", title = "Fig. No. 1 : Simple Bar Diagram(Age Group)")
#
# the issue was in the first line:
#   ggplot(telecom, aes(x - Age_Group, y = Calls)) +
# should have been:
#   ggplot(telecom, aes(x = Age_Group, y = Calls)) +
#
ggplot(telecom, aes(x = Age_Group, y = Calls)) +
  geom_bar(stat = "identity", fill = "darkorange") +
  labs(x = "Age Groups", y = "Total Calls", title = "Fig. No. 1 : Simple Bar Diagram(Age Group)")
