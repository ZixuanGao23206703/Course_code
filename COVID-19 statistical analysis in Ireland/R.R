library(rio)
library(dplyr)
library(tidyverse)
library(lubridate)

# Import the dataset, skipping the first 14 rows and treating ":" as NA
df <- import("COVID-19_HPSC_County_Statistics_Latest_Point_Geometry.csv", 
             sheet = 1, 
             skip = 14, 
             na = ":",
             setclass = "tibble")

# Remove the unnecessary columns
df_new <- df %>%
  select(-ORIGID, -UniqueGeographicIdentifier, -IGEasting, -IGNorthing, -x, -y, -FID)

# replace 'datetime' with your actual column name
# Seperate date and time to two columns
df_new <- df_new %>%
  mutate(
    Date = as.Date(TimeStampDate), # Extract the date part
    Time = format(as.POSIXct(TimeStampDate), format = "%H:%M:%S") # Extract the time part
  ) %>%
  select(-TimeStampDate) # Remove the original datetime column if not needed

# give meaningful names to the variables
df_new <- rename(df_new,
                 County=CountyName,
                 Population=PopulationCensus16,
                 ConfirmedCases=ConfirmedCovidCases,
                 PopulationProportion=PopulationProportionCovidCases,
                 ConfirmedDeaths=ConfirmedCovidDeaths,
                 ConfirmedRecovered=ConfirmedCovidRecovered)

# Display the size of the dataset (number of rows and columns)
cat("Dataset size:", nrow(df_new), "rows and", ncol(df_new), "columns\n")

# Check the structure of dataset
str(df_new)

# Check if the Date variable is stored as a Date
if (!inherits(df_new$Date, "Date")) {
  cat("Warning: Date variable is not of type Date.\n")
}

# Check if the Time variable is stored as character
if (!is.character(df_new$Time)) {
  cat("Warning: Time variable is not of type character.\n")
}

# Define the expected numeric and factor (categorical) variable names
numeric_vars <- c("Population", "Lat", "Long", "ConfirmedCases", "PopulationProportion", "ConfirmedDeaths", "ConfirmedRecovered")
factor_vars <- c("County") # Add other factor variable names here

# Check if the numeric variables are indeed numeric
for (var in numeric_vars) {
  if (!is.numeric(df_new[[var]])) {
    cat("Warning:", var, "variable is not of type numeric.\n")
  }
}

# Check if the factor variables are indeed factors
for (var in factor_vars) {
  if (!is.factor(df_new[[var]])) {
    cat("Warning:", var, "variable is not of type factor.\n")
  }
}

# Check the structure again to confirm
str(df_new)

# Calculate the mortality rate and recovery rate for each county
df_new <- df_new %>%
  mutate(
    DeathRate = (ConfirmedDeaths / ConfirmedCases) * 100, # Calculate the death rate
    RecoveryRate = (ConfirmedRecovered / ConfirmedCases) * 100 # Calculate the recovery rate
  )

# Handle possible NaN or Inf values (when ConfirmedCases is 0)
df_new$DeathRate[is.na(df_new$DeathRate) | is.infinite(df_new$DeathRate)] <- 0
df_new$RecoveryRate[is.na(df_new$RecoveryRate) | is.infinite(df_new$RecoveryRate)] <- 0

# Display the modified dataset
print(df_new)

# Optional: Check the structure to confirm that the new columns have been added
str(df_new)
df_new

# Remove the time column
df_new <- df_new %>%
  select(-Time)

# Check the data type of the Date column
if (!inherits(df_new$Date, "Date")) {
  cat("The Date column is not of date data type.\n")
} else {
  cat("The Date column is of date data type.\n")
  
  # Check if the dates are sorted
  if (all(diff(df_new$Date) >= 0)) {
    cat("The date data is sorted in ascending order.\n")
  } else {
    cat("The date data is not sorted in ascending order.\n")
  }
}

