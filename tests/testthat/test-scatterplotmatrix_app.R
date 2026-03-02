# nolint start
# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc(
  # nolint
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

skip_if_not_running_shiny_tests()

root_app <- start_app_driver(dv.explorer.parameter::mock_app_scatterplotmatrix())
on.exit(if ("stop" %in% names(root_app)) root_app$stop())


if (is.null(root_app)) {
  rlang::abort("App could not be started")
}

local({
  app <- shinytest2::AppDriver$new(root_app$get_url())
  app_args <- dv.explorer.parameter::mock_app_boxplot(dry_run = TRUE)

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

  exported_test_values <- app$get_value(export = "not_ebas-output_arguments")

  expected_ds <- spm_subset_data(
    cat = inputs[[ID$INPUT$CAT]],
    cat_col = app_args$srv$cat_var,
    par = inputs2[[ID$INPUT$PAR]],
    par_col = app_args$srv$par_var,
    val_col = inputs[[ID$INPUT$VAL]],
    vis = inputs[[ID$INPUT$VIS]],
    vis_col = app_args$srv$visit_var,
    group_vect = stats::setNames(c(inputs[[ID$INPUT$GRP]]), c(CNT$MAIN_GROUP)),
    bm_ds = shiny::isolate(app_args$srv$bm_dataset()),
    group_ds = shiny::isolate(app_args$srv$group_dataset()),
    subj_col = app_args$srv$subjid_var
  )

  test_that(
    "scatterplotmatrix chart is included according to selection" |>
      vdoc[["add_spec"]](c(
        specs$scatterplot_matrix_module$composition,
        specs$scatterplot_matrix_module$scatterplot_matrix_chart
      )),
    {
      expected <- list(
        ds = expected_ds
      )

      exported <- shiny::isolate(exported_test_values[[SPM$ID$CHART]][["arguments"]]())

      expect_identical(exported, expected)

      plot <- app$get_value(output = ID$OUTPUT$CHART)
      expect_true("src" %in% names(plot))
    }
  )

  test_that(
    "bookmark is restored. Clicks are excluded are not bookmarked." |>
      vdoc[["add_spec"]](c(specs$scatterplot_matrix_module$bookmark)),
    {
      bmk_url <- suppressWarnings(app$get_js("window.location.href"))

      bookmark_app <- shinytest2::AppDriver$new(bmk_url)
      bookmark_app$wait_for_idle()
      app_input_values <- app$get_values()[["input"]]

      # Explicitely exclude click
      bmk_input_values <- bookmark_app$get_values()[["input"]]
      expect_identical(app_input_values, bmk_input_values)
    }
  )
})


test_that("default values are set", {
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
