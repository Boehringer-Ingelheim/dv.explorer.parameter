#' Selectors
#'
#' @param id Shiny ID `[character(1)]`
#'
#' @keywords internal

parameter_UI <- function(id) { # nolint
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::uiOutput(ns("cat_menu")),
    shiny::uiOutput(ns("par_menu"))
  )
}

# nolint start: cyclocomp_linter
parameter_server <- function(id, data,
                             cat_label = "Select a category", par_label = "Select a parameter",
                             cat_var, par_var,
                             default_cat = NULL, default_par = NULL,
                             multi_cat = TRUE, multi_par = TRUE, options_cat = NULL, options_par = NULL) {
  mod <- function(input, output, session) {
    shiny::onRestore(function(state) {
      default_cat <<- if ("cat_val" %in% names(state$input)) state$input$cat_val else default_cat
      default_par <<- if ("par_val" %in% names(state$input)) state$input$par_val else default_par
    })

    ns <- session[["ns"]]

    output[["cat_menu"]] <- shiny::renderUI({
      shiny::tagList(
        shiny::tags[["style"]](shiny::HTML(paste0(
          "#",
          ns("cat_val"),
          " + div.selectize-control div.selectize-input.items {max-height:200px; overflow-y:auto;}"
        ))),
        shiny::selectizeInput(
          inputId = ns("cat_val"),
          label = cat_label,
          choices = NULL,
          multiple = multi_cat,
          selected = NULL,
          options = options_cat
        )
      )
    })

    output[["par_menu"]] <- shiny::renderUI({
      shiny::tagList(
        shiny::tags[["style"]](shiny::HTML(paste0(
          "#",
          ns("par_val"),
          " + div.selectize-control div.selectize-input.items {max-height:200px; overflow-y:auto;}"
        ))),
        shiny::selectizeInput(
          inputId = ns("par_val"),
          label = par_label,
          choices = NULL,
          multiple = multi_par,
          selected = NULL,
          options = options_par
        )
      )
    })

    shiny::observeEvent(try(data()), {
      shiny::req(checkmate::test_data_frame(try(data()), min.rows = 1))
      choices <- levels(droplevels(data()[[cat_var]]))
      if (is_not_null(default_cat) && !checkmate::test_subset(default_cat, choices)) {
        log_warn(ssub("`DEFAULT` not found in `SET` for selector `ID`",
          DEFAULT = default_cat,
          SET = paste(choices,
            collapse = ",
"
          ),
          ID = ns("cat_val")
        ))
      }
      selected <- default_cat %||% shiny::isolate(input[["cat_val"]])
      default_cat <<- NULL
      shiny::updateSelectizeInput(inputId = "cat_val", choices = choices, selected = selected)
    })

    shiny::observeEvent(v_cat_val(), {
      shiny::req(checkmate::test_data_frame(try(data()), min.rows = 1))
      if (!test_empty(v_cat_val())) {
        f_data <- dplyr::filter(data(), .data[[cat_var]] %in% v_cat_val())
        choices <- levels(droplevels(f_data)[[par_var]])
        if (is_not_null(default_par) && !checkmate::test_subset(default_par, choices)) {
          log_warn(ssub("`DEFAULT` not found in `SET` for selector `ID`",
            DEFAULT = default_par,
            SET = paste(choices,
              collapse = ",
"
            ),
            ID = ns("par_val")
          ))
        }
        selected <- default_par %||% shiny::isolate(input[["par_val"]])
        selected <- if (!multi_par && !selected %in% choices) choices[1] else selected
        default_par <<- NULL
      } else {
        choices <- character(0)
        selected <- character(0)
      }
      shiny::updateSelectizeInput(inputId = "par_val", choices = choices, selected = selected)
    })

    v_cat_val <- shiny::reactive({
      if (checkmate::test_character(input[["cat_val"]],
        min.chars = 1,
        min.len = 1
      )) {
        input[["cat_val"]]
      } else {
        set_empty(
          character(0),
          TRUE
        )
      }
    })

    v_par_val <- shiny::reactive({
      if (checkmate::test_character(input[["par_val"]],
        min.chars = 1,
        min.len = 1
      ) && test_not_empty(v_cat_val())) {
        input[["par_val"]]
      } else {
        set_empty(
          character(0),
          TRUE
        )
      }
    })

    shiny::outputOptions(output, "cat_menu", suspendWhenHidden = FALSE)
    shiny::outputOptions(output, "par_menu", suspendWhenHidden = FALSE)

    update_function <- function(cat_selected = NULL, par_selected = NULL) {
      if (length(cat_selected) == 0) {
        # The cat is updated to empty but we do not leave anything in the default_par.
        # Otherwise the value is NOT deleted in the renderUI and it can be used in a later update
        shiny::updateSelectizeInput(inputId = "cat_val", selected = cat_selected)
        return() # NULL and character(0) cases
      }

      if (length(v_cat_val()) == 0 || cat_selected != v_cat_val()) {
        # cat and its choices WILL change therefore the renderUI WILL run because no reactive inside
        # is invalidated
        shiny::updateSelectizeInput(session = session, inputId = "cat_val", selected = cat_selected)
        default_par <<- par_selected
      } else {
        # cat and its choices WILL NOT change therefore the renderUI WILL NOT run because no reactive inside
        # is invalidated
        shiny::updateSelectizeInput(session = session, inputId = "par_val", selected = par_selected)
      }
    }

    res <- list()
    res[["cat"]] <- v_cat_val
    res[["par"]] <- v_par_val
    res <- res |>
      set_id(
        cat = paste0(id, "-", "cat_val"),
        par = paste0(id, "-", "par_val")
      ) |>
      set_update(val = update_function)
    return(res)
  }

  shiny::moduleServer(id, mod)
}

