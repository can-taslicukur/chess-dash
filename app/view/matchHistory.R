box::use(
  shiny[NS, moduleServer, tagList, fluidPage, shinyApp],
  reactable[reactableOutput, renderReactable, reactable],
  reactablefmtr[superhero],
  dplyr[select],
  utils[tail]
)

matchHistoryUI <- function(id) {
  ns <- NS(id)
  tagList(
    reactableOutput(outputId = ns("matchHistoryTable"))
  )
}

matchHistoryServer <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {
      output$matchHistoryTable <- renderReactable({
        last_20_games <- data() |>
          select(Timestamp, UserResult, UserColor, TimeControl, UserELO, OpponentELO) |>
          tail(20)

        names(last_20_games) <- c("Date", "Result", "Played Color", "Time Control", "Your ELO", "Opponent ELO")
        reactable(last_20_games,
          theme = superhero(),
          rowStyle = function(index) {
            switch(last_20_games$Result[index],
              Win = list(background = "#79ea86"),
              Loss = list(background = "#e75757"),
              Draw = list(background = "#808080")
            )
          }
        )
      })
    }
  )
}

matchHistoryApp <- function() {
  sample_data <- function() {
    data.frame(
      Timestamp = as.POSIXct(seq(from = Sys.Date() - 4, to = Sys.Date(), by = 1), tz = "UTC"),
      UserResult = c("Win", "Draw", "Loss", "Win", "Win"),
      UserColor = c(rep("White", 3), rep("Black", 2)),
      TimeControl = rep("300", 5),
      UserELO = rep(1500, 5),
      OpponentELO = rep(1500, 5)
    )
  }

  shinyApp(
    fluidPage(matchHistoryUI("matchHistory")),
    function(input, output, session) {
      matchHistoryServer("matchHistory", sample_data)
    }
  )
}
