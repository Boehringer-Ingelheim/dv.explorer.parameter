# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc(
  # nolint
  INPUT = poc(
    CAT = tns(BP$ID$PAR, "cat_val"),
    PAR = tns(BP$ID$PAR, "par_val"),
    VAL = tns(BP$ID$PAR_VALUE, "val"),
    VIS = tns(BP$ID$PAR_VISIT, "val"),
    MGRP = tns(BP$ID$MAIN_GRP, "val"),
    SGRP = tns(BP$ID$SUB_GRP, "val"),
    PGRP = tns(BP$ID$PAGE_GRP, "val"),
    VCHECK = tns(BP$ID$VIOLIN_CHECK),
    SPCHECK = tns(BP$ID$SHOW_POINTS_CHECK),
    Y_PROJECTION_CHECK = tns(BP$ID$Y_PROJECTION_CHECK),
    ANLFL = tns(BP$ID$ANLFL_FILTER, "val")
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
      SIGNIF = tns(BP$ID$TABLE_SIGNIFICANCE) %>%
        structure(
          tab = BP$MSG$LABEL$TABLE_SIGNIFICANCE
        )
    )
  )
)

root_app <- start_app_driver(dv.explorer.parameter::mock_app_boxplot())
on.exit(if ("stop" %in% names(root_app)) root_app$stop())

if (is.null(root_app)) {
  rlang::abort("App could not be started")
}

