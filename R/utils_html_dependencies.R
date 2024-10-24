#' @keywords internal
ebas_sel_css_dep <- function() {
  htmltools::htmlDependency(
    name = "ebas_sel",
    version = "1.0",
    src = system.file("www/css", package = "dv.explorer.parameter", mustWork = TRUE),
    stylesheet = "ebas_sel.css"
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
