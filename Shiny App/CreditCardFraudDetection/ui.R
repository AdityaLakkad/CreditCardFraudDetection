library(shiny)
library(shinythemes)

shinyUI(
    
    navbarPage(
        "CreditcardFraudDetection",
        
        theme = shinytheme("darkly"),
        tabPanel("About",
                 tags$head(
                     tags$style(HTML("
                        @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                        
                        h1,h2,h3,h4,p {
                            font-family: 'cambria', cursive;
                            font-weight: 500;
                            line-height: 1.1;
                            color: White;
                        }
                "))
                 ),
                 h1("Credit Card Fraud Detection", align="center"),
                 hr(),
                 fluidRow(
                     column(2),
                     column(8,
                            p("Hello, Welcome to our webapp. This webapp states
                               the legitimacy of the Credit card or Bank transection.
                               This webapp has been created by the Student of Institute 
                               of Computer Technology, Ganpat University."),
                            p("Developer", align="center"),
                            p(a("Aditya Lakkad [Linkedin : https://www.linkedin.com/in/aditya-lakkad]/", 
                              href="https://www.linkedin.com/in/aditya-lakkad/"), align="center"),br(),
                            p("This webapp has been built based on only Credit card 
                               Transection data available on kaggle"),
                            p("(Link:  \" https://www.kaggle.com/mlg-ulb/creditcardfraud \")",
                               style = "font-family:calibri;
                                        font-style: italic"),br(),
                            p("But the size of this Dataset is 148 MB. And This webapp
                               does not have the capacity to hold that size of file. So,
                               Here is the sample data file of compatible size that you 
                               can upload in this webapp."),
                            a("(Sample datafile Link: \"https://drive.google.com/file/d/1QTsBnTS1Zx0w9HJip3xKbzPnaIyc7soR/view?usp=sharing\" )",
                               style = "font-family:calibri;
                                        font-style: italic", href="https://drive.google.com/file/d/1QTsBnTS1Zx0w9HJip3xKbzPnaIyc7soR/view?usp=sharing"),
                            hr(),
                            h3("How to Use the webapp", align="center"),
                            p("Go to \"Data Uploading\" tab. Upload your file or the downloded
                               file form the google drive. That's it, sit back and relax. 
                               Go through the various parts of webapp to see what is happening
                               with the data. If you want to check the legitimacy go straight to
                               the \"Check Transection\" tab. Fill up the variable values and you will
                               get the result."),
                            hr(),
                            h3("Different navbar tabs and their contents", align = "center"),
                            h4("Data Uploding"),
                            p("Here you have to upload the data file and have to give the separator 
                               used in the file to separate the Data. You will be able to see the statisticcal
                               summary and the structure of the data of the uploded file"),
                            h4("Data Exploration"),
                            p("In Data exploration , you will see the credit card transection type comparison.
                               There will be a no model prediction using confusion matrix and a visualization 
                               which will show imbalance in the credit card transection type. SO to balance the
                               transection type data we have to use sampling."),
                            h4("Data Sampling"),
                            p("In data sampling webapp uses somtefamily package and SMOTE function to create 
                               synthetic samples of the data. There you can set ratio of fraud cases and Legit
                               cases. You can visualize the result there."),
                            h4("Data Model"),
                            p("Here in the backend Data model gets prepared and there is a decision tree
                               visualization to check how the particular decision is been made."),
                            h4("Check Transection Legitimacy"),
                            p("Here, YOu have to enter the data of your transection and model will 
                               predict that if the transection is a legitimate transection or a Fraud 
                               transection"),
                            h3("Things to keep in mind", align="center"),
                            p("Please upload the data file before exploring anything.
                              ", style="color:red;", align="center"),
                            p("Ignore invalid file errors, those occurs because uploded 
                              file is in valid. So please upload the proper file",
                              style="color:red;", align="center")
                            ),
                            
                     column(2)
                 )
                 ),
        tabPanel(
            "Data Uploding",
            h1("Data Uploding", align = "center"),
            fluidRow(column(2),
                     column(8,
                            p("Here, you have to upload the file of the creditcard function's reading of 
               deviation in the process. Please uplod the valid uplod file which contains valid data. 
               You can separate data with the separatoers provided below.", align = "center"),
                            p("You can download the sample Datafile from google drive link given in the \"About\" tab."
                              ,style="color:aqua;",align="center")
                            ),
                     column(2)),
            
            tags$hr(),
            fluidRow(
                column(4),
                column(3,
                       fileInput("file1", "Choose CSV File",
                                 multiple = FALSE,
                                 accept = c("text/csv",
                                            "text/comma-separated-values,text/plain",
                                            ".csv"))),
                column(1, radioButtons("sep", "Separator",
                                       choices = c(Comma = ",",
                                                   Semicolon = ";",
                                                   Tab = "\t"),
                                       selected = ","),
                       
                       ),
                column(3)
                
            ),
            tags$hr(),
            fluidRow(
                column(5,
                       h3("Structure of table data", align = "center"),
                       verbatimTextOutput('dataStructure')),
                column(7,
                       h3("Summary of table data", align = "center"),
                       verbatimTextOutput('dataSummary'))
            ),
            tags$hr()
        ),
        tabPanel(
            "Data  Exploration",
            h1("Data Exploration and No model prediction", align ="center"),
            tags$hr(),
            fluidRow(
                column(1),
                column(2, 
                       h3("Count of two Cases", align = "center"),
                       verbatimTextOutput('caseCompare')),
                column(6,
                       h3("Visualization", align = "center"),
                       plotOutput("piechart")),
                column(2, 
                       h3("Probability of two Cases", align = "center"),
                       verbatimTextOutput('caseCompareProb'))
            ),
            tags$hr(),
            fluidRow(
                column(4,
                       h3("No model prediction", align="center"),
                       verbatimTextOutput("noModelPrediction")),
                column(8,
                       h3("Visualization of fraud and legit cases", align = "center"),
                       plotOutput("scatterPlot"),
                       p("Here, 0 represents the Legitimate transactions and 1 represents 
                              the Fraud transactions.", align="center")
                       )
            )
        ),
        tabPanel("Data Sampling",
                 h1("Data Sampling using SMOTE family", align="center"),
                 tags$hr(),
                 fluidRow(
                     column(3),
                     column(4,
                            p("Here, you have to specify that in the whole 
                               100% data set how much percentage of Fraud cases
                               you want to create accorting to that synthetic 
                               sample will be created. Best result can be derived
                              from 40/60 ratio to 30/70 ratio")),
                     column(2,
                            numericInput(
                                "frdc", label = "Enter Fraud Cases Percentage", value = 40,
                                min = NA, max = NA, step = NA, width = NULL)
                     ),
                     column(3)
                 ),
                 h4(textOutput("legitCasePercentage"), align="center"),
                 tags$hr(),
                 h3("After applying SMOTE Sampling", align = "center"),
                 p("Here, after applying SMOTE sampling, I have increased the 
                    amount of fraud cases. So this data will be helpful to us 
                    to create a better model", align = "center"),
                 tags$hr(),
                 fluidRow(
                     column(3,
                            h4("Before applying SMOTE Sampling", align = "center"),
                            verbatimTextOutput("compareProb")),
                     column(6,
                            h4("Visualization of Synthetic Samples created by 
                               smote", align="center"),
                            plotOutput('sampleScatter')),
                     column(3,
                            h4("After applying SMOTE Sampling", align = "center"),
                            verbatimTextOutput("smoteDataProb")),
                 ),
                 p("The data is sampled, Now we can make a model on this data 
                    set which can give a highly efficient result.", align = "center")
            ),
        tabPanel("Data Model",
                 h1("Data Model using Classification algorithm : Decision Tree",
                         align="center"),
                 h4("This model gived different accuracy at different size of data.",
                    align="center"),
                 fluidRow(
                     column(4),
                     column(4,
                            h4("Confusion Matrix", align="center")),
                     column(4)
                 ),
                 fluidRow(
                     
                     column(12,
                            plotOutput('classModel')),
                     
                 ),
                 verbatimTextOutput("confMatrixFinal")
        ),
        tabPanel("Check Transection Legitimacy",
                 h3("Predicting transection legitimacy based on data", align = "center"),
                 fluidRow(
                     column(2),
                     column(8,
                            p(" Here, You have to enter the data of readings cpatured from 
                            deviation caused in the security function's output. 
                            The security functions kept secret because of security reasons.
                            Please enter proper values of variable below",align = "center"),
                            ),
                     column(2),
                 ),
                 h3("Enter your input", align = "center"),
                 fluidRow(
                     column(1),
                     column(1,
                            numericInput("V1", label = "for V1", value = 0.96249607),
                            numericInput("V11", label = "for V11", value = 1.690329921),
                            numericInput("V21", label = "for V21", value = 0.143997423)
                     ),
                     column(1,
                            numericInput("V2", label = "for V2", value = 0.328461026),
                            numericInput("V12", label = "for V12", value = 0.406773576),
                            numericInput("V22", label = "for V22", value = 0.402491661)
                     ),
                     column(1,
                            numericInput("V3", label = "for V3", value = -0.171479054),
                            numericInput("V13", label = "for V13", value = -0.936421296),
                            numericInput("V23", label = "for V23", value = -0.048508221)
                     ),
                     column(1,
                            numericInput("V4", label = "for V4", value = 2.109204068),
                            numericInput("V14", label = "for V14", value = 0.983739419),
                            numericInput("V24", label = "for V24", value = -1.371866295),
                     ),
                     column(1,
                            numericInput("V5", label = "for V5", value = 1.129565571),
                            numericInput("V15", label = "for V15", value = 0.710910766),
                            numericInput("V25", label = "for V25", value = 0.390813885),
                     ),
                     column(1,
                            numericInput("V6", label = "for V6", value = 1.696037686),
                            numericInput("V16", label = "for V16", value = -0.602231772),
                            numericInput("V26", label = "for V26", value = 0.199963658),
                     ),
                     column(1,
                            numericInput("V7", label = "for V7", value = 0.107711607),
                            numericInput("V17", label = "for V17", value = 0.402484376),
                            numericInput("V27", label = "for V27", value = 0.016370643),
                     ),
                     column(1,
                            numericInput("V8", label = "for V8", value = 0.521502164),
                            numericInput("V18", label = "for V18", value = -1.737162035),
                            numericInput("V28", label = "for V28", value = -0.014605328),
                     ),
                     column(1,
                            numericInput("V9", label = "for V9", value = -1.191311102),
                            numericInput("V19", label = "for V19", value = -2.027612322),
                            numericInput("amount", label = "for amount", value = 34.09),
                     ),
                     column(1,
                            numericInput("V10", label = "for V10", value = 0.724396315),
                            numericInput("V20", label = "for V20", value = -0.269320967),
                            numericInput("time", label = "for time", value = 17)
                     ),
                     column(1)
                 ),
                 h2(textOutput("predictTras"), align = "center", style="color:aqua"),
                 fluidRow(
                     column(2),
                     column(8,
                            h3("Sample Input",align="center"),
                            verbatimTextOutput('sampleTras')),
                     column(2)
                 )
                 )
    )
)

