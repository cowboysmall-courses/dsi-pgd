
library(ggplot2)

jobs_data <- read.csv("./data/0104_exploratory_data_analysis/05_data_visualisation/JOB\ PROFICIENCY\ DATA.csv", header = TRUE)

ggplot(jobs_data, aes(x = aptitude, y = job_prof)) + 
  geom_point() + 
  geom_smooth(method = "lm", col = "darkorange") + 
  labs(x = "Aptitude", y = "Job Proficiency", title = "Scatter Plot with Regression Line")

