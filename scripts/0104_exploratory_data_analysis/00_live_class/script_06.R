
library(ggplot2)
library(GGally)

job_data_1 <- read.csv("./data/0104_exploratory_data_analysis/00_live_class/JOB\ PROFICIENCY\ DATA.csv", header = TRUE)
head(job_data_1)


ggplot(job_data_1, aes(x = aptitude, y = job_prof)) + 
  geom_point() + geom_smooth(method = "lm") + 
  labs(x = "Aptitude", y = "Job Proficiency", title = "Scatter Plot")



job_data_2 <- read.csv("./data/0104_exploratory_data_analysis/00_live_class/JOB\ PROFICIENCY\ DATA\ for\ Bubble\ Chart.csv", header = TRUE)
head(job_data_2)


qplot(
  aptitude, 
  tech_, 
  data = job_data_2, 
  size = job_prof, 
  color = function., 
  xlab = "Aptitude",  
  ylab = "Technical", 
  main = "Bubble Chart"
)


pairs(job_data_1)


ggpairs(
  job_data_1[, c("aptitude", "testofen", "tech_", "g_k_", "job_prof")],
  title = "Scatter Plot"
)

