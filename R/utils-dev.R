# nocov start

# dev_UI(ns("lmf_dev")), # ONLY FOR DEVELOPING

poc <- pack_of_constants

DEBUG <- poc( # nolint
  INPUT_LIST = "input_list",
  BROWSER_BTN = "browser_button",
  UI = "ui_id",
  SHOW = "show",
  DEBUG_UI = "debug"
)

..__is_db <- function(option_name = "..__db_mode") { # nolint
  isTRUE(getOption(option_name))
}

..__db_input_UI <- function(id, option_name = "..__db_mode") { # nolint
  if (!..__is_db()) {
    return()
  }
  ns <- shiny::NS(id)
  shiny::wellPanel(
    shiny::h4("Debug Output"),
    shiny::checkboxInput(ns(DEBUG$SHOW), label = "Show Debug", value = FALSE),
    shiny::conditionalPanel(
      condition = paste0("input['", ns(DEBUG$SHOW), "']"),
      shiny::uiOutput(ns(DEBUG$UI))
    )
  )
}

..__db_input_server <- function(id, option_name = "..__db_mode") { # nolint
  if (!..__is_db()) {
    return()
  }
  module <- function(input, output, session) {
    shiny::setBookmarkExclude(
      names = c(DEBUG$INPUT_LIST, DEBUG$BROWSER_BTN)
    )

    ns <- session[["ns"]]

    output[[DEBUG$UI]] <- shiny::renderUI({
      shiny::tagList(
        shiny::fluidRow(shiny::verbatimTextOutput(ns(DEBUG$INPUT_LIST))),
        shiny::br(),
        shiny::fluidRow(shiny::actionButton(ns(DEBUG$BROWSER_BTN), "Browser", icon = shiny::icon("eye"))),
      )
    })

    shiny::observeEvent(
      input[[DEBUG$BROWSER_BTN]],
      {
        browser()
      },
      ignoreInit = TRUE
    )

    dev_paste0 <- function(x) { # nolint
      paste0(x, collapse = ",")
    }

    output[[DEBUG$INPUT_LIST]] <- shiny::renderText({
      anc <- ((get(":::"))("shiny", "find_ancestor_session"))(session)
      vc <- shiny::reactiveValuesToList(anc$input)
      vc <- vc[sort(names(vc), index.return = TRUE)[["ix"]]]
      vc <- purrr::map(vc, ~ if (length(.x) > 1) {
        dev_paste0(.x)
      } else {
        .x
      })
      paste0(names(vc), " = ", vc, collapse = "\n")
    })
  }

  shiny::moduleServer(
    id,
    module = module
  )
}

..__db_UI <- function(id, main_ui, option_name = "..__db_mode", stacked = FALSE) { # nolint
  if (!..__is_db()) {
    return(main_ui)
  }
  ns <- shiny::NS(id)

  if (stacked) {
    shiny::tagList(
      shiny::uiOutput(ns(DEBUG$DEBUG_UI)),
      main_ui
    )
  } else {
    shiny::tabsetPanel(
      shiny::tabPanel(
        "Main",
        main_ui
      ),
      shiny::tabPanel(
        "Debug",
        shiny::uiOutput(ns(DEBUG$DEBUG_UI))
      )
    )
  }
}

..__db_server <- function(id, debug_list, option_name = "..__db_mode") { # nolint
  if (!..__is_db()) {
    return()
  }



  module <- function(input, output, session) {
    ns <- session[["ns"]]

    # Add hash for naming
    db_list_with_hash <- lapply(debug_list, function(x) {
      x[["hash_id"]] <- str_to_hash(x[["name"]])
      x
    })
    # Servers ----
    lapply(db_list_with_hash, function(x) {
      output[[x[["hash_id"]]]] <- x[["server"]]
    })
    ..__db_input_server(DEBUG$INPUT_LIST)

    # UI ----
    ui_tabs <- lapply(c(
      list(list( # Add Inputs output
        name = "Inputs",
        ui = ..__db_input_UI,
        hash_id = DEBUG$INPUT_LIST
      )),
      db_list_with_hash
    ), function(x) {
      shiny::tabPanel(
        x[["name"]],
        x[["ui"]](ns(x[["hash_id"]]))
      )
    })

    output[[DEBUG$DEBUG_UI]] <- shiny::renderUI({
      do.call(shiny::tabsetPanel, ui_tabs)
    })
  }
  shiny::moduleServer(
    id,
    module = module
  )
}

# nocov end
