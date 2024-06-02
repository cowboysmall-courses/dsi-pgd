

# BACKGROUND:
#
#     The data is a marketing campaign data of a skin care clinic associated
#     with its success.
#
#     Description of variables:
#
#         Success:         Response to marketing campaign of Skin Care Clinic
#                          which offers both products and services. (1: email
#                          Opened, 0: email not opened)
#         AGE:             Age Group of Customer
#         Recency_Service: Number of days since last service purchase
#         Recency_Product: Number of days since last product purchase
#         Bill_Service:    Total bill amount for service in last 3 months
#         Bill_Product:    Total bill amount for products in last 3 months
#         Gender:          (1: Male, 2: Female)
#
#     Note: Answer following questions using entire data and do not create test
#           data.
#
# QUESTIONS
# 
#     1: Import Email Campaign data. Obtain decision tree to classify cases as
#        success=0 or 1. Obtain Sensitivity/Recall using cut-off value as 0.50
#        for estimated probabilities.
#     2: Compare performance of Decision Tree and Random Forest Method using
#        area under the ROC curve.
#     3: Implement Neural Network Algorithm and obtain are under the ROC curve.





# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import cross_val_predict, cross_val_score
from sklearn.metrics import classification_report, confusion_matrix, precision_score, recall_score, accuracy_score, roc_curve, roc_auc_score

import warnings
warnings.filterwarnings("ignore", category = FutureWarning)

# import random
# random.seed(1024)




# %% 0 - function for plotting ROC curves
def plot_roc_curve(fpr, tpr, auc, description = None):
    plt.figure()

    plt.plot(fpr, tpr, color = "darkorange", lw = 2, label = f"ROC curve (area = {auc:0.3f})")
    plt.plot([0, 1], [0, 1], color = "navy", lw = 2, linestyle = "--")

    plt.title(f"Receiver Operating Characteristic (ROC) Curve{f" - {description}" if description else ""}")
    plt.xlabel("False Positive Rate")
    plt.ylabel("True Positive Rate")

    plt.legend(loc = "lower right")
    plt.axis("tight")

    plt.show()










# %%

# 1: Import Email Campaign data. Obtain decision tree to classify cases as
#    success = 0 or 1. Obtain Sensitivity/Recall using cut-off value as 0.50
#    for estimated probabilities.


# %% 1 - import data and check
data = pd.read_csv("./data/0804_machine_learning_02/05_assignment/Email Campaign.csv")
data.head()
#    SN  Gender   AGE  Recency_Service  Recency_Product  Bill_Service  \
# 0   1       1  <=45               12               11         11.82   
# 1   2       2  <=30                6                0         10.31   
# 2   3       1  <=30                1                9          7.43   
# 3   4       1  <=45                2               14         13.68   
# 4   5       2  <=30                0               11          4.56   

#    Bill_Product  Success  
# 0          2.68        0  
# 1          1.32        0  
# 2          0.49        0  
# 3          1.85        0  
# 4          1.01        1  


# %% 1 - 
data.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 683 entries, 0 to 682
# Data columns (total 8 columns):
#  #   Column           Non-Null Count  Dtype  
# ---  ------           --------------  -----  
#  0   SN               683 non-null    int64  
#  1   Gender           683 non-null    int64  
#  2   AGE              683 non-null    object 
#  3   Recency_Service  683 non-null    int64  
#  4   Recency_Product  683 non-null    int64  
#  5   Bill_Service     683 non-null    float64
#  6   Bill_Product     683 non-null    float64
#  7   Success          683 non-null    int64  
# dtypes: float64(2), int64(5), object(1)
# memory usage: 42.8+ KB


# %% 1 - 
data = data.drop(['SN'], axis = 1)

data['Gender']  = pd.Categorical(np.where(data['Gender'] == 1, "Male", "Female"))
data['AGE']     = pd.Categorical(data['AGE'])
data['Success'] = pd.Categorical(data['Success'])


# %% 1 - 
data_dummy = pd.get_dummies(data, columns = ["Gender", "AGE"], drop_first = True)


