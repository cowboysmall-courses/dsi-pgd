
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.naive_bayes import GaussianNB, MultinomialNB
from sklearn.metrics import confusion_matrix, f1_score, precision_score, recall_score, accuracy_score, roc_curve, roc_auc_score


# %% 1 - import data and check the head
data = pd.read_csv("./data/0704_machine_learning_01/01_naive_bayes/BANK LOAN.csv")
data = data.drop(['SN', 'AGE'], axis = 1)
data.head()


# %% 1 - 
X = data.loc[:, data.columns != 'DEFAULTER']
y = data.loc[:, 'DEFAULTER']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.30, random_state = 999)


# %% 1 - 
model_nb = GaussianNB()
model_nb.fit(X_train, y_train)


# %% 1 - 
predprob_test = model_nb.predict_proba(X_test)
predprob_test
# array([[9.64990910e-01, 3.50090901e-02],
#        [8.69418283e-01, 1.30581717e-01],
#        [9.05857441e-01, 9.41425591e-02],
#        [9.73983929e-01, 2.60160712e-02],
#        [9.95494450e-01, 4.50555043e-03],
#        [5.29787237e-01, 4.70212763e-01],
# ...
#        [6.79197400e-01, 3.20802600e-01],
#        [8.68114889e-01, 1.31885111e-01],
#        [8.95969407e-01, 1.04030593e-01],
#        [9.69960686e-01, 3.00393140e-02],
#        [9.42775307e-01, 5.72246931e-02]])



# %% 1 - 
cutoff = 0.3

pred_test = np.where(predprob_test[:, 1] > cutoff, 1, 0)
pred_test
# array([0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0,
#        0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0,
#        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1,
#        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1,
#        0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0,
#        0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1,
#        0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1,
#        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0,
#        0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1,
#        0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0])


# %% 1 - 
confusion_matrix(y_test, pred_test, labels = [0, 1])
# array([[135,  22],
#        [ 26,  27]])


# %% 1 - 
accuracy_score(y_test, pred_test)
# 0.7714285714285715


# %% 1 - 
precision_score(y_test, pred_test)
# 0.5510204081632653


# %% 1 - 
recall_score(y_test, pred_test)
# 0.5094339622641509


# %% 1 - 
auc = roc_auc_score(y_test, predprob_test[:, 1])
print(f"AUC: {auc:.3f}")
# AUC: 0.816


# %% 1 - 
fpr, tpr, thresholds = roc_curve(y_test, predprob_test[:, 1])


# %% 1 - 
lw = 2

plt.figure()
plt.plot(fpr, tpr, color = 'darkorange', lw = lw, label = f"ROC curve (area = {auc:.3f})")
plt.plot([0, 1], [0, 1], color = 'navy', lw = lw, linestyle = '--')

plt.axis('tight')
plt.title("Receiver operating characteristic")
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')

plt.legend(loc="lower right")
plt.show()
