library(shiny)
library(shinydashboard)
library(dplyr)

ui <- dashboardPage(
  dashboardHeader(title = "Dashboard"),
  
  dashboardSidebar(
    #sidebarMenu(
      #menuItem("Parâmetros", tabName = "dashboard", icon = icon("dashboard"), 
      #  menuSubItem(icon = NULL, tabName="dashboard", uiOutput("selectcurso"))
      #)
    #)
    uiOutput("UIselectcurso"),

    conditionalPanel(
      condition = "input.selectcurso != ''",
      uiOutput("UIselectperiodo")
    ),
    
    conditionalPanel(
      condition = "input.selectperiodo != ''",
      uiOutput("UIselectdisciplina")
    )
  ),
  
  dashboardBody(fluidRow(
    column(width = 8, 
      fluidRow(
        infoBoxOutput("UIboxsatisfatorio"),
        tags$style("#UIboxsatisfatorio {width:50%;}"),
        infoBoxOutput("UIboxinsatisfatorio"),
        tags$style("#UIboxinsatisfatorio {width:50%;}")
      ),
      box(h3("teste"), title = "Representação gráfica:", footer = NULL, status = NULL, solidHeader = TRUE, background = NULL, width = NULL, height = NULL, collapsible = TRUE, collapsed = FALSE)
    ),
    column(width = 4, 
      box(h3("teste"), title = "Variáveis:", footer = NULL, status = NULL, solidHeader = TRUE, background = NULL, width = NULL, height = NULL, collapsible = TRUE, collapsed = FALSE),
      box(h3("teste"), title = "Alunos:", footer = NULL, status = NULL, solidHeader = TRUE, background = NULL, width = NULL, height = NULL, collapsible = TRUE, collapsed = TRUE)
    )
  ))
)
