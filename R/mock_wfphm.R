#' Mock functions
#' @name mock_wfphm
#' @keywords mock
#'
NULL


#' @describeIn mock_wfphm Mock app running the module inside dv.manager
#'
#' @export
mock_wfphm_mm_app <- function() {
  if (requireNamespace("dv.manager")) {
    dv.manager::run_app(
      data = list(
        "Sample Data" = list(adbm = test_data()[["bm"]], group = test_data()[["sl"]])
      ),
      module_list = list(
        "Waterfall" = mod_wfphm(
          subjid_var = "SUBJID",
          bm_dataset_name = "adbm",
          group_dataset_name = "group",
          cat_palette = list(SEX = function(x) {
            pal <- c("green" = "M", "maroon" = "F", "blue" = NA)
            pal_colorize(x, pal)
          }),
          cat_var = "PARCAT",
          visit_var = "VISIT",
          value_vars = c("VALUE1", "VALUE2"),
          module_id = "mod_WF"
        )
      ),
      filter_data = "group",
      filter_key = "SUBJID"
    )
  } else {
    rlang::abort("dv.manager is required to run this mock")
  }
}

#' @describeIn mock_wfphm Mock app running the waterfall plus heatmap module
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @export
mock_app_wfphm2 <- function(dry_run = FALSE,
                            update_query_string = TRUE,
                            srv_defaults = list(),
                            ui_defaults = list()) {
  data <- test_data()
  bm_dataset <- shiny::reactive({
    d <- data[["bm"]]
  })

  group_dataset <- shiny::reactive({
    d <- data[["sl"]]
    d[] <- purrr::map(d, function(x) {
      if (is.character(x)) factor(x) else x
    })
    d
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
      cat_var = "PARCAT",
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
    ui = function() do.call(wfphm_UI, ui_params),
    server = function() {
      do.call(wfphm_server, srv_params)
    }
  )
}

#' @describeIn mock_wfphm Mock app running categorical heatmap module
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @param ui_args,srv_args a list of arguments passed to the ui/server function.
#' @export
mock_app_hmcat <- function(dry_run = FALSE,
                           update_query_string = TRUE,
                           srv_args = list(),
                           ui_args = list()) {
  data <- test_data()

  group_dataset <- shiny::reactive({
    d <- data[["sl"]]
    lbls <- get_lbls_robust(d)
    d[] <- purrr::map(d, function(x) {
      if (is.character(x)) factor(x) else x
    })
    d <- set_lbls(d, lbls)
    d
  })

  ui_params <- list(id = "not_ebas")
  srv_params <- list(
    id = "not_ebas",
    dataset = group_dataset,
    subjid_var = "SUBJID",
    sorted_x = shiny::reactive(levels(data[["sl"]][["SUBJID"]])),
    margin = shiny::reactive(c(top = 20, bottom = 20, left = 200, right = 20))
  )

  ui_params[names(ui_args)] <- ui_args
  srv_params[names(srv_args)] <- srv_args

  if (dry_run) {
    return(list(ui = ui_params, srv = srv_params))
  }

  mock_app_wrap(
    update_query_string = update_query_string,
    ui = function() do.call(wfphm_hmcat_UI, ui_params),
    server = function() {
      do.call(wfphm_hmcat_server, srv_params)
    }
  )
}

#' @describeIn mock_wfphm Mock app running continuous heatmap module
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @param ui_args,srv_args a list of arguments passed to the ui/server function.
#' @export
mock_app_hmcont <- function(dry_run = FALSE,
                            update_query_string = TRUE,
                            srv_args = list(),
                            ui_args = list()) {
  data <- test_data()

  group_dataset <- shiny::reactive({
    d <- data[["sl"]]
    lbls <- get_lbls_robust(d)
    d[] <- purrr::map(d, function(x) {
      if (is.character(x)) factor(x) else x
    })
    d <- set_lbls(d, lbls)
    d
  })

  ui_params <- list(id = "not_ebas")
  srv_params <- list(
    id = "not_ebas",
    dataset = group_dataset,
    subjid_var = "SUBJID",
    sorted_x = shiny::reactive(levels(data[["sl"]][["SUBJID"]])),
    margin = shiny::reactive(c(top = 20, bottom = 20, left = 200, right = 20))
  )

  ui_params[names(ui_args)] <- ui_args
  srv_params[names(srv_args)] <- srv_args

  if (dry_run) {
    return(list(ui = ui_params, srv = srv_params))
  }

  mock_app_wrap(
    update_query_string = update_query_string,
    ui = function() do.call(wfphm_hmcont_UI, ui_params),
    server = function() {
      do.call(wfphm_hmcont_server, srv_params)
    }
  )
}

#' @describeIn mock_wfphm Mock app running parameter heatmap module
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @param ui_args,srv_args a list of arguments passed to the ui/server function.
#' @export
mock_app_hmpar <- function(dry_run = FALSE,
                           update_query_string = TRUE,
                           srv_args = list(),
                           ui_args = list()) {
  data <- test_data()

  dataset <- shiny::reactive({
    data[["bm"]]
  })

  ui_params <- list(
    id = "not_ebas",
    tr_choices = names(tr_mapper_def())
  )

  srv_params <- list(
    id = "not_ebas",
    dataset = dataset,
    cat_var = "PARCAT",
    par_var = "PARAM",
    visit_var = "VISIT",
    anlfl_reactive = shiny::reactive("ANLFL1"),
    subjid_var = "SUBJID",
    value_vars = c("VALUE1", "VALUE2"),
    sorted_x = shiny::reactive(levels(data[["sl"]][["SUBJID"]])),
    tr_mapper = tr_mapper_def(),
    margin = shiny::reactive(c(top = 20, bottom = 20, left = 200, right = 20)),
    show_x_ticks = TRUE
  )

  ui_params[names(ui_args)] <- ui_args
  srv_params[names(srv_args)] <- srv_args

  if (dry_run) {
    return(list(ui = ui_params, srv = srv_params))
  }

  mock_app_wrap(
    update_query_string = update_query_string,
    ui = function() do.call(wfphm_hmpar_UI, ui_params),
    server = function() {
      do.call(wfphm_hmpar_server, srv_params)
    }
  )
}

#' @describeIn mock_wfphm Mock app running waterfall module
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @param ui_args,srv_args a list of arguments passed to the ui/server function.
#' @export
mock_app_wf <- function(dry_run = FALSE,
                        update_query_string = TRUE,
                        srv_args = list(),
                        ui_args = list()) {
  data <- test_data()

  bm_dataset <- shiny::reactive({
    data[["bm"]]
  })

  group_dataset <- shiny::reactive({
    data[["sl"]]
  })

  ui_params <- list(
    id = "not_ebas"
  )

  srv_params <- list(
    id = "not_ebas",
    bm_dataset = bm_dataset,
    group_dataset = group_dataset,
    cat_var = "PARCAT",
    par_var = "PARAM",
    visit_var = "VISIT",
    subjid_var = "SUBJID",
    value_vars = c("VALUE1", "VALUE2", "VALUE3"),
    anlfl_vars = c("ANLFL1", "ANLFL2"),
    margin = shiny::reactive(c(top = 20, bottom = 20, left = 200, right = 20))
  )

  ui_params[names(ui_args)] <- ui_args
  srv_params[names(srv_args)] <- srv_args

  if (dry_run) {
    return(list(ui = ui_params, srv = srv_params))
  }

  mock_app_wrap(
    update_query_string = update_query_string,
    ui = function() do.call(wfphm_wf_UI, ui_params),
    server = function() {
      do.call(wfphm_wf_server, srv_params)
    }
  )
}

#' @describeIn mock_wfphm Mock app running the waterfall plus heatmap module
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @param ui_args,srv_args a list of arguments passed to the ui/server function.
#' @export
mock_app_wfphm <- function(dry_run = FALSE,
                           update_query_string = TRUE,
                           srv_args = list(),
                           ui_args = list()) {
  data <- test_data()

  bm_dataset <- shiny::reactive({
    data[["bm"]]
  })

  group_dataset <- shiny::reactive({
    data[["sl"]]
  })

  ui_params <- list(
    id = "not_ebas"
  )

  srv_params <- list(
    id = "not_ebas",
    bm_dataset = bm_dataset,
    group_dataset = group_dataset,
    cat_var = "PARCAT",
    par_var = "PARAM",
    visit_var = "VISIT",
    subjid_var = "SUBJID",
    anlfl_vars = c("ANLFL1", "ANLFL2"),
    value_vars = c("VALUE1", "VALUE2", "VALUE3")
  )

  ui_params[names(ui_args)] <- ui_args
  srv_params[names(srv_args)] <- srv_args

  if (dry_run) {
    return(list(ui = ui_params, srv = srv_params))
  }

  mock_app_wrap(
    update_query_string = update_query_string,
    ui = function() do.call(wfphm_UI, ui_params),
    server = function() {
      do.call(wfphm_server, srv_params)
    }
  )
}
