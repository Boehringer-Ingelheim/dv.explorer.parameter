#' Mock boxplot app
#' @keywords mock
#' @param dry_run Return parameters used in the call
#' @param update_query_string automatically update query string with app state
#' @param ui_defaults,srv_defaults a list of values passed to the ui/server function
#' @export

mock_app_boxplot <- function(dry_run = FALSE, update_query_string = TRUE, srv_defaults = list(), ui_defaults = list()) {
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
    ui = function() do.call(boxplot_UI, ui_params),
    server = function() {
      do.call(boxplot_server, srv_params)
    }
  )
}

#' Mock mm boxplot app
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @export

mock_app_boxplot_mm <- function(update_query_string = TRUE) {
  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }

  dv.manager::run_app(
    data = list(dummy = list(bm = test_data()[["bm"]], adsl = test_data()[["sl"]])),
    module_list = list(
      Boxplot = mod_boxplot(
        "boxplot",
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
