dados <- data.frame(read.csv2("baseGeral.csv",  fileEncoding="UTF-8",  header = TRUE, sep = ";", dec = ","))
tamcol1 <- 8
tamcol2 <- (12 - tamcol1)

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
  
  #Box de desempenho satisfatório
  output$UIboxsatisfatorio <- renderInfoBox({
    if(!is.null(input$selectcurso) && input$selectcurso != "" && !is.null(input$selectperiodo) && input$selectperiodo != "" && !is.null(input$selectdisciplina) && input$selectdisciplina != "") {
      selecaogeral <- filter(dados, Curso == input$selectcurso, Período == input$selectperiodo, Nome.da.Disciplina == input$selectdisciplina)
      selecaosat <- filter(selecaogeral, DESEMPENHO_BINARIO == 1)
      desempenho <- paste(round((nrow(selecaosat) / nrow(selecaogeral)) * 100, digits = 1), "%", sep = "")
    } else {
      desempenho <- "?"
    }
    
    infoBox(
      "Satisfatório", desempenho, icon = icon("thumbs-up", lib = "glyphicon"), color = "green"
    )
  })
  
  #Box de desempenho satisfatório
  output$UIboxinsatisfatorio <- renderInfoBox({
    if(!is.null(input$selectcurso) && input$selectcurso != "" && !is.null(input$selectperiodo) && input$selectperiodo != "" && !is.null(input$selectdisciplina) && input$selectdisciplina != "") {
      selecaogeral <- filter(dados, Curso == input$selectcurso, Período == input$selectperiodo, Nome.da.Disciplina == input$selectdisciplina)
      selecaonsat <- filter(selecaogeral, DESEMPENHO_BINARIO == 0)
      desempenho <- paste(round((nrow(selecaonsat) / nrow(selecaogeral)) * 100, digits = 1), "%", sep = "")
    } else {
      desempenho <- "?"
    }
    infoBox(
      "Insatisfatório", desempenho, icon = icon("thumbs-down", lib = "glyphicon"), color = "red"
    )
  })
})