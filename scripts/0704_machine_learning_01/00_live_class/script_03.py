
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import classification_report, confusion_matrix, precision_score, recall_score, accuracy_score, roc_curve, roc_auc_score



# %% 1 -
plt.figure(figsize = (8, 6))
plt.style.use("ggplot")

sns.set_style("darkgrid")
sns.set_context("paper")



# %% 1 - import data and check the head
data = pd.read_csv("./data/0704_machine_learning_01/00_live_class/EMPLOYEE CHURN DATA.csv")
data.head()
#    sn  status function          exp gender    source
# 0   1       1       CS           <3      M  external
# 1   2       1       CS           <3      M  external
# 2   3       1       CS  >=3 and <=5      M  internal
# 3   4       1       CS  >=3 and <=5      F  internal
# 4   5       1       CS           <3      M  internal



# %% 2 - 
data_sub = data.loc[:, data.columns != 'sn']
data_sub.head()
#    status function          exp gender    source
# 0       1       CS           <3      M  external
# 1       1       CS           <3      M  external
# 2       1       CS  >=3 and <=5      M  internal
# 3       1       CS  >=3 and <=5      F  internal
# 4       1       CS           <3      M  internal



# %% 2 - 
data_dummy = pd.get_dummies(data_sub)
data_dummy.head()
#    status  function_CS  function_FINANCE  function_MARKETING  exp_<3  exp_>5  \
# 0       1         True             False               False    True   False   
# 1       1         True             False               False    True   False   
# 2       1         True             False               False   False   False   
# 3       1         True             False               False   False   False   
# 4       1         True             False               False    True   False   

#    exp_>=3 and <=5  gender_F  gender_M  source_external  source_internal  
# 0            False     False      True             True            False  
# 1            False     False      True             True            False  
# 2             True     False      True            False             True  
# 3             True      True     False            False             True  
# 4            False     False      True            False             True  



# %% 4 - 
X_emp = data_dummy.loc[:, data_dummy.columns != 'status']
y_emp = data_dummy.loc[:, 'status']



# %% 5 - 
mnb_model = MultinomialNB(alpha = 0.0001)
mnb_model.fit(X_emp, y_emp)

y_pred = mnb_model.predict_proba(X_emp)




# %% 6 - 
cutoff = 0.3

pred_test = np.where(y_pred[:, 1] > cutoff, 1, 0)
pred_test
# array([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
#        1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0,
#        1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
#        0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1])



# %% 7 - 
confusion_matrix(y_emp, pred_test, labels = [0, 1])
# array([[37, 13],
#        [ 3, 30]])



# %% 8 - 
print(accuracy_score(y_emp, pred_test))
# 0.8072289156626506

print(precision_score(y_emp, pred_test))
# 0.6976744186046512

print(recall_score(y_emp, pred_test))
# 0.9090909090909091



# %% 9 - 
print(classification_report(y_emp, pred_test))
#               precision    recall  f1-score   support

#            0       0.93      0.74      0.82        50
#            1       0.70      0.91      0.79        33

#     accuracy                           0.81        83
#    macro avg       0.81      0.82      0.81        83
# weighted avg       0.83      0.81      0.81        83



# %% 10 - 
auc = roc_auc_score(y_emp, y_pred[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.871



# %% 11 - 
fpr, tpr, thresholds = roc_curve(y_emp, y_pred[:, 1])

plt.figure()

plt.plot(fpr, tpr, color = "darkorange", lw = 2, label = f"ROC curve (area = {auc:0.3f})")
plt.plot([0, 1], [0, 1], color = "navy", lw = 2, linestyle = "--")

plt.title("Receiver Operating Characteristic")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.axis("tight")

plt.show()
