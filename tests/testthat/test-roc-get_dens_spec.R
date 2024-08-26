# nolint start
test_that("produce dens spec (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$density$facets,
      specs$roc$outputs$density$axis,
      specs$roc$outputs$density$plot
    )
  ), {
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P1", "P1", "P2", "P2")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G1", "G1", "G2", "G2", "G2", "G2")),
    !!CNT_ROC$RVAL := factor(c("A", "A", "B", "B", "A", "A", "A", "A")),
    !!CNT_ROC$DENS_X := c(0, 1, 2, 3, 4, 10, 2, 3),
    !!CNT_ROC$DENS_Y := c(0, 1, 2, 3, 4, 5, 2, 3)
  )

  attr(ds[[CNT_ROC$PPAR]], "label") <- "Parameter"
  attr(ds[[CNT_ROC$GRP]], "label") <- "Group"

  spec <- get_dens_spec(ds, FALSE, 50)
  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})

test_that("produce dens spec ungrouped (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$density$facets,
      specs$roc$outputs$density$axis,
      specs$roc$outputs$density$plot
    )
  ), {
  snap_file_svg <- list(path = tempfile(fileext = ".svg"), name = "ungrouped_spec.svg")
  # snap_file_png <- list(path = tempfile(fileext = ".png"), name = "ungrouped_spec.png")
  announce_snapshot_file(path = snap_file_svg[["path"]], name = snap_file_svg[["name"]])
  # announce_snapshot_file(path = snap_file_png[["path"]], name = snap_file_png[["name"]])

  ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P1", "P1", "P2", "P2")),
    !!CNT_ROC$RVAL := factor(c("A", "A", "B", "B", "A", "A", "A", "A")),
    !!CNT_ROC$DENS_X := c(0, 1, 2, 3, 4, 10, 2, 3),
    !!CNT_ROC$DENS_Y := c(0, 1, 2, 3, 4, 5, 2, 3)
  )

  attr(ds[[CNT_ROC$PPAR]], "label") <- "Parameter"

  spec <- get_dens_spec(ds, FALSE, 50)
  expect_snapshot(spec %>% vegawidget::vw_as_json())

  vegawidget::vw_write_svg(spec, path = snap_file_svg[["path"]]) %>% suppressWarnings()
  # vegawidget::vw_write_png(spec, path = snap_file_png[["path"]]) %>% suppressWarnings()

  expect_snapshot_file(snap_file_svg[["path"]], cran = TRUE, name = snap_file_svg[["name"]])
  # expect_snapshot_file(snap_file_png[["path"]], cran = TRUE, name = snap_file_png[["name"]])
})

# nolint end
