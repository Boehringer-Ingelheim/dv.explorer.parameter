# nolint start
# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc( # nolint
  INPUT = poc(
    CAT = tns(SPM$ID$PAR, "cat_val"),
    PAR = tns(SPM$ID$PAR, "par_val"),
    VAL = tns(SPM$ID$PAR_VALUE, "val"),
    VIS = tns(SPM$ID$PAR_VISIT, "val"),
    GRP = tns(SPM$ID$MAIN_GRP, "val"),
    ANLFL = tns(BP$ID$ANLFL_FILTER, "val")
  ),
  OUTPUT = poc(
    CHART = tns(SPM$ID$CHART)
  )
)

root_app <- start_app_driver(dv.explorer.parameter::mock_app_scatterplotmatrix())
on.exit(if ("stop" %in% names(root_app)) root_app$stop())

fail_if_app_not_started <- function() {
  if (is.null(root_app)) rlang::abort("App could not be started")
}

test_that("data is subset according to selection", {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$VIS]] <- "VISIT2"
  inputs[[ID$INPUT$GRP]] <- "CAT3"

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  data_subset <- app$get_value(export = tns("data_subset"))

  expect_true(
    all(inputs2[[ID$INPUT$PAR]] %in% names(data_subset))
  )

  expect_equal(
    attr(data_subset[[CNT$MAIN_GROUP]], "label"),
    paste0("Label of ", inputs[[ID$INPUT$GRP]])
  )

  expect_equal(
    unique(as.character(data_subset[[CNT$VIS]])),
    inputs[[ID$INPUT$VIS]]
  )
})

test_that("scatterplotmatrix chart is included according to selection" |>
  vdoc[["add_spec"]](c(specs$scatterplot_matrix_module$composition, specs$scatterplot_matrix_module$scatterplot_matrix_chart)), {skip("This test is likely to fail when comparing snapshots, it is left here aiming to update it in the future so that it doesn't use snapshot comparison, at which point the skip can be removed")
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$VIS]] <- "VISIT2"
  inputs[[ID$INPUT$GRP]] <- "CAT3"

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  chart <- app$get_html(paste0("#", ID$OUTPUT$CHART))
  expect_snapshot(chart, cran = TRUE)
})

test_that("bookmark is restored. Clicks are excluded are not bookmarked." |>
  vdoc[["add_spec"]](c(specs$scatterplot_matrix_module$bookmark)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$VIS]] <- "VISIT2"
  inputs[[ID$INPUT$GRP]] <- "CAT3"

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

  # Explicitely exclude click
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
    default_main_group = "CAT3"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_scatterplotmatrix(
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
  expect_equal(input_values[[ID$INPUT$GRP]], srv_defaults[["default_main_group"]])
})




test_that("default values are set including analysis flag variables", {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  srv_defaults <- list(
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_visit = "VISIT2",
    default_value = "VALUE2",
    default_main_group = "CAT3"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_scatterplotmatrix(
        srv_defaults = !!srv_defaults,
        anlfl_flags = TRUE
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$CAT]], srv_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], srv_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$VIS]], srv_defaults[["default_visit"]])
  expect_equal(input_values[[ID$INPUT$VAL]], srv_defaults[["default_value"]])
  expect_equal(input_values[[ID$INPUT$GRP]], srv_defaults[["default_main_group"]])
  expect_equal(input_values[[ID$INPUT$ANLFL]], "ANLFL1")
})
# nolint end