local({
  skip_if_not_running_shiny_tests()

  # First we set inputs so we can test as much as possible from the application without changing anything

  app <- shinytest2::AppDriver$new(root_app$get_url())
  app_args <- dv.explorer.parameter::mock_app_boxplot(dry_run = TRUE)

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$VIS]] <- "VISIT2"
  inputs[[ID$INPUT$MGRP]] <- "CAT2"
  inputs[[ID$INPUT$SGRP]] <- "CAT2"
  inputs[[ID$INPUT$PGRP]] <- "CAT2"
  inputs[[ID$INPUT$VCHECK]] <- TRUE
  inputs[[ID$INPUT$SPCHECK]] <- TRUE
  inputs[[ID$INPUT$Y_PROJECTION_CHECK]] <- TRUE

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  # set clicks
  click <- readRDS("app/data/bp_click.rds")

  # single click
  local({
    i <- 0
    table <- NULL
    while (length(table) != 1 && i < 10) {
      app$set_inputs("not_ebas-click" = click, allow_no_input_binding_ = TRUE, wait_ = FALSE)
      app$wait_for_idle()
      table <- app$get_value(output = ID$OUTPUT$TABLES$LISTING)
    }
  })

  # double click
  local({
    i <- 0
    table <- NULL
    while (length(table) != 1 && i < 10) {
      app$set_inputs("not_ebas-dclick" = click, allow_no_input_binding_ = TRUE, wait_ = FALSE)
      app$wait_for_idle()
      table <- app$get_value(output = ID$OUTPUT$TABLES$SINGLE)
    }
  })

  exported_test_values <- app$get_value(export = "not_ebas-output_arguments")
  
  expected_ds <- bp_subset_data(
    cat = inputs[[ID$INPUT$CAT]],
    cat_col = app_args$srv$cat_var,
    par = inputs2[[ID$INPUT$PAR]],
    par_col = app_args$srv$par_var,
    val_col = inputs[[ID$INPUT$VAL]],
    vis = inputs[[ID$INPUT$VIS]],
    vis_col = app_args$srv$visit_var,
    group_vect = stats::setNames(c("CAT2", "CAT2", "CAT2"), c(CNT$MAIN_GROUP, CNT$SUB_GROUP, CNT$PAGE_GROUP)),
    bm_ds = shiny::isolate(app_args$srv$bm_dataset()),
    group_ds = shiny::isolate(app_args$srv$group_dataset()),
    subj_col = app_args$srv$subjid_var
  )

  test_that(
    "boxplot chart is included according to selection" |>
      vdoc[["add_spec"]](c(specs$boxplot_module$boxplot_chart, specs$boxplot_module$composition)),
    {
      expected <- list(
        ds = expected_ds,
        violin = inputs[[ID$INPUT$VCHECK]],
        show_points = inputs[[ID$INPUT$SPCHECK]],
        log_project_y = inputs[[ID$INPUT$Y_PROJECTION_CHECK]]
      )
      # Ignoring title_data on purpose it should be tested somewhere else
      exported <- shiny::isolate(exported_test_values[[BP$ID$CHART]][["arguments"]]())
      exported[["title_data"]] <- NULL
      expect_identical(exported, expected)

      plot <- app$get_value(output = ID$OUTPUT$CHART)
      expect_true("src" %in% names(plot))
    }
  )

  # Set up the clicks for the app so tables have content

  # get bounding box function

  # In boxplot when testing clicks tables reset, only listings one.
  # Reason is unknown.
  # It seems to reset randomly after other actions happen mainly setting the other click or taking snapshots
  # It must be set and checked one after the other.

  test_that(
    "listing table appears according to click" |>
      vdoc[["add_spec"]](c(specs$boxplot_module$data_listing, specs$boxplot_module$composition)),
    {
      listing <- shiny::isolate(exported_test_values[[BP$ID$TABLE_LISTING]]$render())[["x"]][["data"]]
      expect_identical(unique(as.character(listing[[CNT$CAT]])), "PARCAT2")
      expect_identical(unique(as.character(listing[[CNT$PAR]])), "PARAM23")
      expect_identical(unique(as.character(listing[[CNT$MAIN_GROUP]])), "B")
      expect_identical(unique(as.character(listing[[CNT$SUB_GROUP]])), "B")
      expect_identical(unique(as.character(listing[[CNT$PAGE_GROUP]])), "B")
    }
  )

  test_that(
    "single listing table appears according to double click" |>
      vdoc[["add_spec"]](c(specs$boxplot_module$single_listing, specs$boxplot_module$composition)),
    {
      listing <- shiny::isolate(exported_test_values[[BP$ID$TABLE_SINGLE_LISTING]]$render())[["x"]][["data"]]
      expect_identical(unique(as.character(listing[[CNT$SBJ]])), "7")
    }
  )

  test_that(
    "count table appears" |>
      vdoc[["add_spec"]](c(specs$boxplot_module$data_count, specs$boxplot_module$composition)),
    {
      listing <- shiny::isolate(exported_test_values[[BP$ID$TABLE_COUNT]]$render())[["x"]][["data"]]
      expect_snapshot(listing, cran = TRUE)
    }
  )

  test_that(
    "summary table appears" |>
      vdoc[["add_spec"]](c(specs$boxplot_module$data_summary, specs$boxplot_module$composition)),
    {
      listing <- shiny::isolate(exported_test_values[[BP$ID$TABLE_SUMMARY]]$render())[["x"]][["data"]]
      expect_snapshot(listing, cran = TRUE)
    }
  )

  test_that(
    "significance table appears" |>
      vdoc[["add_spec"]](c(specs$boxplot_module$data_significance, specs$boxplot_module$composition)),
    {
      listing <- shiny::isolate(exported_test_values[[BP$ID$TABLE_SIGNIFICANCE]]$render())[["x"]][["data"]]
      expect_snapshot(listing, cran = TRUE)
    }
  )

  test_that(
    "bookmark is restored. Clicks are excluded are not bookmarked." |>
      vdoc[["add_spec"]](c(specs$boxplot_module$bookmark, specs$boxplot_module$composition)),
    {
      # URL is automatically updated with the bookmarked URL
      bmk_url <- app$get_js("window.location.href")

      bookmark_app <- suppressWarnings(shinytest2::AppDriver$new(bmk_url))
      bookmark_app$wait_for_idle()
      # Remove excluded bookmarks
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
      app_input_values["not_ebas-click"] <- list(NULL)
      app_input_values["not_ebas-dclick"] <- list(NULL)
      
      bmk_input_values <- bookmark_app$get_values()[["input"]]
      
      expect_identical(app_input_values, bmk_input_values)
    }
  )
})


test_that("default values are set", {
  skip_if_not_running_shiny_tests()

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


test_that("default values are set including analysis flag variables", {
  skip_if_not_running_shiny_tests()

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
  expect_equal(input_values[[ID$INPUT$MGRP]], srv_defaults[["default_main_group"]])
  expect_equal(input_values[[ID$INPUT$SGRP]], srv_defaults[["default_sub_group"]])
  expect_equal(input_values[[ID$INPUT$PGRP]], srv_defaults[["default_page_group"]])
  expect_equal(input_values[[ID$INPUT$ANLFL]], "ANLFL1")
})
