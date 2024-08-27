# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc( # nolint
  INPUT = poc(
    CAT = tns(BP$ID$PAR, "cat_val"),
    PAR = tns(BP$ID$PAR, "par_val"),
    VAL = tns(BP$ID$PAR_VALUE, "val"),
    VIS = tns(BP$ID$PAR_VISIT, "val"),
    MGRP = tns(BP$ID$MAIN_GRP, "val"),
    SGRP = tns(BP$ID$SUB_GRP, "val"),
    PGRP = tns(BP$ID$PAGE_GRP, "val"),
    VCHECK = tns(BP$ID$VIOLIN_CHECK),
    SPCHECK = tns(BP$ID$SHOW_POINTS_CHECK)
  ),
  OUTPUT = poc(
    CHART = tns(BP$ID$CHART),
    TABPANEL = tns(BP$ID$TAB_TABLES),
    TABLES = poc(
      SINGLE = tns(BP$ID$TABLE_SINGLE_LISTING) %>% structure(tab = BP$MSG$LABEL$TABLE_LISTING),
      LISTING = tns(BP$ID$TABLE_LISTING) %>% structure(tab = BP$MSG$LABEL$TABLE_LISTING),
      COUNT = tns(BP$ID$TABLE_COUNT) %>%
        structure(
          tab = BP$MSG$LABEL$TABLE_COUNT
        ),
      SUMMARY = tns(BP$ID$TABLE_SUMMARY) %>%
        structure(
          tab = BP$MSG$LABEL$TABLE_SUMMARY
        ),
      SIGNIF = tns(BP$ID$TABLE_SIGNIFICANCE) %>% structure(
        tab = BP$MSG$LABEL$TABLE_SIGNIFICANCE
      )
    )
  )
)

root_app <- start_app_driver(dv.explorer.parameter::mock_app_boxplot())
on.exit(if ("stop" %in% names(root_app)) root_app$stop())

fail_if_app_not_started <- function() {
  if (is.null(root_app)) rlang::abort("App could not be started")
}

test_that(
  "boxplot chart is included according to selection" |>
    vdoc[["add_spec"]](c(specs$boxplot_module$boxplot_chart, specs$boxplot_module$composition)),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()

    app <- shinytest2::AppDriver$new(root_app$get_url())

    inputs <- list()
    inputs[[ID$INPUT$CAT]] <- "PARCAT2"
    inputs[[ID$INPUT$VAL]] <- "VALUE2"
    inputs[[ID$INPUT$VIS]] <- "VISIT2"
    inputs[[ID$INPUT$MGRP]] <- "CAT2"
    inputs[[ID$INPUT$SGRP]] <- "CAT2"
    inputs[[ID$INPUT$PGRP]] <- "CAT2"
    inputs[[ID$INPUT$VCHECK]] <- TRUE
    inputs[[ID$INPUT$SPCHECK]] <- TRUE

    # Set in two steps because a prior selector is required
    inputs2 <- list()
    inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

    app$set_inputs(!!!inputs)
    app$wait_for_idle()
    app$set_inputs(!!!inputs2)
    app$wait_for_idle()

    plot <- app$get_values()[["output"]][[ID$OUTPUT$CHART]]
    expect_true("src" %in% names(plot))
  }
)

# Set up the clicks for the app so tables have content

# get bounding box function

# In boxplot when testing clicks tables reset, only listings one.
# Reason is unknown.
# It seems to reset randomly after other actions happen mainly setting the other click or taking snapshots
# It must be set and checked one after the other.

test_that("listing table appears according to click" |>
  vdoc[["add_spec"]](c(specs$boxplot_module$data_listing, specs$boxplot_module$composition)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$SGRP]] <- "CAT2"
  inputs[[ID$INPUT$PGRP]] <- "CAT2"
  inputs[[ID$INPUT$VCHECK]] <- TRUE
  inputs[[ID$INPUT$SPCHECK]] <- TRUE

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  click <- readRDS("app/data/bp_click.rds")
  i <- 0
  table <- NULL
  while (length(table) != 1 && i < 10) {
    app$set_inputs("not_ebas-click" = click, allow_no_input_binding_ = TRUE)
    app$wait_for_idle()
    table <- app$get_value(output = ID$OUTPUT$TABLES$LISTING)
  }

  table <- app$get_html(paste0("#", ID$OUTPUT$TABLES$LISTING))
  expect_snapshot(table, cran = TRUE)
})


