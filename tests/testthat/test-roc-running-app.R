# nolint start
    # TODO: Refactor according to:
    # https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
    # TODO: A failure to start the app will delete all snapshots as they are never declared

    expect_table <- function(x) {      
      expect_true(grepl("<table", app$get_html(paste0("#", x))))
    }

expect_svg <- function(x) {
  expect_true(grepl("<svg", app$get_html(paste0("#", x))))
}

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
    INFO_PANEL = "roc-info_panel" %>% structure(tab = NULL, expect = expect_table),
    ROC_PLOT = "roc-vega_roc_plot" %>% structure(tab = "ROC", expect = expect_svg),
    HISTO_PLOT = "roc-vega_histo_plot" %>% structure(tab = "Histogram", expect = expect_svg),
    DENS_PLOT = "roc-vega_density_plot" %>% structure(tab = "Density", expect = expect_svg),
    RAINCLOUD_PLOT = "roc-raincloud_plot" %>% structure(tab = "Raincloud", expect = expect_svg),
    METRICS_PLOT = "roc-metrics_plot" %>% structure(tab = "Metrics", expect = expect_svg),
    EXPLORE_ROC_PLOT = "roc-explore_roc_plot" %>% structure(tab = "Explore ROC", expect = expect_svg),
    GT_SUMMARY_TABLE = "roc-gt_summary_table" %>% structure(tab = "Summary", expect = expect_table)
  ),
  UNAME_OUTPUT = poc(
    INFO_PANEL = "info_panel",
    ROC_PLOT = "vega_roc_plot",
    HISTO_PLOT = "vega_histo_plot",
    DENS_PLOT = "vega_density_plot",
    RAINCLOUD_PLOT = "raincloud_plot",
    METRICS_PLOT = "metrics_plot",
    EXPLORE_ROC_PLOT = "explore_roc_plot",
    GT_SUMMARY_TABLE = "gt_summary_table"
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

if (is.null(app)) rlang::abort("App could not be started")

app$set_inputs(!!!inputs)
app$set_inputs(!!!inputs2)

app$wait_for_idle()

exported <- app$get_value(export = "roc-output_arguments")

test_that("only and all listed outputs are present", {
  skip_if_not_running_shiny_tests()

  outputs <- unlist(app$get_js("$('.shiny-html-output').map(function(_, x) { return x.id; }).get();"))
  checkmate::expect_subset(as.character(ID$OUTPUT), outputs)
})


local({

  for (o_n in names(ID$OUTPUT)) {
    o <- ID$OUTPUT[[o_n]]
    uo <- ID$UNAME_OUTPUT[[o_n]]
    test_that(
    paste("charts are created", o_n) |>
      vdoc[["add_spec"]](
        c(
          specs$roc$composition,
          specs$roc$outputs$info_panel
        )
      ),
    {
    # METRICS PLOT test is sensitive to being loaded or byte-compiled. When byte compiled piped functions are inlined.
    # The snapshot correspond to the byte compiled version
    expect_snapshot(shiny::isolate(exported[[uo]]()), cran = TRUE, transform = function(x) {
      is_bytecode <- grepl("bytecode", x)
      ifelse(is_bytecode, "<bytecode: RANDOM VALUE - NO SNAPSHOT>", x)
    })

    t <- attr(o, "tab")
    exp <- attr(o, "expect")
    if (!is.null(t)) {
      suppressMessages(app$set_inputs(!!!rlang::list2(!!ID$MISC$PANEL := t)))
    }
    app$wait_for_idle()
    exp(o)
  })
}

})

local({
  inputs <- rlang::list2(    
    !!ID$MISC$GRP := c("None")
  )

  app$set_inputs(!!!inputs)
  app$wait_for_idle()

  on.exit({
    inputs <- rlang::list2(
      !!ID$MISC$GRP := c("ARM")
    )
    app$set_inputs(!!!inputs)
    app$wait_for_idle()
  }, add = TRUE)

  for (o_n in names(ID$OUTPUT)) {
    o <- ID$OUTPUT[[o_n]]
    uo <- ID$UNAME_OUTPUT[[o_n]]
    test_that(
      paste("charts are created. Ungrouped", o_n) |>
        vdoc[["add_spec"]](
          c(
            specs$roc$composition,
            specs$roc$outputs$info_panel
          )
        ),
      {
        # METRICS PLOT test is sensitive to being loaded or byte-compiled. When byte compiled piped functions are inlined.
    # The snapshot correspond to the byte compiled version
    expect_snapshot(shiny::isolate(exported[[uo]]()), cran = TRUE, transform = function(x) {
      is_bytecode <- grepl("bytecode", x)
      ifelse(is_bytecode, "<bytecode: RANDOM VALUE - NO SNAPSHOT>", x)
    })

        t <- attr(o, "tab")
        exp <- attr(o, "expect")
        if (!is.null(t)) {
          suppressMessages(app$set_inputs(!!!rlang::list2(!!ID$MISC$PANEL := t)))
        }
        app$wait_for_idle()
        exp(o)
      }
    )
  }
})

test_that("Bookmark test" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$bookmark
    )
  ), {
  skip_if_not_running_shiny_tests()  

# URL is automatically updated with the bookmarked URL
  bmk_url <- app$get_js("window.location.href")
    
  bookmark_app <- suppressWarnings(shinytest2::AppDriver$new(bmk_url))
  bookmark_app$wait_for_idle()
  app_input_values <- app$get_values()[["input"]]
  bmk_input_values <- bookmark_app$get_values()[["input"]]
  expect_identical(app_input_values, bmk_input_values)
  })
# nolint end
