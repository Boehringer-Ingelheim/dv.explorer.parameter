#' Mock forestplot app
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @export
mock_app_forest <- function(dry_run = FALSE, update_query_string = TRUE, srv_defaults = list(), ui_defaults = list()) {
  data <- test_data()
  
  # Patch data to conform with module expectations # TODO: Fix `test_data` instead
  for(col in c("CAT1", "CAT2", "CAT3")) data[["sl"]][[col]] <- as.factor(data[["sl"]][[col]])
  
  bm_dataset <- data[["bm"]]
  group_dataset <- data[["sl"]]

  numeric_numeric_functions <- list(
    "Pearson Correlation" = pearson_correlation,
    "Spearman Correlation" = spearman_correlation
  )
  numeric_factor_functions <- list("Odds Ratio" = odds_ratio)

  ui_params <- c(
    list(
      id = "not_ebas",
      numeric_numeric_function_names = names(numeric_numeric_functions),
      numeric_factor_function_names = names(numeric_factor_functions)
    ),
    ui_defaults
  )
  
  masks <- shiny::reactive({
    list(
      bm = rep(TRUE, nrow(bm_dataset)), 
      group = rep(TRUE, nrow(group_dataset))
    )
  })

  srv_params <- c(
    list(
      id = "not_ebas",
      bm_dataset = bm_dataset,
      group_dataset = group_dataset,
      masks = masks,
      numeric_numeric_functions = numeric_numeric_functions,
      numeric_factor_functions = numeric_factor_functions,
      subjid_var = "SUBJID",
      cat_var = "PARCAT",
      par_var = "PARAM",
      visit_var = "VISIT",
      value_vars = c("VALUE1", "VALUE2", "VALUE3")
    ),
    srv_defaults
  )

  if (dry_run) {
    return(list(srv = srv_params, ui = ui_params))
  }

  mock_app_wrap(
    update_query_string = update_query_string,
    ui = function() do.call(forest_UI, ui_params),
    server = function() {
      do.call(forest_server, srv_params)
    }
  )
}

mock_app_forest_mm <- function() {
  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }
  numeric_numeric_functions <- list(
    "Pearson Correlation" = pearson_correlation,
    "Spearman Correlation" = spearman_correlation
  )
  numeric_factor_functions <- list("Odds Ratio" = odds_ratio)

  module_list <- list(
    "forest" = dv.explorer.parameter::mod_forest(
      module_id = "forest",
      bm_dataset_name = "bm",
      group_dataset_name = "sl",
      numeric_numeric_functions = numeric_numeric_functions,
      numeric_factor_functions = numeric_factor_functions,
      visit_var = "VISIT",
      value_vars = c("VALUE1", "VALUE2"),
      subjid_var = "SUBJID",
      cat_var = "PARCAT"
    )
  )

  bm_dataset <- test_data()[["bm"]]
  group_dataset <- test_data()[["sl"]]

  dv.manager::run_app(
    data = list("DS" = list(bm = bm_dataset, sl = group_dataset)),
    module_list = module_list,
    filter_data = "sl",
    filter_key = "SUBJID"
  )
}