test_that("single listing table appears according to double click" |>
  vdoc[["add_spec"]](c(specs$boxplot_module$single_listing, specs$boxplot_module$composition)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$SGRP]] <- "CAT2"
  inputs[[ID$INPUT$PGRP]] <- "CAT2"
  inputs[[ID$INPUT$VCHECK]] <- TRUE
  inputs[[ID$INPUT$SPCHECK]] <- TRUE

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  click <- readRDS("app/data/bp_click.rds")
  i <- 0
  table <- NULL
  while (length(table) != 1 && i < 10) {
    app$set_inputs("not_ebas-dclick" = click, allow_no_input_binding_ = TRUE)
    app$wait_for_idle()
    table <- app$get_value(output = ID$OUTPUT$TABLES$SINGLE)
  }

  table <- app$get_html(paste0("#", ID$OUTPUT$TABLES$SINGLE))
  expect_snapshot(table, cran = TRUE)
})

test_that("count table appears" |>
  vdoc[["add_spec"]](c(specs$boxplot_module$data_count, specs$boxplot_module$composition)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$SGRP]] <- "CAT2"
  inputs[[ID$INPUT$PGRP]] <- "CAT2"
  inputs[[ID$INPUT$VCHECK]] <- TRUE
  inputs[[ID$INPUT$SPCHECK]] <- TRUE

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  app$set_inputs(!!ID$OUTPUT$TABPANEL := attr(ID$OUTPUT$TABLES$COUNT, "tab")) # nolint
  app$wait_for_idle()

  table <- app$get_html(paste0("#", ID$OUTPUT$TABLES$COUNT))
  expect_snapshot(table, cran = TRUE)
})

test_that("summary table appears" |>
  vdoc[["add_spec"]](c(specs$boxplot_module$data_summary, specs$boxplot_module$composition)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$SGRP]] <- "CAT2"
  inputs[[ID$INPUT$PGRP]] <- "CAT2"
  inputs[[ID$INPUT$VCHECK]] <- TRUE
  inputs[[ID$INPUT$SPCHECK]] <- TRUE

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  app$set_inputs(!!ID$OUTPUT$TABPANEL := attr(ID$OUTPUT$TABLES$SUMMARY, "tab")) # nolint
  app$wait_for_idle()

  table <- app$get_html(paste0("#", ID$OUTPUT$TABLES$SUMMARY))
  expect_snapshot(table, cran = TRUE)
})

test_that("significance table appears" |>
  vdoc[["add_spec"]](c(specs$boxplot_module$data_significance, specs$boxplot_module$composition)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$SGRP]] <- "CAT2"
  inputs[[ID$INPUT$PGRP]] <- "CAT2"
  inputs[[ID$INPUT$VCHECK]] <- TRUE
  inputs[[ID$INPUT$SPCHECK]] <- TRUE

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  app$set_inputs(!!ID$OUTPUT$TABPANEL := attr(ID$OUTPUT$TABLES$SIGNIF, "tab")) # nolint
  app$wait_for_idle()

  table <- app$get_html(paste0("#", ID$OUTPUT$TABLES$SIGNIF))
  expect_snapshot(table, cran = TRUE)
})

test_that("bookmark is restored. Clicks are excluded are not bookmarked." |>
  vdoc[["add_spec"]](c(specs$boxplot_module$bookmark, specs$boxplot_module$composition)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$SGRP]] <- "CAT2"
  inputs[[ID$INPUT$PGRP]] <- "CAT2"
  inputs[[ID$INPUT$VCHECK]] <- TRUE
  inputs[[ID$INPUT$SPCHECK]] <- TRUE

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

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
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_visit = "VISIT2",
    default_value = "VALUE2",
    default_main_group = "CAT1",
    default_sub_group = "CAT2",
    default_page_group = "CAT3"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_boxplot(
        srv_defaults = !!srv_defaults
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$CAT]], srv_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], srv_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$VIS]], srv_defaults[["default_visit"]])
  expect_equal(input_values[[ID$INPUT$VAL]], srv_defaults[["default_value"]])
  expect_equal(input_values[[ID$INPUT$MGRP]], srv_defaults[["default_main_group"]])
  expect_equal(input_values[[ID$INPUT$SGRP]], srv_defaults[["default_sub_group"]])
  expect_equal(input_values[[ID$INPUT$PGRP]], srv_defaults[["default_page_group"]])
})
