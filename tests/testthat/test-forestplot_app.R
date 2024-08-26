# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc( # nolint
  INPUT = poc(
    CAT = tns(FP_ID$PAR, "cat_val"),
    PAR = tns(FP_ID$PAR, "par_val"),
    VAL = tns(FP_ID$PAR_VALUE_TRANSFORM, "val"),
    FOREST_KIND = tns(FP_ID$FOREST_KIND),
    CONT_VAR = tns(FP_ID$CONT_VAR, "val"),
    CATEGORICAL_VAR = tns(FP_ID$CATEGORICAL_VAR, "val"),
    CATEGORICAL_VAL_A = tns(FP_ID$CATEGORICAL_VAL_A),
    CATEGORICAL_VAL_B = tns(FP_ID$CATEGORICAL_VAL_B),
    VIS = tns(FP_ID$PAR_VISIT, "val"),
    MGRP = tns(FP_ID$MAIN_GRP, "val")
  ),
  OUTPUT = poc(
    TABLE = tns(FP_ID$TABLE_LISTING),
    FOREST_SVG = tns(FP_ID$FOREST_SVG)
  )
)

root_app <- start_app_driver(dv.biomarker.general::mock_app_forest())

on.exit(if ("stop" %in% names(root_app)) root_app$stop())

fail_if_app_not_started <- function() {
  if (is.null(root_app)) rlang::abort("App could not be started")
}

test_that("forestplot table is included according to selection. Continuous" |>
  vdoc[["add_spec"]](c(specs$forest_module$forest_plot, specs$forest_module$table, specs$forest_module$composition)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$FOREST_KIND]] <- "Spearman Correlation"
  inputs[[ID$INPUT$CONT_VAR]] <- "CONT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  table_html <- app$get_html(paste0("#", ID$OUTPUT$TABLE))
  expect_snapshot(table_html, cran = TRUE)

  svg_html <- app$get_html(paste0("#", ID$OUTPUT$FOREST_SVG))
  expect_snapshot(svg_html, cran = TRUE)
})

test_that("forestplot table is included according to selection. Odds" |>
  vdoc[["add_spec"]](c(specs$forest_module$forest_plot, specs$forest_module$table, specs$forest_module$composition)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$FOREST_KIND]] <- "Odds Ratio"
  inputs[[ID$INPUT$CATEGORICAL_VAR]] <- "CAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")
  inputs2[[ID$INPUT$CATEGORICAL_VAL_A]] <- "A"
  inputs2[[ID$INPUT$CATEGORICAL_VAL_B]] <- "B"

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  table_html <- app$get_html(paste0("#", ID$OUTPUT$TABLE))
  expect_snapshot(table_html, cran = TRUE)

  if (!isTRUE(Sys.getenv("CI"))) {
    svg_html <- app$get_html(paste0("#", ID$OUTPUT$FOREST_SVG))
    testthat::expect_snapshot(svg_html, cran = FALSE)
  } else {
    warning("Skipping test in CI")
  }
})


test_that("bookmark is restored. Odds" |>
  vdoc[["add_spec"]](c(specs$forest_module$bookmark)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$FOREST_KIND]] <- "Odds Ratio"
  inputs[[ID$INPUT$CATEGORICAL_VAR]] <- "CAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")
  inputs2[[ID$INPUT$CATEGORICAL_VAL_A]] <- "A"
  inputs2[[ID$INPUT$CATEGORICAL_VAL_B]] <- "B"

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

test_that("bookmark is restored. Continuous" |>
  vdoc[["add_spec"]](c(specs$forest_module$bookmark)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$FOREST_KIND]] <- "Spearman Correlation"
  inputs[[ID$INPUT$CONT_VAR]] <- "CONT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"

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

test_that("default values are set. Odds", {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  ui_defaults <- list(
    default_function = "Odds Ratio"
  )
  srv_defaults <- list(
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_visit = "VISIT2",
    default_value = "VALUE2",
    default_var = "CAT2",
    default_categorical_A = "B",
    default_categorical_B = "C",
    default_group = "CAT2"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.biomarker.general::mock_app_forest(
        ui_defaults = !!ui_defaults,
        srv_defaults = !!srv_defaults
      )
    )
  )
  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$FOREST_KIND]], ui_defaults[["default_function"]])
  expect_equal(input_values[[ID$INPUT$CAT]], srv_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], srv_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$VIS]], srv_defaults[["default_visit"]])
  expect_equal(input_values[[ID$INPUT$CATEGORICAL_VAR]], srv_defaults[["default_var"]])
  expect_equal(input_values[[ID$INPUT$CATEGORICAL_VAL_A]], srv_defaults[["default_categorical_A"]])
  expect_equal(input_values[[ID$INPUT$CATEGORICAL_VAL_B]], srv_defaults[["default_categorical_B"]])
})

test_that("default values are set. Continuous", {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  ui_defaults <- list(
    default_function = "Spearman Correlation"
  )
  srv_defaults <- list(
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_visit = "VISIT2",
    default_value = "VALUE2",
    default_var = "CONT2"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.biomarker.general::mock_app_forest(
        ui_defaults = !!ui_defaults,
        srv_defaults = !!srv_defaults
      )
    )
  )
  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$FOREST_KIND]], ui_defaults[["default_function"]])
  expect_equal(input_values[[ID$INPUT$CAT]], srv_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], srv_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$VIS]], srv_defaults[["default_visit"]])
  expect_equal(input_values[[ID$INPUT$CONT_VAR]], srv_defaults[["default_var"]])
})
