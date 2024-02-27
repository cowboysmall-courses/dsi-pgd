
job_proficiency <- read.csv("./data/0104_exploratory_data_analysis/04_descriptive_statistics/Job_Proficiency.csv", header = TRUE)

plot(job_proficiency$aptitude, job_proficiency$job_prof, col = "red")
cor(job_proficiency$aptitude, job_proficiency$job_prof)
lm(job_prof ~ aptitude, data = job_proficiency)
lm(aptitude ~ job_prof, data = job_proficiency)

retail_data <- read.csv("./data/descriptive_statistics/Retail_Data.csv", header = TRUE)
t1 <- table(retail_data$Zone, retail_data$NPS_Category)
t1
prop.table(t1)
prop.table(t1, 1)
prop.table(t1, 2)


library(gmodels)

CrossTable(retail_data$Zone, retail_data$NPS_Category)
CrossTable(retail_data$Zone, retail_data$NPS_Category, prop.r = FALSE, prop.c = FALSE)

t2 <- table(retail_data$Zone, retail_data$NPS_Category, retail_data$Retailer_Age)
ftable(t2)
