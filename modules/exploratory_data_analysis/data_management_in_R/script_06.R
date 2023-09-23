
library(data.table)

salary_data <- fread("../../../data/data_management/sal_data.csv")
bonus_data <- fread("../../../data/data_management/bonus_data.csv")


setkey(salary_data, Employee_ID)
setkey(bonus_data, Employee_ID)


merged_data <- merge(salary_data, bonus_data, all = TRUE)
merged_data


dt1 <- data.table(
  ID = 1:7000000,
  Capacity = sample(100:1000, size = 50, replace = FALSE),
  Code = sample(LETTERS[1:4], size = 50, replace = TRUE),
  State = rep(c("Alabama", "Indiana", "Texas", "Nevada"))
)
head(dt1)

dt1[4:6, ]

sr1 <- dt1[Code == "C" & State == "Alabama"]
head(sr1)

sc1 <- dt1[, .(ID, Capacity)]
head(sc1)

setkey(dt1, Code, State)
sk1 <- dt1[.("C", "Alabama")]
head(sk1)

sk2 <- dt1[.("C")]
head(sk2)

sk3 <- dt1[.(unique(Code), "Alabama")]
head(sk3)


ot1 <- dt1[order(Code, -State)]
head(ot1)

ot2 <- dt1[order(-Code, -Capacity)]
head(ot2)



