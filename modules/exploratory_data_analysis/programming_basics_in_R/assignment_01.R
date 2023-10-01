
# Jerry Kiely
# Data Science Institute
# Programming Basics in R
# EDA T2 Assignment


# 1
m <- matrix(c(1:10, 1:2), nrow = 3, ncol = 4, byrow = TRUE, dimnames = list(c("A", "B", "C"), c("Q", "W", "E", "R")))
print(m)


# 2
x <- 24
y <- "Hello World"
z <- 93.65

class(x)
class(y)
class(z)

x <- factor(x)
y <- factor(y)
z <- factor(z)

class(x)
class(y)
class(z)


# 3
q <- 65.9836
round(sqrt(q), digits = 3)
log10(q) < 2


# 4
x = c("Intelligence", "Knowledge", "Wisdom", "Comprehension") 
y = "I am"
z = "intelligent"

substring(x, 1, 4)
paste(y, z)
toupper(x)


# 5
a <- c(3, 4, 14, 17, 3, 98, 66, 85, 44)
ifelse(a %% 3 == 0, "Yes", "No")


# 6
b <- c(36, 3, 5, 19, 2, 16, 18, 41, 35, 28, 30, 31)
for (v in b)
  if (v < 30) 
    print(v)

# alternative approach:
# c <- b[b < 30]
# for (i in c) print(i)


# 7
Date <- "01/30/18"
Date_new <- as.Date(Date, format = "%m/%d/%y")

weekdays(Date_new)
months(Date_new)

Sys.Date() - Date_new
