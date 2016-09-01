library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)
library(xlsx)
library(plotly)

tamcol1 <- 8
tamcol2 <- (12 - tamcol1)

ui <- dashboardPage(
  dashboardHeader(title = "Dashboard"),
  
  dashboardSidebar(
    #sidebarMenu(
      #menuItem("Parâmetros", tabName = "dashboard", icon = icon("dashboard"), 
      #  menuSubItem(icon = NULL, tabName="dashboard", uiOutput("selectcurso"))
      #)
    #)
    uiOutput("UIselectcurso"),
    uiOutput("UIselectperiodo"),
    uiOutput("UIselectdisciplina"),
    conditionalPanel( cond = "input.selectdisciplina == ''",
                      fluidRow(
                        column(width = 12, 
                               uiOutput('text1'),
                               tags$head(tags$style("#text1{color: red;
                                 font-size: 14px;
                                 padding-left: 1em;
                                 }"
                               )
                               )
                        )
                      )
    )
  ),
  
  dashboardBody(fluidRow(
    conditionalPanel( cond = "input.selectdisciplina != ''", 
      column(width = tamcol1, 
        fluidRow(
          infoBoxOutput("UIboxsatisfatorio"),
          tags$style("#UIboxsatisfatorio {width:50%;}"),
          infoBoxOutput("UIboxinsatisfatorio"),
          tags$style("#UIboxinsatisfatorio {width:50%;}")
        ),
        box(
          conditionalPanel(cond = "input.tabvariaveis_rows_selected == 0",
            h5("Selecione uma variável")
          ),
          conditionalPanel(cond = "input.tabvariaveis_rows_selected != 0",
            plotlyOutput('grafico')
          )
          , title = "Representação gráfica:", footer = NULL, status = NULL, solidHeader = TRUE, background = NULL, width = NULL, height = NULL, collapsible = TRUE, collapsed = FALSE)
      ),
      column(width = tamcol2, 
        box(dataTableOutput("tabvariaveis"), title = "Variáveis:", footer = NULL, status = NULL, solidHeader = TRUE, background = NULL, width = NULL, height = NULL, collapsible = TRUE, collapsed = FALSE),
        box(dataTableOutput("tabalunos"), title = "Alunos:", footer = NULL, status = NULL, solidHeader = TRUE, background = NULL, width = NULL, height = NULL, collapsible = TRUE, collapsed = TRUE)
      )
    )
  ))
)
