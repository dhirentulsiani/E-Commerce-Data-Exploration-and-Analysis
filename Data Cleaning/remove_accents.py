from unidecode import unidecode
import pandas as pd

df = pd.read_csv("C:/Users/dhire/Downloads/City_Populations.csv")

df.Cities = df.Cities.apply(unidecode)

df.to_csv("C:/Users/dhire/Downloads/City_Populations_cleaned.csv")