# Rearrange the columns to have Date, County, DeathRate, and RecoveryRate as the first four columns
df_new <- df_new %>%
  relocate(Date, County, DeathRate, RecoveryRate, .before = 1)


#find missing data rows
countries_with_missing_data <-df_new[!complete.cases(df_new), "County"]
countries_with_missing_data 

#check the numbers of observations and variables
num_observations <- nrow(df_new) #the numbers of observations 
num_variables <- ncol(df_new) #the numbers of variables
num_observations
num_variables

# Calculate the county with the most cases
most_cases <- df_new[which.max(df_new$ConfirmedCases), c("County", "ConfirmedCases")]

# Calculate the county with the least cases
least_cases <- df_new[which.min(df_new$ConfirmedCases), c("County", "ConfirmedCases")]

# Print the results
print(paste("County with the most cases:", most_cases$County, "-", most_cases$ConfirmedCases, "cases"))
print(paste("County with the least cases:", least_cases$County, "-", least_cases$ConfirmedCases, "cases"))

# Sort by the number of confirmed cases in ascending order
df_sorted <- df_new[order(df_new$ConfirmedCases), c("County", "ConfirmedCases")]

# Print the sorted counties and case numbers
print(df_sorted)


# Load the ggplot2 package
library(ggplot2)

# Create a chart, increase label size, and add a regression line
ggplot(df_new, aes(x = ConfirmedCases, y = ConfirmedDeaths)) +
  geom_point() +  # Add points
  geom_text(aes(label = County), vjust = -1, hjust = 1, check_overlap = TRUE, size = 3) +  # Add county labels, increase label size
  geom_smooth(method = "lm", color = "blue") +  # Add a linear regression line
  labs(title = "Confirmed COVID-19 Cases vs Deaths",
       x = "Confirmed COVID-19 Cases",
       y = "Confirmed COVID-19 Deaths") +
  theme_minimal() +  # Use a minimal theme
  theme(plot.title = element_text(hjust = 0.5), # Center the title
        axis.text.x = element_text(angle = 45, hjust = 1)) # Adjust x-axis labels

# Adjust the chart size (if using an IDE like RStudio)
ggsave("covid_cases_vs_deaths.png", width = 12, height = 8)

# Load the necessary packages
library(ggplot2)
library(sf)

# Convert the data to simple feature objects
df_sf <- st_as_sf(df_new, coords = c("Long", "Lat"), crs = 4326)

# Create a visualization using ggplot2
ggplot(data = df_sf) +
  geom_sf(aes(size = ConfirmedCases, color = ConfirmedCases)) +
  scale_size_continuous(range = c(1, 10)) +  # Adjust the point size range
  theme_minimal() +
  labs(title = "Spatial Visualization of Confirmed Cases",
       x = "Longitude",
       y = "Latitude")

library(ggplot2)
library(gridExtra)

# Plot 1: Relationship between ConfirmedCovidCases and Population
plot1 <- ggplot(df_new, aes(x = ConfirmedCases, y = Population)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Relationship between\nConfirmed Covid Cases and Population",
       x = "Confirmed Covid Cases",
       y = "Population") +
  theme_minimal() +
  theme(plot.title = element_text(size = 12))  # Adjust the title font size here

# Plot 2: Relationship between PopulationProportionCovidCases and Population
plot2 <- ggplot(df_new, aes(x = PopulationProportion, y = Population)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Relationship between\nPopulation Proportion Covid Cases and Population",
       x = "Population Proportion Covid Cases",
       y = "Population") +
  theme_minimal() +
  theme(plot.title = element_text(size = 12))  # Adjust the title font size here

# Plot 3: Relationship between ConfirmedCovidDeaths and Population
plot3 <- ggplot(df_new, aes(x = ConfirmedDeaths, y = Population)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "green") +
  labs(title = "Relationship between\nConfirmed Covid Deaths and Population",
       x = "Confirmed Covid Deaths",
       y = "Population") +
  theme_minimal() +
  theme(plot.title = element_text(size = 12))  # Adjust the title font size here

