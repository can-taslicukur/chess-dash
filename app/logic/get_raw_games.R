box::use(
    chessR[get_raw_lichess, get_raw_chessdotcom],
    
)

#' @export
get_raw_games <- function(platform = c("chess.com", "Lichess"), username) {
    
    match.arg(platform)
    
    switch (platform,
            chess.com = get_raw_chessdotcom(username),
            Lichess = get_raw_lichess(username))
}