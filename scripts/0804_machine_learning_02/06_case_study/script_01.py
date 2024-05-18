
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, roc_curve, roc_auc_score
from sklearn.tree import DecisionTreeClassifier, plot_tree
from sklearn.ensemble import RandomForestClassifier


import warnings
warnings.filterwarnings("ignore", category = FutureWarning)


# %% 1 -
plt.figure(figsize = (8, 6))
plt.style.use("ggplot")

sns.set_style("darkgrid")
sns.set_context("paper")


# %% 1 - import data and check the head
data = pd.read_csv("./data/0804_machine_learning_02/06_case_study/Bank Churn.csv")
data.head()
#    RowNumber  CustomerId   Surname  CreditScore Geography  Gender  Age  \
# 0          1    15634602  Hargrave          619    France  Female   42   
# 1          2    15647311      Hill          608     Spain  Female   41   
# 2          3    15619304      Onio          502    France  Female   42   
# 3          4    15701354      Boni          699    France  Female   39   
# 4          5    15737888  Mitchell          850     Spain  Female   43   

#    Tenure    Balance  NumOfProducts  HasCrCard  IsActiveMember  \
# 0       2       0.00              1          1               1   
# 1       1   83807.86              1          0               1   
# 2       8  159660.80              3          1               0   
# 3       1       0.00              2          0               0   
# 4       2  125510.82              1          1               1   

#    EstimatedSalary  Exited  
# 0        101348.88       1  
# 1        112542.58       0  
# 2        113931.57       1  
# 3         93826.63       0  
# 4         79084.10       0  


# %% 1 - 
x_variables = ['CreditScore', 'Geography', 'Gender', 'Age', 'Tenure', 'Balance', 'NumOfProducts', 'HasCrCard', 'IsActiveMember', 'EstimatedSalary']
categorical = ['Geography', 'Gender', 'HasCrCard', 'IsActiveMember']


# %% 1 - 
data[categorical] = data[categorical].astype('category')
data.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 10000 entries, 0 to 9999
# Data columns (total 14 columns):
#  #   Column           Non-Null Count  Dtype   
# ---  ------           --------------  -----   
#  0   RowNumber        10000 non-null  int64   
#  1   CustomerId       10000 non-null  int64   
#  2   Surname          10000 non-null  object  
#  3   CreditScore      10000 non-null  int64   
#  4   Geography        10000 non-null  category
#  5   Gender           10000 non-null  category
#  6   Age              10000 non-null  int64   
#  7   Tenure           10000 non-null  int64   
#  8   Balance          10000 non-null  float64 
#  9   NumOfProducts    10000 non-null  int64   
#  10  HasCrCard        10000 non-null  category
#  11  IsActiveMember   10000 non-null  category
#  12  EstimatedSalary  10000 non-null  float64 
#  13  Exited           10000 non-null  int64   
# dtypes: category(4), float64(2), int64(7), object(1)
# memory usage: 820.9+ KB


# %% 1 - 
X = data[x_variables]
y = data['Exited']

X_encoded = pd.get_dummies(X, categorical, drop_first = True)

X_train, X_test, y_train, y_test = train_test_split(X_encoded, y, test_size = 0.3, random_state = 42)


# %% 1 - 
counts = data['Exited'].value_counts().reset_index()
counts.columns = ['Exited', 'Frequency']
counts['Percent'] = counts['Frequency'] / counts['Frequency'].sum()

print(counts)
#    Exited  Frequency  Percent
# 0       0       7963   0.7963
# 1       1       2037   0.2037


# %% 1 - 
model_dt = DecisionTreeClassifier(criterion = "entropy", min_samples_split = int(len(X_train) * 0.1))
model_dt.fit(X_train, y_train)


# %% 1 - 
plt.figure(figsize = (40, 30))
plot_tree(model_dt, filled = True, feature_names = list(X_encoded.columns))
plt.show()


# %% 1 - 
y_pred = model_dt.predict(X_test)
y_pred_probs = model_dt.predict_proba(X_test)


