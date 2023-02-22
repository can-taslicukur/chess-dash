test_that("mutated columns doesnt have any NA values when platform = 'chess.com'", {
  expect_true({
    box::use(
      app / logic / get_raw_games,
      app / logic / process_raw_games
    )
    chessdotcom <- get_raw_games$get_raw_games("chess.com", "yesil36") |>
      process_raw_games$process_raw_games()

    all(!is.na(chessdotcom$UserColor)) &
      all(!is.na(chessdotcom$Opponent)) &
      all(!is.na(chessdotcom$UserELO)) &
      all(!is.na(chessdotcom$OpponentELO)) &
      all(!is.na(chessdotcom$Date)) &
      all(!is.na(chessdotcom$UserResult)) &
      all(!is.na(chessdotcom$Timestamp)) &
      all(!is.na(chessdotcom$GameNumber))
  })
})

test_that("mutated columns doesnt have any NA values when platform = 'Lichess'", {
  expect_true({
    box::use(
      app / logic / get_raw_games,
      app / logic / process_raw_games
    )
    lichess <- get_raw_games$get_raw_games("Lichess", "Georges") |>
      process_raw_games$process_raw_games()

    all(!is.na(lichess$UserColor)) &
      all(!is.na(lichess$Opponent)) &
      all(!is.na(lichess$UserELO)) &
      all(!is.na(lichess$OpponentELO)) &
      all(!is.na(lichess$Date)) &
      all(!is.na(lichess$WhiteElo)) &
      all(!is.na(lichess$BlackElo)) &
      all(!is.na(lichess$winner)) &
      all(!is.na(lichess$UserResult)) &
      all(!is.na(lichess$Timestamp)) &
      all(!is.na(lichess$GameNumber))
  })
})
