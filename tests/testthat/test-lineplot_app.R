# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc(
  INPUT = poc(
    CAT = tns(LP_ID$PAR, "cat_val"),
    PAR = tns(LP_ID$PAR, "par_val"),
    CENT = tns(LP_ID$PLOT_CENTRALITY_AND_DISPERSION, "cat_val"),
    DISP = tns(LP_ID$PLOT_CENTRALITY_AND_DISPERSION, "par_val"),
    VAL = tns(LP_ID$PAR_VALUE_TRANSFORM, "val"),
    VIS_COL = tns(LP_ID$PAR_VISIT_COL, "val"),
    VIS = tns(LP_ID$PAR_VISIT, "val"),
    MGRP = tns(LP_ID$MAIN_GRP, "val"),
    SGRP = tns(LP_ID$SUB_GRP, "val"),
    TRANSPARENCY = tns(LP_ID$TWEAK_TRANSPARENCY),
    ANLFL = tns(LP_ID$ANLFL_FILTER, "val")
  ),
  OUTPUT = poc(
    CHART = tns(LP_ID$CHART),
    TABPANEL = tns(LP_ID$TAB_TABLES),
    TABLES = poc(
      SUBJECT_LISTING = tns(LP_ID$SUBJECT_LISTING) %>% structure(tab = LP_MSG$LABEL$SUBJECT_LISTING),
      SUMMARY_LISTING = tns(LP_ID$SUMMARY_LISTING) %>% structure(tab = LP_MSG$LABEL$SUMMARY_LISTING),
      COUNT_LISTING = tns(LP_ID$COUNT_LISTING) %>% structure(tab = LP_MSG$LABEL$COUNT_LISTING)
    )
  )
)

root_app <- start_app_driver(dv.explorer.parameter::mock_app_lineplot())

on.exit(if ("stop" %in% names(root_app)) root_app$stop())

fail_if_app_not_started <- function() {
  if (is.null(root_app)) rlang::abort("App could not be started")
}

test_that("lineplot chart is included according to selection" |>
  vdoc[["add_spec"]](c(specs$lineplot_module$composition, specs$lineplot_module$lineplot_chart, specs$lineplot_module$grouping, specs$lineplot_module$summarizing)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$VIS_COL]] <- "VISIT2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$SGRP]] <- "CAT2"
  inputs[[ID$INPUT$TRANSPARENCY]] <- .5
  inputs[[ID$INPUT$CENT]] <- "Mean"
  inputs[[ID$INPUT$DISP]] <- "Standard deviation"

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")
  inputs2[[ID$INPUT$VIS]] <- c(1, 9)

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  chart_html <- app$get_html(paste0("#", ID$OUTPUT$CHART))
  expect_snapshot(chart_html, cran = TRUE)
})

# Set up the clicks for the app so tables have content

# get bounding box function

# In boxplot when testing clicks tables reset, only listings one.
# Reason is unknown.
# It seems to reset randomly after other actions happen mainly setting the other click or taking snapshots
# It must be set and checked one after the other.

test_that("listing/count tables appears according to click" |>
  vdoc[["add_spec"]](c(
    specs$lineplot_module$composition,
    specs$lineplot_module$subject_level_listing,
    specs$lineplot_module$summary_listing,
    specs$lineplot_module$data_count
  )), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$VIS_COL]] <- "VISIT2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$SGRP]] <- "CAT2"
  inputs[[ID$INPUT$TRANSPARENCY]] <- .5
  inputs[[ID$INPUT$CENT]] <- "Mean"

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")
  inputs2[[ID$INPUT$VIS]] <- c(1, 9)
  inputs2[[ID$INPUT$DISP]] <- "Standard deviation"


  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  click <- readRDS("app/data/lp_click.rds")

  i <- 0
  subject_listing_contents <- NULL
  while ((!is.list(subject_listing_contents) || nrow(subject_listing_contents[["contents"]]) < 1) && i < 10) {
    app$set_inputs("not_ebas-click" = click, allow_no_input_binding_ = TRUE)
    app$wait_for_idle()
    subject_listing_contents <- app$get_value(export = tns("subject_listing_contents"))
    i <- i + 1
  }
  expect_snapshot(subject_listing_contents, cran = TRUE)

  app$set_inputs(!!ID$OUTPUT$TABPANEL := attr(ID$OUTPUT$TABLES$SUMMARY_LISTING, "tab"))
  app$wait_for_idle()
  summary_listing_contents <- app$get_value(export = tns("summary_listing_contents"))
  expect_snapshot(summary_listing_contents, cran = TRUE)

  app$set_inputs(!!ID$OUTPUT$TABPANEL := attr(ID$OUTPUT$TABLES$COUNT_LISTING, "tab"))
  app$wait_for_idle()
  count_listing_contents <- app$get_value(export = tns("count_listing_contents"))
  expect_snapshot(count_listing_contents, cran = TRUE)
})

