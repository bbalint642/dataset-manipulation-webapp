require(shiny)
datafile<-read.csv("data.csv", header=TRUE, sep=",", quote="")

runApp(
  list(
    ui = fluidPage(
      headerPanel('Uj sor beszurasa, prototipus'),
      sidebarPanel(
        textInput("fielda", label="a oszlop", value=""),
        textInput("fieldb", label="b oszlop", value=""),
        actionButton("addButton", "beszuras")
      ),
      mainPanel(
        tableOutput("table"))
    ),
    
    server = function(input, output) {     
      datafile_sample <- datafile[sample(nrow(datafile)),]
      row.names(datafile_sample) <- NULL
      
      values <- reactiveValues()
      values$df <- datafile_sample
      addData <- observe({
        
        if(input$addButton > 0) {
          newLine <- isolate(c(input$fielda, input$fieldb))
          isolate(values$df <- rbind(as.matrix(values$df), unlist(newLine)))
          write.csv(values$df, file = "data.csv", row.names=F, quote=F)
        }
      })
      output$table <- renderTable({values$df}, include.rownames=F)
    }
  )
)
