# nolint start
# Static

local({
  data <- data.frame(
    USUBJID = factor(1:3),
    CAT1 = factor(c("c11", "c12", "c13")),
    CAT2 = factor(c("c21", "c22", "c23")),
    CAT3 = factor(c("c31", "c32", "c33"))
  )

  selected_col <- c("CAT1", "CAT2")
  color <- "red"
  sorted_x <- c(3, 1, 2)

  r <- wfphm_hmcat_subset(
    data,
    selected_col,
    palette = list(CAT1 = function(x) {
      color
    }),
    subjid_var = "USUBJID",
    sorted_x = sorted_x
  )

  test_that(
    "wfphm_hmcat_subset selects the correct columns" |>
      vdoc[["add_spec"]](
        c(
          specs$wfphm$hmcat$value_selection,
          specs$wfphm$hmcat$plot_x_axis,
          specs$wfphm$hmcat$plot_y_axis
        )
      ),
    {
      expect_true(setequal(levels(r[["y"]]), c("CAT1", "CAT2")))
    }
  )

  test_that("wfphm_hmcat_subset includes a label column" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmcat$plot_tile_label
      )
    ), {
    expect_identical(as.character(r[["z"]]), r[["label"]])
  })

  test_that("wfphm_hmcat_subset column label attribute is correct", {
    color_cat1 <- unique(r[["color"]][r[["y"]] == "CAT1"])
    expect_identical(color_cat1, color)
  })

  test_that("wfphm_hmcat_subset palette is correctly applied" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmcat$plot_tile_color
    )), {
    color_cat1 <- unique(r[["color"]][r[["y"]] == "CAT1"])
    expect_identical(color_cat1, color)
  })

  test_that("wfphm_hmcat_subset sorted_x is reflected in the level order" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmcat$plot_x_axis_sorted
      )
    ), {
    expect_identical(levels(r[["x"]]), as.character(sorted_x))
  })

  test_that("wfphm_hmcat_subset sorted_x throws a validation error when subjects are repeated" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmcat$only_one_value
      )
    ), {
    data <- data.frame(
      USUBJID = factor(c(1, 1, 3)),
      CAT1 = factor(c("c11", "c12", "c13")),
      CAT2 = factor(c("c21", "c22", "c23")),
      CAT3 = factor(c("c31", "c32", "c33"))
    )

    testthat::expect_error(
      wfphm_hmcat_subset(
        data,
        selected_col,
        palette = list(CAT1 = function(x) {
          color
        }),
        subjid_var = "USUBJID",
        sorted_x = sorted_x
      ),
      class = "validation"
    )
  })

  # Bug driven

  test_that("wfphm_hmcat_subset subsest properly with ordered factors", {
    data <- data.frame(
      USUBJID = factor(1:3),
      CAT1 = factor(c("c11", "c12", "c13"), ordered = TRUE),
      CAT2 = factor(c("c21", "c22", "c23")),
      CAT3 = factor(c("c31", "c32", "c33"))
    )

    r <- wfphm_hmcat_subset(
      data,
      "CAT1",
      palette = list(),
      subjid_var = "USUBJID",
      sorted_x = 1:3
    )

    expect_snapshot(r)
  })
})


# Reactive

root_app <- start_app_driver(rlang::quo({
  data <- data.frame(
    USUBJID = factor(1:3),
    CAT1 = factor(c("c11", "c12", "c13")),
    CAT2 = factor(c("c21", "c22", "c23")),
    CAT3 = factor(c("c31", "c32", "c33"))
  )

  srv_args <- list(
    dataset = shiny::reactive(data),
    subjid_var = "USUBJID",
    cat_palette = list(CAT1 = function(x) {
      "red"
    }),
    sorted_x = shiny::reactive(c("3", "1", "2")),
    margin = shiny::reactive(c(top = 100, bottom = 101, left = 102, right = 103))
  )

  mock_app_hmcat(srv_args = srv_args)
}))
on.exit(if ("stop" %in% names(root_app)) root_app$stop())

fail_if_app_not_started <- function() {
  if (is.null(root_app)) rlang::abort("App could not be started")
}

tns <- tns_factory("not_ebas")

C <- pack_of_constants(
  CAT = tns(WFPHM_ID$HMCAT$CAT, "val"),

  # This two elements use internal knowledge of imod.
  # This couples both thing which is undesirable but allowed for the moment.
  CONTAINER = "#not_ebas-chart-d3_container",
  SVG_JS_QUERY = "document.querySelector('#not_ebas-chart-d3_heatmap').innerHTML;"
)


local({
  app <- shinytest2::AppDriver$new(root_app$get_url())
  on.exit(app$stop, add = TRUE)
  do.call(app$set_inputs, setNames(list("CAT1"), C$CAT))
  app$wait_for_idle()

  test_that(
    "wfphm-hmcat presents a plot" |>
      vdoc[["add_spec"]](
        c(
          specs$wfphm$hmcat$plot
        )
      ),
    {
      testthat::skip_if_not(run_shiny_tests)
      fail_if_app_not_started()
      skip_if_suspect_check()
      expect_r2d3_svg(app, list(list(svg = C$SVG_JS_QUERY, container = C$CONTAINER, n = 1)))
    }
  )

  test_that(
    "wfphm-hmcat returns margin list",
    {
      testthat::skip_if_not(run_shiny_tests)
      fail_if_app_not_started()
      skip_if_suspect_check()
      x <- app$get_values()
      margin <- shiny::isolate(x[["export"]][[tns("r")]][["margin"]]())
      expect_true(setequal(names(margin), c("top", "bottom", "left", "right")))
    }
  )
})
# nolint end
