# Simple outlier
OUT_ID <- pack_of_constants( # nolint
  LL = "ll",
  UL = "ul",
  SEL = "sel",
  CONT = "cont"
)

#' Single outlier selector
#'
#' A selector composed by two rows containing:
#'  - a `label`
#'  - two inline [shiny::textInput] boxes for the upper and lower limit of the outliers
#'
#' @param id Shiny ID `[character(1)]`
#' @param label label for the selectors
#' @param value_ll an initial value for the lower limit
#' @param value_ul an initial value for the upper limit
#'
#' @details The UI root element is a divisor which id attribute is equal to the `id` parameter. So it can be used
#' with [shiny::insertUI] and [shiny::removeUI] functions.
#'
#' @return A reactive containing a list with two entries`ll` and `ul`. It returns either NA if the box is empty or the
#' result of applying as.numeric to the contents of the input box. It does not return NULL values.
#'
#' @seealso outlier_container
#' @name outlier_selector
#' @keywords internal
NULL

#' @describeIn outlier_selector UI
#'
outlier_ui <- function(id, label, value_ll = "", value_ul = "") {
  ns <- shiny::NS(id)
  shiny::div(
    label,
    shiny::div(
      shiny::textInput(ns(OUT_ID$LL), NULL, placeholder = "Min", value = value_ll, width = "5em"),
      ",",
      shiny::textInput(ns(OUT_ID$UL), NULL, placeholder = "Max", value = value_ul, width = "5em"),
      style = "display: flex; align-items: baseline;"
    ),
    id = id
  )
}

#' @describeIn outlier_selector server
#'
outlier_server <- function(id) {
  mod <- function(input, output, session) {
    ns <- session[["ns"]]
    shiny::reactive(
      {
        shiny::req(!is.null(input[[OUT_ID$LL]]), !is.null(input[[OUT_ID$LL]]))
        list(
          ll = as.numeric(input[[OUT_ID$LL]]),
          ul = as.numeric(input[[OUT_ID$UL]])
        )
      },
      label = ns("")
    )
  }
  shiny::moduleServer(id, mod)
}

#' A container for outlier selectors
#'
#'
#' @param id Shiny ID `[character(1)]`
#' @param choices a list with the parameters for which we want to select outliers
#'
#' @details When a choice is deselected and selected again, it will retain its previous state.
#'
#' @return A reactive containing a list with as many entries as choices are selected in the selector. Each of the
#' entries contain a list with two entries`ll` and `ul` as described in [outlier_selector].
#'
#' @seealso outlier_selector
#' @name outlier_container
#' @keywords internal
NULL

#' @describeIn outlier_container UI
#'
outlier_container_UI <- function(id) { # nolint
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::selectizeInput(inputId = ns(OUT_ID$SEL), label = NULL, multiple = TRUE, choices = character(0)),
    shiny::div(id = ns(OUT_ID$CONT))
  )
}

#' @describeIn outlier_container server
#'
outlier_container_server <- function(id, choices) {
  mod <- function(input, output, session) {
    ns <- session[["ns"]]

    # Storage for the server functions of the outliers
    # Starts empty and is filled on request
    server_returns <- shiny::reactiveVal(list(), label = ns("server_returns"))

    # Reactive that contains a list of reactives values from the different outliers
    returned <- shiny::reactiveVal(list(), label = ns("returned"))

    bmk_par <- NULL
    shiny::onRestore(function(state) {
      if (OUT_ID$SEL %in% names(state$input)) {
        bmk_par <<- state[["input"]][[OUT_ID$SEL]]
      }
    })

    shiny::observeEvent(choices(), {
      shiny::req(
        checkmate::test_character(choices(), min.chars = 1, min.len = 1)
      )
      shiny::updateSelectizeInput(
        inputId = OUT_ID$SEL,
        selected = bmk_par %||% input[[OUT_ID$SEL]],
        choices = choices()
      )
      bmk_par <<- NULL
    })

    sel <- shiny::reactive({
      input[[OUT_ID$SEL]]
    })

    shiny::observeEvent(sel(),
      {
        remove <- setdiff(names(returned()), sel())
        insert <- setdiff(sel(), names(returned()))
        l <- server_returns()

        purrr::walk(insert, ~ {
          id <- ns(str_to_hash(.x))
          entry <- l[[.x]]
          possibly_get <- purrr::possibly(~ entry()[[.x]], "")
          selector <- paste0("#", ns(OUT_ID$CONT))
          shiny::insertUI(
            selector = selector,
            where = "beforeEnd",
            outlier_ui(id, .x, possibly_get("ll"), possibly_get("ul"))
          )
        })

        purrr::walk(remove, ~ {
          id <- ns(str_to_hash(.x))
          selector <- paste0("#", id)
          shiny::removeUI(
            selector
          )
        })

        insert_server <- setdiff(sel(), names(l))

        # outlier servers are created and appended on request

        new_servers <- purrr::map(
          insert_server,
          ~ {
            id <- str_to_hash(.x)
            outlier_server(id)
          }
        )

        new_servers <- stats::setNames(new_servers, insert_server)

        server_returns(c(l, new_servers))
        returned(c(l, new_servers)[sel()])
      },
      label = ns("outlier_server"),
      # sel() is NULL for an empty selector
      # If not covered last element remains in the screen
      ignoreNULL = FALSE
    )

    # Maybe we can remove this reactive and move it inside the observe, but we should control
    # the errors in each of the reactives.
    shiny::reactive({
      purrr::map(returned(), ~ {
        .x()
      })
    })
  }
  shiny::moduleServer(id, mod)
}

#' @describeIn outlier_container mock
#'
mock_outlier <- function() {
  ui <- shiny::fluidPage(outlier_container_UI("out"), shiny::verbatimTextOutput("txt"))
  server <- function(input, output, session) {
    x <- outlier_container_server("out", shiny::reactive(letters[1:3]))
    output[["txt"]] <- shiny::renderPrint(x())
  }
  shiny::shinyApp(
    ui = ui,
    server = server
  )
}

outlier_container_single_UI <- function(id) { # nolint
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::div(id = ns(OUT_ID$CONT))
  )
}

outlier_con_single_server <- function(id, selection) {
  mod <- function(input, output, session) {
    ns <- session[["ns"]]

    current_ui_sel <- NULL
    returned <- shiny::reactiveVal(shiny::reactive(NULL), label = ns(" return"))
    selector <- paste0("#", ns(OUT_ID$CONT))
    possibly_get <- purrr::possibly(function(l, x) l[[x]], "")

    shiny::observeEvent(selection(),
      {
        # Remove previous selection
        if (!is.null(current_ui_sel)) {
          shiny::removeUI(
            selector = current_ui_sel
          )
        }

        new_id <- paste0(str_to_hash(selection()), "_", gsub("[^a-zA-Z0-9_]", "", selection()))

        x <- outlier_server(new_id)

        shiny::insertUI(
          selector = selector,
          where = "beforeEnd",
          outlier_ui(ns(new_id), selection(), possibly_get(x(), "ll"), possibly_get(x(), "ul"))
        )

        current_ui_sel <<- paste0("#", ns(new_id))
        returned(x)
      },
      label = ns("outlier_single_server"),
      # sel() is NULL for an empty selector
      # If not covered last element remains in the screen
      ignoreNULL = FALSE
    )

    shiny::reactive({
      returned()()
    })
  }
  shiny::moduleServer(id, mod)
}
