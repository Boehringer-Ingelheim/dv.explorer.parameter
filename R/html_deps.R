roc_dependencies <- function() {
  htmltools::htmlDependency(
    name = "dv.biomarker.general",
    version = "1.0",
    package = "dv.biomarker.general",
    src = "assets",
    stylesheet = "css/bp.css",
    all_files = FALSE
  )
}