# %% 1 - 
data_dummy.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 683 entries, 0 to 682
# Data columns (total 8 columns):
#  #   Column           Non-Null Count  Dtype   
# ---  ------           --------------  -----   
#  0   Recency_Service  683 non-null    int64   
#  1   Recency_Product  683 non-null    int64   
#  2   Bill_Service     683 non-null    float64 
#  3   Bill_Product     683 non-null    float64 
#  4   Success          683 non-null    category
#  5   Gender_Male      683 non-null    bool    
#  6   AGE_<=45         683 non-null    bool    
#  7   AGE_<=55         683 non-null    bool    
# dtypes: bool(3), category(1), float64(2), int64(2)
# memory usage: 24.3 KB


# %% 1 - 
X = data_dummy.loc[:, data_dummy.columns != 'Success']
y = data_dummy.loc[:, 'Success']


# %% 1 - 
model_dt = DecisionTreeClassifier(criterion = 'entropy', min_samples_split = int(len(X) * 0.1))
model_dt.fit(X, y)


# %% 1 - 
y_prob_dt = model_dt.predict_proba(X)
y_pred_dt = np.where(y_prob_dt[:, 1] > 0.5, 1, 0)


# %% 1 - 
print(confusion_matrix(y, y_pred_dt, labels = [0, 1]))
# [[479  24]
#  [101  79]]


# %% 1 - 
print(classification_report(y, y_pred_dt))
#               precision    recall  f1-score   support
# 
#            0       0.83      0.95      0.88       503
#            1       0.77      0.44      0.56       180
# 
#     accuracy                           0.82       683
#    macro avg       0.80      0.70      0.72       683
# weighted avg       0.81      0.82      0.80       683


# %% 1 - 
print(f" Decision Tree Accuracy: {accuracy_score(y, y_pred_dt)}")
print(f"Decision Tree Precision: {precision_score(y, y_pred_dt)}")
print(f"   Decision Tree Recall: {recall_score(y, y_pred_dt)}")
#  Decision Tree Accuracy: 0.8169838945827232
# Decision Tree Precision: 0.7669902912621359
#    Decision Tree Recall: 0.4388888888888889










# %%

# 2: Compare performance of Decision Tree and Random Forest Method using
#    area under the ROC curve.


# %% 2 - 
model_rf = RandomForestClassifier(n_estimators = 100, oob_score = True, max_features = "sqrt")
model_rf.fit(X, y)


# %% 2 - 
y_prob_rf = model_rf.predict_proba(X)


# %% 2 -
auc_dt = roc_auc_score(y, y_prob_dt[:, 1])
auc_rf = roc_auc_score(y, y_prob_rf[:, 1])


# %% 2 -
print(f"Decision Tree AUC: {auc_dt:.3f}")
print(f"Random Forest AUC: {auc_rf:.3f}")
# Decision Tree AUC: 0.870
# Random Forest AUC: 1.000


# %% 2 -
fpr_dt, tpr_dt, _ = roc_curve(y, y_prob_dt[:, 1])
fpr_rf, tpr_rf, _ = roc_curve(y, y_prob_rf[:, 1])


# %% 2 -
plot_roc_curve(fpr_dt, tpr_dt, auc_dt, description = "Decision Tree")


# %% 2 -
plot_roc_curve(fpr_rf, tpr_rf, auc_rf, description = "Random Forest")





# %% 2 -
y_pred_rf = np.where(y_prob_rf[:, 1] > 0.5, 1, 0)


# %% 2 - 
print(confusion_matrix(y, y_pred_rf, labels = [0, 1]))
# [[503   0]
#  [  0 180]]


# %% 2 - 
print(classification_report(y, y_pred_rf))
#               precision    recall  f1-score   support
# 
#            0       1.00      1.00      1.00       503
#            1       1.00      1.00      1.00       180
# 
#     accuracy                           1.00       683
#    macro avg       1.00      1.00      1.00       683
# weighted avg       1.00      1.00      1.00       683


# %% 2 - 
print(f" Random Forest Accuracy: {accuracy_score(y, y_pred_rf)}")
print(f"Random Forest Precision: {precision_score(y, y_pred_rf)}")
print(f"   Random Forest Recall: {recall_score(y, y_pred_rf)}")
#  Random Forest Accuracy: 1.0
# Random Forest Precision: 1.0
#    Random Forest Recall: 1.0










# %%

# 3: Implement Neural Network Algorithm and obtain are under the ROC curve.


# %% 3 - 
scaler   = MinMaxScaler( )
X_scaled = scaler.fit_transform(X)


# %% 3 - 
model_mlp = MLPClassifier(hidden_layer_sizes = (3, ), max_iter = 1000)
model_mlp.fit(X_scaled, y)


