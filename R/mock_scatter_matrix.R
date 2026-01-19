#' Mock matrix of scatterplots app
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @export

mock_app_scatterplotmatrix <- function(dry_run = FALSE,
                                       update_query_string = TRUE,
                                       srv_defaults = list(),
                                       ui_defaults = list(),
                                       anlfl_flags = FALSE) {
  data <- test_data(anlfl_flags = anlfl_flags)
  bm_dataset <- shiny::reactive({
    data[["bm"]]
  })

  group_dataset <- shiny::reactive({
    data[["sl"]]
  })

  ui_params <- c(
    list(
      id = "not_ebas"
    ),
    ui_defaults
  )

  if (anlfl_flags) {
    anlfl_vars <- c("ANLFL1", "ANLFL2")
  } else {
    anlfl_vars <- NULL
  }

  srv_params <- c(
    list(
      id = "not_ebas",
      bm_dataset = bm_dataset,
      group_dataset = group_dataset,
      subjid_var = "SUBJID",
      cat_var = "PARCAT",
      par_var = "PARAM",
      visit_var = "VISIT",
      value_vars = c("VALUE1", "VALUE2", "VALUE3"),
      anlfl_vars = anlfl_vars
    ),
    srv_defaults
  )

  if (dry_run) {
    return(list(ui = ui_params, srv = srv_params))
  }

  mock_app_wrap(
    update_query_string = update_query_string,
    ui = function() do.call(scatterplotmatrix_UI, ui_params),
    server = function() {
      do.call(scatterplotmatrix_server, srv_params)
    }
  )
}

mock_app_scatterplotmatrix_mm <- function(in_fluid = TRUE, defaults = list(), update_query_string = TRUE,  anlfl_flags = FALSE) {
  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }

  data <- test_data(anlfl_flags = anlfl_flags)

  if (anlfl_flags) {
    anlfl_vars <- c("ANLFL1", "ANLFL2")
  } else {
    anlfl_vars <- NULL
  }

  dv.manager::run_app(
    data = list(dummy = list(bm = data[["bm"]], adsl = data[["sl"]])),
    module_list = list(
      Scatter = mod_scatterplotmatrix(
        "scatter_plotmatrix",
        bm_dataset_name = "bm",
        group_dataset_name = "adsl",
        visit_var = "VISIT",
        value_vars = c("VALUE1", "VALUE2"),
        subjid_var = "SUBJID",
        cat_var = "PARCAT",
        anlfl_vars = anlfl_vars
      )
    ),
    filter_data = "adsl",
    filter_key = "SUBJID",
    enableBookmarking = "url"
  )
}
