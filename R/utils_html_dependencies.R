#' @keywords internal
event_count_dep <- function() {
  htmltools::htmlDependency(
    name = "event_count",
    version = "1.0",
    src = system.file("assets", package = "dv.explorer.parameter", mustWork = TRUE),
    stylesheet = "css/event_count.css",
    script = "js/event_count.js"
  )
}

#' @keywords internal
dvd3h_dep <- function() {
  htmltools::htmlDependency(
    name = "dvd3h",
    version = "1.0",
    src = system.file("www/dist", package = "dv.explorer.parameter", mustWork = TRUE),
    script = "dv_d3_helpers.js"
  )
}

#' @keywords internal
screenshot_deps <- function() {
  list(
    htmltools::htmlDependency(
      name = "wfphm-msg-handlers",
      version = "1.0",
      src = system.file("www/msg-handlers", package = "dv.explorer.parameter", mustWork = TRUE),
      script = "msg-handlers.js"
    )
  )
}

#' @keywords intermal
roc_dependencies <- function() {
  htmltools::htmlDependency(
    name = "dv.explorer.parameter",
    version = "1.0",
    package = "dv.explorer.parameter",
    src = system.file("assets", package = "dv.explorer.parameter", mustWork = TRUE),
    stylesheet = "css/roc.css",
    all_files = FALSE
  )
}
