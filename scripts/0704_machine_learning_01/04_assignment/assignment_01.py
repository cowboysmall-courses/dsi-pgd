

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
#     1: Import Email Campaign data. Perform binary logistic regression to model
#        "Success". Interpret sign of each significant variable in the model.
#     2: Compare performance of Binary Logistic Regression (significant
#        variables) and Naïve Bayes Method (all variables) using area under the
#        ROC curve.
#     3: Implement binary logistic regression and Support Vector Machines by
#        combining service and product variables. State area under the ROC curve
#        in each case.





# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from statsmodels.formula.api import logit
from statsmodels.stats.outliers_influence import variance_inflation_factor

from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.naive_bayes import MultinomialNB
from sklearn.svm import SVC
from sklearn.metrics import classification_report, roc_curve, roc_auc_score

import warnings
warnings.filterwarnings("ignore", category = FutureWarning)

import random
random.seed(27041970)





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

# 1. Import Email Campaign data. Perform binary logistic regression to model
#    "Success". Interpret sign of each significant variable in the model.


# %% 1 - import data and check
data = pd.read_csv("./data/0704_machine_learning_01/04_assignment/Email Campaign.csv")
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
data.isna().sum()
# SN                 0
# Gender             0
# AGE                0
# Recency_Service    0
# Recency_Product    0
# Bill_Service       0
# Bill_Product       0
# Success            0
# dtype: int64


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

data['Gender'] = pd.Categorical(np.where(data['Gender'] == 1, "Male", "Female"))
data['AGE']    = pd.Categorical(data['AGE'])


# %% 1 - 
data.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 683 entries, 0 to 682
# Data columns (total 7 columns):
#  #   Column           Non-Null Count  Dtype   
# ---  ------           --------------  -----   
#  0   Gender           683 non-null    category
#  1   AGE              683 non-null    category
#  2   Recency_Service  683 non-null    int64   
#  3   Recency_Product  683 non-null    int64   
#  4   Bill_Service     683 non-null    float64 
#  5   Bill_Product     683 non-null    float64 
#  6   Success          683 non-null    int64   
# dtypes: category(2), float64(2), int64(3)
# memory usage: 28.4 KB


# %% 1 - 
counts = data['Success'].value_counts().reset_index()
counts.columns = ['Success', 'Freq']
counts['Percent'] = counts['Freq'] / counts['Freq'].sum()
print(counts)
#    Success  Freq   Percent
# 0        0   503  0.736457
# 1        1   180  0.263543


# %% 1 - 
# we could use the percent value from the counts table above for the cutoff,
# which would reflect the prior distribution of Success, but instead I will
# use 0.5 and look at the optimal cutoffs at each stage to see how they may 
# vary

# cutoff = 0.26
cutoff = 0.5


# %% 1 - 
model = logit('Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product', data = data).fit()
model.summary()
# <class 'statsmodels.iolib.summary.Summary'>
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:                Success   No. Observations:                  683
# Model:                          Logit   Df Residuals:                      675
# Method:                           MLE   Df Model:                            7
# Date:                Wed, 22 May 2024   Pseudo R-squ.:                  0.3070
# Time:                        17:02:34   Log-Likelihood:                -272.99
# converged:                       True   LL-Null:                       -393.91
# Covariance Type:            nonrobust   LLR p-value:                 1.516e-48
# ===================================================================================
#                       coef    std err          z      P>|z|      [0.025      0.975]
# -----------------------------------------------------------------------------------
# Intercept          -1.2585      0.271     -4.641      0.000      -1.790      -0.727
# Gender[T.Male]      0.2370      0.214      1.107      0.268      -0.183       0.657
# AGE[T.<=45]         0.1572      0.267      0.588      0.556      -0.367       0.681
# AGE[T.<=55]         0.6727      0.366      1.839      0.066      -0.044       1.390
# Recency_Service    -0.2459      0.029     -8.352      0.000      -0.304      -0.188
# Recency_Product    -0.0909      0.022     -4.117      0.000      -0.134      -0.048
# Bill_Service        0.0929      0.019      5.013      0.000       0.057       0.129
# Bill_Product        0.5197      0.081      6.413      0.000       0.361       0.678
# ===================================================================================
# """


# %% 1 -
vif_data = pd.DataFrame()
vif_data["Feature"] = model.model.exog_names[1:]
vif_data["VIF"] = [variance_inflation_factor(model.model.exog, i) for i in range(1, model.model.exog.shape[1])]
vif_data
#            Feature       VIF
# 0   Gender[T.Male]  1.010874
# 1      AGE[T.<=45]  1.622806
# 2      AGE[T.<=55]  2.300305
# 3  Recency_Service  1.653418
# 4  Recency_Product  1.495121
# 5     Bill_Service  1.468963
# 6     Bill_Product  1.755991


