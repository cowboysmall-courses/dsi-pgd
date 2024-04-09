
data <- read.csv("./data/0504_time_series_analysis/01_time_series_analysis_introduction/turnover_annual.csv", header = TRUE)
head(data)
#   Year  sales
# 1 1961 224786
# 2 1962 230034
# 3 1963 236562
# 4 1964 250960
# 5 1965 261615
# 6 1966 268316

series <- ts(data$sales, start = 1961, end = 2017)

plot(series, col = "red", main = "Sales Time Series (Simple Plot)")

s_series <- window(series, start = 1990, end = 2017)

plot(s_series, col = "red", main = "Sales Time Series (Subset)")
