# Data Analysis Documentation

## Introduction
# This Python script performs a Principal Component Analysis (PCA) on a dataset to explore relationships and patterns. The dataset used in this analysis is sourced from a CSV file ('donnees_tableau.csv'), containing demographic and behavioral features.

## Libraries
# Import necessary libraries
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

## Data Loading and Preprocessing
# Load the dataset from a CSV file
data = pd.read_csv('donnees_tableau.csv', header=0, index_col="Annees", sep=';')

# Select relevant rows and columns from the dataset
df = data.iloc[0:78, 0:12]

# Convert string-formatted numbers to numeric
df = df.apply(lambda x: pd.to_numeric(x.astype(str).str.replace(',', '.'), errors='coerce'))

# Standardize the data
scaler = StandardScaler()
df_standardized = scaler.fit_transform(df)

## Principal Component Analysis (PCA)
# Perform PCA with 2 components
pca = PCA(n_components=2)
pca_results = pca.fit_transform(df_standardized)

# Display principal components for the first 10 rows
print("Principal Components:")
print(pca_results[:10])

# Display variance explained by each principal component
print("Variance explained by each principal component:")
print(pca.explained_variance_ratio_)

# Display percentage of total explained variance
print("Percentage of total explained variance:")
print(sum(pca.explained_variance_ratio_) * 100)

## Visualization
# Scatter plot of individuals in the PCA space
plt.scatter(pca_results[:, 0], pca_results[:, 1])
plt.xlabel('Principal Component 1')
plt.ylabel('Principal Component 2')
plt.title('Individuals Plot (PCA)')
plt.show()
