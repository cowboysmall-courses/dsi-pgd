
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeRegressor, plot_tree


# %% 1 - import data and check the head
data = pd.read_csv("./data/0804_machine_learning_02/01_decision_trees/Motor Claims.csv")
data.head()


# %% 1 - 
X = data.loc[:, data.columns != 'claimamt']
y = data.loc[:, 'claimamt']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.30, random_state = 999)


# %% 1 - 
dtreg = DecisionTreeRegressor(min_samples_split = int(len(X_train) * 0.1))
dtreg.fit(X_train, y_train)


# %% 1 - 
plt.figure(figsize = (30, 15))
plot_tree(dtreg, filled = True, feature_names = list(X.columns))
plt.show()


# %% 1 - 
y_pred_reg = dtreg.predict(X_test)
y_pred_reg
