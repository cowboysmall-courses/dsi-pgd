#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 17 16:52:03 2024

@author: jerry
"""




# %% 0 - Import libraries
import pandas as pd
import matplotlib.pyplot as plt
# import scikitplot as skplt
import seaborn as sns

from statsmodels.formula.api import logit

from sklearn.metrics import roc_curve, auc
from scipy.stats import ks_2samp





# %% 0 - 
data = pd.read_csv("../../../data/0404_advanced_predictive_modelling/live_class/BANK LOAN.csv")
         



# %% 0 -             
data['AGE'] = data['AGE'].astype('category')




# %% 0 - 
model = logit('DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT', data = data).fit()
model.summary()
# """
#                            Logit Regression Results                           
# ==============================================================================
# Dep. Variable:              DEFAULTER   No. Observations:                  700
# Model:                          Logit   Df Residuals:                      695
# Method:                           MLE   Df Model:                            4
# Date:                Sat, 17 Feb 2024   Pseudo R-squ.:                  0.3079
# Time:                        17:00:50   Log-Likelihood:                -278.37
# converged:                       True   LL-Null:                       -402.18
# Covariance Type:            nonrobust   LLR p-value:                 2.114e-52
# ==============================================================================
#                  coef    std err          z      P>|z|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     -0.7911      0.252     -3.145      0.002      -1.284      -0.298
# EMPLOY        -0.2426      0.028     -8.646      0.000      -0.298      -0.188
# ADDRESS       -0.0812      0.020     -4.144      0.000      -0.120      -0.043
# DEBTINC        0.0883      0.019      4.760      0.000       0.052       0.125
# CREDDEBT       0.5729      0.087      6.566      0.000       0.402       0.744
# ==============================================================================
# """




# %% 0 - 
data = data.assign(pred = model.predict())




# %% 0 - 
fpr, tpr, thresholds = roc_curve(data['DEFAULTER'], data['pred'])
ruc_auc = auc(fpr, tpr)




# %% 0 - 
lw = 2

plt.figure()

plt.plot(fpr, tpr, color = 'darkorange', lw = lw, label = 'ROC curve (area = %0.2f)' % ruc_auc)
plt.plot([0, 1], [0, 1], color = 'navy', lw = lw, linestyle = '--')

plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver operating characteristic')
plt.legend(loc="lower right")

plt.show()




# %% 0 - 
print("Area under the ROC curve : %f" % ruc_auc)
# Area under the ROC curve : 0.855619




# %% 0 - 
# X = data[["EMPLOY", "ADDRESS", "DEBTINC", "CREDDEBT"]]
# y = data[["DEFAULTER"]]

# log_model = LogisticRegression()
# log_model.fit(X, y)

# pred_log = log_model.predict_proba(X)

# skplt.metrics.plot_lift_curve(y, pred_log)
# plt.show()




# %% 0 - 
ks_2samp(data.loc[data.DEFAULTER == 0, "pred"], data.loc[data.DEFAULTER == 1, "pred"])
# KstestResult(statistic=0.561552039403452, pvalue=4.984622730585168e-40, statistic_location=0.18623437807769838, statistic_sign=1)



# %% 0 - 
data = data.assign(resid = model.resid_pearson)
data.head()
#    SN AGE  EMPLOY  ADDRESS  ...  OTHDEBT  DEFAULTER      pred     resid
# 0   1   3      17       12  ...     5.01          1  0.808347  0.486922
# 1   2   1      10        6  ...     4.00          0  0.198115 -0.497052
# 2   3   2      15       14  ...     2.17          0  0.010063 -0.100822
# 3   4   3      15       14  ...     0.82          0  0.022160 -0.150539
# 4   5   1       2        0  ...     3.06          1  0.781808  0.528286




# %% 0 - 
sns.scatterplot(x = "SN", y = "resid", data = data)
plt.xlabel("SN")
plt.ylabel("residual")



