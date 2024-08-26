# nolint start
test_that("produce roc spec (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$roc_curve$facets,
      specs$roc$outputs$roc_curve$axis,
      specs$roc$outputs$roc_curve$plot,
      specs$roc$outputs$roc_curve$optimal_cut,
      specs$roc$outputs$roc_curve$CI
    )
  ), {
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  roc_curve <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2")),
    !!CNT_ROC$SPEC := c(.1, .3, .11, .33),
    !!CNT_ROC$SENS := c(.2, .4, .22, .44),
    !!CNT_ROC$AUC := list(c(0, .1, .2), c(.1, .2, .3), c(.2, .3, .4), c(.5, .6, .7)),
    !!CNT_ROC$THR := c(1, 2, 3, 4),
    !!CNT_ROC$DIR := c("1", "2", "3", "4"),
    !!CNT_ROC$LEV := list(c("a", "b"), c("c", "d"), c("e", "f"), c("g", "h"))
  )

  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Parameter"
  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Group"

  roc_ci <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2")),
    !!CNT_ROC$CI_SPEC := c(.0, .01, .02, .03),
    !!CNT_ROC$CI_SENS := c(.1, .11, .12, .13),
    !!CNT_ROC$CI_L_SPEC := c(.2, .21, .22, .23),
    !!CNT_ROC$CI_L_SENS := c(.3, .31, .32, .33),
    !!CNT_ROC$CI_U_SPEC := c(.4, .41, .42, .43),
    !!CNT_ROC$CI_U_SENS := c(.5, .51, .52, .53)
  )

  roc_oc <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2")),
    !!CNT_ROC$OC_TITLE := c("OC_P1_G1", "OC_P2_G1", "OC_P1_G2", "OC_P2_G2"),
    !!CNT_ROC$OC_SPEC := c(.1, .2, .3, .4),
    !!CNT_ROC$OC_SENS := c(.5, .6, .7, .8),
    !!CNT_ROC$OC_L_SPEC := c(.2, .21, .22, .23),
    !!CNT_ROC$OC_L_SENS := c(.3, .31, .32, .33),
    !!CNT_ROC$OC_U_SPEC := c(.4, .41, .42, .43),
    !!CNT_ROC$OC_U_SENS := c(.5, .51, .52, .53),
    !!CNT_ROC$OC_THR := c(1, 2, 3, 4)
  )

  ds_list <-
    list(
      roc_curve = roc_curve,
      roc_ci = roc_ci,
      roc_optimal_cut = roc_oc
    )

  spec <- get_roc_spec(ds_list, FALSE, 50)

  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})

test_that("produce ungrouped roc spec (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$roc_curve$facets,
      specs$roc$outputs$roc_curve$axis,
      specs$roc$outputs$roc_curve$plot,
      specs$roc$outputs$roc_curve$optimal_cut,
      specs$roc$outputs$roc_curve$CI
    )
  ), {
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "ungrouped_spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "ungrouped_spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  roc_curve <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$SPEC := c(.1, .3, .11, .33),
    !!CNT_ROC$SENS := c(.2, .4, .22, .44),
    !!CNT_ROC$AUC := list(c(0, .1, .2), c(.1, .2, .3), c(.2, .3, .4), c(.5, .6, .7)),
    !!CNT_ROC$THR := c(1, 2, 3, 4),
    !!CNT_ROC$DIR := c("1", "2", "3", "4"),
    !!CNT_ROC$LEV := list(c("a", "b"), c("c", "d"), c("e", "f"), c("g", "h"))
  )

  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Parameter"
  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Group"

  roc_ci <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$CI_SPEC := c(.0, .01, .02, .03),
    !!CNT_ROC$CI_SENS := c(.1, .11, .12, .13),
    !!CNT_ROC$CI_L_SPEC := c(.2, .21, .22, .23),
    !!CNT_ROC$CI_L_SENS := c(.3, .31, .32, .33),
    !!CNT_ROC$CI_U_SPEC := c(.4, .41, .42, .43),
    !!CNT_ROC$CI_U_SENS := c(.5, .51, .52, .53)
  )

  roc_oc <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$OC_TITLE := c("OC_P1", "OC_P2", "OC_P1", "OC_P2"),
    !!CNT_ROC$OC_SPEC := c(.1, .2, .3, .4),
    !!CNT_ROC$OC_SENS := c(.5, .6, .7, .8),
    !!CNT_ROC$OC_L_SPEC := c(.2, .21, .22, .23),
    !!CNT_ROC$OC_L_SENS := c(.3, .31, .32, .33),
    !!CNT_ROC$OC_U_SPEC := c(.4, .41, .42, .43),
    !!CNT_ROC$OC_U_SENS := c(.5, .51, .52, .53),
    !!CNT_ROC$OC_THR := c(1, 2, 3, 4)
  )

  ds_list <-
    list(
      roc_curve = roc_curve,
      roc_ci = roc_ci,
      roc_optimal_cut = roc_oc
    )

  spec <- get_roc_spec(ds_list, FALSE, 50)

  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})