# nolint end

col_menu_UI <- function(id) { # nolint: object_name_linter
  ns <- shiny::NS(id)
  shiny::uiOutput(ns("menu_cont"))
}

col_menu_server <- function(id,
                            data,
                            include_func = function(x) {
                              TRUE
                            },
                            label = "Select a column",
                            default = NULL,
                            multiple = FALSE,
                            include_none = TRUE,
                            options = NULL) {
  nargs_include_func <- length(formals(args(include_func)))
  stopifnot(nargs_include_func <= 2)
  if (nargs_include_func == 1) {
    mapper <- purrr::map_lgl
  }
  if (nargs_include_func == 2) {
    mapper <- purrr::imap_lgl
  }

  mod <- function(input, output, session) {
    ns <- session[["ns"]]

    if (checkmate::test_string(include_none, min.chars = 1)) {
      none_choice <- include_none
      include_none <- TRUE
    } else {
      none_choice <- "None"
    }

    include_none <- isTRUE(include_none)

    output[["menu_cont"]] <- shiny::renderUI({
      shiny::req(data())
      include <- mapper(data(), include_func)
      choices <- get_labelled_names(data())[include]

      if (include_none) {
        shiny::validate(
          shiny::need(
            checkmate::test_disjunct(none_choice, choices),
            paste("'", none_choice, "' cannot be a column name. Please contact the app creator")
          )
        )
        choices <- c(none_choice, choices)
      }

      if (is_not_null(default) && !checkmate::test_subset(default, choices)) {
        log_warn(ssub("`DEFAULT` not found in `SET` for selector `ID`",
          DEFAULT = default,
          SET = paste(choices,
            collapse = ",
"
          ),
          ID = ns("val")
        ))
      }

      selected <- default %||% shiny::isolate(input[["val"]])
      default <<- NULL

      shiny::selectizeInput(
        ns("val"),
        label = label, multiple = multiple, choices = choices, selected = selected, options = options
      )
    })

    v_val <- shiny::reactive({
      if (checkmate::test_character(input[["val"]], min.chars = 1, min.len = 1)) {
        input[["val"]]
      } else {
        set_empty(character(0), TRUE)
      }
    })

    shiny::outputOptions(output, "menu_cont", suspendWhenHidden = FALSE)

    v_val <- v_val |>
      set_id(val = paste0(id, "-", "val")) |>
      set_update(
        val = function(selected = NULL) {
          shiny::updateSelectizeInput(session = session, inputId = "val", selected = selected)
        }
      )
    return(v_val)
  }
  shiny::moduleServer(id, mod)
}

