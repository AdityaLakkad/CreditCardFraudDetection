library(smotefamily)
library(rpart)
library(rpart.plot)

credit_card <- read.csv("E:\\Aditya\\DSM\\Book2.csv")
credit_card$Class <- factor(credit_card$Class, levels=c(0,1))
d = table(credit_card$Class)
n0 = d['0']
n1 = d['1']
r0 <- 0.7
ntimes <- ((1-r0)/r0)*(n0/n1)-1
smote_output = SMOTE(X = credit_card[,-c(1,31)],
                     target = credit_card$Class,
                     K = 5,
                     dup_size = ntimes)
credit_smote <- smote_output$data
str(credit_smote)
colnames(credit_smote)[30] <- "Class"
credit_smote$Class <- factor(credit_smote$Class, levels=c(0,1))
print(prop.table(table(credit_smote$Class)))
ggplot(credit_smote, aes(x = V1, y=V2, color = Class)) +
  geom_point() +
  scale_color_manual(values = c('dodgerblue2', 'red'))

library(rpart)
library(rpart.plot)
CART_MODEL <- rpart(Class ~ ., credit_smote)
rpart.plot(CART_MODEL, extra = 0, type = 5, tweak = 1.2)
s <- tail(credit_smote,1)
predicted_val <- predict(CART_MODEL, s, type = 'class')
confusionMatrix(predicted_val, s$Class)

