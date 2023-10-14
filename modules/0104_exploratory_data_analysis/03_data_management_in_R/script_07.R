
library(reshape2)
library(plyr)

stud_data <- read.csv("../../../data/eda/data_management/stud_data.csv", header = TRUE)
stud_data


melt(stud_data)
melt(stud_data, id.vars = c("Student_ID", "Names"))
melt(stud_data, id.vars = c("Student_ID", "Names"), measure.vars = c("Maths", "Economics"))


long_format <- melt(stud_data, id.vars = c("Student_ID", "Names"), variable.name = "Subjects", value.name = "Marks")
long_format


dcast(long_format, Student_ID + Names ~ Subjects)
dcast(long_format, Names + Student_ID ~ Subjects)
dcast(long_format, Student_ID ~ Subjects)
dcast(long_format, Names ~ Subjects)


dcast(long_format, Student_ID + Names ~ Subjects, subset = .(Subjects == "Maths"))


dcast(long_format, Student_ID + Names ~ .)
dcast(long_format, Student_ID + Names ~ ., fun.aggregate = sum, na.rm = TRUE)
