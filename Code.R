# Load necessary libraries
install.packages("tidyverse")
install.packages("randomForest")
install.packages("caTools")
install.packages("caret")
library(tidyverse)
library(randomForest)
library(caTools)
library(caret)

# Load the dataset
data <- read.csv("filled columns.csv")

# Convert categorical variables to factors
data$class <- as.factor(data$class)
data$Source <- as.factor(data$Source)
data$Browser <- as.factor(data$Browser)
data$Gender <- as.factor(data$Gender)
data$Country <- as.factor(data$Country)
data$Chip.Use <- as.factor(data$Chip.Use)
data$Time.of.day <- as.factor(data$Time.of.day)
data$Category <- as.factor(data$Category)
data$Card.Brand <- as.factor(data$Card.Brand)

# Convert timestamps to time difference
data$Signup_time <- as.POSIXct(data$Signup_time, format="%m/%d/%Y %H:%M")
data$Purchase_time <- as.POSIXct(data$Purchase_time, format="%m/%d/%Y %H:%M")
data$time_diff <- as.numeric(difftime(data$Purchase_time, data$Signup_time, units="mins"))

# Drop unnecessary columns
data <- data %>% select(-User_ID, -Device_id, -ip_address, -Signup_time, -Purchase_time)

# Handle missing values
data <- na.omit(data)

# Split data into training and testing sets
set.seed(123)
split <- sample.split(data$class, SplitRatio = 0.7)
train_data <- subset(data, split == TRUE)
test_data <- subset(data, split == FALSE)

# Random Forest Model
rf_model <- randomForest(class ~ ., data = train_data, ntree = 100, mtry = 4, importance = TRUE)
rf_pred <- predict(rf_model, test_data)

# Evaluate Random Forest
confusionMatrix(rf_pred, test_data$class)

# Feature Importance from Random Forest
importance(rf_model)
varImpPlot(rf_model)
