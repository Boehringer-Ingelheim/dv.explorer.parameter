# nolint start
# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared



ID <- poc(
  PRED = poc(
    CAT = "roc-pred_par-cat_val",
    PAR = "roc-pred_par-par_val",
    VAL = "roc-pred_value-val",
    VIS = "roc-pred_visit-val"
  ),
  RESP = poc(
    CAT = "roc-resp_par-cat_val",
    PAR = "roc-resp_par-par_val",
    VAL = "roc-resp_value-val",
    VIS = "roc-resp_visit-val"
  ),
  MISC = poc(
    GRP = "roc-group-val",
    CIQ = "roc-ci_spec_points",
    FSZ = "roc-fig_size",
    IRC = "roc-invert_row_col",
    SRT = "roc-sort_auc",
    XCL = "roc-x_col_metrics",
    PANEL = "roc-chart_panel"
  ),
  OUTPUT = poc(
    INFO_PANEL = "roc-info_panel" %>% structure(tab = NULL),
    ROC_PLOT = "roc-vega_roc_plot" %>% structure(tab = "ROC"),
    HISTO_PLOT = "roc-vega_histo_plot" %>% structure(tab = "Histogram"),
    DENS_PLOT = "roc-vega_density_plot" %>% structure(tab = "Density"),
    RAINCLOUD_PLOT = "roc-raincloud_plot" %>% structure(tab = "Raincloud"),
    METRICS_PLOT = "roc-metrics_plot" %>% structure(tab = "Metrics"),
    EXPLORE_ROC_PLOT = "roc-explore_roc_plot" %>% structure(tab = "Explore ROC"),
    GT_SUMMARY_TABLE = "roc-gt_summary_table" %>% structure(tab = "Summary")
  )
)

inputs <- rlang::list2(
  !!ID$PRED$CAT := "A",
  !!ID$PRED$PAR := c("A1", "A2"),
  !!ID$PRED$VAL := c("AVAL"),
  !!ID$PRED$VIS := c("V1"),
  !!ID$RESP$CAT := "BinA",
  !!ID$RESP$PAR := c("BinA1"),
  !!ID$RESP$VAL := c("CHG1"),
  !!ID$RESP$VIS := c("V2"),
  !!ID$MISC$GRP := c("ARM"),
  !!ID$MISC$CIQ := c(".25; .5"),
  !!ID$MISC$IRC := c(TRUE),
  !!ID$MISC$SRT := c(TRUE),
  !!ID$MISC$XCL := c("norm_rank")
)

inputs2 <- rlang::list2(
  !!ID$PRED$PAR := c("A1", "A2"),
  !!ID$RESP$PAR := c("BinA1")
)
app <- start_app_driver(dv.explorer.parameter:::roc_test_app())
fail_if_app_not_started <- function() {
  if (is.null(app)) rlang::abort("App could not be started")
}

fail_if_app_not_started()

app$set_inputs(!!!inputs)
app$set_inputs(!!!inputs2)

app$wait_for_idle()

test_that("only and all listed outputs are present", {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  outputs <- unlist(app$get_js("$('.shiny-html-output').map(function(_, x) { return x.id; }).get();"))
  checkmate::expect_subset(as.character(ID$OUTPUT), outputs)
})

test_that("charts are created" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$composition,
      specs$roc$outputs$info_panel
    )
  ), {
  # Announce snapshots so they are not removed when skipping
  purrr::walk(
    as.character(ID$OUTPUT), function(o) {
      announce_snapshot_file(name = paste0(o, ".json"))
      announce_snapshot_file(name = paste0(o, "_.png"))
    }
  )

  skip("skipping for now because it causes snapshot differences that can't be reviewed manually")

  # We skip after snapshots are announced otherwise snapshots are removed when the test is skipped
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  # If the charts are shown then it can be inferred that inputs are correctly connected, otherwise it should be a bug-driven approach

  for (o_n in names(ID$OUTPUT)) {
    o <- ID$OUTPUT[[o_n]]
    t <- attr(o, "tab")
    if (!is.null(t)) suppressMessages(app$set_inputs(!!!rlang::list2(!!ID$MISC$PANEL := t)))
    app$wait_for_idle()
    app$expect_values(output = o, name = o)
    ##############################################################
  }
})

test_that("charts are created. Ungrouped" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$composition,
      specs$roc$outputs$info_panel
    )
  ), {
  # Announce snapshots so they are not removed when skipping
  purrr::walk(
    as.character(ID$OUTPUT), function(o) {
      o_ungrouped <- paste0("ungrouped_", o)
      announce_snapshot_file(name = paste0(o_ungrouped, ".json"))
      announce_snapshot_file(name = paste0(o_ungrouped, "_.png"))
    }
  )

  skip("skipping for now because it causes snapshot differences that can't be reviewed manually")

  # We skip after snapshots are announced otherwise snapshots are removed when the test is skipped
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  app$set_inputs(!!!rlang::list2(!!ID$MISC$GRP := "None"))

  # If the charts are shown then it can be inferred that inputs are correctly connected, otherwise it should be a bug-driven approach
  for (o_n in names(ID$OUTPUT)) {
    o <- ID$OUTPUT[[o_n]]
    o_ungrouped <- paste0("ungrouped_", o)
    t <- attr(o, "tab")
    if (!is.null(t)) suppressMessages(app$set_inputs(!!!rlang::list2(!!ID$MISC$PANEL := t)))
    app$wait_for_idle()
    app$expect_values(output = o, name = o_ungrouped)
    ###############################################
  }
})

test_that("Bookmark test" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$bookmark
    )
  ), {
  n <- "bmk"
  announce_snapshot_file(name = paste0(n, ".json"))
  announce_snapshot_file(name = paste0(n, "_.png"))

  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

  url <- paste0(
    app$get_url(),
    "?_inputs_&roc-pred_button_dropmenu=false&roc-resp_button_dropmenu=false&roc-other_button_dropmenu=false&roc-chart_panel=%22ROC%22&roc-pred_button=5&roc-resp_button=2&roc-other_button=3&roc-x_col_metrics=%22norm_rank%22&roc-invert_row_col=false&roc-sort_auc=false&roc-gt_summary_table_alph=false&roc-explore_roc_alph=false&roc-ci_spec_points=%22.25%3B.50%3B.75%22&roc-ci_raw_points=%22%22&roc-fig_size=%22200%22&roc-resp_value-val=%22CHG1%22&roc-pred_value-val=%22AVAL%22&roc-resp_visit-val=%22V2%22&roc-pred_visit-val=%22V1%22&roc-resp_par-par_val=%22BinA1%22&roc-resp_par-cat_val=%22BinA%22&roc-pred_par-par_val=%22A1%22&roc-pred_par-cat_val=%22A%22&roc-group-val=%22COUNTRY%22"
  )
  bmk_app <- shinytest2::AppDriver$new(url)
  bmk_app$wait_for_idle()

  bmk_app$expect_values(output = ID$OUTPUT$ROC_PLOT, name = n)
})
# nolint end
