box::use(
    shiny[fluidPage, shinyApp, NS, tagList, moduleServer, observeEvent, updateSelectInput,
          plotOutput, renderPlot, uiOutput, renderUI, selectInput, req],
    ggplot2[ggplot, aes, geom_line]
)


eloChartUI <- function(id) {
    ns <- NS(id)
    tagList(
        selectInput(inputId = ns("timeControlFilter"),label = "TimeControl", choices = c("300","600")),
        plotOutput(outputId = ns("eloChart"))
    )
}


eloChartServer <- function(id, data) {
    moduleServer(
        id,
        function(input, output, session) {
            
            observeEvent(data(),{
                playedTimeControls <- sort(table(data()$TimeControl),decreasing = TRUE)
                updateSelectInput(inputId = "timeControlFilter",
                                  choices = names(playedTimeControls))
            })
            
            output$eloChart <- renderPlot({
                data()[data()$TimeControl == input$timeControlFilter, c("GameNumber", "UserELO", "TimeControl")] |>
                    ggplot(aes(x = GameNumber, y = UserELO, color = TimeControl)) +
                    geom_line()
            })
        }
    )
}

eloChartShinyApp <- function() {
    
    sample_data <- function() {
        d <- data.frame(
            TimeControl = c(rep("300", 50), rep("600", 5)),
            UserELO = c(rnorm(50, 500, sd = 50), rnorm(5, 1500, sd = 50)),
            GameNumber = sample(1:55, 55)
        )
        d
    }
    
    shinyApp(
        eloChartUI("eloChart"),
        function(input, output, session) {
            eloChartServer("eloChart", sample_data)
        }
    )
}