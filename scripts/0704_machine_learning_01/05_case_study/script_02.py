
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, roc_curve, roc_auc_score
from sklearn.linear_model import LogisticRegression
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import SVC

import warnings
warnings.filterwarnings("ignore", category = FutureWarning)



# %% 1 -
plt.figure(figsize = (8, 6))
plt.style.use("ggplot")

sns.set_style("darkgrid")
sns.set_context("paper")



# %% 1 - import data and check the head
data = pd.read_csv("./data/0704_machine_learning_01/05_case_study/Bank Churn.csv")
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
X_variables = ['CreditScore', 'Geography', 'Gender', 'Age', 'Tenure', 'Balance', 'NumOfProducts', 'HasCrCard', 'IsActiveMember', 'EstimatedSalary']
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
X = data[X_variables]
y = data['Exited']



# %% 1 - 
X_encoded = pd.get_dummies(X, columns = categorical, drop_first = True)



# %% 1 - 
X_train, X_test, y_train, y_test = train_test_split(X_encoded, y, test_size = 0.2, random_state = 42)

print(X_train.shape)
# (8000, 11)



# %% 1 - 
scaler = StandardScaler()
scaler.fit(X_train)



# %% 1 - 
X_train = scaler.transform(X_train)
X_test  = scaler.transform(X_test)



# %% 1 - 
counts = data['Exited'].value_counts().reset_index()
counts.columns = ['Exited', 'Frequency']
counts['Percent'] = counts['Frequency'] / counts['Frequency'].sum()

print(counts)



# %% 1 - 
threshold = 0.2




# %% 1 - Logistic Regression
model_log = LogisticRegression(max_iter = 1000)
model_log.fit(X_train, y_train)



# %% 1 - 
y_pred = model_log.predict(X_test)




# %% 1 -
test_predprob = model_log.predict_proba(X_test)
test_pred     = np.where(test_predprob[:, 1] > threshold, 1, 0)

print(classification_report(y_test, test_pred))
#               precision    recall  f1-score   support

#            0       0.91      0.70      0.79      1607
#            1       0.37      0.72      0.49       393

#     accuracy                           0.70      2000
#    macro avg       0.64      0.71      0.64      2000
# weighted avg       0.80      0.70      0.73      2000



# %% 1 -
auc = roc_auc_score(y_test, test_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.779



# %% 1 -
fpr, tpr, _ = roc_curve(y_test, test_predprob[:, 1])

plt.figure()

plt.plot(fpr, tpr, color = "darkorange", lw = 2, label = f"ROC curve (area = {auc:0.3f})")
plt.plot([0, 1], [0, 1], color = "navy", lw = 2, linestyle = "--")

plt.title("Receiver Operating Characteristic (ROC) Curve - Logistic Regression")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.axis("tight")

plt.show()






# %% 1 - Naive Bayes
model_nb = GaussianNB()
model_nb.fit(X_train, y_train)



# %% 1 -
y_pred = model_nb.predict(X_test)



# %% 1 -
test_predprob = model_nb.predict_proba(X_test)
test_pred     = np.where(test_predprob[:, 1] > threshold, 1, 0)

print(classification_report(y_test, test_pred))
#               precision    recall  f1-score   support

#            0       0.92      0.73      0.81      1607
#            1       0.40      0.73      0.51       393

#     accuracy                           0.73      2000
#    macro avg       0.66      0.73      0.66      2000
# weighted avg       0.81      0.73      0.75      2000



# %% 1 -
auc = roc_auc_score(y_test, test_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.804



# %% 1 -
fpr, tpr, _ = roc_curve(y_test, test_predprob[:, 1])

plt.figure()

plt.plot(fpr, tpr, color = "darkorange", lw = 2, label = f"ROC curve (area = {auc:0.3f})")
plt.plot([0, 1], [0, 1], color = "navy", lw = 2, linestyle = "--")

plt.title("Receiver Operating Characteristic (ROC) Curve - Naive Bayes")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.axis("tight")

plt.show()






# %% 1 - SVM / SVC
model_svm = SVC(probability = True, random_state = 0, kernel = "linear")
model_svm.fit(X_train, y_train)



# %% 1 -
y_pred = model_svm.predict(X_test)



# %% 1 -
test_predprob = model_svm.predict_proba(X_test)
test_pred     = np.where(test_predprob[:, 1] > threshold, 1, 0)

print(classification_report(y_test, test_pred))
#               precision    recall  f1-score   support
# 
#            0       0.90      0.48      0.63      1607
#            1       0.27      0.77      0.40       393
# 
#     accuracy                           0.54      2000
#    macro avg       0.58      0.63      0.51      2000
# weighted avg       0.77      0.54      0.58      2000



# %% 1 -
auc = roc_auc_score(y_test, test_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.678



# %% 1 -
fpr, tpr, _ = roc_curve(y_test, test_predprob[:, 1])

plt.figure()

plt.plot(fpr, tpr, color = "darkorange", lw = 2, label = f"ROC curve (area = {auc:0.3f})")
plt.plot([0, 1], [0, 1], color = "navy", lw = 2, linestyle = "--")

plt.title("Receiver Operating Characteristic (ROC) Curve - SVM")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.axis("tight")

plt.show()
