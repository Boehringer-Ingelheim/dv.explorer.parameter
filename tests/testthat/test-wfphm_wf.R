# nolint start
# Static

local({
  group_dataset <-
    tibble::tibble(
      NUMERIC1 = c(1, 2, 3),
      NUMERIC2 = c(1, 2, 3) * 10,
      GROUP1 = factor(c("a", "b", "c")),
      GROUP2 = factor(c("aa", "bb", "cc")),
      SUBJECT = factor(c(1, 2, 3))
    )

  group_dataset <- set_lbls(group_dataset, get_lbls_robust(group_dataset))

  r <- wfphm_wf_subset_data_cont(
    val_col = "NUMERIC1",
    color_col = "GROUP1",
    group_ds = group_dataset,
    subj_col = "SUBJECT"
  )

  test_that("wfphm_wf_subset_data_cont subsets the selected column", {
    expect_identical(r[[CNT$VAL]], group_dataset[["NUMERIC1"]])
    expect_identical(r[[CNT$MAIN_GROUP]], group_dataset[["GROUP1"]])
  })

  test_that("wfphm_wf_subset_data_cont includes the label column", {
    expect_identical(r[["label"]], as.character(r[[CNT$MAIN_GROUP]]))
  })

  test_that("wfphm_wf_subset_data_cont x levels are set according to the selected column", {
    expect_equal(levels(r[[CNT$SBJ]]), c("3", "2", "1"))
  })


  test_that("wfphm_wf_subset_data_cont raises an error with repeated subjects" |>
    vdoc[["add_spec"]](c(
      specs$wfphm$wf$only_one_height_value,
      specs$wfphm$wf$only_one_grouping_value
    )
    ), {
    group_dataset <-
      tibble::tibble(
        NUMERIC1 = c(1, 2, 3),
        GROUP1 = factor(c("a", "b", "c")),
        SUBJECT = factor(c(2, 2, 3))
      )

    testthat::expect_error(
      wfphm_wf_subset_data_cont(
        "NUMERIC1",
        "GROUP1",
        group_dataset,
        "SUBJECT"
      ),
      class = "validation"
    )
  })
})

local({
  bm_dataset <-
    tibble::tibble(
      NUMERIC = c(1, 1, 2, 2, 3, 3),
      NUMERIC2 = c(2, 8, 4, 9, 6, 10),
      CATEGORY = factor(c("C", "C", "C", "C", "C", "C")),
      PARAMETER = factor(c("A", "B", "A", "B", "3 HAS NO A value", "B")),
      SUBJECT = factor(c(1, 1, 2, 2, 3, 3)),
      VISIT = factor(c("A", "B", "A", "B", "A", "B")),
    )
  group_dataset <-
    tibble::tibble(
      NUMERIC1 = c(1, 2, 3),
      NUMERIC2 = c(1, 2, 3) * 10,
      GROUP1 = factor(c("a", "b", "c")),
      GROUP2 = factor(c("aa", "bb", "cc")),
      SUBJECT = factor(c(1, 2, 3))
    )

  r <- wfphm_wf_subset_data_par(
    cat = "C",
    cat_col = "CATEGORY",
    par = "A",
    par_col = "PARAMETER",
    val_col = "NUMERIC",
    vis = "A",
    vis_col = "VISIT",
    color_col = "GROUP1",
    bm_ds = bm_dataset,
    group_ds = group_dataset,
    subj_col = "SUBJECT"
  )

  test_that("wfphm_wf_subset_data_par subsets the selected category", {
    expect_true(setequal(r[[CNT$CAT]], c("C")))
  })

  test_that("wfphm_wf_subset_data_par subsets the selected parameter", {
    expect_true(setequal(r[[CNT$PAR]], c("A")))
  })

  test_that("wfphm_wf_subset_data_par subsets the selected group", {
    expect_true(setequal(r[[CNT$MAIN_GROUP]], group_dataset[["GROUP1"]]))
  })

  test_that("wfphm_wf_subset_data_par includes the label column", {
    expect_true(setequal(levels(r[["label"]]), as.character(group_dataset[[CNT$VAL]])))
  })

  test_that("wfphm_wf_subset_data_par x levels are set according to the selected column", {
    expect_equal(levels(r[[CNT$SBJ]]), c("2", "1", "3"))
  })


  test_that("wfphm_wf_subset_data_par raises an error with repeated subjects" |>
    vdoc[["add_spec"]](c(
      specs$wfphm$wf$only_one_height_value,
      specs$wfphm$wf$only_one_grouping_value
    )
    ), {
    bm_dataset <-
      tibble::tibble(
        NUMERIC = c(1, 1, 2, 2, 3, 3),
        NUMERIC2 = c(2, 8, 4, 9, 6, 10),
        CATEGORY = factor(c("C", "C", "C", "C", "C", "C")),
        PARAMETER = factor(c("A", "B", "A", "B", "3 HAS NO A/B value", "B")),
        SUBJECT = factor(c(1, 1, 1, 2, 3, 3)),
        VISIT = factor(c("A", "B", "A", "B", "A", "B")),
      )

    group_dataset <-
      tibble::tibble(
        NUMERIC1 = c(1, 2, 3),
        NUMERIC2 = c(1, 2, 3) * 10,
        GROUP1 = factor(c(1, 2, 3)),
        GROUP2 = factor(c("a", "b", "c")),
        SUBJECT = factor(c(1, 2, 3))
      )

    testthat::expect_error(
      wfphm_wf_subset_data_par(
        cat = "C",
        cat_col = "CATEGORY",
        par = "A",
        par_col = "PARAMETER",
        val_col = "NUMERIC",
        vis = "A",
        vis_col = "VISIT",
        color_col = "GROUP1",
        bm_ds = bm_dataset,
        group_ds = group_dataset,
        subj_col = "SUBJECT"
      ),
      class = "validation"
    )
  })
})


