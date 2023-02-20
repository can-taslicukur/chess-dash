box::use(
  shiny[
    fluidPage, moduleServer, NS, fluidRow, textOutput, renderText, tableOutput,
    renderTable, column
  ],
  shinythemes[shinytheme],
  thematic[thematic_shiny]
)

box::use(
  app / view / getProfileInfo,
  app / view / matchHistory
)

thematic_shiny()

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    title = "Chess Dashboard",
    theme = shinytheme("superhero"),
    getProfileInfo$getProfileInfoUI(ns("profileInfo")),
    fluidRow(
      column(
        matchHistory$matchHistoryUI(ns("matchHistory")),
        width = 6,
        align = "center"
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    game_history <- getProfileInfo$getProfileInfoServer("profileInfo")
    matchHistory$matchHistoryServer("matchHistory", data = game_history)
  })
}
