#' Mock scatterplot app
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @export
mock_app_scatterplot <- function(dry_run = FALSE,
                                 update_query_string = TRUE,
                                 srv_defaults = list(),
                                 ui_defaults = list()) {
  data <- test_data()
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

  srv_params <- c(
    list(
      id = "not_ebas",
      bm_dataset = bm_dataset,
      group_dataset = group_dataset,
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
    ui = function() do.call(scatterplot_UI, ui_params),
    server = function() {
      do.call(scatterplot_server, srv_params)
    }
  )
}

mock_app_scatterplot_mm <- function(in_fluid = TRUE, defaults = list(), update_query_string = TRUE) {
  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }

  data <- test_data()
  dv.manager::run_app(
    data = list(dummy = list(bm = data[["bm"]], adsl = data[["sl"]])),
    module_list = list(
      Scatter = mod_scatterplot(
        "scatter_plot",
        bm_dataset_disp = dv.manager::mm_dispatch("filtered_dataset", "bm"),
        group_dataset_disp = dv.manager::mm_dispatch("filtered_dataset", "adsl"),
        visit_var = "VISIT",
        value_var = c("VALUE1", "VALUE2"),
        subjid_var = "SUBJID",
        cat_var = "PARCAT"
      )
    ),
    filter_data = "adsl",
    filter_key = "SUBJID",
    enableBookmarking = "url"
  )
}
