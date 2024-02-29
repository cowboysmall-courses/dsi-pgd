
data <- read.csv("./data/0504_time_series_analysis/00_live_class/CROP\ DATA.csv", header = TRUE)
head(data)


data$Date <- as.Date(paste(data$Year, data$Quarter * 3 - 2, "01", sep = "-"))


series <- ts(data$CROPYIELD, start = c(data$Year[1], data$Quarter[1]), frequency = 4)
diff   <- diff(series, differences = 1)


par(mfrow = c(2, 2))
plot(series, col = "red")
acf(series, col = "blue")
plot(diff, col = "red")
acf(diff, col = "blue")


ndiffs(series)


diff2  <- diff(series, differences = 2)


par(mfrow = c(2, 2))
plot(series, col = "red")
acf(series, col = "blue")
plot(diff2,col="red")
acf(diff2,col="blue")


summary(ur.df(series, lag = 0))


summary(ur.df(diff2, lag = 0))