# %% 1 - 
model = logit('Success ~ Recency_Service + Recency_Product + Bill_Service + Bill_Product', data = data).fit()
model.summary()
# <class 'statsmodels.iolib.summary.Summary'>
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:                Success   No. Observations:                  683
# Model:                          Logit   Df Residuals:                      678
# Method:                           MLE   Df Model:                            4
# Date:                Wed, 22 May 2024   Pseudo R-squ.:                  0.3008
# Time:                        17:04:48   Log-Likelihood:                -275.44
# converged:                       True   LL-Null:                       -393.91
# Covariance Type:            nonrobust   LLR p-value:                 4.224e-50
# ===================================================================================
#                       coef    std err          z      P>|z|      [0.025      0.975]
# -----------------------------------------------------------------------------------
# Intercept          -1.1578      0.248     -4.673      0.000      -1.643      -0.672
# Recency_Service    -0.2298      0.027     -8.426      0.000      -0.283      -0.176
# Recency_Product    -0.0739      0.019     -3.825      0.000      -0.112      -0.036
# Bill_Service        0.0918      0.018      4.974      0.000       0.056       0.128
# Bill_Product        0.5185      0.081      6.415      0.000       0.360       0.677
# ===================================================================================
# """


# %% 1 -
vif_data = pd.DataFrame()
vif_data["Feature"] = model.model.exog_names[1:]
vif_data["VIF"] = [variance_inflation_factor(model.model.exog, i) for i in range(1, model.model.exog.shape[1])]
vif_data
#            Feature       VIF
# 0  Recency_Service  1.395258
# 1  Recency_Product  1.149015
# 2     Bill_Service  1.468302
# 3     Bill_Product  1.750976


# %% 1 -

# - one unit increase in the Recency_Service estimator will result in a -0.2298
#   change in the log odds of the email being successfully opened
# - one unit increase in the Recency_Product estimator will result in a -0.0739
#   change in the log odds of the email being successfully opened

# - one unit increase in the Bill_Service estimator will result in a 0.0918
#   change in the log odds of the email being successfully opened
# - one unit increase in the Bill_Product estimator will result in a 0.5185
#   change in the log odds of the email being successfully opened

# - Both the estimates of Recency_Service and Recency_Product negatively affect
#   the outcome - the greater the value of each estimator, the less is the
#   likelihood a successful outcome

# - Both the estimates of Bill_Service and Bill_Product positively affect the
#   outcome - the greater the value of each estimator, the more is the
#   likelihood a successful outcome










# %% 2 -

# 2. Compare performance of Binary Logistic Regression (significant variables)
#    and Naïve Bayes Method (all variables) using area under the ROC curve.


#   My approach is as follows:
#     1. split the data into train and test data sets 
#     2. train a model for each classifier (glm and naive bayes) 
#     3. evaluate the models with both train and test sets - to 
#        ensure that each of the models are consistent and perform 
#        well
#     4. compare the results of each model's performance for the 
#        test data set


# %% 2 -
sig_preds  = ["Recency_Service", "Recency_Product", "Bill_Service", "Bill_Product"]

data_dummy = pd.get_dummies(data)


# %% 2 -
X = data_dummy.loc[:, data_dummy.columns != 'Success']
y = data_dummy.loc[:, 'Success']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.3, random_state = 27041970)





# %% 2 -
model_log = LogisticRegression(max_iter = 1000)
model_log.fit(X_train[sig_preds], y_train)


# %% 2 -
y_pred = model_log.predict(X_train[sig_preds])


# %% 2 -
train_predprob = model_log.predict_proba(X_train[sig_preds])
train_pred     = np.where(train_predprob[:, 1] > cutoff, 1, 0)