local({
  data <- data.frame(row.names = 1)
  data[[CNT$SBJ]] <- factor(1)
  data[[CNT$VAL]] <- structure(1, label = "Value Label")
  data[[CNT$MAIN_GROUP]] <- 1
  data[[CNT$PAR]] <- factor("P")
  data[[CNT$VIS]] <- factor("V")
  data[["color"]] <- "c"
  data[["label"]] <- "l"

  r <- wfphm_wf_rename_cols(data)

  test_that("wfphm_wf_rename_cols renames and selects columns", {
    expect_equal(names(r), c("x", "y", "z", "label", "color"))
  })

  test_that("wfphm_wf_rename_cols sets y column when visit value is present" |>
    vdoc[["add_spec"]](c(
      specs$wfphm$wf$plot_y_axis_label
    )
    ), {
    expect_equal(get_lbl(r, "y"), "P (Value Label) at V")
  })

  test_that("wfphm_wf_rename_cols sets y column when visit value is not present", {
    data_bis <- data
    data_bis[[CNT$VIS]] <- NULL
    r <- wfphm_wf_rename_cols(data_bis)
    expect_equal(get_lbl(r, "y"), "P (Value Label)")
  })
})

local({
  data <- data.frame(row.names = 1:3)
  data[[CNT$SBJ]] <- factor(c(1, 2, 3))
  data[[CNT$VAL]] <- c(1, 2, 3)
  data[[CNT$PAR]] <- factor("P")
  data[["color"]] <- c("1", "2", "3")
  data[["label"]] <- c("1", "2", "3")

  r <- wfphm_wf_apply_outliers(data, ll = 1.1, ul = 2.9)

  test_that("wfphm_wf_apply_outliers marks values above and below ul and ll as outliers" %>%
    vdoc[["add_spec"]](c(
      specs$wfphm$wf$outliers
    )
    ), {
    expect_identical(r[["color"]], c("gray", NA, "gray"))
    expect_identical(r[["label"]], c("outlier", 2, "outlier"))
  })
})

# App
# WFPHM en conjunto
# Linkar specs


component <- "wfphm-wf"
# Steps
# 1. Start an app with AppDriver. We will not navigate using this driver but connect to it with other drivers.
#   - We do this to avoid creating the app in the background manually, but just delegate it to AppDriver.
# 2. Get the app url from the AppDriver.
# 3. Start a driver with a new session per test.
# Reason: This allows starting test in clean sessions without restarting the app (restarting apps is really time
# consuming).
# Possible problems: If the app process in the background itself crashes in a given test, following tests will crash.
#
# TEST RUN IN INDEPENDENT SESSIONS BUT NOT INDEPENDENT APPS

root_app <- start_app_driver(rlang::quo({
  srv_args <- list(
    bm_dataset = shiny::reactive({
      tibble::tibble(
        NUMERIC = c(1, 1, 2, 2, 3, 3),
        NUMERIC2 = c(2, 8, 4, 9, 6, 10),
        CATEGORY = factor(c("C", "C", "C", "C", "C", "C")),
        PARAMETER = factor(c("A", "B", "A", "B", "3 HAS NO A/B value", "B")),
        SUBJECT = factor(c(1, 1, 2, 2, 3, 3)),
        VISIT = factor(c("A", "B", "A", "B", "A", "B")),
      )
    }),
    group_dataset = shiny::reactive({
      tibble::tibble(
        NUMERIC1 = c(1, 2, 3),
        NUMERIC2 = c(1, 2, 3) * 10,
        GROUP1 = factor(c(1, 2, 3)),
        GROUP2 = factor(c("a", "b", "c")),
        SUBJECT = factor(c(1, 2, 3))
      )
    }),
    margin = c(top = 30, bottom = 30, left = 30, right = 30),
    cat_var = "CATEGORY",
    par_var = "PARAMETER",
    visit_var = "VISIT",
    subjid_var = "SUBJECT",
    value_vars = c(ORG = "NUMERIC", ORG2 = "NUMERIC2")
  )

  mock_app_wf(srv_args = srv_args)
}))
on.exit(if ("stop" %in% names(root_app)) root_app$stop())

