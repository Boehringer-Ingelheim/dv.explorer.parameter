#' Mock corr hm app
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @export

mock_app_corr_hm <- function(dry_run = FALSE, update_query_string = TRUE, srv_defaults = list(), ui_defaults = list()) {
  data <- test_data(random_bm_values = TRUE)
  bm_dataset <- shiny::reactive({
    data[["bm"]]
  })

  ui_params <- c(
    list(
      id = "not_ebas"
    ),
    ui_defaults
  )

  srv_params <- c(
    list(
      id = "not_ebas",
      bm_dataset = bm_dataset,
      subjid_var = "SUBJID",
      cat_var = "PARCAT",
      par_var = "PARAM",
      visit_var = "VISIT",
      value_vars = c("VALUE1", "VALUE2", "VALUE3")
    ),
    srv_defaults
  )

  if (dry_run) {
    return(list(ui = ui_params, srv = srv_params))
  }

  mock_app_wrap(
    update_query_string = update_query_string,
    ui = function() do.call(corr_hm_UI, ui_params),
    server = function() {
      do.call(corr_hm_server, srv_params)
    }
  )
}

#' Mock corr hm app
#' @keywords mock
#' @export

mock_app_correlation_hm_mm <- function() {
  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }

  module_list <- list(
    "correlation heatmap" = dv.biomarker.general::mod_corr_hm(
      module_id = "corr_hm",
      bm_dataset_disp = dv.manager::mm_dispatch("filtered_dataset", "bm"),
      visit_var = "VISIT",
      value_var = c("VALUE1", "VALUE2"),
      subjid_var = "SUBJID",
      cat_var = "PARCAT"
    )
  )

  bm_dataset <- test_data(random_bm_values = TRUE)[["bm"]]

  dv.manager::run_app(
    data = list("DS" = list(bm = bm_dataset, sl = bm_dataset)),
    module_list = module_list,
    filter_data = "sl",
    filter_key = "SUBJID"
  )
}

mock_app_correlation_hm_mm_safetyData <- function() { # nolint
  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }

  module_list <- list(
    "correlation heatmap" = dv.biomarker.general::mod_corr_hm(
      module_id = "corr_hm",
      bm_dataset_disp = dv.manager::mm_dispatch("filtered_dataset", "bm"),
      visit_var = "VISIT",
      value_var = c("AVAL", "CHG"),
      subjid_var = "SUBJID",
      cat_var = "PARCAT1"
    )
  )

  data <- safety_data()

  dv.manager::run_app(
    data = list("DS" = list(bm = data[["bm"]], sl = data[["sl"]])),
    module_list = module_list,
    filter_data = "sl",
    filter_key = "SUBJID"
  )
}
