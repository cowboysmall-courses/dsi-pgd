
set.seed(09092022)

data <- read.csv("./data/0804_machine_learning_02/04_neural_networks/BANK LOAN.csv")
head(data)

library(fastDummies)

data_dummies <- dummy_cols(data, select_columns = "AGE", remove_first_dummy = TRUE)

head(data_dummies)

scale <- function(x) { return((x - min(x)) / (max(x) - min(x))) }

data_dummies$EMPLOY   <- scale(data_dummies$EMPLOY)
data_dummies$ADDRESS  <- scale(data_dummies$ADDRESS)
data_dummies$DEBTINC  <- scale(data_dummies$DEBTINC)
data_dummies$CREDDEBT <- scale(data_dummies$CREDDEBT)
data_dummies$OTHDEBT  <- scale(data_dummies$OTHDEBT)

head(data_dummies)



library(neuralnet)

nn_bank <- neuralnet(DEFAULTER ~ AGE_2 + AGE_3 + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, data = data_dummies, hidden = 3, err.fct = "ce", linear.output = FALSE)

nn_bank$net.result[[1]]

out_bank <- cbind(nn_bank$covariate, nn_bank$net.result[[1]])
head(out_bank)

dimnames(out_bank) <- list(NULL, c("AGE_2", "AGE_3", "EMPLOY", "ADDRESS", "DEBTINC", "CREDDEBT", "OTHDEBT", "Predicted"))
head(out_bank)


library(ROCR)

outdf <- as.data.frame(out_bank)
pred  <- prediction(outdf$Predicted, data_dummies$DEFAULTER)
perf  <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)

auc <- performance(pred, "auc")
auc@y.values




data_dummies$Predicted <- nn_bank$net.result[[1]]
head(data_dummies)

pred  <- prediction(data_dummies$Predicted, data_dummies$DEFAULTER)
perf  <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)

auc <- performance(pred, "auc")
auc@y.values




Predicted <- predict(nn_bank, data_dummies)
Predicted

pred  <- prediction(Predicted, data_dummies$DEFAULTER)
perf  <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)

auc <- performance(pred, "auc")
auc@y.values