fail_if_app_not_started <- function() {
  if (is.null(root_app)) rlang::abort("App could not be started")
}

tns <- tns_factory("not_ebas")

C <- pack_of_constants(
  CHECK = tns(WFPHM_ID$WF$CHECK),
  CONT = tns(WFPHM_ID$WF$CONT, "val"),
  GROUP = tns(WFPHM_ID$WF$GROUP, "val"),
  LL_A = tns(WFPHM_ID$WF$OUTLIER, "54dcf7ce_A-ll"),
  UL_A = tns(WFPHM_ID$WF$OUTLIER, "54dcf7ce_A-ul"),
  LL_NUMERIC = tns(WFPHM_ID$WF$OUTLIER, "e81cb189_NUMERIC-ll"),
  UL_NUMERIC = tns(WFPHM_ID$WF$OUTLIER, "e81cb189_NUMERIC-ul"),
  CAT = tns(WFPHM_ID$WF$PAR, "cat_val"),
  PAR = tns(WFPHM_ID$WF$PAR, "par_val"),
  VALUE = tns(WFPHM_ID$WF$VALUE, "val"),
  VISIT = tns(WFPHM_ID$WF$VISIT, "val"),

  # This two elements use interntal knowledge of imod.
  # This couples both thing which is undesirable but allowed for the moment.
  CONTAINER = "#not_ebas-chart-d3_container",
  SVG_JS_QUERY = "document.querySelector('#not_ebas-chart-d3_bar').innerHTML;"
)

test_that(
  "wfphm_wf presents a plot when using a continous variable from group dataset" %>%
    vdoc[["add_spec"]](c(
      specs$wfphm$wf$height_selection$numeric,
      specs$wfphm$wf$grouping_selection,
      specs$wfphm$wf$plot,
      specs$wfphm$wf$plot_x_axis,
      specs$wfphm$wf$plot_x_axis_sorted,
      specs$wfphm$wf$plot_y_axis,
      specs$wfphm$wf$plot_bar_color,
      specs$wfphm$wf$plot_bar_label
    )
    ),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()

    app <- shinytest2::AppDriver$new(root_app$get_url())
    app$set_inputs(!!C$CHECK := TRUE)
    app$set_inputs(!!C$GROUP := "GROUP1")
    app$set_inputs(!!C$CONT := "NUMERIC1")
    app$wait_for_idle()
    expect_r2d3_svg(app, list(list(svg = C$SVG_JS_QUERY, container = C$CONTAINER, n = 1)))
  }
)

test_that(
  "wfphm_wf presents a plot when using a parameter variable from bm dataset"
  %>%
    vdoc[["add_spec"]](c(
      specs$wfphm$wf$height_selection$parameter,
      specs$wfphm$wf$grouping_selection,
      specs$wfphm$wf$plot,
      specs$wfphm$wf$plot_x_axis,
      specs$wfphm$wf$plot_x_axis_sorted,
      specs$wfphm$wf$plot_y_axis,
      specs$wfphm$wf$plot_bar_color,
      specs$wfphm$wf$plot_bar_label
    )
    ),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()

    app <- shinytest2::AppDriver$new(root_app$get_url())
    app$set_inputs(!!C$CHECK := FALSE)
    app$set_inputs(!!C$CAT := "C")
    app$wait_for_idle()
    app$set_inputs(!!C$PAR := "A")
    app$set_inputs(!!C$VALUE := "NUMERIC")
    app$set_inputs(!!C$GROUP := "GROUP1")
    app$set_inputs(!!C$VISIT := "A")
    app$wait_for_idle()
    app$wait_for_idle()
    expect_r2d3_svg(app, list(list(svg = C$SVG_JS_QUERY, container = C$CONTAINER, n = 1)))
  }
)

local({
  app <- shinytest2::AppDriver$new(root_app$get_url())
  app$set_inputs(!!C$CHECK := FALSE)
  app$set_inputs(!!C$CAT := "C")
  app$wait_for_idle()
  app$set_inputs(!!C$PAR := "A")
  app$set_inputs(!!C$VALUE := "NUMERIC")
  app$set_inputs(!!C$GROUP := "GROUP1")
  app$set_inputs(!!C$VISIT := "A")
  app$wait_for_idle()
  app$wait_for_idle()

  test_that("wfphm_wf returns a margin list", {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    x <- app$get_values()
    margin <- shiny::isolate(x[["export"]][[tns("r")]][["margin"]]())
    expect_true(setequal(names(margin), c("top", "bottom", "left", "right")))
  })

  test_that("wfphm_wf returns a sorting for the x axis", {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    x <- app$get_values()
    sorted_x <- shiny::isolate(x[["export"]][[tns("r")]][["sorted_x"]]())
    expect_identical(sorted_x, c("2", "1", "3"))
  })
})
# nolint end
