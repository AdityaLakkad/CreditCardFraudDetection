#importing the data set from respective folder.
credit_card <- read.csv("E:\\SEM-5\\DSM\\Project\\creditcard.csv")

#viewing data set
str(credit_card)

#converting Class into factor, levels=(0,1)
credit_card$Class <- factor(credit_card$Class, levels=c(0,1))

#Get the summary of data
summary(credit_card)

#Count the missing Values
sum(is.na(credit_card))

#-------------------------------------------------------------------------------------

#Get the distribution of fraud and legit transaction in deta set
table(credit_card$Class)

#Percentage of
prop.table(table(credit_card$Class))

#piechart of creditcard transection
labels <- c("Legit","Fraud")
labels <- paste(labels, round(100*prop.table(table(credit_card$Class)), 2))
labels <- paste0(labels, "%")

pie(table(credit_card$Class), labels, col = c("orange","Red"), main="Piechart of credit card transection")

#------------------------------------------------------------------------------------------

#No model predictions
predictions <- rep.int(0, nrow(credit_card))
predictions<- factor(predictions, levels = c(0,1))

#initiating package caret
library(caret)
confusionMatrix(data=predictions, reference = credit_card$Class)

#-------------------------------------------------------------------------------------------

library(dplyr)

set.seed(1)
credit_card <- credit_card %>% sample_frac(0.1)

table(credit_card$Class)

library(ggplot2)

ggplot(data = credit_card, aes(x = V1, y = V2, col = Class)) + 
  geom_point() 

#----------------------------------------------------------------------------------------
#Creating training and Test sets for fraud Detection Model
library(caTools)

set.seed(123)

data_sample = sample.split(credit_card$Class, SplitRatio = 0.80)

train_data = subset(credit_card, data_sample==TRUE)

test_data = subset(credit_card,data_sample==FALSE)

dim(train_data)
dim(test_data)

#-----------------------------------------------------------------------------------------
#Random Over-Sampling(ROS)

table(train_data$Class)

n_legit <- 22750

new_frac_legit <- 0.50

new_n_total <- n_legit/new_frac_legit

# ROSE for ros
library(ROSE)
oversampling_result <- ovun.sample(Class ~ ., data = train_data, method = "over", N=new_n_total, seed=2019)

oversampling_credit <- oversampling_result$data

table(oversampling_credit$Class)

ggplot(data = oversampling_credit, aes(x = V1, y = V14, col = Class)) + 
  geom_point(position = position_jitter(width = 0.7)) 
#----------------------------------------------------------------------------------------------
# Random under sampling

table(train_data$Class)

n_fraud <- 35
new_frac_fraud <- 0.50
new_n_total <- n_fraud/new_frac_fraud

undersampling_result <- ovun.sample(Class ~ ., data = train_data, method = "under", N=new_n_total, seed=2019)

undersampled_credit <- undersampling_result$data

table(undersampled_credit$Class)

ggplot(data = undersampled_credit, aes(x = V1, y = V2, col = Class)) + 
  geom_point(position = position_jitter(width = 0.7))
#------------------------------------------------------------------------------------------------
# ROS and RUS both

n_new <- nrow(train_data)
fraction_fraud_new <- 0.50

sampling_result <- ovun.sample(Class ~.,
                               data=train_data,
                               method="both",
                               N = n_new,
                               p = fraction_fraud_new,
                               seed = 2019)

sampled_credit <- sampling_result$data

table(sampled_credit$Class)

ggplot(data = sampled_credit, aes(x = V1, y = V2, col = Class)) + 
  geom_point(position = position_jitter(width = 0.1))

#---------------------------------------------------------------------------------------------
#Using SMOTE to balance the dataset
library(smotefamily)

table(train_data$Class)

#set the number of fraud and legitimate cases and the desired percentage of legitimate cases
n0 <- 22750
n1 <- 35
r0 <- 0.6

#Calculate number of How many times we have to run the SMOTE 
ntimes <- ((1-r0)/r0)*(n0/n1)-1

smote_output = SMOTE(X = train_data[,-c(1,31)],
                     target = train_data$Class,
                     K = 5,
                     dup_size = ntimes)

credit_smote <- smote_output$data

colnames(credit_smote)[30] <- "Class"

prop.table(table(credit_smote$Class))

#Class distribution for original dataset
ggplot(credit_smote, aes(x = V1, y=V2, color = Class)) +
  geom_point() +
  scale_color_manual(values = c('dodgerblue2', 'red'))

#Class distribution for over sampled dataset using SMOTE
ggplot(credit_smote, aes(x = V1, y=V2, color = Class)) +
  geom_point() +
  scale_color_manual(values = c('dodgerblue2', 'red'))


#------------------------------------------------------------------------------------------------
# Decision Tree with 
library(rpart)
library(rpart.plot)

CART_MODEL <- rpart(Class ~ ., credit_smote)
rpart.plot(CART_MODEL, extra = 0, type = 5, tweak = 1.2)

#predict fraud classes
predicted_val <- predict(CART_MODEL, test_data, type = 'class')

#Build confusion matrix
library(caret)
confusionMatrix(predicted_val, test_data$Class)

#------------------------------------------------------------------------------------------------
# Final Check
predicted_val <- predict(CART_MODEL, credit_card[,-1], type = 'class')
confusionMatrix(predicted_val, credit_card$Class)
