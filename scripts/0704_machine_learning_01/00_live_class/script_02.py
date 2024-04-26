
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import classification_report, confusion_matrix, precision_score, recall_score, accuracy_score, roc_curve, roc_auc_score



# %% 1 -
plt.figure(figsize = (8, 6))
plt.style.use("ggplot")

sns.set_style("darkgrid")
sns.set_context("paper")



# %% 1 - import data and check the head
data = pd.read_csv("./data/0704_machine_learning_01/00_live_class/BANK LOAN.csv")
data.head()
#    SN  AGE  EMPLOY  ADDRESS  DEBTINC  CREDDEBT  OTHDEBT  DEFAULTER
# 0   1    3      17       12      9.3     11.36     5.01          1
# 1   2    1      10        6     17.3      1.36     4.00          0
# 2   3    2      15       14      5.5      0.86     2.17          0
# 3   4    3      15       14      2.9      2.66     0.82          0
# 4   5    1       2        0     17.3      1.79     3.06          1



# %% 2 - 
data_sub = data.drop(['SN', 'AGE'], axis = 1)
data_sub.head()
#    EMPLOY  ADDRESS  DEBTINC  CREDDEBT  OTHDEBT  DEFAULTER
# 0      17       12      9.3     11.36     5.01          1
# 1      10        6     17.3      1.36     4.00          0
# 2      15       14      5.5      0.86     2.17          0
# 3      15       14      2.9      2.66     0.82          0
# 4       2        0     17.3      1.79     3.06          1



# %% 3 - 
X = data_sub.loc[:, data_sub.columns != 'DEFAULTER']
y = data_sub.loc[:, 'DEFAULTER']


X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.3, random_state = 999)



# %% 4 - 
nb_classifier = GaussianNB()
nb_classifier.fit(X_train, y_train)

y_pred = nb_classifier.predict_proba(X_test)



# %% 5 - 
cutoff = 0.3

pred_test = np.where(y_pred[:, 1] > cutoff, 1, 0)
pred_test
# array([0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0,
#        0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0,
#        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1,
#        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1,
#        0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0,
#        0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1,
#        0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1,
#        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0,
#        0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1,
#        0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0])



# %% 6 - 
confusion_matrix(y_test, pred_test, labels = [0, 1])
# array([[135,  22],
#        [ 26,  27]])



# %% 7 - 
print(accuracy_score(y_test, pred_test))
# 0.7714285714285715

print(precision_score(y_test, pred_test))
# 0.5510204081632653

print(recall_score(y_test, pred_test))
# 0.5094339622641509



# %% 8 - 
print(classification_report(y_test, pred_test))
#               precision    recall  f1-score   support
# 
#            0       0.84      0.86      0.85       157
#            1       0.55      0.51      0.53        53
# 
#     accuracy                           0.77       210
#    macro avg       0.69      0.68      0.69       210
# weighted avg       0.77      0.77      0.77       210



# %% 9 - 
auc = roc_auc_score(y_test, y_pred[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.816



# %% 10 - 
fpr, tpr, thresholds = roc_curve(y_test, y_pred[:, 1])

plt.figure()

plt.plot(fpr, tpr, color = "darkorange", lw = 2, label = f"ROC curve (area = {auc:0.3f})")
plt.plot([0, 1], [0, 1], color = "navy", lw = 2, linestyle = "--")

plt.title("Receiver Operating Characteristic")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.axis("tight")

plt.show()
