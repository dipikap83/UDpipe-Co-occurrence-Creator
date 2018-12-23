#setwd('C:/Users/dipik/Desktop/ISB - CBA/Text Analytics/Group Assignment')
#getwd()

# Team Member 1 : Dipika Pushpakaran (11810132)
# Team Member 2 : Shrey Nayak (11810033)
# Team Member 3 : Pooja Patil (11810123)

#try(require("shinythemes")||install.packages('shinythemes'))
#try(require("ggplot2")||install.packages('ggplot2'))
#try(require("ggraph")||install.packages('ggraph'))
#try(require("corrplot")||install.packages('corrplot'))
#try(require("shiny")||install.packages('shiny'))
#try(require("udpipe")||install.packages('udpipe'))
#try(require("stringr")||install.packages('stringr'))
#try(require("wordcloud")||install.packages('wordcloud'))
#try(require("dplyr")||install.packages('dplyr'))

options(shiny.maxRequestSize=500*1024^2)
windowsFonts(devanew=windowsFont("Devanagari new normal"))

shinyServer(function(input, output) {
  
  #Read the input text in the .txt file
  InputFile <- reactive({
    if (is.null(input$File1))
    {
      return(NULL) 
    } 
    else
    {
      Input <- readLines(input$File1$datapath,encoding="UTF-8")
      Input  =  str_replace_all(Input, "<.*?>", "")  
      Input  =  str_replace_all(Input, "(?!')[[:punct:]]", "")
      str(Input)
      return(Input)
    }
  })
  
  #Read the udpipe language model file
  lang_model = reactive({
    lang_model = udpipe_load_model(input$File2$datapath)  
    return(lang_model)
  })
  
  
  #Create the annotated text using the udpipe language model
  annottext = reactive({
    annotdata <- udpipe_annotate(lang_model(),x = InputFile())
    annotdata <- as.data.frame(annotdata)
    return(annotdata)
  })
  
  
  #Co-occurrence plot
  output$coplot1 = renderPlot({
    windowsFonts(devanew=windowsFont("Devanagari new normal"))
    if(is.null(input$File1)|is.null(input$File2)|is.null(input$checkGroup)){return(NULL)}
    else{
        text_cooc <- cooccurrence(   
        
          
        #Check if the annotated text has xpos values. If not, use upos
        if(is.na(annottext()$xpos)){
            x = subset(annottext(), upos %in% c(input$checkGroup))
        }
        else{
            xposval <- str_replace_all(input$checkGroup,c("ADJ" = "JJ", "NOUN" = "NN", "PROPN" = "NNP","ADV" = "WRB", "VERB" = "VB"))
            #Hindi language has different xpos values for Adverb and Verb
            if(xposval %in% c("WRB")){xposval <- append(xposval,"NST")}
            if(xposval %in% c("VB")){xposval <- append(xposval,"VM")}
            x = subset(annottext(), xpos %in% c(xposval))
        },
        
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))
        
        wordnetwork <- head(text_cooc, 50)
        wordnetwork <- igraph::graph_from_data_frame(wordnetwork) 
        ggraph(wordnetwork, layout = "fr") +  
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 6) +
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        labs(title = "Co-occurrences within 3 words distance")
      
       }
  })
  
  
  #Table of Annotated Documents
  output$annottable = renderDataTable({
    if(is.null(input$File1)|is.null(input$File2)){return(NULL)}
    else{
        out = annottext()
        return(out)
        }
  })
  
  
  #Word Cloud
  output$wplot2 = renderPlot({
    if(is.null(input$File1)|is.null(input$File2)|is.null(input$checkGroup)){return(NULL)}
    else{
      
      #Check if the annotated text has xpos values
      if(is.na(annottext()$xpos)){
        all_pos = annottext() %>% subset(., upos %in% c(input$checkGroup))}
      else{
        xposval <- str_replace_all(input$checkGroup,c("ADJ" = "JJ", "NOUN" = "NN", "PROPN" = "NNP","ADV" = "WRB", "VERB" = "VB"))
        #Hindi language has different xpos values for Adverb and Verb
        if(xposval %in% c("WRB")){xposval <- append(xposval,"NST")}
        if(xposval %in% c("VB")){xposval <- append(xposval,"VM")}
        all_pos = annottext() %>% subset(., xpos %in% c(xposval))
      }
      
      top_pos = txt_freq(all_pos$lemma)  
      wordcloud(top_pos$key, top_pos$freq, scale=c(6,0.5),
                min.freq = input$freq, max.words=input$max,
                colors=brewer.pal(8, "Dark2"))
      }
  })
  
})