# Plot 4: Relationship between ConfirmedCovidRecovered and Population
plot4 <- ggplot(df_new, aes(x = ConfirmedRecovered, y = Population)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "yellow") +
  labs(title = "Relationship between\nConfirmed Covid Recovered and Population",
       x = "Confirmed Covid Recovered",
       y = "Population") +
  theme_minimal() +
  theme(plot.title = element_text(size = 12))  # Adjust the title font size here

# Arrange the plots into a grid
grid.arrange(plot1, plot2, plot3, plot4, ncol = 2, nrow = 2)

# Import necessary packages
# install.packages("caret")
library(glmnet)
library(caret) # For data preprocessing

# Prepare the data
# Assume df_new is your original dataset

# Data preprocessing
df_new <- na.omit(df_new) # Remove missing values
df_new$Population <- as.numeric(df_new$Population) # Ensure the target variable is numeric

# Determine the columns to be used in the model
feature_cols <- c("ConfirmedCases", "PopulationProportion", "ConfirmedDeaths", "ConfirmedRecovered")

# Normalize these columns
preProcValues <- preProcess(df_new[, feature_cols], method = c("center", "scale")) # Normalization
df_new_normalized <- predict(preProcValues, df_new[, feature_cols])

# Create a data matrix
data_matrix <- as.matrix(df_new_normalized)

# Fit the elastic net model
model <- glmnet(x = data_matrix, y = df_new$Population, alpha = 0.5)

# Perform cross-validation (using more folds)
cv_model <- cv.glmnet(x = data_matrix, y = df_new$Population, nfolds = 10)

# Select the optimal lambda
opt_lambda <- cv_model$lambda.min

# Perform predictions on the training set for demonstration (typically you'd use a test set or new data)
predictions <- predict(model, newx = data_matrix, s = opt_lambda)

# Output prediction results
print(predictions)

# Output detailed information about the model and the results of cross-validation
print(summary(model))
print(cv_model)

# Visualize the coefficient path of the model
plot(model)
# Import necessary packages
library(glmnet)

# Define the main analysis function
elastic_net_analysis <- function(df_new, response, predictors, alpha = 0.5) {
  if(!all(c(response, predictors) %in% names(df_new))) {
    stop("Response or predictors not found in data.")
  }
  
  # Data preprocessing
  data <- na.omit(df_new)
  data[[response]] <- as.numeric(df_new[[response]])
  data_matrix <- as.matrix(df_new[predictors])
  
  # Fit the elastic net model
  model <- glmnet(x = data_matrix, y = df_new[[response]], alpha = alpha)
  
  # Create an S3 object
  output <- list(model = model, data = df_new, response = response, predictors = predictors)
  class(output) <- "elastic_net"
  return(output)
}

# Custom print method
print.elastic_net <- function(x) {
  cat("Elastic Net Model Analysis\n")
  cat("Response variable:", x$response, "\n")
  cat("Predictors:", toString(x$predictors), "\n")
  print(x$model)
}

# Custom summary method
summary.elastic_net <- function(object) {
  summary(object$model)
}

# Custom plot method
plot.elastic_net <- function(x, ...) {
  if(!"glmnet" %in% class(x$model)) {
    stop("Model is not a glmnet object.")
  }
  
  # Plot the coefficient path
  plot(x$model, xvar = "lambda", label = TRUE, ...)
  title("Coefficient Path of Elastic Net Model")
}

# Example
# Assume df_new is your dataset
data <- df_new # Load the dataset
response <- "Population"
predictors <- c("ConfirmedCases", "PopulationProportion", "ConfirmedDeaths", "ConfirmedRecovered")

# Run analysis
analysis_result <- elastic_net_analysis(df_new, response, predictors)

# Print analysis results
print(analysis_result)

# Display summary
summary(analysis_result)

# Plot the model
plot(analysis_result)