test_that("produce roc sorted spec (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$roc_curve$facets,
      specs$roc$outputs$roc_curve$axis,
      specs$roc$outputs$roc_curve$plot,
      specs$roc$outputs$roc_curve$optimal_cut,
      specs$roc$outputs$roc_curve$CI
    )
  ), {
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "sorted_spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "sorted_spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  roc_curve <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2")),
    !!CNT_ROC$SPEC := c(.1, .3, .11, .33),
    !!CNT_ROC$SENS := c(.2, .4, .22, .44),
    !!CNT_ROC$AUC := list(c(0, .1, .2), c(.1, .2, .3), c(.2, .3, .4), c(.5, .6, .7)),
    !!CNT_ROC$THR := c(1, 2, 3, 4),
    !!CNT_ROC$DIR := c("1", "2", "3", "4"),
    !!CNT_ROC$LEV := list(c("a", "b"), c("c", "d"), c("e", "f"), c("g", "h"))
  )

  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Parameter"
  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Group"

  roc_ci <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2")),
    !!CNT_ROC$CI_SPEC := c(.0, .01, .02, .03),
    !!CNT_ROC$CI_SENS := c(.1, .11, .12, .13),
    !!CNT_ROC$CI_L_SPEC := c(.2, .21, .22, .23),
    !!CNT_ROC$CI_L_SENS := c(.3, .31, .32, .33),
    !!CNT_ROC$CI_U_SPEC := c(.4, .41, .42, .43),
    !!CNT_ROC$CI_U_SENS := c(.5, .51, .52, .53)
  )

  roc_oc <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2")),
    !!CNT_ROC$OC_TITLE := c("OC_P1_G1", "OC_P2_G1", "OC_P1_G2", "OC_P2_G2"),
    !!CNT_ROC$OC_SPEC := c(.1, .2, .3, .4),
    !!CNT_ROC$OC_SENS := c(.5, .6, .7, .8),
    !!CNT_ROC$OC_L_SPEC := c(.2, .21, .22, .23),
    !!CNT_ROC$OC_L_SENS := c(.3, .31, .32, .33),
    !!CNT_ROC$OC_U_SPEC := c(.4, .41, .42, .43),
    !!CNT_ROC$OC_U_SENS := c(.5, .51, .52, .53),
    !!CNT_ROC$OC_THR := c(1, 2, 3, 4)
  )

  ds_list <-
    list(
      roc_curve = roc_curve,
      roc_ci = roc_ci,
      roc_optimal_cut = roc_oc
    )

  spec <- get_roc_sorted_spec(ds_list, FALSE, 50)

  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})

test_that("produce ungrouped roc sorted spec (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$roc_curve$facets,
      specs$roc$outputs$roc_curve$axis,
      specs$roc$outputs$roc_curve$plot,
      specs$roc$outputs$roc_curve$optimal_cut,
      specs$roc$outputs$roc_curve$CI
    )
  ), {
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "ungrouped_sorted_spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "ungrouped_sorted_spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  roc_curve <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$SPEC := c(.1, .3, .11, .33),
    !!CNT_ROC$SENS := c(.2, .4, .22, .44),
    !!CNT_ROC$AUC := list(c(0, .1, .2), c(.1, .2, .3), c(.2, .3, .4), c(.5, .6, .7)),
    !!CNT_ROC$THR := c(1, 2, 3, 4),
    !!CNT_ROC$DIR := c("1", "2", "3", "4"),
    !!CNT_ROC$LEV := list(c("a", "b"), c("c", "d"), c("e", "f"), c("g", "h"))
  )

  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Parameter"
  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Group"

  roc_ci <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$CI_SPEC := c(.0, .01, .02, .03),
    !!CNT_ROC$CI_SENS := c(.1, .11, .12, .13),
    !!CNT_ROC$CI_L_SPEC := c(.2, .21, .22, .23),
    !!CNT_ROC$CI_L_SENS := c(.3, .31, .32, .33),
    !!CNT_ROC$CI_U_SPEC := c(.4, .41, .42, .43),
    !!CNT_ROC$CI_U_SENS := c(.5, .51, .52, .53)
  )

  roc_oc <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$OC_TITLE := c("OC_P1", "OC_P2", "OC_P1", "OC_P2"),
    !!CNT_ROC$OC_SPEC := c(.1, .2, .3, .4),
    !!CNT_ROC$OC_SENS := c(.5, .6, .7, .8),
    !!CNT_ROC$OC_L_SPEC := c(.2, .21, .22, .23),
    !!CNT_ROC$OC_L_SENS := c(.3, .31, .32, .33),
    !!CNT_ROC$OC_U_SPEC := c(.4, .41, .42, .43),
    !!CNT_ROC$OC_U_SENS := c(.5, .51, .52, .53),
    !!CNT_ROC$OC_THR := c(1, 2, 3, 4)
  )

  ds_list <-
    list(
      roc_curve = roc_curve,
      roc_ci = roc_ci,
      roc_optimal_cut = roc_oc
    )

  spec <- get_roc_sorted_spec(ds_list, FALSE, 50)

  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})
# nolint end
