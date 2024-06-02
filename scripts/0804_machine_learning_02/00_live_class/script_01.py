
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier, DecisionTreeRegressor, plot_tree
from sklearn.metrics import classification_report, confusion_matrix, precision_score, recall_score, accuracy_score, roc_curve, roc_auc_score



# %% 1 - import data and check the head
data = pd.read_csv("./data/0804_machine_learning_02/00_live_class/BANK LOAN.csv")
data.head()
#    SN  AGE  EMPLOY  ADDRESS  DEBTINC  CREDDEBT  OTHDEBT  DEFAULTER
# 0   1    3      17       12      9.3     11.36     5.01          1
# 1   2    1      10        6     17.3      1.36     4.00          0
# 2   3    2      15       14      5.5      0.86     2.17          0
# 3   4    3      15       14      2.9      2.66     0.82          0
# 4   5    1       2        0     17.3      1.79     3.06          1



# %% 1 - 
data_sub = data.drop(['SN'], axis = 1)
data_sub['AGE'] = data_sub['AGE'].astype('category')
data_sub = pd.get_dummies(data_sub)
data_sub.head()
#    EMPLOY  ADDRESS  DEBTINC  CREDDEBT  OTHDEBT  DEFAULTER  AGE_1  AGE_2  AGE_3
# 0      17       12      9.3     11.36     5.01          1  False  False   True
# 1      10        6     17.3      1.36     4.00          0   True  False  False
# 2      15       14      5.5      0.86     2.17          0  False   True  False
# 3      15       14      2.9      2.66     0.82          0  False  False   True
# 4       2        0     17.3      1.79     3.06          1   True  False  False



# %% 1 - 
X = data_sub.loc[:, data_sub.columns != 'DEFAULTER']
y = data_sub.loc[:, 'DEFAULTER']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.3, random_state = 999)



# %% 1 - 
model = DecisionTreeClassifier(criterion = 'entropy', min_samples_split = int(len(X_train) * 0.1))
model.fit(X_train, y_train)



# %% 1 - 
plt.figure(figsize = (16, 10))
plot_tree(model, filled = True, feature_names = list(X.columns))
plt.show()



# %% 1 - 
y_pred = model.predict(X_test)
y_prob = model.predict_proba(X_test)

cutoff = 0.3
pred_test = np.where(y_prob[:, 1] > cutoff, 1, 0)
pred_test
# array([0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0,
#        1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 0, 1,
#        0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0,
#        1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1,
#        0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1,
#        0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0,
#        0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0,
#        1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0,
#        0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0,
#        0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1])



# %% 1 - 
confusion_matrix(y_test, pred_test, labels = [0, 1])
# array([[107,  50],
#        [ 14,  39]])



# %% 1 - 
print(accuracy_score(y_test, pred_test))
# 0.6952380952380952

print(precision_score(y_test, pred_test))
# 0.43820224719101125

print(recall_score(y_test, pred_test))
# 0.7358490566037735



# %% 1 - 
print(classification_report(y_test, pred_test))
#               precision    recall  f1-score   support
# 
#            0       0.88      0.68      0.77       157
#            1       0.44      0.74      0.55        53
# 
#     accuracy                           0.70       210
#    macro avg       0.66      0.71      0.66       210
# weighted avg       0.77      0.70      0.71       210



# %% 1 - 
dt_auc = roc_auc_score(y_test, y_prob[:, 1])
print(f"AUC: {dt_auc:.3f}")
# AUC: 0.720



# %% 1 - 
dt_fpr, dt_tpr, _ = roc_curve(y_test, y_prob[:, 1])

ab_probs          = [0 for _ in range(len(y_test))]
ab_auc            = roc_auc_score(y_test, ab_probs)
ab_fpr, ab_tpr, _ = roc_curve(y_test, ab_probs)

plt.plot(dt_fpr, dt_tpr, marker = '.', label = f"ROC Curve  (area = {dt_auc:0.3f})")
plt.plot(ab_fpr, ab_tpr, linestyle = '--', label = f"abline  (area = {ab_auc:0.1f})")

plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend()

plt.show()