# %% 3 - 
y_prob_mlp = model_mlp.predict_proba(X_scaled)


# %% 3 -
auc_mlp = roc_auc_score(y, y_prob_mlp[:, 1])


# %% 3 -
print(f"Neural Network AUC: {auc_mlp:.3f}")
# Neural Network AUC: 0.855


# %% 3 -
fpr_mlp, tpr_mlp, _ = roc_curve(y, y_prob_mlp[:, 1])


# %% 3 -
plot_roc_curve(fpr_mlp, tpr_mlp, auc_mlp, description = "Neural Network")





# %% 3 -
y_pred_mlp = np.where(y_prob_mlp[:, 1] > 0.5, 1, 0)


# %% 3 - 
print(confusion_matrix(y, y_pred_mlp, labels = [0, 1]))
# [[476  27]
#  [100  80]]


# %% 3 - 
print(classification_report(y, y_pred_mlp))
#               precision    recall  f1-score   support
# 
#            0       0.83      0.95      0.88       503
#            1       0.75      0.44      0.56       180
# 
#     accuracy                           0.81       683
#    macro avg       0.79      0.70      0.72       683
# weighted avg       0.81      0.81      0.80       683


# %% 3 - 
print(f" Neural Network Accuracy: {accuracy_score(y, y_pred_mlp)}")
print(f"Neural Network Precision: {precision_score(y, y_pred_mlp)}")
print(f"   Neural Network Recall: {recall_score(y, y_pred_mlp)}")
#  Neural Network Accuracy: 0.8140556368960469
# Neural Network Precision: 0.7476635514018691
#    Neural Network Recall: 0.4444444444444444










# %%

# 4. Addendum - look at the Random Forest classifier performance - using cross
#    validation - to get a more realistic indication of the performance of the 
#    classifier


# %% 4 - 
model_rf_cv  = RandomForestClassifier(n_estimators = 100, oob_score = True, max_features = "sqrt")
scores_rf_cv = cross_val_score(model_rf_cv, X, y, cv = 5, scoring = 'roc_auc')
print(f"Random Forest (CV) - mean AUC: {scores_rf_cv.mean():.3f}")
print(f"Random Forest (CV) -  Max AUC: {scores_rf_cv.max():.3f}")
# Random Forest (CV) - mean AUC: 0.788
# Random Forest (CV) -  Max AUC: 0.847


# %% 4 - 
model_rf_cv  = RandomForestClassifier(n_estimators = 100, oob_score = True, max_features = "sqrt")
y_prob_rf_cv = cross_val_predict(model_rf_cv, X, y, cv = 5, method = 'predict_proba')


# %% 4 -
auc_rf_cv = roc_auc_score(y, y_prob_rf_cv[:, 1])


# %% 4 -
print(f"Random Forest (CV) AUC: {auc_rf_cv:.3f}")
# Random Forest (CV) AUC: 0.791


# %% 4 -
fpr_rf_cv, tpr_rf_cv, _ = roc_curve(y, y_prob_rf_cv[:, 1])


# %% 4 -
plot_roc_curve(fpr_rf_cv, tpr_rf_cv, auc_rf_cv, description = "Random Forest (CV)")



# %% 4 - 
y_pred_rf_cv = np.where(y_prob_rf_cv[:, 1] > 0.5, 1, 0)


# %% 4 - 
print(confusion_matrix(y, y_pred_rf_cv, labels = [0, 1]))
# [[458  45]
#  [ 97  83]]


# %% 4 - 
print(classification_report(y, y_pred_rf_cv))
#               precision    recall  f1-score   support
# 
#            0       0.83      0.91      0.87       503
#            1       0.65      0.46      0.54       180
# 
#     accuracy                           0.79       683
#    macro avg       0.74      0.69      0.70       683
# weighted avg       0.78      0.79      0.78       683


# %% 4 - 
print(f" Random Forest (CV) Accuracy: {accuracy_score(y, y_pred_rf_cv)}")
print(f"Random Forest (CV) Precision: {precision_score(y, y_pred_rf_cv)}")
print(f"   Random Forest (CV) Recall: {recall_score(y, y_pred_rf_cv)}")
#  Random Forest (CV) Accuracy: 0.7920937042459737
# Random Forest (CV) Precision: 0.6484375
#    Random Forest (CV) Recall: 0.46111111111111114

# %%
