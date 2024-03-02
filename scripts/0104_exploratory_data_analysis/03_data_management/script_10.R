
library(tidyr)

stud_data <- read.csv("./data/0104_exploratory_data_analysis/03_data_management/stud_data.csv", header = TRUE)
stud_data


gather(stud_data)

long_format <- gather(stud_data, Subjects, Marks, Maths, Economics, Statistics)

spread(long_format, Subjects, Marks, fill = 0)
