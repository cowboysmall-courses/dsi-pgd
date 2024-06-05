
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import confusion_matrix, precision_score, recall_score, accuracy_score, roc_curve, roc_auc_score


# %% 1 - import data and check the head
data = pd.read_csv("./data/0804_machine_learning_02/02_random_forest/BANK LOAN.csv")
data.head()
#    SN  AGE  EMPLOY  ADDRESS  DEBTINC  CREDDEBT  OTHDEBT  DEFAULTER
# 0   1    3      17       12      9.3     11.36     5.01          1
# 1   2    1      10        6     17.3      1.36     4.00          0
# 2   3    2      15       14      5.5      0.86     2.17          0
# 3   4    3      15       14      2.9      2.66     0.82          0
# 4   5    1       2        0     17.3      1.79     3.06          1


# %% 1 - 
data_sub = data.drop(['SN'], axis = 1)


# %% 1 - 
data_sub['AGE'] = data_sub['AGE'].astype('category')
data_sub.dtypes
# AGE          category
# EMPLOY          int64
# ADDRESS         int64
# DEBTINC       float64
# CREDDEBT      float64
# OTHDEBT       float64
# DEFAULTER       int64
# dtype: object


# %% 1 - 
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

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.30, random_state = 999)


# %% 1 - 
rf = RandomForestClassifier(random_state = 999, n_estimators = 100, oob_score = True, max_features = 'sqrt')
rf.fit(X_train, y_train)


# %% 1 - 
y_pred = rf.predict(X_test)
y_prob = rf.predict_proba(X_test)

cutoff = 0.3
pred_test = np.where(y_prob[:, 1] > cutoff, 1, 0)
pred_test
# array([0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0,
#        1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1,
#        0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0,
#        0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1,
#        0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0,
#        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0,
#        0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0,
#        0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0,
#        1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0,
#        0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1])


# %% 1 - 
confusion_matrix(y_test, pred_test, labels = [0, 1])
# array([[127,  30],
#        [ 17,  36]])


# %% 1 - 
print(accuracy_score(y_test, pred_test))
# 0.7761904761904762

print(precision_score(y_test, pred_test))
# 0.5454545454545454

print(recall_score(y_test, pred_test))
# 0.6792452830188679


# %% 1 - 
rf_auc = roc_auc_score(y_test, y_prob[:, 1])
print(f"AUC: {rf_auc:.3f}")
# AUC: 0.852


# %% 1 - 
rf.oob_score_
# 0.753061224489796


# %% 1 - 
rf.feature_importances_
# array([0.18827389, 0.14472019, 0.23581877, 0.20153387, 0.18166248,
#        0.0233408 , 0.01439653, 0.01025348])


# %% 1 - 
RFfpr, RFtpr, thresholds = roc_curve(y_test, y_prob[:, 1])

lw = 2

plt.figure()

plt.plot(RFfpr, RFtpr, color = 'darkorange',lw = lw, label = 'ROC curve (area = %0.3f)' % rf_auc)
plt.plot([0, 1], [0, 1], color = 'navy', lw = lw, linestyle = '--')

plt.axis('tight')

plt.title('Receiver Operating Characteristic')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')

plt.legend(loc = "lower right")
plt.show()


# %% 1 - 
features    = list(X.columns)
importances = rf.feature_importances_
indices     = np.argsort(importances)


# %% 1 - 
plt.barh(range(len(indices)), importances[indices], color = 'g', align = 'center')

plt.title('Feature Importances')
plt.xlabel('Relative Importance')

plt.yticks(range(len(indices)), [features[i] for i in indices])

plt.show()
