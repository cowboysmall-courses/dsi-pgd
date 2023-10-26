# Q1Import House Price Data. Check the structure of the data
##A.

import pandas as pd
hpd = pd.read_csv("House Price Data.csv")
hpd.info()


#Q2 Split the data into Training (80%) and Testing (20%)
##A.

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(hpd, hpd.Price, test_size=0.2)
print (X_train.shape, y_train.shape)
print (X_test.shape, y_test.shape)


#Q3 Build a regression model on training data to estimate average price of a House
##A.

import statsmodels.formula.api as smf
training_model=smf.ols('Price ~ Area+Distance+Schools', data=X_train).fit()
training_model.summary()


#Q4 List down significant variables and interpret their regression coefficients
##A.

#Interpretation:p-value for all the variables are < 0.05 indicating all the variables are significant.
#Interpretation:The regression coefficient of Area, Distance and Schools are is 0.032798, -1.712052 and 1.488712 respectively.
#Interpretation:With 1 unit increase in carpet area, price increase by 0.032798
#Interpretation:With 1 unit increase in Distance from station, price decreases by 1.712052  
#Interpretation:With 1 unit increase in number of schools, price increases by 1.488712 


#Q5 What is the R2 of the model? Give interpretation
##A.

#Interpretation:R-squared value is 0.7929
#Interpretation:Adj R-squared value is 0.7889 indicating a fairly good model


#Q6 Is there a multicollinearity problem?
##A.

from patsy import dmatrices
from statsmodels.stats.outliers_influence import variance_inflation_factor

y, X = dmatrices('Price ~ Area+Distance+Schools', data=X_train, return_type="dataframe")

vif = [variance_inflation_factor(X.values,i) for i in range(X.shape[1])] 
vif

#Interpretation:Since all VIFs < 5, there is no multicollinearity problem

#Q7 Are there any influential observations in the data?
##A.

from statsmodels.graphics.regressionplots import *
influence_plot(training_model, criterion = 'Cooks')

#Interpretation:Observations 17,32,35.98 and 134 are influential observations


#Q8 Can we assume that errors follow 'Normal' distribution?
##A.

X_train = X_train.assign(res=pd.Series(training_model.resid))
import statsmodels.api as sm
sm.stats.diagnostic.lilliefors(X_train.res)


#Interpretation:Since p-value<0.05, normality cannot be assumed

#Q9 Is there a Heteroscedasticity problem?
##A.

from statsmodels.compat import lzip
name = ['Lagrange multiplier statistic', 'p-value','f-value', 'f p-value']

import statsmodels.api as sm
test = sm.stats.diagnostic.het_breuschpagan(X_train.res, training_model.model.exog)
lzip(name, test)

#Interpretation:Since p-value<0.05, there is a Heteroscedasticity problem

se_correct=training_model.cov_params()

training_model_robust = training_model.get_robustcov_results(cov_type = 'HC0', use_t = True)
training_model_robust.summary()

#Interpretation:Corrected p-values show all variables are significant and standard errors have been corrected when compared to model before applying remedial measure


#Q10 Calculate the RMSE for the Training and Testing data
##A.

X_test = X_test.assign(pred=pd.Series(training_model.predict(X_test)))
X_test = X_test.assign(res=pd.Series(X_test.Price - X_test.pred))

from math import sqrt
training_rmse = sqrt((X_train['res']**2).mean())
training_rmse

testing_rmse = sqrt((X_test['res']**2).mean())
testing_rmse