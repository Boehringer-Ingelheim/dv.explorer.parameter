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
    CLICK = tns(CH_ID$CHART, HM2SVG$CLICK)
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

fail_if_app_not_started <- function() {
  if (is.null(root_app)) rlang::abort("App could not be started")
}

test_that("correlation chart is included according to selection" |>
  vdoc[["add_spec"]](c(specs$corr_hm_module$correlation_chart, specs$corr_hm_module$composition)), {
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

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

  chart <- app$get_html(paste0("#", ID$OUTPUT$CHART))
  expect_snapshot(chart, cran = TRUE)
  listing_contents <- app$get_value(export = tns("listing_contents"))
  expect_snapshot(listing_contents, cran = TRUE)
})

# Set up the clicks for the app so tables have content

# get bounding box function

# Clicks are sometimes reset.
# Reason is unknown.
# It seems to reset randomly after other actions happen mainly setting the other click or taking snapshots
# It must be set and checked one after the other.

test_that(
  "scatter chart appears according to click" |>
    vdoc[["add_spec"]](c(specs$corr_hm_module$scatter_chart, specs$corr_hm_module$composition)),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()

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

    click <- list(x = 1, y = 2)

    app$set_inputs(!!ID$INPUT$CLICK := click, allow_no_input_binding_ = TRUE)
    app$wait_for_idle()
    chart <- app$get_value(output = ID$OUTPUT$SCATTER)

    expect_snapshot(chart, cran = TRUE)
  }
)

test_that("bookmark is restored. Clicks are excluded" |>
  vdoc[["add_spec"]](c(specs$corr_hm_module$bookmark)), {
  # Lots of out of memory warnings because the bookmark is too long. Repair, leave, or keep?
  testthat::skip_if_not(run_shiny_tests)
  fail_if_app_not_started()
  skip_if_suspect_check()

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
# nolint end
