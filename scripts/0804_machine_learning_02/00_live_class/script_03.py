
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os


from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import classification_report, roc_curve, auc


import random
random.seed(14062024)



# %% 1 - import data and check the head
data = pd.read_csv("./data/0804_machine_learning_02/00_live_class/Bank Churn.csv")
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
data = pd.get_dummies(data, columns = ["Geography", "Gender"], drop_first = True, dtype = int) 
data.head()
#    RowNumber  CustomerId   Surname  CreditScore  Age  Tenure    Balance  \
# 0          1    15634602  Hargrave          619   42       2       0.00   
# 1          2    15647311      Hill          608   41       1   83807.86   
# 2          3    15619304      Onio          502   42       8  159660.80   
# 3          4    15701354      Boni          699   39       1       0.00   
# 4          5    15737888  Mitchell          850   43       2  125510.82   

#    NumOfProducts  HasCrCard  IsActiveMember  EstimatedSalary  Exited  \
# 0              1          1               1        101348.88       1   
# 1              1          0               1        112542.58       0   
# 2              3          1               0        113931.57       1   
# 3              2          0               0         93826.63       0   
# 4              1          1               1         79084.10       0   

#    Geography_Germany  Geography_Spain  Gender_Male  
# 0                  0                0            0  
# 1                  0                1            0  
# 2                  0                0            0  
# 3                  0                0            0  
# 4                  0                1            0  



# %% 1 - 
scaler = MinMaxScaler() 

data["Age"]             = scaler.fit_transform(np.array(data["Age"]).reshape(-1, 1)) 
data["Tenure"]          = scaler.fit_transform(np.array(data["Tenure"]).reshape(-1, 1)) 
data["NumOfProducts"]   = scaler.fit_transform(np.array(data["NumOfProducts"]).reshape(-1, 1)) 
data["EstimatedSalary"] = scaler.fit_transform(np.array(data["EstimatedSalary"]).reshape(-1, 1)) 
data["CreditScore"]     = scaler.fit_transform(np.array(data["CreditScore"]).reshape(-1, 1)) 
data["Balance"]         = scaler.fit_transform(np.array(data["Balance"]).reshape(-1, 1)) 
data.head()
#    RowNumber  CustomerId   Surname  CreditScore       Age  Tenure   Balance  \
# 0          1    15634602  Hargrave        0.538  0.324324     0.2  0.000000   
# 1          2    15647311      Hill        0.516  0.310811     0.1  0.334031   
# 2          3    15619304      Onio        0.304  0.324324     0.8  0.636357   
# 3          4    15701354      Boni        0.698  0.283784     0.1  0.000000   
# 4          5    15737888  Mitchell        1.000  0.337838     0.2  0.500246   

#    NumOfProducts  HasCrCard  IsActiveMember  EstimatedSalary  Exited  \
# 0       0.000000          1               1         0.506735       1   
# 1       0.000000          0               1         0.562709       0   
# 2       0.666667          1               0         0.569654       1   
# 3       0.333333          0               0         0.469120       0   
# 4       0.000000          1               1         0.395400       0   

#    Geography_Germany  Geography_Spain  Gender_Male  
# 0                  0                0            0  
# 1                  0                1            0  
# 2                  0                0            0  
# 3                  0                0            0  
# 4                  0                1            0  



# %% 1 - 
data1 = data.copy() 
data1.drop(['RowNumber', 'CustomerId', 'Surname'], axis = 1, inplace = True) 

X = data1.loc[:, data1.columns != "Exited"] 
y = data1.loc[:, "Exited"] 

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.3, random_state = 999)



# %% 1 - 
classifier = MLPClassifier(hidden_layer_sizes = (2), max_iter = 1000, activation = 'logistic', solver = 'adam', random_state = 1)
classifier.fit(X_train, y_train)



# %% 1 - 
y_train_prob = classifier.predict_proba(X_train)[:, 1] 

fpr_train, tpr_train, _ = roc_curve(y_train, y_train_prob) 
roc_auc_train           = auc(fpr_train, tpr_train)




# %% 1 - 
plt.figure()

plt.plot(fpr_train, tpr_train, color = "darkorange", lw = 2, label = f"ROC curve (area = {roc_auc_train:0.2f})")
plt.plot([0, 1], [0, 1], color = "navy", lw = 2, linestyle = '--')

plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])

plt.title("Receiver Operating Characteristic - Training Data")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.show()




# %% 1 - 
predicted_class = np.zeros(y_train_prob.shape)
predicted_class[y_train_prob > 0.5] = 1

print(classification_report(y_train, predicted_class))
#               precision    recall  f1-score   support
# 
#            0       0.84      0.98      0.90      5553
#            1       0.75      0.28      0.40      1447
# 
#     accuracy                           0.83      7000
#    macro avg       0.79      0.63      0.65      7000
# weighted avg       0.82      0.83      0.80      7000



# %% 1 - 
y_test_prob = classifier.predict_proba(X_test)[:, 1]
y_test_pred = classifier.predict(X_test)

fpr_test, tpr_test, _ = roc_curve(y_test, y_test_prob)
roc_auc_test          = auc(fpr_test, tpr_test)



# %% 1 - 
plt.figure()

plt.plot(fpr_test, tpr_test, color = "darkorange", lw = 2, label = f"ROC curve (area = {roc_auc_train:0.2f})")
plt.plot([0, 1], [0, 1], color = "navy", lw = 2, linestyle = '--')

plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])

plt.title("Receiver Operating Characteristic - Test Data")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")

plt.legend(loc = "lower right")
plt.show()



# %% 1 - 
predicted_class = np.zeros(y_test_prob.shape)
predicted_class[y_test_prob > 0.5] = 1

print(classification_report(y_test, predicted_class))
#               precision    recall  f1-score   support
# 
#            0       0.85      0.96      0.91      2410
#            1       0.69      0.33      0.44       590
# 
#     accuracy                           0.84      3000
#    macro avg       0.77      0.65      0.67      3000
# weighted avg       0.82      0.84      0.81      3000



# %% 1 - 


