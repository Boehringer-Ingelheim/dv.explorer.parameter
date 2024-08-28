use_load_all <- TRUE # (isTRUE(as.logical(Sys.getenv("LOCAL_SHINY_TESTS"))) || isTRUE(as.logical(Sys.getenv("CI")))) #nolint
if (use_load_all) {
  pkg_path <- "."
  prev_path <- ""
  while (!length(list.files(pkg_path, pattern = "^DESCRIPTION$")) == 1) {
    if (normalizePath(pkg_path) == prev_path) rlang::abort("root folder reached and no DESCRIPTION file found")
    prev_path <- normalizePath(pkg_path)
    pkg_path <- file.path("..", pkg_path)
  }
  devtools::load_all(pkg_path, quiet = TRUE)
}

# MODIFY BELOW

non_reactive_args <- c()
both_args <- c()
reactive_args <- c("data", "x_axis", "y_axis", "z_axis", "margin", "palette", "msg_func", "quiet")

# STOP MODIFYING

non_reactive_id <- stats::setNames(non_reactive_args, non_reactive_args)
both_id <- stats::setNames(both_args, both_args)
reactive_id <- stats::setNames(reactive_args, reactive_args)

# HELPERS

eval_inpt <- function(x, input) {
  val <- shiny::reactive({
    v <- tryCatch(
      {
        eval(parse(text = input[[x]]))
      },
      error = function(e) {
        NULL
      }
    )
  })

  list(
    val = val,
    as_reactive = shiny::reactive(input[[paste0(x, "_as_reactive")]])
  )
}

solver <- function(x, as_reactive) {
  if (is.null(as_reactive)) {
    as_reactive <- x[["as_reactive"]]()
  }

  if (isTRUE(as_reactive)) {
    x[["val"]]
  } else {
    x[["val"]]()
  }
}

create_inpt_tb <- function(x, include_check) {
  shiny::tags[["table"]](
    purrr::map(
      x,
      ~ {
        shiny::tags[["tr"]](
          shiny::tags[["td"]](.x),
          shiny::tags[["td"]](shiny::textAreaInput(.x, NULL)),
          shiny::tags[["td"]](if (include_check) shiny::checkboxInput(paste0(.x, "_as_reactive"), "As reactive?")),
        )
      }
    )
  )
}

ui <- function(request) {
  non_reactive_tb <- create_inpt_tb(non_reactive_id, FALSE)
  reactive_tb <- create_inpt_tb(reactive_id, FALSE)
  both_tb <- create_inpt_tb(both_id, TRUE)

  shiny::fluidPage(
    shiny::tagList(
      shiny::div(
        shiny::tags[["h3"]]("Bookmark"),
        shiny::bookmarkButton()
      ),
      shiny::div(
        shiny::tags[["h3"]]("Static"),
        non_reactive_tb,
        shiny::tags[["hr"]]()
      ),
      shiny::div(
        shiny::tags[["h3"]]("Reactive"),
        reactive_tb,
        shiny::tags[["hr"]]()
      ),
      shiny::div(
        shiny::tags[["h3"]]("Both"),
        both_tb,
        shiny::tags[["hr"]]()
      ),
      shiny::div(
        shiny::tags[["h3"]]("Module"),
        shiny::uiOutput("cont")
      )
    )
  )
}

server <- function(input, output, session) {
  n_ipt <- purrr::map(non_reactive_id, ~ eval_inpt(.x, input))
  r_ipt <- purrr::map(reactive_id, ~ eval_inpt(.x, input))
  b_ipt <- purrr::map(both_id, ~ eval_inpt(.x, input))

  returned_values <- NULL

  output[["cont"]] <- shiny::renderUI({
    message("Rendering")
    # MODIFY THIS BODY

    # Non reactive input should usually be first checked with shiny::req as there are no internal controls in the
    # module for "strange" values in them

    returned_values <<- dv.explorer.parameter:::heatmap_d3_server(
      "mod",
      data = solver(r_ipt[["data"]], as_reactive = TRUE),
      x_axis = solver(r_ipt[["x_axis"]], as_reactive = TRUE),
      y_axis = solver(r_ipt[["y_axis"]], as_reactive = TRUE),
      z_axis = solver(r_ipt[["z_axis"]], as_reactive = TRUE),
      margin = solver(r_ipt[["margin"]], as_reactive = TRUE),
      palette = solver(r_ipt[["palette"]], as_reactive = TRUE),
      msg_func = solver(r_ipt[["msg_func"]], as_reactive = TRUE)
    )


    output[["out"]] <- shiny::renderPrint({
      returned_values[["margin"]]()
    })

    # UIs must be static

    shiny::tagList(
      dv.explorer.parameter:::heatmap_d3_UI("mod"),
      shiny::verbatimTextOutput("out")
    )
  })

  shiny::exportTestValues(
    # MODIFY PARAMETERS AS NEEDED
    returned = returned_values
  )
}

shiny::shinyApp(
  ui = ui,
  server = server,
  enableBookmarking = "url"
)
