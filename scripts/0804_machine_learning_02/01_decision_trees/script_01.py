
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier, plot_tree
from sklearn.metrics import confusion_matrix, precision_score, recall_score, accuracy_score, roc_curve, roc_auc_score


# %% 1 - import data and check the head
data = pd.read_csv("./data/0804_machine_learning_02/01_decision_trees/BANK LOAN.csv")
data.head()


# %% 1 - 
data_sub = data.drop(['SN'], axis = 1)
data_sub['AGE'] = data_sub['AGE'].astype('category')
data_sub = pd.get_dummies(data_sub)
data_sub.head()


# %% 1 -
X = data_sub.loc[:, data_sub.columns != 'DEFAULTER']
y = data_sub.loc[:, 'DEFAULTER']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.30, random_state = 999)


# %% 1 -
dtcl = DecisionTreeClassifier(criterion = 'entropy', min_samples_split = int(len(X_train) * 0.1))
dtcl.fit(X_train, y_train)


# %% 1 -
y_pred = dtcl.predict(X_test)
y_prob = dtcl.predict_proba(X_test)

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
dt_auc = roc_auc_score(y_test, y_prob[:, 1])
print(f"AUC: {dt_auc:.3f}")
# AUC: 0.720


# %% 1 - 
DTfpr, DTtpr, thresholds  = roc_curve(y_test, y_prob[:,1])

abline_probs              = [0 for _ in range(len(y_test))]
abline_auc                = roc_auc_score(y_test, abline_probs)
abline_fpr, abline_tpr, _ = roc_curve(y_test, abline_probs)

plt.plot(abline_fpr, abline_tpr, linestyle = '--', label = 'abline')
plt.plot(DTfpr, DTtpr, marker = '.', label = 'ROC Curve')

plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')

plt.legend()
plt.show()


# %% 1 - 
dtcl_infgain = DecisionTreeClassifier(criterion = 'entropy', min_samples_split = int(len(X_train) * 0.1))
dtcl_infgain.fit(X_train, y_train)


# %% 1 - 
plt.figure(figsize = (16, 10))
plot_tree(dtcl_infgain, filled = True, feature_names = list(X.columns))
plt.show()
