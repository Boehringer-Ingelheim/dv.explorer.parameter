# nolint start
test_that("produce explore roc spec (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$explore_auc$axis,
      specs$roc$outputs$explore_auc$plot
    )
  ), {
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2")),
    !!CNT_ROC$AUC := c(.1, .2, .3, .4),
    !!CNT_ROC$L_AUC := c(0, .1, .2, .3),
    !!CNT_ROC$U_AUC := c(.2, .3, .4, .5)
  )

  attr(ds[[CNT_ROC$PPAR]], "label") <- "Parameter"
  attr(ds[[CNT_ROC$GRP]], "label") <- "Group"

  spec <- get_explore_roc_spec(ds, 50, sort_alph = FALSE)

  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})

test_that("produce explore roc spec. Ungrouped (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$explore_auc$axis,
      specs$roc$outputs$explore_auc$plot
    )
  ), {
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "ungrouped_spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "ungrouped_spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$AUC := c(.1, .2),
    !!CNT_ROC$L_AUC := c(0, .1),
    !!CNT_ROC$U_AUC := c(.2, .3)
  )

  attr(ds[[CNT_ROC$PPAR]], "label") <- "Parameter"

  spec <- get_explore_roc_spec(ds, 50, sort_alph = FALSE)

  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})

test_that("produce explore roc spec. Alphabetical order (Snapshot)", {
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "sort_alph_spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2")),
    !!CNT_ROC$AUC := c(.1, .2, .3, .4),
    !!CNT_ROC$L_AUC := c(0, .1, .2, .3),
    !!CNT_ROC$U_AUC := c(.2, .3, .4, .5)
  )

  attr(ds[[CNT_ROC$PPAR]], "label") <- "Parameter"
  attr(ds[[CNT_ROC$GRP]], "label") <- "Group"

  spec <- get_explore_roc_spec(ds, 50, sort_alph = TRUE)

  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})

test_that("produce explore roc spec. too many rows (Snapshot)", {
  ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(1:1001)
  )

  get_explore_roc_spec(ds, 50, sort_alph = FALSE) %>%
    expect_error(ROC_MSG$ROC$VALIDATE$TOO_MANY_ROWS_EXPLORE, fixed = TRUE)
})
# nolint end
