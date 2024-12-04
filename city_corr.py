import numpy
import pandas as pd
from sklearn import linear_model
from scipy import stats
#import statsmodels.api as sm

df = pd.read_csv("C:\SqliteDbs\olist\Outputs\Cities_And_Delivery_2.csv", sep = ',')
#print(df)
#print(type(df['item_pop_ratio'][0]))

#print(df['City'].to_numpy())

#df = numpy.loadtxt("C:\SqliteDbs\olist\Outputs\Cities_And_Delivery_2.csv", delimiter = ',')

#display(df)


X = df['item_pop_ratio'].to_numpy()
y = df['avg_delivery_cost'].to_numpy()

'''
model = sm.OLS(y, X)
results = model.fit()
print(results.summary())
'''

t = stats.linregress(y, X)
print(t.rvalue, t.pvalue)

'''
regr = linear_model.LinearRegression()
regr.fit(X, y)
print(regr.coef_)
'''

#print("hello")

