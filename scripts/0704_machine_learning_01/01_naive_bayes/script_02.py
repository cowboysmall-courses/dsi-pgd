
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import confusion_matrix, precision_score, recall_score, accuracy_score, roc_curve, roc_auc_score


# %% 1 - import data and check the head
data = pd.read_csv("./data/0704_machine_learning_01/01_naive_bayes/EMPLOYEE CHURN DATA.csv")
data.head()


# %% 1 - 
data1 = data.loc[:, data.columns != 'sn']
data1.head()


# %% 1 - 
data2 = pd.get_dummies(data)
data2.head()


# %% 1 - 
X_emp = data2.loc[:, data2.columns != 'status']
y_emp = data2.loc[:, 'status']


# %% 1 - 
model_mnb = MultinomialNB(alpha = 0)
model_mnb.fit(X_emp, y_emp)


# %% 1 - 
predprob_mnb = model_mnb.predict_proba(X_emp)
predprob_mnb
# array([[1.00985819e-03, 9.98990142e-01],
#        [1.16744949e-03, 9.98832551e-01],
#        [1.92955021e-02, 9.80704498e-01],
#        [2.56259219e-02, 9.74374078e-01],
#        [4.19089170e-03, 9.95809108e-01],
#        [3.76917066e-02, 9.62308293e-01],
#        [4.97513309e-02, 9.50248669e-01],
#        [3.21819595e-03, 9.96781804e-01],
# ...
#        [9.99966508e-01, 3.34916549e-05],
#        [9.99932528e-01, 6.74717372e-05],
#        [9.99971038e-01, 2.89624814e-05],
#        [9.99924857e-01, 7.51433829e-05],
#        [9.99054650e-01, 9.45350120e-04]])


# %% 1 - 
cutoff = 0.3

pred_test = np.where(predprob_mnb[:, 1] > cutoff, 1, 0)


# %% 1 - 
confusion_matrix(y_emp, pred_test, labels=[0, 1])
# array([[47,  3],
#        [ 2, 31]])


# %% 1 - 
accuracy_score(y_emp, pred_test)
# 0.9397590361445783


# %% 1 - 
precision_score(y_emp, pred_test)
# 0.9117647058823529


# %% 1 - 
recall_score(y_emp, pred_test)
# 0.9393939393939394


# %% 1 - 
auc = roc_auc_score(y_emp, predprob_mnb[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.982


# %% 1 - 
fpr, tpr, thresholds = roc_curve(y_emp, predprob_mnb[:, 1])


# %% 1 - 
lw = 2

plt.figure()
plt.plot(fpr, tpr, color = 'darkorange', lw = lw, label = f"ROC curve (area = {auc:.3f})")
plt.plot([0, 1], [0, 1], color = 'navy', lw = lw, linestyle = '--')

plt.axis('tight')
plt.title("Receiver operating characteristic")
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')

plt.legend(loc = "lower right")
plt.show()
