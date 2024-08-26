# nolint start
# Static

local({
  data <- expand.grid(
    SUBJID = factor(1:3),
    CAT = factor(1:2),
    PAR = factor(1:2),
    VISIT = factor(sprintf("VISIT%s", 1:2))
  )

  data[["CAT"]] <- factor(sprintf("C%s", data[["CAT"]]))
  data[["PAR"]] <- factor(sprintf("%sP%s", data[["CAT"]], data[["PAR"]]))
  data[["VALUE"]] <- seq_len(nrow(data))
  levels(data[["SUBJID"]]) <- 1:4 # Add subject with no parameter values
  data

  sorted_x <- c("3", "4", "2", "1")
  r <- wfphm_hmpar_subset(
    data = data,
    cat_selection = c("C1", "C2"),
    cat_var = "CAT",
    par_selection = c("C1P1", "C2P2"),
    par_var = "PAR",
    visit_selection = "VISIT1",
    visit_var = "VISIT",
    value_var = "VALUE",
    subjid_var = "SUBJID",
    sorted_x = sorted_x,
    out_criteria = list(C1P1 = list(ll = 1.1, ul = 2.9)),
    scale = get_tr_apply(tr_identity)
  )

  # Completed until here

  test_that(
    "wfphm_hmpar_subset selects the correct parameters" |>
      vdoc[["add_spec"]](
        c(
          specs$wfphm$hmpar$value_selection,
          specs$wfphm$hmpar$plot_x_axis,
          specs$wfphm$hmpar$plot_y_axis,
          specs$wfphm$hmpar$plot_tile_color
        )
      ),
    {
      expect_true(setequal(levels(r[["y"]]), c("C1P1", "C2P2")))
    }
  )

  test_that("wfphm_hmpar_subset includes a label column" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmpar$plot_tile_label
      )
    ), {
    checkmate::expect_set_equal(r[["label"]], c("x", NA_character_))
  })


  test_that("wfphm_hmpar_subset sorted_x is reflected in the level order" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmpar$plot_x_axis_sorted
      )
    ), {
    expect_identical(levels(r[["x"]]), as.character(sorted_x))
  })

  test_that("wfphm_hmpar_subset sorted_x marks outliers" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmpar$outliers
      )
    ), {
    outlier_mask <- r[["label"]] %in% WFPHM_VAL$HMPAR$OUTLIER_LABEL
    expect_true(all(is.na(r[["z"]][outlier_mask])))

    C1P1_mask <- r[["y"]] %in% c("C1P1")
    expect_true(all(r[["z"]][C1P1_mask] %in% c(2, NA)))
  })

  test_that("wfphm_hmpar_subset applies transformation" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmpar$plot_transformation
      )
    ), {
    data <- data.frame(
      SUBJID = factor(1),
      CAT = factor("C1"),
      PAR = factor("P1"),
      VISIT = factor("VISIT1"),
      VALUE = 1
    )

    sorted_x <- levels(data[["SUBJID"]])
    r <- wfphm_hmpar_subset(
      data = data,
      cat_selection = c("C1"),
      cat_var = "CAT",
      par_selection = c("P1"),
      par_var = "PAR",
      visit_selection = "VISIT1",
      visit_var = "VISIT",
      value_var = "VALUE",
      subjid_var = "SUBJID",
      sorted_x = sorted_x,
      out_criteria = NULL,
      scale = get_tr_apply(function(x) {
        2 * x
      })
    )

    expect_equal(r[["z"]], 2)
  })



  test_that("wfphm_hmpar_subset sorted_x throws a validation error when subjects are repeated" |>
    vdoc[["add_spec"]](
      c(
        specs$wfphm$hmpar$only_one_value
      )
    ), {
    data <- expand.grid(
      SUBJID = factor(c(1, 1:3)),
      CAT = factor(1:2),
      PAR = factor(1:2),
      VISIT = factor(sprintf("VISIT%s", 1:2))
    )

    data[["CAT"]] <- factor(sprintf("C%s", data[["CAT"]]))
    data[["PAR"]] <- factor(sprintf("%sP%s", data[["CAT"]], data[["PAR"]]))
    data[["VALUE"]] <- seq_len(nrow(data))
    data

    sorted_x <- c("3", "2", "1")

    testthat::expect_error(
      wfphm_hmpar_subset(
        data = data,
        cat_selection = c("C1", "C2"),
        cat_var = "CAT",
        par_selection = c("C1P1", "C2P2"),
        par_var = "PAR",
        visit_selection = "VISIT1",
        visit_var = "VISIT",
        value_var = "VALUE",
        subjid_var = "SUBJID",
        sorted_x = sorted_x,
        out_criteria = list(C1P1 = list(ll = 1.1, ul = 2.9)),
        scale = get_tr_apply(tr_identity)
      ),
      class = "validation"
    )
  })
})


