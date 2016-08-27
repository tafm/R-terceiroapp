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
    
  ))
)
