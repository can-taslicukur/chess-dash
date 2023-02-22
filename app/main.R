box::use(
    shiny[
        navbarPage, moduleServer, NS, tabPanel, observeEvent, updateTabsetPanel,
        appendTab, hideTab, column, reactiveVal, updateNavbarPage
    ],
    shinythemes[shinytheme],
    thematic[thematic_shiny]
)

box::use(
    app / view / getProfileInfo,
    app / view / matchHistory,
    app / view / eloChart
)

thematic_shiny()

#' @export
ui <- function(id) {
    ns <- NS(id)
    navbarPage(
        title = "Chess Dashboard",
        id = ns("mainPage"),
        tabPanel(title = "Account", getProfileInfo$getProfileInfoUI(ns("profileInfo")),value = "accountTab"),
        theme = shinytheme("superhero")
    )
    
}

#' @export
server <- function(id) {
    ns <- NS(id)
    moduleServer(id, function(input, output, session) {
        game_history <- getProfileInfo$getProfileInfoServer("profileInfo")
        query_count <- reactiveVal(value = 0)
        observeEvent(game_history(),{
            if (query_count() == 0) {
                appendTab(inputId = "mainPage",
                          tab = tabPanel(
                              title = "Dashboard",
                              column(matchHistory$matchHistoryUI(ns("matchHistory")),width = 6),
                              column(eloChart$eloChartUI(ns("eloChart")), width = 6),
                              value = "dashboardTab"),
                          select = TRUE)
            } else {
                updateNavbarPage(inputId = "mainPage",selected = "dashboardTab")
            }
            query_count(query_count()+1)
        })
        matchHistory$matchHistoryServer("matchHistory", data = game_history)
        eloChart$eloChartServer("eloChart",data = game_history)
    })
}
