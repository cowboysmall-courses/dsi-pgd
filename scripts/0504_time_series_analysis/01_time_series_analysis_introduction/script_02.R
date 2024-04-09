
data <- read.csv("./data/0504_time_series_analysis/01_time_series_analysis_introduction/Sales\ Data\ for\ 3\ Years.csv", header = TRUE)
head(data)

series <- ts(data$Sales, start = c(2013, 1), end = c(2015, 12), frequency = 12)

decomposed <- decompose(series)
plot(decomposed)

decomposed$seasonal
#             Jan        Feb        Mar        Apr        May        Jun
# 2013 -5.0069444 -1.1819444 -3.7361111 -1.5881944 -2.8319444 -2.2319444
# 2014 -5.0069444 -1.1819444 -3.7361111 -1.5881944 -2.8319444 -2.2319444
# 2015 -5.0069444 -1.1819444 -3.7361111 -1.5881944 -2.8319444 -2.2319444
#             Jul        Aug        Sep        Oct        Nov        Dec
# 2013  0.2347222 -1.5256944 -4.0944444 -6.4465278 -7.1277778 35.5368056
# 2014  0.2347222 -1.5256944 -4.0944444 -6.4465278 -7.1277778 35.5368056
# 2015  0.2347222 -1.5256944 -4.0944444 -6.4465278 -7.1277778 35.5368056

decomposed$trend
#           Jan      Feb      Mar      Apr      May      Jun      Jul      Aug
# 2013       NA       NA       NA       NA       NA       NA 192.8333 200.7708
# 2014 227.1667 230.9625 234.5500 237.9292 241.1000 244.5167 247.8917 250.5750
# 2015 261.0417 262.9958 264.9167 266.8417 268.7583 270.8417       NA       NA
#           Sep      Oct      Nov      Dec
# 2013 207.4500 213.1958 218.4083 223.0167
# 2014 252.9333 254.9917 257.0417 259.1042
# 2015       NA       NA       NA       NA

decomposed$random
#              Jan         Feb         Mar         Apr         May         Jun
# 2013          NA          NA          NA          NA          NA          NA
# 2014  0.84027778  2.71944444  2.98611111  4.75902778  1.73194444  3.31527778
# 2015  1.96527778  0.08611111 -0.18055556 -1.95347222  1.07361111 -0.50972222
#              Jul         Aug         Sep         Oct         Nov         Dec
# 2013  5.93194444  3.75486111  3.64444444  2.25069444  2.71944444 -3.55347222
# 2014 -3.12638889 -0.94930556 -0.83888889  0.55486111  0.08611111  6.35902778
# 2015          NA          NA          NA          NA          NA          NA


seasonal_adj <- series - decomposed$seasonal
plot(seasonal_adj)


loess_decomposed <- stl(series, s.window = "periodic")
plot(loess_decomposed)
