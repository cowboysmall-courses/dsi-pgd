#Background: The food delivery app company conducted a survey of customers using
#three parameters: 1) Q1: Service Quality 2)Q2: Ease of Use 3) Q3: Complaints Handling
#The rating scale is 0-10 where higher number indicates positive feedback.

# Import data and check first 5 rows
library(dplyr)
df<-read.csv(file.choose())
df <- read.csv("C:/Users/rushd/Downloads/Food Delivery App Survey.csv")
head(df,5)

# Find median rating for each parameter by AGE
# Using dplyr
median_rating<- df %>% group_by(AGE) %>% summarise(across(Q1:Q3, median))
median_rating

#Using aggregate
median_rate_agg <- aggregate(cbind(Q1,Q2,Q3) ~ AGE, df, FUN = median)
median_rate_agg

# Calculate total score as sum of 3 parameter ratings
df <- df %>% mutate(Total_Score = Q1 + Q2 + Q3)
head(df)

# Obtain box-whisker plot of total score
boxplot(df$Total_Score, main = "Box-and-Whisker Plot for Total Score", ylab = "Total Score")

# Can total score be assumed to be "Normal"? Use statistical test
shapiro.test(df$Total_Score)

# Compare total score for 3 age groups using statistical test
anovatable1<-aov(Total_Score ~ AGE, data = df)
summary(anovatable1)

# Compare total score for male and female customers using statistical test
t.test(Total_Score ~ GENDER, data = df)

# Analyze the effect of Age group and Gender with interaction on total score
anovatable2<-aov(Total_Score ~ AGE * GENDER, data = df)
summary(anovatable2)

# Create indicator variable as Satisfied="YES" if total score > 20 
# ="NO" otherwise
df$Satisfied <- ifelse(df$Total_Score > 20, "YES", "NO")
head(df)

# Find proportion of satisfied customers
prop.table(table(df$Satisfied))
##

aggregate(Total_Score ~ AGE,data = df,
          FUN = function(x) {y <- shapiro.test(x); c(y$p.value)})

aggregate(Total_Score ~ GENDER,data = df,
          FUN = function(x) {y <- shapiro.test(x); c(y$p.value)})