# nolint start
test_that("produce metric spec (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$metrics$facets,
      specs$roc$outputs$metrics$axis,
      specs$roc$outputs$metrics$plot
    )
  ), {
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P3", "P3")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G1", "G2")),
    !!CNT_ROC$RPAR := factor("R1"),
    score = c(11, 22, 11, 22),
    norm_score = c(111, 222, 111, 222),
    norm_rank = c(1111, 2222, 1111, 2222),
    type = c("A", "B", "A", "B"),
    y = c(1, 2, 1, 2)
  )

  attr(ds[[CNT_ROC$GRP]], "label") <- "Group"
  attr(ds[["score"]], "label") <- "Score"
  attr(ds[["norm_score"]], "label") <- "Normalized Score"
  attr(ds[["norm_rank"]], "label") <- "Normalized Rank"

  limits <- list(
    A = c(-2, 2),
    B = c(-10, 10)
  )

  spec <- get_metric_spec(ds = ds, limits = limits, param_as_cols = FALSE, fig_size = 50, x_col = "norm_score")
  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})

test_that("produce metric spec. Ungrouped. (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$metrics$facets,
      specs$roc$outputs$metrics$axis,
      specs$roc$outputs$metrics$plot
    )
  ), {
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "ungrouped_spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "ungrouped_spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P3")),
    !!CNT_ROC$RPAR := factor("R1"),
    score = c(11, 22),
    norm_score = c(111, 222),
    norm_rank = c(1111, 2222),
    type = c("A", "B"),
    y = c(1, 2)
  )

  attr(ds[["score"]], "label") <- "Score"
  attr(ds[["norm_score"]], "label") <- "Normalized Score"
  attr(ds[["norm_rank"]], "label") <- "Normalized Rank"

  limits <- list(
    A = c(-2, 2),
    B = c(-10, 10)
  )

  spec <- get_metric_spec(ds = ds, limits = limits, param_as_cols = FALSE, fig_size = 50, x_col = "norm_score")
  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})
# nolint end
