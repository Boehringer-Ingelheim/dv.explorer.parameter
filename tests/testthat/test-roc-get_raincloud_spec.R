# nolint start
test_that("produce raincloud spec (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$raincloud$facets,
      specs$roc$outputs$raincloud$axis,
      specs$roc$outputs$raincloud$plot
    )
  ), {
  withr::local_seed(1234)
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  area_ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P2", "P2", "P2", "P2", "P1", "P1", "P1", "P1", "P2", "P2", "P2", "P2")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G1", "G1", "G1", "G1", "G1", "G1", "G2", "G2", "G2", "G2", "G2", "G2", "G2", "G2")),
    !!CNT_ROC$RVAL := factor(c("A", "A", "B", "B", "A", "A", "B", "B", "A", "A", "B", "B", "A", "A", "B", "B")),
    !!CNT_ROC$DENS_X := c(1, 21, 0, 5, 2, 10, 2, 3, 0, 1, 0, 1, 2, 3, 2, 3),
    !!CNT_ROC$DENS_Y := c(1, 21, 0, 5, 2, 10, 2, 3, 0, 1, 0, 1, 2, 3, 2, 3)
  )

  quantile_ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2")),
    !!CNT_ROC$RVAL := factor(c("A", "B", "A", "B")),
    mean = c(-2, 1, 1, 2),
    q05 = mean - 2,
    q25 = mean - 1,
    q50 = mean - .5,
    q75 = mean + 1,
    q95 = mean + 2
  )

  point_ds <- tibble::tibble(
    !!CNT_ROC$SBJ := factor(c("S1", "S2", "S1", "S2", "S1", "S1", "S2", "S2")), # Subject ID is not considered in this case
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P2", "P2", "P2", "P2")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2", "G1", "G1", "G2", "G2")),
    !!CNT_ROC$RVAL := factor(c("A", "B", "A", "B", "A", "B", "A", "B")),
    !!CNT_ROC$PVAL := c(1, 2, 3, 4, 5, 6, 7, 8) / 2,
    !!CNT_ROC$RPAR := factor("R1")
  )

  attr(area_ds[[CNT_ROC$PPAR]], "label") <- "Parameter"
  attr(point_ds[[CNT_ROC$RPAR]], "label") <- "Response"

  spec <- get_raincloud_spec(area_ds = area_ds, quantile_ds = quantile_ds, point_ds = point_ds, param_as_cols = FALSE, fig_size = 50)
  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})

test_that("produce raincloud spec. Ungrouped. (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$raincloud$facets,
      specs$roc$outputs$raincloud$axis,
      specs$roc$outputs$raincloud$plot
    )
  ), {
  withr::local_seed(1234)
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "ungrouped_spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "ungrouped_spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  area_ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P2", "P2", "P2", "P2", "P1", "P1", "P1", "P1", "P2", "P2", "P2", "P2")),
    !!CNT_ROC$RVAL := factor(c("A", "A", "B", "B", "A", "A", "B", "B", "A", "A", "B", "B", "A", "A", "B", "B")),
    !!CNT_ROC$DENS_X := c(1, 21, 0, 5, 2, 10, 2, 3, 0, 1, 0, 1, 2, 3, 2, 3),
    !!CNT_ROC$DENS_Y := c(1, 21, 0, 5, 2, 10, 2, 3, 0, 1, 0, 1, 2, 3, 2, 3)
  )

  quantile_ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RVAL := factor(c("A", "B", "A", "B")),
    mean = c(-2, 1, 1, 2),
    q05 = mean - 2,
    q25 = mean - 1,
    q50 = mean - .5,
    q75 = mean + 1,
    q95 = mean + 2
  )

  point_ds <- tibble::tibble(
    !!CNT_ROC$SBJ := factor(c("S1", "S2", "S1", "S2", "S1", "S1", "S2", "S2")), # Subject ID is not considered in this case
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P2", "P2", "P2", "P2")),
    !!CNT_ROC$RVAL := factor(c("A", "B", "A", "B", "A", "B", "A", "B")),
    !!CNT_ROC$PVAL := c(1, 2, 3, 4, 5, 6, 7, 8) / 2,
    !!CNT_ROC$RPAR := factor("R1")
  )

  attr(area_ds[[CNT_ROC$PPAR]], "label") <- "Parameter"
  attr(point_ds[[CNT_ROC$RPAR]], "label") <- "Response"

  spec <- get_raincloud_spec(area_ds = area_ds, quantile_ds = quantile_ds, point_ds = point_ds, param_as_cols = FALSE, fig_size = 50)
  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})
# nolint end
