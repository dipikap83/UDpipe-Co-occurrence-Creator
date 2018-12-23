
# Team Member 1 : Dipika Pushpakaran (11810132)
# Team Member 2 : Shrey Nayak (11810033)
# Team Member 3 : Pooja Patil (11810123)

shinyUI(
 fluidPage(theme = shinytheme('superhero'),
  
  titlePanel("Co-occurrence Plots Creator"),  
  
  #Sidebar layout
  sidebarLayout(  
    
    sidebarPanel(   
      
      fileInput("File1", 
                h4("Upload the input data in a text file")),
      
      fileInput("File2",
                h4("Upload the language model dataset")),
  
      checkboxGroupInput("checkGroup", label = h4("Select the Parts of Speech"), 
                         choices = c("ADJECTIVE" = "ADJ", "NOUN" = "NOUN", "PROPER NOUN" = "PROPN", "ADVERB" = "ADV", "VERB" = "VERB"),
                         selected = c("ADJ","NOUN","PROPN")),
      
      hr(),
      fluidRow(column(3, verbatimTextOutput("value"))),
      
      sliderInput("freq",
                  h4("Word Cloud - Min. Frequency:"),
                  min = 1,  max = 50, value = 1),
      
      sliderInput("max",
                  h4("Word Cloud - Max. Number of Words:"),
                  min = 1,  max = 50,  value = 50)
    ),   
    
    #Main Panel on top
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                  #About Tab
                  tabPanel(h4("About"),   
                           
                          h3(p("Welcome to the Co-Occurrence Plot Creator")),
                           
                          p("This Shiny app is for creating a co-occurrence plot for input text in different languages and by different parts of speech. The co-occurrence plot will give you an idea of what words or terms exist in the document and what words follow another word. As a user, you can upload text in different languages with the respective udpipe model file and see different co-occurrence plots. The app uses the UDpipe R packaget to create the co-occurrence plot and other entities", align="justify"),
                           
                          p("As added features, we will also be sharing the table of annoted documents and a word cloud with you should you be interested in doing some additional analysis.Please read the below instructions in detail to use the Shiny app effectively.", align="justify"),
             
                          h3(p("How do I?")),
                           
                          p("Step 1: Simply upload the input text data by clicking on the 'Browse' tab in the side panel on the left. Remember to upload the input data in a .txt file ONLY."),
                          p("Step 2: Upload the UDpipe language mode in the second file input on the left. If you do not have the UDpipe language model files, please visit the LINDAT/CLARINS repository to download the different model files.", align="justify"),
                          a(href="https://lindat.mff.cuni.cz/repository/xmlui/handle/11234/1-2898"
                             ,"LINDAT/CLARIN Repository Home"), 
                          br(),
                          br(),
                           
                          p("Step 3: Select the Parts of Speech you would like to see a co-occurence plot and word cloud for. Remember to select ATLEAST one part of speech for meaningful output.", align="justify"),
                          p("Step 4: You can also select the minimum frequency for the words and maximum number of words for the Word Cloud by moving the bar in the slider panel.", align="justify"),
                          br(),
                      
                          p("Once you have uploaded the two files, selected the parts of speech and word cloud details, simply click on the tabs on top to see the co-occurrence plot, word cloud and table of annotated documents. This is a reactive live Shiny app, which means you can simply change the input to see instant changes in the plots and annotated documents", align="justify"),
                          p("Here is a sample input file to get you started! ", align="justify"),
                          a(href="https://github.com/dipikap83/UDpipe-Co-occurrence-Creator/blob/master/English%20Input%20File.txt","Sample Input File"), 
                          br()),
                  
                  #Co-Occurrence Plot
                  tabPanel(h4("Co-Occurrence"),
                           h3("Co-occurrence Plot"),
                           plotOutput('coplot1')),
                  
                  #Table of Annotated Documents
                  tabPanel(h4("Annotated document Table"), 
                           h3('Table of Annotated Documents'),
                           dataTableOutput('annottable')),
                          
                  #Noun and Verb Word Cloud
                  tabPanel(h4("Word Cloud"),
                           h3("Word Cloud"),
                           plotOutput('wplot2'))
                  
      ) # end of tabsetPanel
    )# end of main panel
  ) # end of sidebarLayout
)  # end if fluidPage
)# end of UI