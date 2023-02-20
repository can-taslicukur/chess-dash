box::use(
  shiny[
    fluidPage, shinyApp, NS, moduleServer, tagList, tags, fluidRow, tableOutput,
    column, selectInput, renderTable, reactive, bindEvent, observeEvent,
    icon, req, isTruthy
  ],
  shinyWidgets[searchInput, updateSearchInput],
  shinybusy[show_modal_spinner, remove_modal_spinner]
)

box::use(
  app / logic / get_raw_games,
  app / logic / process_raw_games
)

#' @export
getProfileInfoUI <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(
      tags$h1("Enter your chess username to see your personalized dashboard"),
      align = "center"
    ),
    fluidRow(
      column(
        selectInput(
          inputId = ns("platform"),
          label = "Chess Platform",
          choices = c("chess.com", "Lichess")
        ),
        width = 2
      ),
      column(
        width = 10,
        searchInput(
          inputId = ns("username"), label = "Username", width = "100%",
          placeholder = "chess.com username",
          btnSearch = icon("magnifying-glass"),
          btnReset = icon("xmark")
        )
      ),
      align = "center"
    )
  )
}



#' @export
getProfileInfoServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      observeEvent(input$platform, {
        updateSearchInput(
          session = session,
          inputId = "username",
          placeholder = paste(input$platform, "username"),
          value = "",
          trigger = FALSE
        )
      })

      reactive({
        req(input$username)
        if (input$platform == "chess.com") {
          show_modal_spinner(text = "Fetching your data")
        } else {
          show_modal_spinner(text = "Hold tight, Lichess has 15 games per second rate limit. It could take a few minutes to get all your games.")
        }
        game_history <- get_raw_games$get_raw_games(
          platform = input$platform, username = input$username
        ) |>
          process_raw_games$process_raw_games()
        remove_modal_spinner()
        game_history
      }) |>
        bindEvent(input$username)
    }
  )
}

getProfileInfoApp <- function() {
  shinyApp(
    fluidPage(getProfileInfoUI("getProfileInfo"), tableOutput("out")),
    function(input, output, session) {
      d <- getProfileInfoServer("getProfileInfo")
      output$out <- renderTable(d()[1, ])
    }
  )
}
