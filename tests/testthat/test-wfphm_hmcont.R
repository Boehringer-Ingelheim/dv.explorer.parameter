# nolint start
# Static

local({
  data <- data.frame(
    USUBJID = factor(1:3),
    NUM1 = 11:13,
    NUM2 = 21:23,
    NUM3 = 31:33
  )

  selected_col <- c("NUM1", "NUM2")
  sorted_x <- c(3, 1, 2)

  r <- wfphm_hmcont_subset(
    data,
    selected_col,
    subjid_var = "USUBJID",
    sorted_x = sorted_x
  )

  test_that(
    "wfphm_hmcont_subset selects the correct columns" |>
      vdoc[["add_spec"]](
        c(
          specs$wfphm$hmcont$value_selection,
          specs$wfphm$hmcont$plot_x_axis,
          specs$wfphm$hmcont$plot_y_axis
        )
      ),
    {
      expect_true(setequal(levels(r[["y"]]), c("NUM1", "NUM2")))
    }
  )

  test_that("wfphm_hmcont_subset includes a label column" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmcont$plot_tile_label
      )
    ), {
    expect_identical(as.character(r[["z"]]), r[["label"]])
  })


  test_that("wfphm_hmcont_subset sorted_x is reflected in the level order" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmcont$plot_x_axis_sorted
      )
    ), {
    expect_identical(levels(r[["x"]]), as.character(sorted_x))
  })

  test_that("wfphm_hmcont_subset sorted_x throws a validation error when subjects are repeated" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmcont$only_one_value
      )
    ), {
    data <- data.frame(
      USUBJID = factor(c(1, 1, 3)),
      NUM1 = 11:13,
      NUM2 = 21:23,
      NUM3 = 31:33
    )

    testthat::expect_error(
      wfphm_hmcont_subset(
        data,
        selected_col,
        subjid_var = "USUBJID",
        sorted_x = sorted_x
      ),
      class = "validation"
    )
  })
})


# Reactive

root_app <- start_app_driver(rlang::quo({
  data <- data.frame(
    USUBJID = factor(1:3),
    NUM1 = 11:13,
    NUM2 = 21:23,
    NUM3 = 31:33
  )

  srv_args <- list(
    dataset = shiny::reactive(data),
    subjid_var = "USUBJID",
    sorted_x = shiny::reactive(c("3", "1", "2")),
    margin = shiny::reactive(c(top = 100, bottom = 101, left = 102, right = 103))
  )

  mock_app_hmcont(srv_args = srv_args)
}))
on.exit(if ("stop" %in% names(root_app)) root_app$stop())

fail_if_app_not_started <- function() {
  if (is.null(root_app)) rlang::abort("App could not be started")
}

tns <- tns_factory("not_ebas")

C <- pack_of_constants(
  CONT = tns(WFPHM_ID$HMCONT$CONT, "val"),

  # This two elements use internal knowledge of imod.
  # This couples both thing which is undesirable but allowed for the moment.
  CONTAINER = "#not_ebas-chart-d3_container",
  SVG_JS_QUERY = "document.querySelector('#not_ebas-chart-d3_heatmap').innerHTML;"
)


local({
  app <- shinytest2::AppDriver$new(root_app$get_url())
  on.exit(app$stop, add = TRUE)
  do.call(app$set_inputs, setNames(list("NUM1"), C$CONT))
  app$wait_for_idle()

  test_that(
    "wfphm-hmcont presents a plot" |>
      vdoc[["add_spec"]](
        c(
          specs$wfphm$hmcont$plot
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
    "wfphm-hmcont returns margin list",
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
