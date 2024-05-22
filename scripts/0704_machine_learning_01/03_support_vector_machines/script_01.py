
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.metrics import confusion_matrix, precision_score, recall_score, accuracy_score, classification_report, roc_curve, roc_auc_score


# %% 1 - import data and check the head
data = pd.read_csv("./data/0704_machine_learning_01/03_support_vector_machines/BANK LOAN.csv")
data.head()
#    SN  AGE  EMPLOY  ADDRESS  DEBTINC  CREDDEBT  OTHDEBT  DEFAULTER
# 0   1    3      17       12      9.3     11.36     5.01          1
# 1   2    1      10        6     17.3      1.36     4.00          0
# 2   3    2      15       14      5.5      0.86     2.17          0
# 3   4    3      15       14      2.9      2.66     0.82          0
# 4   5    1       2        0     17.3      1.79     3.06          1


# %% 1 - 
data['AGE'] = pd.Categorical(data['AGE'])
data.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 700 entries, 0 to 699
# Data columns (total 8 columns):
#  #   Column     Non-Null Count  Dtype   
# ---  ------     --------------  -----   
#  0   SN         700 non-null    int64   
#  1   AGE        700 non-null    category
#  2   EMPLOY     700 non-null    int64   
#  3   ADDRESS    700 non-null    int64   
#  4   DEBTINC    700 non-null    float64 
#  5   CREDDEBT   700 non-null    float64 
#  6   OTHDEBT    700 non-null    float64 
#  7   DEFAULTER  700 non-null    int64   
# dtypes: category(1), float64(3), int64(4)
# memory usage: 39.2 KB


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


# %% 3 - 
model_svm = SVC(kernel = "linear", probability = True)
model_svm.fit(X_train, y_train)


# %% 3 - 
predprob_test = model_svm.predict_proba(X_test)


# %% 3 - 
cutoff = 0.3
pred_test = np.where(predprob_test[:, 1] > cutoff, 1, 0)
pred_test
# array([0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0,
#        0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1,
#        0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0,
#        0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1,
#        0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0,
#        0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1,
#        0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0,
#        1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0,
#        1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1,
#        0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0])


# %% 6 - 
confusion_matrix(y_test, pred_test, labels = [0, 1])
# array([[131,  26],
#        [  9,  44]])



# %% 7 - 
print(accuracy_score(y_test, pred_test))
# 0.8333333333333334

print(precision_score(y_test, pred_test))
# 0.6285714285714286

print(recall_score(y_test, pred_test))
# 0.8301886792452831


# %% 1 -
auc = roc_auc_score(y_test, predprob_test[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.894


# %% 1 -
fpr, tpr, thresholds = roc_curve(y_test, predprob_test[:, 1])

plt.figure()

plt.plot(fpr, tpr, color = "darkorange", lw = 2, label = f"ROC curve (area = {auc:0.3f})")
plt.plot([0, 1], [0, 1], color = "navy", lw = 2, linestyle = "--")

plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])

plt.title("Receiver Operating Characteristic (ROC) Curve - SVM")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.axis("tight")

plt.show()






