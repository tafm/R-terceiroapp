dados <- data.frame(read.csv2("baseGeral.csv",  fileEncoding="UTF-8",  header = TRUE, sep = ";", dec = ","))

shinyServer(function(input, output) {
  
  #Seletor de curso
  output$UIselectcurso<- renderUI({
    selectInput("selectcurso", "Selecione o curso:", sort(as.character(dados$Curso)), selected = NULL)
  })
  
  #Seletor de período
  output$UIselectperiodo<- renderUI({
    if(!is.null(input$selectcurso) && input$selectcurso != "") {
      opcoesperiodo <- filter(dados, Curso == input$selectcurso) 
      opcoesperiodo <- sort(unique(opcoesperiodo$Período))
      names(opcoesperiodo) <- paste(opcoesperiodo, "º Período", sep = "")
    } else {
      opcoesperiodo <- NULL
    }
    
    selectInput("selectperiodo", "Escolha o período:", opcoesperiodo, selected = NULL)
  })
  
  #Seletor de disciplina
  output$UIselectdisciplina<- renderUI({
    if(!is.null(input$selectperiodo) && input$selectperiodo != "") {
      opcoesdisciplina <- filter(dados, Curso == input$selectcurso, Período == input$selectperiodo)
      opcoesdisciplina <- sort(as.character(opcoesdisciplina$Nome.da.Disciplina))
    } else {
      opcoesdisciplina <- NULL
    }
    
    selectInput("selectdisciplina", "Disciplina:", opcoesdisciplina, selected = NULL)
  })
})