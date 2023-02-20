box::use(
  dplyr[
    mutate, case_when, case_match, row_number
  ],
  stringr[str_extract]
)

#' @export
process_raw_games <- function(data) {
  username <- data$Username[1]

  data <- data |>
    mutate(
      UserColor = ifelse(White == username, "White", "Black"),
      Opponent = ifelse(White == username, Black, White),
      UserELO = as.numeric(ifelse(UserColor == "White", WhiteElo, BlackElo)),
      OpponentELO = as.numeric(ifelse(UserColor == "White", BlackElo, WhiteElo))
    )

  ## decide if data is whether lichess or chess.com
  if (data$Site[1] == "Chess.com") {
    data <- data |>
      mutate(
        # TerminationType = str_extract(Termination,pattern = "((?<=by\\s).*)|((?<=\\son\\s).*)"),
        # ECOName = gsub("-"," ",str_extract(ECOUrl, "(?<=openings/).*")),
        Date = as.Date(Date),
        UserResult = case_when(
          grepl(paste(username, "won"), Termination) ~ "Win",
          grepl("drawn", Termination) ~ "Draw",
          T ~ "Loss"
        )
      )
  } else {
    data <- data |>
      mutate(
        Date = as.Date(Date, format = "%Y.%m.%d"),
        WhiteElo = ifelse(WhiteElo == "?", "1500", WhiteElo),
        BlackElo = ifelse(BlackElo == "?", "1500", BlackElo),
        winner = case_match(
          Result,
          "0-1" ~ "Black",
          "1-0" ~ "White",
          "1/2-1/2" ~ "Draw"
        ),
        UserResult = case_when(
          winner == "Draw" ~ "Draw",
          winner == UserColor ~ "Win",
          T ~ "Loss"
        )
      )
  }

  data <- data |>
    mutate(
      Timestamp = as.POSIXct(paste(Date, UTCTime), tz = "UTC")
    )

  data <- data[order(data$Timestamp, decreasing = FALSE), ]

  data |> mutate(GameNumber = row_number())
}