# %% 1 -
auc = roc_auc_score(y_test, y_pred_probs[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.832


# %% 1 - ROC Curve
fpr, tpr, _ = roc_curve(y_test, y_pred_probs[:, 1])

plt.figure()

plt.plot(fpr, tpr, color = "darkorange", lw = 2, label = f"ROC curve (area = {auc:0.3f})")
plt.plot([0, 1], [0, 1], color = "navy", lw = 2, linestyle = "--")

plt.title("Receiver Operating Characteristic (ROC) Curve - Decision Tree")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.axis("tight")

plt.show()


# %% 1 - Alternative ROC Curve
ab_probs          = [0 for _ in range(len(y_test))]
ab_auc            = roc_auc_score(y_test, ab_probs)
ab_fpr, ab_tpr, _ = roc_curve(y_test, ab_probs)

plt.figure()

plt.plot(fpr, tpr, marker = '.', label = f"ROC curve (area = {auc:0.3f})")
plt.plot(ab_fpr, ab_tpr, linestyle = '--', label = 'abline')

plt.title("Receiver Operating Characteristic (ROC) Curve - Decision Tree")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.axis("tight")

plt.show()


# %% 1 -
print(classification_report(y_test, y_pred))
#               precision    recall  f1-score   support
# 
#            0       0.87      0.96      0.91      2416
#            1       0.70      0.43      0.53       584
# 
#     accuracy                           0.85      3000
#    macro avg       0.79      0.69      0.72      3000
# weighted avg       0.84      0.85      0.84      3000


# %% 1 -
model_rf = RandomForestClassifier(random_state = 999, n_estimators = 100, oob_score = True, max_features = "sqrt")
model_rf.fit(X_train, y_train)


# %% 1 -
model_rf.oob_score_
# 0.8578571428571429


# %% 1 -
model_rf.feature_importances_
# array([0.14428493, 0.23946382, 0.08136962, 0.14157388, 0.12746573,
#        0.14664391, 0.02562787, 0.01426298, 0.01850706, 0.019517  ,
#        0.0412832 ])


# %% 1 -
features    = list(X_encoded.columns)
importances = model_rf.feature_importances_
indices     = np.argsort(importances)


# %% 1 -
plt.figure()

plt.barh(range(len(indices)), importances[indices], color = 'g', align = 'center')

plt.title("Feature Importances")
plt.xlabel("Relative Importance")

plt.yticks(range(len(indices)), [features[i] for i in indices])

plt.show()


# %% 1 - 
y_pred = model_rf.predict(X_test)
y_pred_probs = model_rf.predict_proba(X_test)


# %% 1 -
auc = roc_auc_score(y_test, y_pred_probs[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.854


# %% 1 - ROC Curve
fpr, tpr, _ = roc_curve(y_test, y_pred_probs[:, 1])

plt.figure()

plt.plot(fpr, tpr, color = "darkorange", lw = 2, label = f"ROC curve (area = {auc:0.3f})")
plt.plot([0, 1], [0, 1], color = "navy", lw = 2, linestyle = "--")

plt.title("Receiver Operating Characteristic (ROC) Curve - Random Forest")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.axis("tight")

plt.show()


# %% 1 - Alternative ROC Curve
ab_probs          = [0 for _ in range(len(y_test))]
ab_auc            = roc_auc_score(y_test, ab_probs)
ab_fpr, ab_tpr, _ = roc_curve(y_test, ab_probs)

plt.figure()

plt.plot(fpr, tpr, marker = '.', label = f"ROC curve (area = {auc:0.3f})")
plt.plot(ab_fpr, ab_tpr, linestyle = '--', label = 'abline')

plt.title("Receiver Operating Characteristic (ROC) Curve - Random Forest")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.axis("tight")

plt.show()


# %% 1 -
print(classification_report(y_test, y_pred))
#               precision    recall  f1-score   support
# 
#            0       0.88      0.97      0.92      2416
#            1       0.78      0.46      0.58       584
# 
#     accuracy                           0.87      3000
#    macro avg       0.83      0.72      0.75      3000
# weighted avg       0.86      0.87      0.86      3000


# %% 1 -
model_rf = RandomForestClassifier(random_state = 999, n_estimators = 500, oob_score = True, max_features = "sqrt")
model_rf.fit(X_train, y_train)


# %% 1 -
model_rf.oob_score_
# 0.8604285714285714
