# Data Analysis Documentation

## Introduction
# This R script performs a comprehensive data analysis on a dataset to explore relationships and patterns using various statistical techniques, including Principal Component Analysis (PCA). The dataset used in this analysis is sourced from INSEE (Institut national de la statistique et des études économiques), containing demographic and behavioral features.

## Libraries
# Load the required libraries
library("FactoInvestigate")
library("ggplot2")
library("FactoMineR")
library("shiny")
library("Factoshiny")
library("factoextra")
library("corrplot")
library("psych")

## Data Loading and Preprocessing
# Set the working directory
setwd('C:/Users/Ahmed/Desktop/AnalyseDeDonnes/')

# Load the dataset from a CSV file
data <- read.csv('donnees_tableau.csv', header = TRUE, row.names = "Annees", sep = ';')

# Define the maximum number of columns to display
options(max.print = 1000)

# Select relevant columns and rows
df <- data[c(1:78), c(1:12)]

# Display the structure of the data
str(df)

# Resolve data structure issues
df[] <- lapply(df, function(x) as.numeric(gsub(",", ".", x)))

# Display descriptive statistics
summary(df)

## Exploratory Data Analysis (EDA)
# Reverse row and column order
data_reversed_rows <- df[rev(row.names(df)), ]
data_reversed <- data_reversed_rows[, rev(colnames(data_reversed_rows))]

# Export the reversed data to CSV
write.csv(data_reversed, "output_file.csv", row.names = FALSE)

# Display correlation matrix
pairs(df[, 1:12])
correlation_matrix <- cor(df[, 1:12])
print(correlation_matrix, width = 1000)

# Perform Bartlett's test
cortest.bartlett(correlation_matrix, n = 78)

# Calculate KMO
KMO(correlation_matrix)

## Principal Component Analysis (PCA)
# Perform PCA
resultACP <- PCA(df, ncp = 5, scale.unit = TRUE, graph = TRUE)
corrplot(resultACP$var$contrib, is.corr=F, cl.ratio=0.5)
summary(resultACP)

# Eigenvalues
eigenvalues <- get_eigenvalue(resultACP)
print(eigenvalues)

# Decision aid for choosing the number of principal components
screen_plot <- fviz_eig(resultACP, addlabels = TRUE)

# Variable results
variable_results <- get_pca_var(resultACP)
variable_results$coord
variable_results$contrib
variable_results$cos2

# Variable graphs
fviz_pca_var(resultACP, axes = c(1, 2))
fviz_contrib(resultACP, choice = "var", axes = 1, top = 13)
fviz_contrib(resultACP, choice = "var", axes = 2, top = 13)
fviz_pca_var(resultACP, col.var = "contrib", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE)
fviz_pca_var(resultACP, col.var = "cos2", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE)

# Individual graphs
fviz_pca_ind(resultACP, col.ind = "cos2", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE)
fviz_pca_ind(resultACP, col.ind = "contrib", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE)
fviz_pca_ind(resultACP, col.ind = "coord", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE)

# Biplot of individuals and variables
fviz_pca_biplot(resultACP, repel = TRUE)
fviz_pca_biplot(resultACP, geom.ind = "point", axes = c(1, 2), pointshape = 21, pointsize = 1, alpha.var = "contrib", col.var = "cos2", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE)

# Launch Factoshiny for interactive exploration
Factoshiny(df)
