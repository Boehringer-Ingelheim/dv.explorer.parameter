# nolint start
# validation (S)
vdoc <- local({
  #                      ##########
  # package_name is used # INSIDE # the sourced file below
  #                      ##########
  package_name <- read.dcf("../../DESCRIPTION")[, "Package"]
  utils_file_path <- system.file("validation", "utils-validation.R", package = package_name, mustWork = TRUE)
  source(utils_file_path, local = TRUE)[["value"]]
})
specs <- vdoc[["specs"]]
#  validation (F)

run_shiny_tests <- !isFALSE(as.logical(Sys.getenv("SKIP_SHINY_TESTS")))
suspect_check <- any(names(Sys.getenv()) == "_R_CHECK_CRAN_INCOMING_")

skip_if_not_running_shiny_tests <- function() testthat::skip_if_not(run_shiny_tests, message = "Skip tests") # nolint
skip_if_suspect_check <- function() testthat::skip_if(suspect_check, message = "Suspected check")

tns_factory <- function(id) function(...) paste0(c(id, as.character(list(...))), collapse = "-")

# `expr` must be a quosure or a regular call, in both cases they must be self-contained as they will be deparsed
# and run in another process
start_app_driver <- function(expr) {
  root_app <- if (run_shiny_tests && !suspect_check) {
    app_dir <- if (testthat::is_testing()) {
      "app/app.R"
    } else {
      "tests/testthat/app/app.R"
    }

    call <- if (rlang::is_quosure(expr) || rlang::is_expression(expr)) expr else substitute(expr)

    # tryCatch to avoid snapshots being deleted when the app cannot be started
    tryCatch(
      {
        temp <- tempfile()
        saveRDS(expr, temp)

        app <- shinytest2::AppDriver$new(
          app_dir = app_dir,
          seed = 1,
          options = list(
            "__quo_file" = temp,
            "__use_load_all" = isTRUE(as.logical(Sys.getenv("LOCAL_SHINY_TESTS")))
          )
        )
        app$wait_for_idle()
        app
      },
      condition = function(e) {
        if (exists("app") && "stop" %in% names(app)) app$stop()
        print(e)
        NULL
      }
    )
  } else {
    NULL
  }
  root_app
}

# SVG EXPECTATION
# When an error occurs over an r2d3 svg it is not neccesarily removed from the DOM but its visibility is hidden, therefore if we expect the graph
# we expect that it is there, that it is visible and that there are no errors inside the container.
expect_r2d3_svg <- function(app, query_list) {
  purrr::walk(query_list, function(query) {
    # Check there is an SVG
    svg_vec <- rvest::read_html(app$get_js(query[["svg"]])) %>%
      rvest::html_elements("svg")
    expect_length(svg_vec, query[["n"]])

    # Check that is visible
    is_hidden <- rvest::read_html(app$get_html(query[["container"]])) %>%
      rvest::html_element("div .r2d3") %>%
      rvest::html_attr("style") %>%
      stringr::str_detect("visibility: hidden;")
    expect_false(is_hidden)

    # Check that there is no error inside the div
    error_vec <- rvest::read_html(app$get_html(query[["container"]])) %>%
      rvest::html_element("div .shiny-output-error")
    expect_length(error_vec, 0)
  })
}
# nolint end
