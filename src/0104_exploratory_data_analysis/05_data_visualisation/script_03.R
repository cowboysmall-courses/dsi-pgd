
jobs_data <- read.csv("./data/0104_exploratory_data_analysis/data_visualisation/JOB\ PROFICIENCY\ DATA.csv", header = TRUE)
attach(jobs_data)
head(jobs_data)

plot(
  aptitude,
  job_prof,
  main = "Scatterplot with Regression Line",
  xlab = "Aptitude",
  ylab = "Job Proficiency",
  pch = 19
)
abline(lm(job_prof ~ aptitude), col = "darkorange")

pairs(
  ~ aptitude + job_prof + testofen + tech_ + g_k_,
  data = jobs_data,
  main = "Scatterplot Matrix",
  col = "darkorange"
)




library(GGally)
ggpairs(jobs_data[, c("aptitude", "testofen", "tech_", "g_k_", "job_prof")], title = "Scatter Plot Matrix")




library(ggplot2)
qplot(
  x = tech_, 
  y = job_prof, 
  data = jobs_data, 
  color = aptitude, 
  size = aptitude, 
  xlab = "Technical", 
  ylab = "Job Proficiency", 
  main = "Bubble Chart"
)




