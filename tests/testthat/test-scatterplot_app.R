# nolint start
# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc(
  # nolint
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
if (is.null(root_app)) {
  rlang::abort("App could not be started")
}


skip_if_not_running_shiny_tests()

local({
  app <- shinytest2::AppDriver$new(root_app$get_url())
  app_args <- dv.explorer.parameter::mock_app_scatterplot(dry_run = TRUE)

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

  brush <- readRDS("app/data/sp_brush.rds")
  # brush interaction
  local({
    i <- 0
    table <- NULL
    while (length(table) != 1 && i < 10) {
      app$set_inputs("not_ebas-brush" = brush, allow_no_input_binding_ = TRUE, wait_ = FALSE)
      app$wait_for_idle()
      table <- app$get_value(output = ID$OUTPUT$TABLES$LISTING)
    }
  })

  exported_test_values <- app$get_value(export = "not_ebas-output_arguments")

  expected_ds <- sp_subset_data(
    x_cat = inputs[[ID$INPUT$X$CAT]],
    y_cat = inputs[[ID$INPUT$Y$CAT]],
    cat_col = app_args$srv$cat_var,
    x_par = inputs2[[ID$INPUT$X$PAR]],
    y_par = inputs2[[ID$INPUT$Y$PAR]],
    par_col = app_args$srv$par_var,
    x_val_col = inputs[[ID$INPUT$X$VAL]],
    y_val_col = inputs[[ID$INPUT$Y$VAL]],
    x_vis = inputs[[ID$INPUT$X$VIS]],
    y_vis = inputs[[ID$INPUT$Y$VIS]],
    vis_col = app_args$srv$visit_var,
    group_vect = stats::setNames(c("CAT2", "CAT3"), c(CNT$MAIN_GROUP, CNT$COLOR_GROUP)),
    bm_ds = shiny::isolate(app_args$srv$bm_dataset()),
    group_ds = shiny::isolate(app_args$srv$group_dataset()),
    subj_col = app_args$srv$subjid_var
  )

  test_that(
    "scatterplot chart is included according to selection" |>
      vdoc[["add_spec"]](c(specs$scatterplot_plot_module$composition, specs$scatterplot_plot_module$scatterplot_chart)),
    {
      expected <- list(
        ds = expected_ds,
        xlim = c(NA_real_, NA_real_),
        ylim = c(NA_real_, NA_real_)
      )

      exported <- shiny::isolate(exported_test_values[[SP$ID$CHART]][["arguments"]]())

      expect_identical(exported, expected)

      plot <- app$get_value(output = ID$OUTPUT$CHART)
      expect_true("src" %in% names(plot))
    }
  )

  test_that(
    "tables are included" |>
      vdoc[["add_spec"]](c(
        specs$scatterplot_plot_module$composition,
        specs$scatterplot_plot_module$data_listing,
        specs$scatterplot_plot_module$cor_reg_table
      )),
    {
      expect_snapshot(
        shiny::isolate(exported_test_values[[SP$ID$TABLE_LISTING]]$render())[["x"]][["data"]],
        cran = TRUE
      )
      expect_snapshot(
        shiny::isolate(exported_test_values[[SP$ID$TABLE_CORRELATION]]$render())[["x"]][["data"]],
        cran = TRUE
      )
      
      # Test against hardcoded values otherwise we get rounding error due to collinear values
      # We just set all unstable values to 0, stats are tested in another file
      unstable_to_zero <- shiny::isolate(exported_test_values[[SP$ID$TABLE_REGRESSION]]$render())[["x"]][["data"]]
      unstable_to_zero[["std.error"]] <- 0
      unstable_to_zero[["statistic"]] <- 0
      unstable_to_zero[["p.value"]] <- 0
      
      expect_snapshot(
        {
          unstable_to_zero <- shiny::isolate(exported_test_values[[SP$ID$TABLE_REGRESSION]]$render())[["x"]][["data"]]
          unstable_to_zero[["std.error"]] <- 0
          unstable_to_zero[["statistic"]] <- 0
          unstable_to_zero[["p.value"]] <- 0
          unstable_to_zero
        },
        cran = TRUE
      )
    }
  )

  test_that(
    "bookmark is restored. Clicks are excluded are not bookmarked." |>
      vdoc[["add_spec"]](c(specs$scatterplot_plot_module$bookmark)),
    {
      # URL is automatically updated with the bookmarked URL
      bmk_url <- app$get_js("window.location.href")

      bookmark_app <- suppressWarnings(shinytest2::AppDriver$new(bmk_url))
      bookmark_app$wait_for_idle()

      excluded <- c(
        "not_ebas-table_listing_cell_clicked",
        "not_ebas-table_listing_cells_selected",
        "not_ebas-table_listing_columns_selected",
        "not_ebas-table_listing_rows_all",
        "not_ebas-table_listing_rows_current",
        "not_ebas-table_listing_search",
        "not_ebas-table_listing_state",
        "not_ebas-table_listing_rows_selected",
        "not_ebas-table_single_listing_cell_clicked",
        "not_ebas-table_single_listing_cells_selected",
        "not_ebas-table_single_listing_columns_selected",
        "not_ebas-table_single_listing_rows_all",
        "not_ebas-table_single_listing_rows_current",
        "not_ebas-table_single_listing_search",
        "not_ebas-table_single_listing_state",
        "not_ebas-table_single_listing_rows_selected"
      )

      app_input_values <- app$get_values()[["input"]]
      app_input_values <- app_input_values[!names(app_input_values) %in% excluded]
      app_input_values["not_ebas-brush"] <- list(NULL)
      
      bmk_input_values <- bookmark_app$get_values()[["input"]]
      expect_identical(app_input_values, bmk_input_values)
    }
  )
})


test_that("default values are set", {
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
