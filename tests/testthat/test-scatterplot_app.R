# nolint start
# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc( # nolint
  INPUT = poc(
    X = poc(
      CAT = tns(SP$ID$X$PAR, "cat_val"),
      PAR = tns(SP$ID$X$PAR, "par_val"),
      VAL = tns(SP$ID$X$PAR_VALUE, "val"),
      VIS = tns(SP$ID$X$PAR_VISIT, "val")
    ),
    Y = poc(
      CAT = tns(SP$ID$Y$PAR, "cat_val"),
      PAR = tns(SP$ID$Y$PAR, "par_val"),
      VAL = tns(SP$ID$Y$PAR_VALUE, "val"),
      VIS = tns(SP$ID$Y$PAR_VISIT, "val")
    ),
    GRP = tns(SP$ID$GRP, "val"),
    COLOR = tns(SP$ID$COLOR, "val"),
    ANLFL = tns(BP$ID$ANLFL_FILTER, "val")
  ),
  OUTPUT = poc(
    CHART = tns(SP$ID$CHART),
    TABPANEL = tns(SP$ID$TAB_TABLES),
    TABLES = poc(
      LISTING = tns(SP$ID$TABLE_LISTING) %>% structure(tab = SP$MSG$LABEL$TABLE_LISTING),
      CORRELATION = tns(SP$ID$TABLE_CORRELATION) %>% structure(tab = SP$MSG$LABEL$TABLE_REGRESSION),
      REGRESSION = tns(SP$ID$TABLE_REGRESSION) %>% structure(tab = SP$MSG$LABEL$TABLE_REGRESSION)
    )
  )
)

root_app <- start_app_driver(dv.explorer.parameter::mock_app_scatterplot())
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
  inputs[[ID$INPUT$X$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$X$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$X$VIS]] <- "VISIT2"
  inputs[[ID$INPUT$Y$CAT]] <- "PARCAT3"
  inputs[[ID$INPUT$Y$VAL]] <- "VALUE3"
  inputs[[ID$INPUT$Y$VIS]] <- "VISIT3"
  inputs[[ID$INPUT$GRP]] <- "CAT2"
  inputs[[ID$INPUT$COLOR]] <- "CAT3"

  # Set in two steps because Category must be set before parameter can be set
  inputs2 <- list()
  inputs2[[ID$INPUT$X$PAR]] <- "PARAM22"
  inputs2[[ID$INPUT$Y$PAR]] <- "PARAM32"

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  data_subset <- app$get_value(export = tns("data_subset"))
  x_label <- attr(data_subset[[CNT$X_VAL]], "label")
  y_label <- attr(data_subset[[CNT$Y_VAL]], "label")
  main_group_label <- attr(data_subset[[CNT$MAIN_GROUP]], "label")
  color_group_label <- attr(data_subset[[CNT$COLOR_GROUP]], "label")
  expect_equal(x_label, paste0(inputs2[[ID$INPUT$X$PAR]], " ", "[Label of ", inputs[[ID$INPUT$X$VAL]], "]"))
  expect_equal(y_label, paste0(inputs2[[ID$INPUT$Y$PAR]], " ", "[Label of ", inputs[[ID$INPUT$Y$VAL]], "]"))
  expect_equal(main_group_label, paste0("Label of ", inputs[[ID$INPUT$GRP]], ""))
  expect_equal(color_group_label, paste0("Label of ", inputs[[ID$INPUT$COLOR]], ""))
})

test_that("scatterplot chart is included according to selection" |>
  vdoc[["add_spec"]](c(specs$scatterplot_plot_module$composition, specs$scatterplot_plot_module$scatterplot_chart)), {skip("This test is likely to fail when comparing snapshots, it is left here aiming to update it in the future so that it doesn't use snapshot comparison, at which point the skip can be removed")
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$X$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$X$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$X$VIS]] <- "VISIT2"
  inputs[[ID$INPUT$Y$CAT]] <- "PARCAT3"
  inputs[[ID$INPUT$Y$VAL]] <- "VALUE3"
  inputs[[ID$INPUT$Y$VIS]] <- "VISIT3"
  inputs[[ID$INPUT$GRP]] <- "CAT2"
  inputs[[ID$INPUT$COLOR]] <- "CAT3"

  # Set in two steps because Category must be set before parameter can be set
  inputs2 <- list()
  inputs2[[ID$INPUT$X$PAR]] <- "PARAM22"
  inputs2[[ID$INPUT$Y$PAR]] <- "PARAM32"

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  # This against gg internals, but is better than the snapshot

  if (!isTRUE(Sys.getenv("CI"))) {
    chart <- app$get_html(paste0("#", ID$OUTPUT$CHART))
    expect_snapshot(chart, cran = FALSE)
  } else {
    warning("Skipping test in CI")
  }
})


