
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import classification_report


# %% 1 - import data and check the head
data = pd.read_csv("./data/0804_machine_learning_02/00_live_class/BANK LOAN.csv")
data.head()
#    SN  AGE  EMPLOY  ADDRESS  DEBTINC  CREDDEBT  OTHDEBT  DEFAULTER
# 0   1    3      17       12      9.3     11.36     5.01          1
# 1   2    1      10        6     17.3      1.36     4.00          0
# 2   3    2      15       14      5.5      0.86     2.17          0
# 3   4    3      15       14      2.9      2.66     0.82          0
# 4   5    1       2        0     17.3      1.79     3.06          1


# %% 1 - 
dummies = pd.get_dummies(data['AGE'], prefix = 'AGE', drop_first = True)
data    = pd.concat([data, dummies], axis = 1)



# %% 1 - 
scaler = MinMaxScaler()

data['EMPLOY']   = scaler.fit_transform(np.array(data['EMPLOY']).reshape(-1, 1))
data['ADDRESS']  = scaler.fit_transform(np.array(data['ADDRESS']).reshape(-1, 1))
data['DEBTINC']  = scaler.fit_transform(np.array(data['DEBTINC']).reshape(-1, 1))
data['CREDDEBT'] = scaler.fit_transform(np.array(data['CREDDEBT']).reshape(-1, 1))
data['OTHDEBT']  = scaler.fit_transform(np.array(data['OTHDEBT']).reshape(-1, 1))


# %% 1 - 
X = data.loc[:, data.columns != 'DEFAULTER']
y = data.loc[:, 'DEFAULTER']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.30, random_state = 999)


# %% 1 - 
classifier = MLPClassifier(hidden_layer_sizes = (3, ), max_iter = 300, activation = 'relu', solver = 'adam', random_state = 1)
classifier.fit(X_train, y_train)


# %% 1 - 
y_pred = classifier.predict_proba(X_test)[0:210, 1]


# %% 1 - 
predicted_class = np.zeros(y_pred.shape)
predicted_class[y_pred > 0.3] = 1


# %% 1 - 
print(classification_report(y_test, predicted_class))
#               precision    recall  f1-score   support
# 
#            0       0.77      0.39      0.52       157
#            1       0.27      0.66      0.38        53
# 
#     accuracy                           0.46       210
#    macro avg       0.52      0.52      0.45       210
# weighted avg       0.64      0.46      0.48       210