# %% 2 -
auc = roc_auc_score(y_train, train_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.841


# %% 2 -
fpr, tpr, thresholds = roc_curve(y_train, train_predprob[:, 1])

plot_roc_curve(fpr, tpr, auc, description = "Logistic Regression")


# %% 2 -
optimal_threshold = round(thresholds[np.argmax(tpr - fpr)], 3)
print(f'Best Threshold is : {optimal_threshold}')
# Best Threshold is : 0.289


# %% 2 -
print(classification_report(y_train, train_pred))
#               precision    recall  f1-score   support
# 
#            0       0.83      0.93      0.87       353
#            1       0.69      0.46      0.55       125
# 
#     accuracy                           0.80       478
#    macro avg       0.76      0.69      0.71       478
# weighted avg       0.79      0.80      0.79       478


# %% 2 -
y_pred = model_log.predict(X_test[sig_preds])


# %% 2 -
test_predprob = model_log.predict_proba(X_test[sig_preds])
test_pred     = np.where(test_predprob[:, 1] > cutoff, 1, 0)


# %% 2 -
auc = roc_auc_score(y_test, test_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.875


# %% 2 -
fpr, tpr, thresholds = roc_curve(y_test, test_predprob[:, 1])

plot_roc_curve(fpr, tpr, auc, description = "Logistic Regression")


# %% 2 -
optimal_threshold = round(thresholds[np.argmax(tpr - fpr)], 3)
print(f'Best Threshold is : {optimal_threshold}')
# Best Threshold is : 0.256


# %% 2 -
print(classification_report(y_test, test_pred))
#               precision    recall  f1-score   support
# 
#            0       0.86      0.93      0.89       150
#            1       0.75      0.60      0.67        55
# 
#     accuracy                           0.84       205
#    macro avg       0.81      0.76      0.78       205
# weighted avg       0.83      0.84      0.83       205


# %% 2 -

# The glm model performs consistently well





# %% 2 -
model_nb = MultinomialNB(alpha = 0)
model_nb.fit(X_train, y_train)


# %% 2 -
y_pred = model_nb.predict(X_train)


# %% 2 -
train_predprob = model_nb.predict_proba(X_train)
train_pred     = np.where(train_predprob[:, 1] > cutoff, 1, 0)


# %% 2 -
auc = roc_auc_score(y_train, train_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.814


# %% 2 -
fpr, tpr, thresholds = roc_curve(y_train, train_predprob[:, 1])

plot_roc_curve(fpr, tpr, auc, description = "Naive Bayes")


# %% 2 -
optimal_threshold = round(thresholds[np.argmax(tpr - fpr)], 3)
print(f'Best Threshold is : {optimal_threshold}')
# Best Threshold is : 0.163


# %% 2 -
print(classification_report(y_train, train_pred))
#               precision    recall  f1-score   support
# 
#            0       0.86      0.76      0.81       353
#            1       0.50      0.66      0.57       125
# 
#     accuracy                           0.74       478
#    macro avg       0.68      0.71      0.69       478
# weighted avg       0.77      0.74      0.75       478


# %% 2 -
y_pred = model_nb.predict(X_test)


# %% 2 -
test_predprob = model_nb.predict_proba(X_test)
test_pred     = np.where(test_predprob[:, 1] > cutoff, 1, 0)


# %% 2 -
auc = roc_auc_score(y_test, test_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.846


# %% 2 -
fpr, tpr, thresholds = roc_curve(y_test, test_predprob[:, 1])

plot_roc_curve(fpr, tpr, auc, description = "Naive Bayes")


# %% 2 -
optimal_threshold = round(thresholds[np.argmax(tpr - fpr)], 3)
print(f'Best Threshold is : {optimal_threshold}')
# Best Threshold is : 0.455


# %% 2 -
print(classification_report(y_test, test_pred))
#               precision    recall  f1-score   support
# 
#            0       0.91      0.76      0.83       150
#            1       0.55      0.80      0.65        55
# 
#     accuracy                           0.77       205
#    macro avg       0.73      0.78      0.74       205
# weighted avg       0.81      0.77      0.78       205


# %% 2 -

# The naive bayes model performs consistently well


# %% 2 -

# According to the above analysis, the glm model outperforms the naive bayes
# model significantly - looking at AUC for the test data for each model:
#     GLM AUC: 0.875
#      NB AUC: 0.846










# %% 3 -

# 3. Implement binary logistic regression and Support Vector Machines by
#    combining service and product variables. State area under the ROC curve
#    in each case.


# For this exercise I have decided on the following ways of combining the data:
#     1. Bill_Total  = Bill_Service + Bill_Product
#     2. Recency_Max = max(Recency_Service, Recency_Product)
# I was considering adding both Recency values to get an indication of the
# magnitude of both Recency values, but in the end went with the max value of
# each.


# %% 3 -
# sig_preds  = ["Recency_Service", "Recency_Product", "Bill_Service", "Bill_Product"]
data['Recency_Max'] = data[['Recency_Service', 'Recency_Product']].max(axis = 1)
data['Bill_Total']  = data['Bill_Service'] + data['Bill_Product']
data.head()
#    SN  Gender   AGE  Recency_Service  Recency_Product  Bill_Service  \
# 0   1    Male  <=45               12               11         11.82   
# 1   2  Female  <=30                6                0         10.31   
# 2   3    Male  <=30                1                9          7.43   
# 3   4    Male  <=45                2               14         13.68   
# 4   5  Female  <=30                0               11          4.56   

#    Bill_Product  Success  Recency_Max  Bill_Total  
# 0          2.68        0           12       14.50  
# 1          1.32        0            6       11.63  
# 2          0.49        0            9        7.92  
# 3          1.85        0           14       15.53  
# 4          1.01        1           11        5.57  


# %% 3 -
X = data.loc[:, ['Recency_Max', 'Bill_Total']]
y = data.loc[:, 'Success']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.3, random_state = 27041970)





# %% 3 -
model_log = LogisticRegression(max_iter = 1000)
model_log.fit(X_train, y_train)


# %% 3 -
y_pred = model_log.predict(X_train)


# %% 3 -
train_predprob = model_log.predict_proba(X_train)
train_pred     = np.where(train_predprob[:, 1] > cutoff, 1, 0)


# %% 3 -
auc = roc_auc_score(y_train, train_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.805


# %% 3 -
fpr, tpr, thresholds = roc_curve(y_train, train_predprob[:, 1])

plot_roc_curve(fpr, tpr, auc, description = "Logistic Regression")


# %% 2 -
optimal_threshold = round(thresholds[np.argmax(tpr - fpr)], 3)
print(f'Best Threshold is : {optimal_threshold}')
# Best Threshold is : 


# %% 3 -
print(classification_report(y_train, train_pred))
#               precision    recall  f1-score   support
# 
#            0       0.81      0.93      0.87       353
#            1       0.66      0.38      0.48       125
# 
#     accuracy                           0.79       478
#    macro avg       0.73      0.66      0.68       478
# weighted avg       0.77      0.79      0.77       478


# %% 3 -
y_pred = model_log.predict(X_test)


# %% 3 -
test_predprob = model_log.predict_proba(X_test)
test_pred     = np.where(test_predprob[:, 1] > cutoff, 1, 0)


# %% 3 -
auc = roc_auc_score(y_test, test_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.843


# %% 3 -
fpr, tpr, thresholds = roc_curve(y_test, test_predprob[:, 1])

plot_roc_curve(fpr, tpr, auc, description = "Logistic Regression")


# %% 2 -
optimal_threshold = round(thresholds[np.argmax(tpr - fpr)], 3)
print(f'Best Threshold is : {optimal_threshold}')
# Best Threshold is : 


# %% 3 -
print(classification_report(y_test, test_pred))
#               precision    recall  f1-score   support
# 
#            0       0.83      0.95      0.89       150
#            1       0.78      0.45      0.57        55
# 
#     accuracy                           0.82       205
#    macro avg       0.80      0.70      0.73       205
# weighted avg       0.81      0.82      0.80       205


# %% 3 -

# The glm model performs consistently well





# %% 3 - SVM / SVC
model_svm = SVC(probability = True, random_state = 0, kernel = "linear")
model_svm.fit(X_train, y_train)


# %% 3 -
y_pred = model_svm.predict(X_train)


# %% 3 -
train_predprob = model_svm.predict_proba(X_train)
train_pred     = np.where(train_predprob[:, 1] > cutoff, 1, 0)


# %% 3 -
auc = roc_auc_score(y_train, train_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.806


# %% 3 -
fpr, tpr, thresholds = roc_curve(y_train, train_predprob[:, 1])

plot_roc_curve(fpr, tpr, auc, description = "SVM")


# %% 2 -
optimal_threshold = round(thresholds[np.argmax(tpr - fpr)], 3)
print(f'Best Threshold is : {optimal_threshold}')
# Best Threshold is : 


# %% 3 -
print(classification_report(y_train, train_pred))
#               precision    recall  f1-score   support
# 
#            0       0.80      0.93      0.86       353
#            1       0.64      0.33      0.43       125
# 
#     accuracy                           0.78       478
#    macro avg       0.72      0.63      0.65       478
# weighted avg       0.76      0.78      0.75       478


# %% 3 -
y_pred = model_svm.predict(X_test)


# %% 3 -
test_predprob = model_svm.predict_proba(X_test)
test_pred     = np.where(test_predprob[:, 1] > cutoff, 1, 0)


# %% 3 -
auc = roc_auc_score(y_test, test_predprob[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.844


# %% 3 -
fpr, tpr, thresholds = roc_curve(y_test, test_predprob[:, 1])

plot_roc_curve(fpr, tpr, auc, description = "SVM")


# %% 2 -
optimal_threshold = round(thresholds[np.argmax(tpr - fpr)], 3)
print(f'Best Threshold is : {optimal_threshold}')
# Best Threshold is : 


# %% 3 -
print(classification_report(y_test, test_pred))
#               precision    recall  f1-score   support
# 
#            0       0.82      0.97      0.89       150
#            1       0.82      0.42      0.55        55
# 
#     accuracy                           0.82       205
#    macro avg       0.82      0.69      0.72       205
# weighted avg       0.82      0.82      0.80       205


# %% 3 -

# The svm model performs consistently well


# %% 3 -

# According to the above analysis, the glm model and the svm model perform
# almost identically - looking at AUC for the train and test data for each
# model in turn:
# 
# Training Data:
#       GLM AUC: 0.805
#       SVM AUC: 0.806
# 
#     Test Data:
#       GLM AUC: 0.843
#       SVM AUC: 0.844
