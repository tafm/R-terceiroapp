dados <- data.frame(read.csv2("baseGeral.csv",  fileEncoding="UTF-8",  header = TRUE, sep = ";", dec = ","))
xlsxsheet1 <- read.xlsx("DicionarioDados.xlsx", 1, encoding = "UTF-8")
xlsxsheet2 <- read.xlsx("DicionarioDados.xlsx", 2, encoding = "UTF-8")

#Concatenação de sheets 1 e 2 do arquivo

variaveis <- data.frame(
  "col1" = c(
    as.character(xlsxsheet1$Variável),
    as.character(xlsxsheet2$Variável)
  ),
  "col2" = c(
    as.character(xlsxsheet1$Descrição.sobre.as.variáveis),
    as.character(xlsxsheet2$Descrição.sobre.as.variáveis)
  ),
  "col3" = c(
    as.character(xlsxsheet1$Construto),
    as.character(xlsxsheet2$Categoria)
  )
)

linhatabToVar <- function(linhaselecionada) {
  return(as.character(variaveis[linhaselecionada,1]))
}

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
      selecaosat <- filter(selecaogeral, DESEMPENHO_BINARIO == 0)
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
      selecaonsat <- filter(selecaogeral, DESEMPENHO_BINARIO == 1)
      desempenho <- paste(round((nrow(selecaonsat) / nrow(selecaogeral)) * 100, digits = 1), "%", sep = "")
    } else {
      desempenho <- "?"
    }
    infoBox(
      "Insatisfatório", desempenho, icon = icon("thumbs-down", lib = "glyphicon"), color = "red"
    )
  })
  
  #Tabela de variáveis
  
  output$tabvariaveis <- renderDataTable({#print(input$tabvariaveis_rows_selected)
    variaveisUI <- select(variaveis, col1, col2)
    colnames(variaveisUI) <- c("Id", "Descrição")
    variaveisUI
  },  rownames = FALSE,
      options = list(paging = FALSE, searching = FALSE, scrollX = TRUE, scrollY = "400px", bInfo = FALSE, bAutoWidth = FALSE),
      selection = list(target = 'row', mode = 'single', selected = c(1))
  )
  
  #Tabela de alunos
  output$tabalunos <- renderDataTable({
    if(!is.null(input$tabvariaveis_rows_selected) && input$tabvariaveis_rows_selected != 0) {
      selecaogeral <- filter(dados, Curso == input$selectcurso, Período == input$selectperiodo, Nome.da.Disciplina == input$selectdisciplina)
      var <- linhatabToVar(input$tabvariaveis_rows_selected)
      colunas <- c("Nome.do.Aluno", var, "DESEMPENHO_BINARIO")
      ncol <- match(colunas,names(selecaogeral))
      alunos <- select(selecaogeral, ncol)
      alunos$DESEMPENHO_BINARIO <- as.character(alunos$DESEMPENHO_BINARIO)
      alunos$DESEMPENHO_BINARIO[alunos$DESEMPENHO_BINARIO == "0"] <- "Satistatório"
      alunos$DESEMPENHO_BINARIO[alunos$DESEMPENHO_BINARIO == "1"] <- "Insatisfatório"
      alunos <- alunos[order(alunos$Nome.do.Aluno),]
      colnames(alunos) <- c("Aluno", "Frequência", "Desempenho")
    } else {print('teste')
      alunos <- NULL
    }
    alunos
    },  rownames = FALSE,
        options = list(paging = FALSE, searching = FALSE, scrollX = TRUE, scrollY = "400px", bInfo = FALSE),
        #selection = 'single'
        selection = 'none'
  )
  
  #Gráfico
  output$grafico <- renderPlotly({
    if(!is.null(input$selectcurso) && input$selectcurso != "" && !is.null(input$selectperiodo) && input$selectperiodo != "" && !is.null(input$selectdisciplina) && input$selectdisciplina != "") {
      selecaoalunos <- filter(dados, Curso == input$selectcurso, Período == input$selectperiodo, Nome.da.Disciplina == input$selectdisciplina)
      var <- linhatabToVar(input$tabvariaveis_rows_selected)
      colunas <- c("Nome.do.Aluno","DESEMPENHO_BINARIO", var)
      ncol <- match(colunas,names(selecaoalunos))
      alunos <- select(selecaoalunos, ncol)
      alunos <- alunos[order(alunos[var]),]
      alunos["r"] <- c(1:nrow(alunos))
      colnames(alunos) <- c("Nome", "Desempenho", "Variavel", "Rank")
      alunos$Desempenho[alunos$Desempenho == "0"] <- "Satisfatório"
      alunos$Desempenho[alunos$Desempenho == "1"] <- "Insatisfatório"
      plot_ly(data = alunos, x = Rank, y = Variavel, mode = "markers", color = Variavel, text = paste(paste("Nome:", Nome), paste("Frequência:", Variavel), paste("Desempenho:", Desempenho), sep = "<br>"))
    }
  })
})