
# %% 0 - import libraries
import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import confusion_matrix, precision_score, recall_score, accuracy_score



# %% 1 - import data and check the head
data = pd.read_csv("./data/0704_machine_learning_01/02_knn/BANK LOAN KNN.csv")
data.head()
#    SN  AGE  EMPLOY  ADDRESS  DEBTINC  CREDDEBT  OTHDEBT  DEFAULTER
# 0   1    3      17       12      9.3     11.36     5.01          1
# 1   5    1       2        0     17.3      1.79     3.06          1
# 2   8    3      12       11      3.6      0.13     1.24          0
# 3   9    1       3        4     24.4      1.36     3.28          1
# 4  13    3      24       14     10.0      3.93     2.47          0


# %% 2 - 
data_sub = data.drop(['SN', 'AGE'], axis = 1)
data_sub.head()
#    EMPLOY  ADDRESS  DEBTINC  CREDDEBT  OTHDEBT  DEFAULTER
# 0      17       12      9.3     11.36     5.01          1
# 1       2        0     17.3      1.79     3.06          1
# 2      12       11      3.6      0.13     1.24          0
# 3       3        4     24.4      1.36     3.28          1
# 4      24       14     10.0      3.93     2.47          0


# %% 3 - 
X = data_sub.loc[:, data_sub.columns != 'DEFAULTER']
y = data_sub.loc[:, 'DEFAULTER']


X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.3, random_state = 999)


# %% 4 - 
scaler = StandardScaler()
scaler.fit(X_train)

X_train = scaler.transform(X_train)
X_test  = scaler.transform(X_test)

X_train
# array([[-0.89496854, -0.29977261,  1.11865332, -0.28678534,  0.00538471],
#        [-0.23076269, -1.21765047,  1.07813931,  1.32686881, -0.1734379 ],
#        [ 0.26739169,  0.00618668,  0.26785916, -0.20818328,  0.80582882],
#        ...,
#        [-0.06471123,  1.07704418, -0.69097236, -0.3191509 , -0.42889879],
#        [-0.56286562,  0.15916632,  0.28136383, -0.18044137, -0.50553705],
#        [-1.22707147, -0.14679297,  0.24084982,  0.2356872 , -0.40051425]])


# %% 5 - 
knn_classifier = KNeighborsClassifier(n_neighbors = int(np.sqrt(len(X)).round()))
knn_classifier.fit(X_train, y_train)

y_pred = knn_classifier.predict(X_test)


# %% 6 - 
confusion_matrix(y_test, y_pred, labels = [0, 1])
# array([[49,  7],
#        [24, 37]])



# %% 7 - 
print(accuracy_score(y_test, y_pred))
# 0.7350427350427351

print(precision_score(y_test, y_pred))
# 0.8409090909090909

print(recall_score(y_test, y_pred))
# 0.6065573770491803