val_menu_UI <- function(id) { # nolint: object_name_linter
  ns <- shiny::NS(id)
  shiny::uiOutput(ns("menu_cont"))
}

# var can be reactive
val_menu_server <- function(id,
                            data,
                            label = "Select a value",
                            var,
                            default = NULL,
                            defaults_per_var = NULL,
                            multiple = FALSE,
                            all_on_change = FALSE) {
  mod <- function(input, output, session) {
    ns <- session[["ns"]]

    r_var <- if (!shiny::is.reactive(var)) {
      shiny::reactive(var)
    } else {
      shiny::reactive({
        shiny::req(checkmate::test_string(var(), min.chars = 1))
        var()
      })
    }

    output[["menu_cont"]] <- shiny::renderUI({
      shiny::req(data())
      choices <- data()[[r_var()]]
      if (is.factor(choices)) {
        choices <- levels(droplevels(data()[[r_var()]]))
      } else if (is.numeric(choices)) {
        choices <- sort(unique(choices))
      }
     
      # explicitly defined defaults for this variable take precedence
      default <- defaults_per_var[[r_var()]] %||% default

      if (is_not_null(default) && !checkmate::test_subset(default, choices)) {
        log_warn(ssub("`DEFAULT` not found in `SET` for selector `ID`",
          DEFAULT = paste(default,
            collapse = ",
"
          ),
          SET = paste(choices,
            collapse = ",
"
          ),
          ID = ns("cat_val")
        ))
      }
      selected <- default %||% if (!all_on_change || !multiple) shiny::isolate(input[["val"]]) else choices
      default <<- NULL
      shiny::selectizeInput(
        inputId = ns("val"),
        label = label,
        choices = choices,
        multiple = multiple,
        selected = selected
      )
    })

    v_val <- shiny::reactive({
      if (checkmate::test_character(input[["val"]],
        min.chars = 1,
        min.len = 1
      )) {
        input[["val"]]
      } else {
        set_empty(
          character(0),
          TRUE
        )
      }
    })

    shiny::outputOptions(output, "menu_cont", suspendWhenHidden = FALSE)

    v_val <- v_val |>
      set_id(val = paste0(id, "-", "val")) |>
      set_update(val = function(selected = NULL) {
        shiny::updateSelectizeInput(
          session = session,
          inputId = "val",
          selected = selected
        )
      })
    return(v_val)
  }

  shiny::moduleServer(id, mod)
}



# Helpers ----

set_factory <- function(n) {
  function(x, ...) {
    attr(x, n) <- list(...)
    x
  }
}

get_factory <- function(n) {
  function(x) {
    attr(x, n, exact = TRUE)
  }
}

set_empty <- function(x, v) {
  attr(x, "empty") <- v
  x
}
set_id <- set_factory("id")
set_update <- set_factory("update")

get_empty <- get_factory("empty")
get_id <- get_factory("id")
get_update <- get_factory("update")

test_empty <- function(x) get_empty(x) %||% FALSE
test_not_empty <- Negate(test_empty)


drop_menu_helper <- function(id, label, ...) {
  shiny::tagList(
    shiny::tagAppendAttributes(
      shinyWidgets::dropMenu(
        shiny::tags[["button"]](id = id, label, class = "btn btn-default"),
        ...,
        arrow = TRUE
      ),
      style = "display:inline"
    )
  )
}

add_warning_mark_dependency <- function() {
  htmltools::htmlDependency(
    "warning_mark_lib",
    "0.1",
    src = system.file("warning_mark_lib", package = "dv.explorer.parameter", mustWork = TRUE),
    script = "warning_mark.js",
    stylesheet = "warning_mark.css"
  )
}

add_top_menu_dependency <- function() {
  htmltools::htmlDependency(
    "top_menu",
    "0.1",
    src = system.file("assets/css", package = "dv.explorer.parameter", mustWork = TRUE),
    stylesheet = "top_menu.css"
  )
}
