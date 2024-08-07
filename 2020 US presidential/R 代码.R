load("data_assignment_2.Rdata")
data <- elections
# summary(data)

sum(is.na(data))
data_new <- data[, -c(1, 2)] # Remove 'state' and 'county' columns
data_new$winner <- factor(data_new$winner, levels = c("trump","biden")) # Organize factor data for response variable

# Standardize numerical columns
num_cols <- sapply(data_new, is.numeric)  # Determine which columns are numeric
data_new[, num_cols] <- scale(data_new[, num_cols])  # Standardize only the numeric columns

# separate training data and test data
set.seed(23206703) 
train_indices <- sample(1:nrow(data_new), 0.8 * nrow(data_new))  
train_data <- data_new[train_indices, ]
test_data <- data_new[-train_indices, ]

library(caret)
library(pROC) 

# Predict and evaluate each model's performance on the test set
train_predictors <- train_data[,-ncol(train_data)]
train_response <- train_data$winner

# Initialize a list to store models
models <- list()
performance <- data.frame(Model = character(), Accuracy = numeric(), AUC = numeric())

# Set trainControl object
control <- trainControl(
  method = "cv",       
  number = 10,          
  savePredictions = "final",  
  classProbs = TRUE,   
  summaryFunction = twoClassSummary 
)

# model tuning and model fitting
# Logistic Regression
set.seed(23206703)
glmGrid <- expand.grid(alpha = c(0, 0.5, 1),  
                       lambda = 10^seq(-4, -1, length = 10)) 
suppressWarnings({
  models$Logistic <- train(train_predictors, train_response, method = 'glm',
                           family = 'binomial', 
                           trControl = trainControl(method = "cv", number = 10))
})



# Support Vector Machine (SVM)
set.seed(23206703)
svmGrid <- expand.grid(.sigma = seq(0.01, 0.1, length = 5), .C = seq(1, 100, length = 5))
models$SVM <- train(train_predictors, train_response, method='svmRadial',
                    trControl=control, tuneGrid=svmGrid, preProcess = c("center", "scale"))



# Random Forest
set.seed(23206703)
rfGrid <- expand.grid(.mtry = c(2, sqrt(ncol(train_predictors)), ncol(train_predictors)/3))
control <- trainControl(method="cv", number=10)
models$RandomForest <- train(train_predictors, train_response, method='rf',
                             trControl=control, tuneGrid=rfGrid)



# K-Nearest Neighbors (KNN)
set.seed(23206703)
knnGrid <- expand.grid(.k = seq(1, 21, by = 2))  
models$KNN <- train(train_predictors, train_response, method='knn',
                    trControl=control, tuneGrid=knnGrid)

for (model_name in names(models)) {
  model <- models[[model_name]]
  
  best_params <- model$bestTune
  
  print(paste("Best parameters for", model_name, ":", toString(best_params)))
}


# Predict and evaluate each model's performance on the test set
test_predictors <- test_data[,-ncol(test_data)]
test_response <- test_data$winner

# Add ROC library for AUC calculation
library(pROC)

# Initialize a data frame to store all performance metrics
performance <- data.frame(Model = character(), 
                          Accuracy = numeric(), 
                          AUC = numeric(), 
                          F1score = numeric(),
                          Sensitivity = numeric(), 
                          Specificity = numeric())

# Loop through each model, make predictions, and calculate performance metrics
for(model_name in names(models)) {
  # Predict using the current model
  predictions <- predict(models[[model_name]], newdata = test_predictors)
  
  # Calculate confusion matrix
  confusion_matrix <- confusionMatrix(predictions, test_response)
  accuracy <- confusion_matrix$overall['Accuracy']
  sensitivity <- confusion_matrix$byClass['Sensitivity']
  specificity <- confusion_matrix$byClass['Specificity']
  f1_score <- confusion_matrix$byClass['F1']
  
  # Calculate AUC
  roc_result <- roc(response = test_response, predictor = as.numeric(predictions),
                    levels = rev(levels(test_response)))
  auc <- auc(roc_result)
  
  # Append to the performance data frame
  performance <- rbind(performance, data.frame(Model = model_name, 
                                               Accuracy = accuracy, 
                                               AUC = auc, 
                                               F1score = f1_score, 
                                               Sensitivity = sensitivity, 
                                               Specificity = specificity))
}

# Print the performance metrics
print(performance)

# Optional: Select and print the best model based on Test Accuracy or AUC
best_model <- performance[which.max(performance$Accuracy),]
cat("The best model on test set is", best_model$Model, 
    "with an Accuracy of", best_model$Accuracy, 
    "and AUC of", best_model$AUC, 
    "and F1 Score of", best_model$F1score, 
    ", Sensitivity of", best_model$Sensitivity, 
    ", and Specificity of", best_model$Specificity, "\n")

library(ggplot2)
library(tidyr)  # For pivot_longer

performance_long <- pivot_longer(performance, 
                                 cols = c(Accuracy, F1score, Sensitivity, Specificity), 
                                 names_to = "Metric", 
                                 values_to = "Value")

performance_long$Model <- factor(performance_long$Model, levels = unique(performance_long$Model))

ggplot(performance_long, aes(x = Model, y = Value, fill = Metric)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  theme_minimal() +
  labs(title = "Comparison of Model Metrics", x = "Model", y = "Metric Value") +
  facet_wrap(~ Metric, scales = "free_y") +
  geom_text(aes(label = sprintf("%.2f", Value)), position = position_dodge(0.9),
            vjust = -0.5, size = 3) +
  coord_flip()


# Choose the best model (based on AUC or accuracy)
best_model_name <- performance[which.max(performance$AUC), "Model"]

# Extract the best model
best_model <- models[[best_model_name]]

# Make predictions on the test data using the best model
predictions <- predict(best_model, newdata = test_predictors)
predicted_probabilities <- predict(best_model, newdata = test_predictors, type = "prob")

# Calculate performance metrics
conf_matrix <- confusionMatrix(predictions, test_response)
accuracy <- conf_matrix$overall['Accuracy']
auc_value <- roc(response = test_response, predictor = predicted_probabilities[, "trump"])$auc
f1_score <- conf_matrix$byClass['F1']

# Output performance metrics
cat(sprintf("The best model (%s) has an Accuracy of %.2f, AUC of %.2f, and F1 Score of %.2f.\n",
            best_model_name, accuracy, auc_value, f1_score))


# Visualize the predicted probability distribution
ggplot(data.frame(Actual = test_response, Predicted_Probability =
                    predicted_probabilities[, "trump"]), 
       aes(x = Actual, y = Predicted_Probability)) +
  geom_boxplot(aes(color = Actual)) +
  labs(title = sprintf("Predicted Probability Distribution for Trump (Model: %s)",
                       best_model_name),
       x = "Actual Category",
       y = "Predicted Probability for Trump") +
  theme_minimal()
