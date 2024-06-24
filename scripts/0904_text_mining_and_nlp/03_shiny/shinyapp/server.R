
library(ggplot2)
library(dplyr)


teledata <- read.csv("Telecom data.csv", header = TRUE)

function(input, output) {

  output$weeks <- renderTable({

    xy <- subset(teledata, (Age_Group %in% input$age) & (Gender %in% input$gender))
    summarise(group_by(xy, Week), Avg_Calls = mean(Calls), Avg_Minutes = mean(Minutes), Avg_Amt = mean(Amt))
  })

  output$pie <- renderPlot({

    xy  <- subset(teledata, (Age_Group %in% input$age) & (Gender %in% input$gender))
    pie <- ggplot(xy, aes(x = "", fill = Active)) +
      geom_bar(width = 1) +
      coord_polar(theta = "y", start = pi / 3)
    pie
  })
}
