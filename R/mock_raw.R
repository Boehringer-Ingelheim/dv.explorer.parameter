test_data <- function(random_bm_values = FALSE) {
  set.seed(1)

  n_participants <- 20
  n_categories <- 4
  n_param_per_cat <- 5

  bm <- expand.grid(
    SUBJID = 1:n_participants,
    VISITN = 1:3,
    PARCATN = 1:n_categories,
    PARAMN = 1:n_param_per_cat
  )

  bm[["VISIT"]] <- paste0("VISIT", bm[["VISITN"]])
  bm[["VISIT2"]] <- bm[["VISITN"]] * bm[["VISITN"]]
  bm[["PARCAT"]] <- paste0("PARCAT", bm[["PARCATN"]])
  bm[["PARAM"]] <- paste0("PARAM", bm[["PARCATN"]], bm[["PARAMN"]])
  if (random_bm_values) {
    bm[["VALUE1"]] <- stats::runif(n = nrow(bm), min = 0, max = 100)
    bm[["VALUE2"]] <- stats::runif(n = nrow(bm), min = 0, max = 100)
    bm[["VALUE3"]] <- stats::runif(n = nrow(bm), min = 0, max = 100)
  } else {
    bm[["VALUE1"]] <- seq_len(nrow(bm))
    bm[["VALUE2"]] <- 10 + seq_len(nrow(bm))
    bm[["VALUE3"]] <- 100 + seq_len(nrow(bm))
  }

  sl <- data.frame(
    SUBJID = 1:n_participants
  )
  sl[["CAT1"]] <- sample(c("Y", "N"), size = nrow(sl), replace = TRUE)
  sl[["CAT2"]] <- sample(c("A", "B", "C", "D"), size = nrow(sl), replace = TRUE)
  sl[["CAT3"]] <- sample(c("E", "F", "G", "H"), size = nrow(sl), replace = TRUE)
  sl[["CONT1"]] <- sample(1:100, size = nrow(sl), replace = TRUE)
  sl[["CONT2"]] <- sample(100:200, size = nrow(sl), replace = TRUE)
  sl[["CONT3"]] <- sample(200:300, size = nrow(sl), replace = TRUE)

  bm <- bm |>
    dplyr::mutate(
      SUBJID = factor(.data[["SUBJID"]]), # nolint
      PARCAT = factor(.data[["PARCAT"]]), # nolint
      PARAM = factor(.data[["PARAM"]]), # nolint
      VISIT = factor(.data[["VISIT"]]), # nolint
      VISIT2 = factor(.data[["VISIT2"]]) # nolint # TODO(miguel): Remove to make mock process numerical visits
    )

  # Duplicate for the rest of test cases, default with no default, default, bookmark, setup
  sl <- dplyr::mutate(
    sl,
    SUBJID = factor(.data[["SUBJID"]]) # nolint
  )

  for (col in names(bm)) {
    attr(bm[[col]], "label") <- paste("Label of", col)
  }

  for (col in names(sl)) {
    attr(sl[[col]], "label") <- paste("Label of", col)
  }

  list(bm = bm, sl = sl)
}

mock_app_wrap <- function(in_fluid = TRUE, update_query_string, ui, server) {
  container <- if (in_fluid) shiny::fluidPage else shiny::tagList

  shiny::shinyApp(
    ui = function(request) {
      container(
        shiny::verbatimTextOutput("returned"),
        ui(),
        shiny::bookmarkButton()
      )
    },
    server = function(input, output, session) {
      # TODO PACK THIS MAGIC

      if (update_query_string) {
        shiny::observe({
          shiny::reactiveValuesToList(input) # Trigger this observer every time an input changes
          session$doBookmark()
        })
        shiny::onBookmarked(shiny::updateQueryString)
      }

      returned <- server()

      output[["returned"]] <- shiny::renderPrint({
        if (shiny::is.reactive(returned)) returned() else returned
      })
    },
    enableBookmarking = "url"
  )
}