test_that("tables are included" |>
  vdoc[["add_spec"]](c(specs$scatterplot_plot_module$composition, specs$scatterplot_plot_module$data_listing, specs$scatterplot_plot_module$cor_reg_table)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$X$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$X$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$X$VIS]] <- "VISIT2"
  inputs[[ID$INPUT$Y$CAT]] <- "PARCAT3"
  inputs[[ID$INPUT$Y$VAL]] <- "VALUE3"
  inputs[[ID$INPUT$Y$VIS]] <- "VISIT3"
  inputs[[ID$INPUT$GRP]] <- "CAT2"
  inputs[[ID$INPUT$COLOR]] <- "CAT3"

  # Set in two steps because Category must be set before parameter can be set
  inputs2 <- list()
  inputs2[[ID$INPUT$X$PAR]] <- "PARAM22"
  inputs2[[ID$INPUT$Y$PAR]] <- "PARAM32"

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  app$set_inputs(!!ID$OUTPUT$TABPANEL := attr(ID$OUTPUT$TABLES$REGRESSION, "tab"))
  app$wait_for_idle()

  reg <- app$get_html(paste0("#", ID$OUTPUT$TABLES$REGRESSION))
  expect_snapshot(reg, cran = TRUE)

  cor <- app$get_html(paste0("#", ID$OUTPUT$TABLES$CORRELATION))
  expect_snapshot(cor, cran = TRUE)
})

test_that("bookmark is restored. Clicks are excluded are not bookmarked." |>
  vdoc[["add_spec"]](c(specs$scatterplot_plot_module$bookmark)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$X$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$X$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$X$VIS]] <- "VISIT2"
  inputs[[ID$INPUT$Y$CAT]] <- "PARCAT3"
  inputs[[ID$INPUT$Y$VAL]] <- "VALUE3"
  inputs[[ID$INPUT$Y$VIS]] <- "VISIT3"
  inputs[[ID$INPUT$GRP]] <- "CAT2"
  inputs[[ID$INPUT$COLOR]] <- "CAT3"

  # Set in two steps because Category must be set before parameter can be set
  inputs2 <- list()
  inputs2[[ID$INPUT$X$PAR]] <- "PARAM22"
  inputs2[[ID$INPUT$Y$PAR]] <- "PARAM32"

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
    default_x_cat = "PARCAT2",
    default_x_par = "PARAM22",
    default_x_visit = "VISIT2",
    default_x_value = "VALUE2",
    default_y_cat = "PARCAT3",
    default_y_par = "PARAM32",
    default_y_visit = "VISIT3",
    default_y_value = "VALUE3",
    default_group = "CAT2",
    default_color = "CAT3"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_scatterplot(
        srv_defaults = !!srv_defaults
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$X$CAT]], srv_defaults[["default_x_cat"]])
  expect_equal(input_values[[ID$INPUT$X$PAR]], srv_defaults[["default_x_par"]])
  expect_equal(input_values[[ID$INPUT$X$VIS]], srv_defaults[["default_x_visit"]])
  expect_equal(input_values[[ID$INPUT$X$VAL]], srv_defaults[["default_x_value"]])
  expect_equal(input_values[[ID$INPUT$Y$CAT]], srv_defaults[["default_y_cat"]])
  expect_equal(input_values[[ID$INPUT$Y$PAR]], srv_defaults[["default_y_par"]])
  expect_equal(input_values[[ID$INPUT$Y$VIS]], srv_defaults[["default_y_visit"]])
  expect_equal(input_values[[ID$INPUT$Y$VAL]], srv_defaults[["default_y_value"]])
  expect_equal(input_values[[ID$INPUT$GRP]], srv_defaults[["default_group"]])
  expect_equal(input_values[[ID$INPUT$COLOR]], srv_defaults[["default_color"]])
})



test_that("default values are set including analysis flag variables", {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  srv_defaults <- list(
    default_x_cat = "PARCAT2",
    default_x_par = "PARAM22",
    default_x_visit = "VISIT2",
    default_x_value = "VALUE2",
    default_y_cat = "PARCAT3",
    default_y_par = "PARAM32",
    default_y_visit = "VISIT3",
    default_y_value = "VALUE3",
    default_group = "CAT2",
    default_color = "CAT3"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_scatterplot(
        srv_defaults = !!srv_defaults,
        anlfl_flags = TRUE
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$X$CAT]], srv_defaults[["default_x_cat"]])
  expect_equal(input_values[[ID$INPUT$X$PAR]], srv_defaults[["default_x_par"]])
  expect_equal(input_values[[ID$INPUT$X$VIS]], srv_defaults[["default_x_visit"]])
  expect_equal(input_values[[ID$INPUT$X$VAL]], srv_defaults[["default_x_value"]])
  expect_equal(input_values[[ID$INPUT$Y$CAT]], srv_defaults[["default_y_cat"]])
  expect_equal(input_values[[ID$INPUT$Y$PAR]], srv_defaults[["default_y_par"]])
  expect_equal(input_values[[ID$INPUT$Y$VIS]], srv_defaults[["default_y_visit"]])
  expect_equal(input_values[[ID$INPUT$Y$VAL]], srv_defaults[["default_y_value"]])
  expect_equal(input_values[[ID$INPUT$GRP]], srv_defaults[["default_group"]])
  expect_equal(input_values[[ID$INPUT$COLOR]], srv_defaults[["default_color"]])
  expect_equal(input_values[[ID$INPUT$ANLFL]], "ANLFL1")
})
# nolint end
