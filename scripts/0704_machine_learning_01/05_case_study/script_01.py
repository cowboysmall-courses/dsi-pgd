
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import classification_report, roc_curve, roc_auc_score

import warnings
warnings.filterwarnings("ignore", category = FutureWarning)



# %% 1 -
plt.figure(figsize = (8, 6))
plt.style.use("ggplot")

sns.set_style("darkgrid")
sns.set_context("paper")



# %% 1 - import data and check the head
data = pd.read_csv("./data/0704_machine_learning_01/05_case_study/Hospital Readmissions.csv")
data.head()
#    id      age  time_in_hospital  n_lab_procedures  n_procedures  \
# 0   1  [70-80)                 8                72             1   
# 1   2  [70-80)                 3                34             2   
# 2   3  [50-60)                 5                45             0   
# 3   4  [70-80)                 2                36             0   
# 4   5  [60-70)                 1                42             0   

#    n_medications  n_outpatient  n_inpatient  n_emergency    diagnosis  \
# 0             18             2            0            0  Circulatory   
# 1             13             0            0            0        Other   
# 2             18             0            0            0  Circulatory   
# 3             12             1            0            0  Circulatory   
# 4              7             0            0            0        Other   

#   glucose_test A1Ctest change diabetes_med readmitted  
# 0           no      no     no          yes         no  
# 1           no      no     no          yes         no  
# 2           no      no    yes          yes        yes  
# 3           no      no    yes          yes        yes  
# 4           no      no     no          yes         no  



# %% 1 -
data["readmitted"] = data["readmitted"].astype("category")
data["readmitted"] = data["readmitted"].cat.codes
data["readmitted"].head()
# 0    0
# 1    0
# 2    1
# 3    1
# 4    0
# Name: readmitted, dtype: int8



# %% 1 -
data_types = {
    'age': 'category',
    'diagnosis': 'category',
    'glucose_test': 'category',
    'A1Ctest': 'category',
    'change': 'category',
    'diabetes_med': 'category'
}
data = data.astype(data_types)



# %% 1 -
data_copy = data.copy()
readmitted_counts = data_copy["readmitted"].value_counts(normalize = True)
print(readmitted_counts)
# readmitted
# 0    0.52984
# 1    0.47016
# Name: proportion, dtype: float64



# %% 1 -
plt.figure()

plt.pie(readmitted_counts, labels = readmitted_counts.index, autopct = '%1.1f%%', startangle = 90, colors = ["lightcoral", "lightgreen"])

plt.title("Readmission Status")

plt.show()



# %% 1 -
plt.figure()

readmitted_counts.plot.pie(label = (""), title = "Readmission Status", startangle = 90, colormap = 'brg', autopct = '%1.1f%%')

plt.show()



# %% 1 -
plt.figure(figsize = (5, 5))

sns.boxplot(x = "readmitted", y = "n_lab_procedures", data = data_copy)

plt.title("Boxplot of Lab Procedures by Readmitted")
plt.xlabel("Readmitted")
plt.ylabel("Number of Lab Procedures")

plt.show()



# %% 1 -
data_grouped = data.groupby("age")["readmitted"].value_counts(normalize = True).unstack()

plt.figure(figsize = (12, 6))

data_grouped.plot(kind = "bar", stacked = True)

plt.title("Percentage of Readmitted Cases by Age")
plt.xlabel("Age")
plt.ylabel("% of Readmitted Cases")

plt.legend(title = "Readmission Status", loc = "upper right")

plt.show()



# %% 1 -
data_grouped = data.groupby("diagnosis")["readmitted"].value_counts(normalize = True).unstack()

plt.figure(figsize = (12, 6))

data_grouped.plot(kind = "bar", stacked = True)

plt.title("Percentage of Readmitted Cases by Diagnosis")
plt.xlabel("Diagnosis")
plt.ylabel("% of Readmitted Cases")

plt.legend(title = "Readmission Status", loc = "upper right")

plt.show()



# %% 1 -
X_variables = [
    'age', 
    'time_in_hospital', 
    'n_lab_procedures', 
    'n_procedures', 
    'n_medications', 
    'n_outpatient', 
    'n_inpatient', 
    'n_emergency', 
    'diagnosis', 
    'glucose_test', 
    'A1Ctest', 
    'change', 
    'diabetes_med'
]

X = data.loc[:, X_variables]
y = data.loc[:, "readmitted"]

X = pd.get_dummies(X, columns = ['age', 'diagnosis', 'glucose_test', 'A1Ctest', 'change', 'diabetes_med'], drop_first = True)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.3, random_state = 0)



# %% 1 -
threshold = 0.45



# %% 1 -
model_log = LogisticRegression(max_iter = 1000)
model_log.fit(X_train, y_train)



# %% 1 -
y_pred = model_log.predict(X_test)
# y_pred.head()



# %% 1 -
test_predprob = model_log.predict_proba(X_test)
test_pred = np.where(test_predprob[:, 1] > threshold, 1, 0)

print(classification_report(y_test, test_pred))
#               precision    recall  f1-score   support
# 
#            0       0.61      0.67      0.64      3880
#            1       0.60      0.53      0.57      3620
# 
#     accuracy                           0.60      7500
#    macro avg       0.60      0.60      0.60      7500
# weighted avg       0.60      0.60      0.60      7500



# %% 1 -
auc = roc_auc_score(y_test, test_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.642



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



# %% 1 -
model_nb = GaussianNB()
model_nb.fit(X_train, y_train)



# %% 1 -
y_pred = model_nb.predict(X_test)
# y_pred.head()



# %% 1 -
test_predprob = model_nb.predict_proba(X_test)
test_pred = np.where(test_predprob[:, 1] > threshold, 1, 0)

print(classification_report(y_test, test_pred))
#               precision    recall  f1-score   support
# 
#            0       0.57      0.81      0.67      3880
#            1       0.63      0.33      0.44      3620
# 
#     accuracy                           0.58      7500
#    macro avg       0.60      0.57      0.55      7500
# weighted avg       0.60      0.58      0.56      7500



# %% 1 -
auc = roc_auc_score(y_test, test_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.622



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
