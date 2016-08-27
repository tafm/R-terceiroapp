dados <- data.frame(read.csv2("baseGeral.csv",  fileEncoding="UTF-8",  header = TRUE, sep = ";", dec = ","))

shinyServer(function(input, output) {
  
  #Seletor de curso
  output$selectcurso<- renderUI({
    selectInput("tipografico", "Selecione o curso:", sort(as.character(dados$Curso)), selected = NULL)
  })
  
  #Seletor de período
  
})