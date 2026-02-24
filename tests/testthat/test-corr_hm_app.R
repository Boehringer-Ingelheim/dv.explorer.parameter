# nolint start
# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc( # nolint
  INPUT = poc(
    CAT = tns(CH_ID$MULTI_PAR_VIS, paste0(MPVS$ID$CAT_PREFIX, 1)),
    PAR = tns(CH_ID$MULTI_PAR_VIS, paste0(MPVS$ID$PAR_PREFIX, 1)),
    VIS = tns(CH_ID$MULTI_PAR_VIS, paste0(MPVS$ID$VIS_PREFIX, 1)),
    VAL = tns(CH_ID$PAR_VALUE_TRANSFORM, "val"),
    CORR = tns(CH_ID$CORR_METHOD),
    CLICK = tns(CH_ID$CHART, HM2SVG$CLICK),
    ANLFL = tns(CH_ID$ANLFL_FILTER, "val")
  ),
  OUTPUT = poc(
    CHART = tns(CH_ID$CHART, HM2SVG$CHART),
    SCATTER = tns(CH_ID$SCATTER),
    TABPANEL = tns(BP$ID$TAB_TABLES),
    TABLES = poc(
      CORRELATION_LISTING = tns(CH_ID$TABLE_CORRELATION_LISTING) %>%
        structure(tab = CH_MSG$LABEL$TABLE_CORRELATION_LISTING)
    )
  )
)

root_app <- start_app_driver(dv.explorer.parameter::mock_app_corr_hm())
on.exit(if ("stop" %in% names(root_app)) root_app$stop())

if (is.null(root_app)) {
  rlang::abort("App could not be started")
}

skip_if_not_running_shiny_tests()

local({
  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$VIS]] <- "VISIT2"
  inputs[[ID$INPUT$CORR]] <- "Spearman"

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  # Set up the clicks for the app so tables have content

  # get bounding box function

  click <- list(x = 1, y = 2)
  app$set_inputs(!!ID$INPUT$CLICK := click, allow_no_input_binding_ = TRUE)

  exported <- app$get_values(export = TRUE)[["export"]]

  test_that(
    "correlation chart is included according to selection" |>
      vdoc[["add_spec"]](c(specs$corr_hm_module$correlation_chart, specs$corr_hm_module$composition)),
    {
      chart_args <- shiny::isolate(exported[["not_ebas-chart-output_arguments"]][[HM2SVG$CHART]][["arguments"]]())
      chart_args <- chart_args[!names(chart_args) %in% c("ns", "pal_fun")]
      expect_snapshot(chart_args, cran = TRUE)
      chart_html <- app$get_html(paste0("#", ID$OUTPUT$CHART))
      expect_true(grepl("^<div id=\"not_ebas-chart-chart\"", chart_html))
    }
  )

    test_that(
      "table is included according to selection" |>
        vdoc[["add_spec"]](c(specs$corr_hm_module$correlation_chart, specs$corr_hm_module$composition)),
      {
        listing_args <- shiny::isolate(exported[["not_ebas-output_arguments"]][[CH_ID$TABLE_CORRELATION_LISTING]][[
          "arguments"
        ]]())
        expect_snapshot(listing_args, cran = TRUE)
        listing_html <- app$get_html(paste0("#", ID$OUTPUT$TABLES$CORRELATION_LISTING))
        expect_true(grepl("^<div class=\"datatables", listing_html))
      }
    )

  test_that(
    "scatter chart appears according to click" |>
      vdoc[["add_spec"]](c(specs$corr_hm_module$scatter_chart, specs$corr_hm_module$composition)),
    {
      scatter_args <- shiny::isolate(exported[["not_ebas-output_arguments"]][[CH_ID$SCATTER]][[
        "arguments"
      ]]())
      expect_snapshot(scatter_args, cran = TRUE)

      scatter_html <- app$get_value(output = ID$OUTPUT$SCATTER)[["html"]]
      expect_true(grepl("^<svg", scatter_html))      
    }
  )
})

test_that("bookmark is restored. Clicks are excluded" |>
  vdoc[["add_spec"]](c(specs$corr_hm_module$bookmark)), {
  # Lots of out of memory warnings because the bookmark is too long. Repair, leave, or keep?
  skip_if_not_running_shiny_tests()
  
  app <- shinytest2::AppDriver$new(root_app$get_url())

  inputs <- list()
  inputs[[ID$INPUT$CAT]] <- "PARCAT2"
  inputs[[ID$INPUT$VAL]] <- "VALUE2"
  inputs[[ID$INPUT$VIS]] <- "VISIT2"
  inputs[[ID$INPUT$CORR]] <- "spearman"

  # Set in two steps because a prior selector is required
  inputs2 <- list()
  inputs2[[ID$INPUT$PAR]] <- c("PARAM22", "PARAM23")

  app$set_inputs(!!!inputs)
  app$wait_for_idle()
  app$set_inputs(!!!inputs2)
  app$wait_for_idle()

  # URL is automatically updated with the bookmarked URL
  bmk_url <- app$get_js("window.location.href")

  bookmark_app <- suppressWarnings(shinytest2::AppDriver$new(bmk_url))
  bookmark_app$wait_for_idle()
  app_input_values <- app$get_values()[["input"]]
  bmk_input_values <- bookmark_app$get_values()[["input"]]
  expect_identical(app_input_values, bmk_input_values)
})

test_that("default values are set", {
  skip_if_not_running_shiny_tests()
  
  ui_defaults <- list(
    default_corr_method = "spearman",
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_visit = "VISIT2"
  )

  srv_defaults <- list(
    default_value = "VALUE2"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_corr_hm(
        ui_defaults = !!ui_defaults,
        srv_defaults = !!srv_defaults
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$CORR]], ui_defaults[["default_corr_method"]])
  expect_equal(input_values[[ID$INPUT$CAT]], ui_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], ui_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$VIS]], ui_defaults[["default_visit"]])
  expect_equal(input_values[[ID$INPUT$VAL]], srv_defaults[["default_value"]])
})



test_that("default values are set including analysis flag variables", {
  skip_if_not_running_shiny_tests()
  
  ui_defaults <- list(
    default_corr_method = "spearman",
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_visit = "VISIT2"
  )

  srv_defaults <- list(
    default_value = "VALUE2"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_corr_hm(
        ui_defaults = !!ui_defaults,
        srv_defaults = !!srv_defaults,
        anlfl_flags = TRUE
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$CORR]], ui_defaults[["default_corr_method"]])
  expect_equal(input_values[[ID$INPUT$CAT]], ui_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], ui_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$VIS]], ui_defaults[["default_visit"]])
  expect_equal(input_values[[ID$INPUT$VAL]], srv_defaults[["default_value"]])
  expect_equal(input_values[[ID$INPUT$ANLFL]], "ANLFL1")
})



# nolint end

