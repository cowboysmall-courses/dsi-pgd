
# Q1
nsv_data <- read.csv("./data/0104_exploratory_data_analysis/live_class/NSVDATA.csv", header = TRUE)
head(nsv_data)
dim(nsv_data)
str(nsv_data)
summary(nsv_data)


cust_data <- read.csv("./data/0104_exploratory_data_analysis/live_class/CUST_PROFILE.csv", header = TRUE)
head(cust_data)
dim(cust_data)
str(cust_data)
summary(cust_data)


nps_data <- read.csv("./data/0104_exploratory_data_analysis/live_class/NPSDATA.csv", header = TRUE)
head(nps_data)
dim(nps_data)
str(nps_data)
summary(nps_data)



# Q2
length(unique(nsv_data$CUSTID))
length(unique(cust_data$CUSTID))
length(unique(nps_data$CUSTID))



#Q3
agg_nsv <- aggregate(NSV ~ CUSTID, data = nsv_data, FUN = sum)
head(agg_nsv)

des_nsv <- agg_nsv[order(-agg_nsv$NSV), ]
head(des_nsv, 10)

asc_nsv <- agg_nsv[order(agg_nsv$NSV), ]
head(asc_nsv, 10)



# Q4
merged_nsv <- merge(agg_nsv, cust_data, by = "CUSTID")
head(merged_nsv)

des_merged_nsv <- merged_nsv[order(-merged_nsv$NSV), ]
head(des_merged_nsv)

top_merged_nsv <- head(des_merged_nsv, 100)
table(top_merged_nsv$REGION)



# Q5
# to come after the class on ggplot...



# Q6
lob_nsv <- aggregate(NSV ~ BUSINESS,  data = nsv_data, FUN = sum)
total <- sum(lob_nsv$NSV)
lob_nsv$CONTRIBUTION <- (lob_nsv$NSV / total) * 100
lob_nsv



# Q8
head(nps_data)
merged_nps <- merge(nps_data, cust_data, by = "CUSTID")
median_nps <- aggregate(NPS ~ REGION, data = merged_nps, FUN = median)
median_nps