test_that("listing/count table appears according to brush" |>
  vdoc[["add_spec"]](c(
    specs$lineplot_module$composition,
    specs$lineplot_module$subject_level_listing,
    specs$lineplot_module$summary_listing,
    specs$lineplot_module$data_count
  )), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$VIS_COL]] <- "VISIT2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$SGRP]] <- "CAT2"
  inputs[[ID$INPUT$TRANSPARENCY]] <- .5
  inputs[[ID$INPUT$CENT]] <- "Mean"

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")
  inputs2[[ID$INPUT$VIS]] <- c(1, 9)
  inputs2[[ID$INPUT$DISP]] <- "Standard deviation"

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  brush <- readRDS("app/data/lp_brush.rds")

  i <- 0
  subject_listing_contents <- NULL
  while ((!is.list(subject_listing_contents) || nrow(subject_listing_contents[["contents"]]) < 1) && i < 10) {
    app$set_inputs("not_ebas-brush" = brush, allow_no_input_binding_ = TRUE)
    app$wait_for_idle()
    subject_listing_contents <- app$get_value(export = tns("subject_listing_contents"))
    i <- i + 1
  }
  expect_snapshot(subject_listing_contents, cran = TRUE)

  app$set_inputs(!!ID$OUTPUT$TABPANEL := attr(ID$OUTPUT$TABLES$SUMMARY_LISTING, "tab"))
  app$wait_for_idle()
  summary_listing_contents <- app$get_value(export = tns("summary_listing_contents"))
  expect_snapshot(summary_listing_contents, cran = TRUE)

  app$set_inputs(!!ID$OUTPUT$TABPANEL := attr(ID$OUTPUT$TABLES$COUNT_LISTING, "tab"))
  app$wait_for_idle()
  count_listing_contents <- app$get_value(export = tns("count_listing_contents"))
  expect_snapshot(count_listing_contents, cran = TRUE)
})

test_that("bookmark is restored. Clicks are excluded" |>
  vdoc[["add_spec"]](c(specs$lineplot_module$bookmark)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$VIS_COL]] <- "VISIT2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$SGRP]] <- "CAT2"
  inputs[[ID$INPUT$TRANSPARENCY]] <- .5
  inputs[[ID$INPUT$CENT]] <- "Mean"

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")
  inputs2[[ID$INPUT$VIS]] <- c(1, 9)
  inputs2[[ID$INPUT$DISP]] <- "Standard deviation"

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  # URL is automatically updated with the bookmarked URL
  bmk_url <- app$get_js("window.location.href")

  bookmark_app <- shinytest2::AppDriver$new(bmk_url)
  bookmark_app$wait_for_idle()
  app_input_values <- app$get_values()[["input"]]
  bmk_input_values <- bookmark_app$get_values()[["input"]]
  expect_identical(app_input_values, bmk_input_values)
})

test_that("default values are set", {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  srv_defaults <- list(
    default_centrality_fn = "Mean",
    default_dispersion_fn = "Standard deviation",
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_val = "VALUE2",
    default_visit_var = "VISIT2",
    default_visit_val = list(VISIT2 = c(1, 9)),
    default_main_group = "CAT2",
    default_sub_group = "CAT2"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_lineplot(
        srv_defaults = !!srv_defaults
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$CAT]], srv_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], srv_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$CENT]], srv_defaults[["default_centrality_fn"]])
  expect_equal(input_values[[ID$INPUT$DISP]], srv_defaults[["default_dispersion_fn"]])
  expect_equal(input_values[[ID$INPUT$VIS_COL]], srv_defaults[["default_visit_var"]])
  expect_equal(input_values[[ID$INPUT$VIS]], as.character(srv_defaults[["default_visit_val"]][["VISIT2"]]))
  expect_equal(input_values[[ID$INPUT$VAL]], srv_defaults[["default_val"]])
  expect_equal(input_values[[ID$INPUT$MGRP]], srv_defaults[["default_main_group"]])
  expect_equal(input_values[[ID$INPUT$SGRP]], srv_defaults[["default_sub_group"]])
})



test_that("default values are set including analysis flag variables", {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  srv_defaults <- list(
    default_centrality_fn = "Mean",
    default_dispersion_fn = "Standard deviation",
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_val = "VALUE2",
    default_visit_var = "VISIT2",
    default_visit_val = list(VISIT2 = c(1, 9)),
    default_main_group = "CAT2",
    default_sub_group = "CAT2"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_lineplot(
        srv_defaults = !!srv_defaults,
        anlfl_flags = TRUE
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$CAT]], srv_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], srv_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$CENT]], srv_defaults[["default_centrality_fn"]])
  expect_equal(input_values[[ID$INPUT$DISP]], srv_defaults[["default_dispersion_fn"]])
  expect_equal(input_values[[ID$INPUT$VIS_COL]], srv_defaults[["default_visit_var"]])
  expect_equal(input_values[[ID$INPUT$VIS]], as.character(srv_defaults[["default_visit_val"]][["VISIT2"]]))
  expect_equal(input_values[[ID$INPUT$VAL]], srv_defaults[["default_val"]])
  expect_equal(input_values[[ID$INPUT$MGRP]], srv_defaults[["default_main_group"]])
  expect_equal(input_values[[ID$INPUT$SGRP]], srv_defaults[["default_sub_group"]])
  expect_equal(input_values[[ID$INPUT$ANLFL]], "ANLFL1")
})


test_that("module tolerates the absence of visit-dependent data", {
  # TODO(miguel): Test the parameter selector under R/utils-selector.R instead/on top of this
  testthat::skip_if_not(run_shiny_tests)
  skip_if_suspect_check()
  data <- dv.explorer.parameter:::test_data()
  data[["bm"]] <- data[["bm"]][0, ] # zero rows, equivalent to dv.filtering everything out
  app <- start_app_driver(rlang::quo(dv.explorer.parameter::mock_app_lineplot(data = data)))
  testthat::expect_true(!is.null(app)) # `app` is NULL if it crashes on load
})