# Reactive

root_app <- start_app_driver(rlang::quo({
  data <- expand.grid(
    SUBJID = factor(1:3),
    CAT = factor(1:2),
    PAR = factor(1:2),
    VISIT = factor(sprintf("VISIT%s", 1:2))
  )

  data[["CAT"]] <- factor(sprintf("C%s", data[["CAT"]]))
  data[["PAR"]] <- factor(sprintf("%sP%s", data[["CAT"]], data[["PAR"]]))
  data[["VALUE1"]] <- seq_len(nrow(data))
  data[["VALUE2"]] <- seq_len(nrow(data)) + 10
  levels(data[["SUBJID"]]) <- 1:4 # Add subject with no parameter values
  data

  sorted_x <- c("3", "4", "2", "1")

  ui_args <- list(
    tr_choices = names(tr_mapper_def())
  )

  srv_args <- list(
    id = "not_ebas",
    dataset = shiny::reactive(data),
    cat_var = "CAT",
    par_var = "PAR",
    visit_var = "VISIT",
    subjid_var = "SUBJID",
    value_vars = c("VALUE1", "VALUE2"),
    sorted_x = shiny::reactive(sorted_x),
    tr_mapper = tr_mapper_def(),
    margin = shiny::reactive(c(top = 20, bottom = 20, left = 200, right = 20)),
    show_x_ticks = TRUE
  )

  mock_app_hmpar(ui_args = ui_args, srv_args = srv_args)
}))
on.exit(if ("stop" %in% names(root_app)) root_app$stop())

fail_if_app_not_started <- function() {
  if (is.null(root_app)) rlang::abort("App could not be started")
}

tns <- tns_factory("not_ebas")

C <- pack_of_constants(
  CAT = tns(WFPHM_ID$HMPAR$PAR, "cat_val"),
  PAR = tns(WFPHM_ID$HMPAR$PAR, "par_val"),
  VAL = tns(WFPHM_ID$HMPAR$VALUE, "val"),
  VIS = tns(WFPHM_ID$HMPAR$VISIT, "val"),
  TRANS = tns(WFPHM_MSG$HMPAR$TRANSFORMATION),

  # This two elements use internal knowledge of imod.
  # This couples both thing which is undesirable but allowed for the moment.
  CONTAINER = "#not_ebas-chart-d3_container",
  SVG_JS_QUERY = "document.querySelector('#not_ebas-chart-d3_heatmap').innerHTML;"
)


local({
  app <- shinytest2::AppDriver$new(root_app$get_url())
  on.exit(app$stop, add = TRUE)
  do.call(app$set_inputs, setNames(list("C1"), C$CAT))
  app$wait_for_idle()
  do.call(app$set_inputs, setNames(list("C1P1"), C$PAR))
  app$wait_for_idle()

  test_that(
    "wfphm-hmpar presents a plot" |>
      vdoc[["add_spec"]](
        c(
          specs$wfphm$hmpar$plot
        )
      ),
    {
      testthat::skip_if_not(run_shiny_tests)
      fail_if_app_not_started()
      skip_if_suspect_check()
      expect_r2d3_svg(app, list(list(svg = C$SVG_JS_QUERY, container = C$CONTAINER, n = 2)))
    }
  )

  test_that(
    "wfphm-hmpar returns margin list",
    {
      testthat::skip_if_not(run_shiny_tests)
      fail_if_app_not_started()
      skip_if_suspect_check()
      x <- app$get_values()
      margin <- shiny::isolate(x[["export"]][[tns("r")]][["margin"]]())
      expect_true(setequal(names(margin), c("top", "bottom", "left", "right")))
    }
  )

  test_that(
    "wfphm-hmpar x axis ticks are shown or hidden" %>%
      vdoc[["add_spec"]](c(
        specs$wfphm$hmpar$plot_x_axis_ticks
      )
      ),
    {
      testthat::skip_if_not(run_shiny_tests)
      fail_if_app_not_started()
      skip_if_suspect_check()

      expect_identical(app$get_values()[["export"]][["not_ebas-chart_args"]][["x_axis"]], "S")
    }
  )
})
# nolint end
