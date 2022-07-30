#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(caret)
library(dplyr)
library(e1071)
library(ggplot2)
library(smotefamily)
library(rpart)
library(rpart.plot)

fetchData <- function(input){
  tryCatch(
    {
      df <- read.csv(input$file1$datapath,
                     sep = input$sep)
    },
    error = function(e) {
      stop(safeError(e))
    }
  )
  df$Class <- factor(df$Class, levels=c(0,1))
  return(df)
}

smoteData <- function(input){
  credit_card = fetchData(input)
  d = table(credit_card$Class)
  n0 = d['0']
  n1 = d['1']
  r0 <- (100 - input$frdc)/100
  ntimes <- ((1-r0)/r0)*(n0/n1)-1
  smote_output = SMOTE(X = credit_card[,-c(1,31)],
                       target = credit_card$Class,
                       K = 5,
                       dup_size = ntimes)
  credit_smote <- smote_output$data
  colnames(credit_smote)[30] <- "Class"
  return(credit_smote)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
    output$columns <- renderUI({
      inFile <- input$file1
      if (is.null(inFile))
        return(NULL)
      dat = read.csv(inFile$datapath)
      selectInput("selectedColumn", "Select One column", names(dat), multiple = T)
    })
    
    output$contents <- renderTable({
      tryCatch(
        {
          df <- read.csv(input$file1$datapath,
                         sep = input$sep)
        },
        error = function(e) {
          stop(safeError(e))
        }
      )
      data = df
      print(data)
        return(head(df))
    })
    
    output$dataStructure <- renderPrint({
      df = fetchData(input)
      print(str(df))
    })
    
    output$dataSummary <- renderPrint({
      df = fetchData(input)
      print(summary(df))
    })
    
    output$caseCompare <- renderPrint({
      df = fetchData(input)
      print(table(df$Class))
    })
    
    output$caseCompareProb <- renderPrint({
      df = fetchData(input)
      print(prop.table(table(df$Class)))
    })
    
    output$piechart <- renderPlot({
      credit_card = fetchData(input)
      labels <- c("Legit","Fraud")
      labels <- paste(labels, round(100*prop.table(table(credit_card$Class)), 2))
      labels <- paste0(labels, "%")
      pie(table(credit_card$Class), labels, col = c("orange","Red"), main="Piechart of credit card transection")
    })
    
    output$noModelPrediction <- renderPrint({
      df = fetchData(input)
      predictions <- rep.int(0, nrow(df))
      predictions<- factor(predictions, levels = c(0,1))
      print(confusionMatrix(data=predictions, reference = df$Class))
    })
    
    output$scatterPlot <- renderPlot({
      df <- fetchData(input)
      ggplot(data = df, aes(x = V1, y = V2, col = Class)) + 
        geom_point() + theme_bw() +
        scale_color_manual(values = c("dodgerblue2","red"))
    })
    
    output$legitCasePercentage <- renderPrint({
      a <- input$frdc
      d <- 100 - a
      cat("Fraud case data percentage is ",a,"% and Legit case data percentage is ",d,"%")
    })
    
    output$smoteDataProb <- renderPrint({
      credit_smote <- smoteData(input)
      print(prop.table(table(credit_smote$Class)))
    })
    
    output$compareProb <- renderPrint({
      df = fetchData(input)
      print(prop.table(table(df$Class)))
    })
    
    output$sampleScatter <- renderPlot({
      credit_smote <- smoteData(input)
      ggplot(credit_smote, aes(x = V1, y=V2, color = Class)) +
        geom_point() +
        scale_color_manual(values = c('dodgerblue2', 'red'))
    })
    
    output$classModel <- renderPlot({
      credit_smote = smoteData(input)
      CART_MODEL <- rpart(Class ~ ., credit_smote)
      rpart.plot(CART_MODEL, extra = 0, type = 5, tweak = 1.2)
    })
    
    output$predictTras <- renderPrint({
      credit_smote = smoteData(input)
      V1 = input$V1
      V2 = input$V2
      V3 = input$V3
      V4 = input$V4
      V5 = input$V5
      V6 = input$V6
      V7 = input$V7
      V8 = input$V8
      V9 = input$V9
      V10 = input$V10
      V11 = input$V11
      V12 = input$V12
      V13 = input$V13
      V14 = input$V14
      V15 = input$V15
      V16 = input$V16
      V17 = input$V17
      V18 = input$V18
      V19 = input$V19
      V20 = input$V20
      V21 = input$V21
      V22 = input$V22
      V23 = input$V23
      V24 = input$V24
      V25 = input$V25
      V26 = input$V26
      V27 = input$V27
      V28 = input$V28
      Amount = input$amount
      Time = input$time
      data = data.frame(Time,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,
                        V17,V18,V19,V20,V21,V22,V23,V24,V25,V26,V27,V28,Amount)
      
      CART_MODEL <- rpart(Class ~ ., credit_smote)
      
      predicted_val <- predict(CART_MODEL, data, type = 'class')
      
      
      
      if(predicted_val==0){
        print("Conclusion : Your Transection is a Legitimate transaction")
      }else{
        print("Conclusion : Your Transection is a Fraud transaction")
      }
    })
    
    output$sampleTras <- renderPrint({
      df = fetchData(input)
      a <- head(df,1)
      print(a)
    })
    
    output$confMatrixFinal <- renderPrint({
      df = fetchData(input)
      credit_smote = smoteData(input)
      CART_MODEL <- rpart(Class ~ ., credit_smote)
      predicted_val <- predict(CART_MODEL, df, type = 'class')
      print(confusionMatrix(predicted_val, df$Class))
    })
})
