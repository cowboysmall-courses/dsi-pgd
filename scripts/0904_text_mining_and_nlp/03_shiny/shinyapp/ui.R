
library(shiny)


fluidPage(

  titlePanel("Weekly Pattern of Usage"),

  sidebarLayout(

    sidebarPanel(

      checkboxGroupInput(

        inputId = "age",
        label = "Select the Age group",
        choices = c("18-30", "30-45", ">45"),
        selected = c("18-30", "30-45", ">45")
      ),

      checkboxGroupInput(

        inputId = "gender",
        label = "Select the gender",
        choices = c("F", "M"),
        selected = c("F", "M")
      )
    ),

    mainPanel(

      fluidRow(

        column(6, tableOutput("weeks")),
        column(6, plotOutput("pie"))
      )
    )
  )
)
