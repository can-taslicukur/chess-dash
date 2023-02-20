test_that("cant enter unrecognized platform", {
    expect_error({
        box::use(
            app/logic/get_raw_games
        )
        get_raw_games$get_raw_games("foo", "yesil36")
    }, "'arg' should be one of “chess.com”, “Lichess”")
})

test_that("platform is correct", {
  expect_true({
      box::use(
         app/logic/get_raw_games
      )
      chessdotcom <- get_raw_games$get_raw_games("chess.com", "yesil36")
      lichess <- get_raw_games$get_raw_games("Lichess", "Georges")
      chessdotcom$Site[1] == "Chess.com" & grepl("lichess",lichess$Site[1])
  })
})

test_that("returns the correct user", {
    expect_true({
        box::use(
            app/logic/get_raw_games
        )
        chessdotcom <- get_raw_games$get_raw_games("chess.com", "yesil36")
        lichess <- get_raw_games$get_raw_games("Lichess", "Georges")
        
        chessdotcom$Username[1] == "chesstopkek" & lichess$Username[1] == "Georges"
    })
})
