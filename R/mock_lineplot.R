#' Mock lineplot app
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @param data data for the mock application
#' @export

mock_app_lineplot <- function(dry_run = FALSE,
                              update_query_string = TRUE,
                              srv_defaults = list(),
                              ui_defaults = list(),
                              data = test_data()) {
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
      visit_vars = c("VISIT", "VISIT2", "VISITN"),
      value_vars = c("VALUE1", "VALUE2", "VALUE3")
    ),
    srv_defaults
  )

  if (dry_run) {
    return(list(ui = ui_params, srv = srv_params))
  }

  mock_app_wrap(
    update_query_string = update_query_string,
    ui = function() do.call(lineplot_UI, ui_params),
    server = function() {
      do.call(lineplot_server, srv_params)
    }
  )
}

mock_app_lineplot_user_fn <- function(in_fluid = TRUE, defaults = list()) {
  container <- if (in_fluid) shiny::fluidPage else shiny::tagList

  bm_dataset <- test_data()[["bm"]]
  group_dataset <- test_data()[["sl"]]


  geometric_mean <- function(x) {
    x <- x[!is.na(x)]
    if (length(x) == 0 || any(x < 0)) {
      NA
      # numerically it makes sense, but is that what the user wants
    } else if (any(x == 0)) {
      0
    } else {
      base::exp(base::mean(base::log(x)))
    }
  }

  gmean_function <- list(
    fn = geometric_mean,
    dispersion = list(), # `No error bar` implicit
    y_prefix = "gMean "
  )

  gmean_fold_change_fn <- list(
    fn = function(x) geometric_mean(x / 100 + 1),
    dispersion = list(), # `No error bar` implicit
    y_prefix = "gMean fold change"
  )

  gmean_fold_change_percent_fn <- list(
    fn = function(x) {
      gm <- geometric_mean(x / 100 + 1)
      (gm - 1) * 100
    },
    dispersion = list(), # `No error bar` implicit
    y_prefix = "(gMean fold change - 1)*100%"
  )

  shiny::shinyApp(
    ui = function() {
      container(
        lineplot_UI("not_ebas"),
        shiny::bookmarkButton()
      )
    },
    server = function(input, output, session) {
      # TODO PACK THIS MAGIC
      shiny::observe({
        shiny::reactiveValuesToList(input) # Trigger this observer every time an input changes
        session$doBookmark()
      })
      shiny::onBookmarked(shiny::updateQueryString)

      lineplot_server(
        id = "not_ebas",
        bm_dataset = shiny::reactive(bm_dataset),
        group_dataset = shiny::reactive(group_dataset),
        summary_fns = list(
          `Mean` = lp_mean_summary_fns,
          `Median` = lp_median_summary_fns,
          `gMean` = gmean_function,
          `gMean fold change` = gmean_fold_change_fn,
          `(gMean fold change - 1)*100%` = gmean_fold_change_percent_fn
        ),
        value_vars = c("VALUE1", "VALUE2"),
        subjid_var = "SUBJID",
        cat_var = "PARCAT",
        visit_vars = c("VISIT", "VISIT2"),
        additional_listing_vars = c("CONT1", "CAT2")
      )
    },
    enableBookmarking = "url"
  )
}

mock_app_lineplot_mm <- function() {
  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }
  module_list <- list(
    "lineplot" = dv.explorer.parameter::mod_lineplot(
      module_id = "lineplot",
      bm_dataset_name = "bm",
      group_dataset_name = "sl",
      visit_vars = "VISIT",
      value_vars = c("VALUE1", "VALUE2"),
      subjid_var = "SUBJID",
      cat_var = "PARCAT"
    )
  )

  bm_dataset <- test_data()[["bm"]]
  group_dataset <- test_data()[["sl"]]

  dv.manager::run_app(
    data = list("DS" = list(bm = bm_dataset, sl = group_dataset), "DS2" = list(bm = bm_dataset, sl = group_dataset)),
    module_list = module_list,
    filter_data = "sl",
    filter_key = "SUBJID"
  )
}

mock_app_lineplot_mm_safetyData <- function() {
  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }

  module_list <- list(
    "lineplot" = dv.explorer.parameter::mod_lineplot(
      module_id = "lineplot",
      bm_dataset_name = "bm",
      group_dataset_name = "sl",
      visit_vars = c("VISIT", "AVISITN"),
      value_vars = c("AVAL", "CHG"),
      subjid_var = "SUBJID",
      cat_var = "PARCAT1",
      default_centrality_fn = "Mean",
      default_dispersion_fn = "Standard deviation",
      default_cat = "CHEM",
      default_par = "Bilirubin (umol/L)",
      default_main_group = "ARM",
      default_visit_var = "VISIT"
    )
  )

  data <- safety_data()
  data[["bm"]][["AVISITN"]][[1]] <- NA_integer_

  dv.manager::run_app(
    data = list("DS" = list(bm = data[["bm"]], sl = data[["sl"]])),
    module_list = module_list,
    filter_data = "sl",
    filter_key = "SUBJID"
  )
}
