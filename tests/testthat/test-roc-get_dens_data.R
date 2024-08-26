# nolint start
test_that("function is applied per parameter and group" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$density$facets,
      specs$roc$outputs$density$axis,
      specs$roc$outputs$density$plot
    )
  ), {
  ds <- tibble::tibble(
    !!CNT_ROC$SBJ := factor(c("S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1")), # Subject ID is not considered in this case
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P1", "P1", "P1", "P1", "P3", "P3", "P3", "P3")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G1", "G1", "G2", "G2", "G2", "G2", "G1", "G1", "G1", "G1")),
    !!CNT_ROC$PVAL := c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
    !!CNT_ROC$RVAL := factor(c("A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B")),
    !!CNT_ROC$RPAR := factor("R1")
  )

  p1_g1_A <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$GRP := factor(c("G1")),
    !!CNT_ROC$RVAL := factor(c("A")),
    !!CNT_ROC$DENS_X := c(stats::density(c(1, 3))[[c("x")]]),
    !!CNT_ROC$DENS_Y := c(stats::density(c(1, 3))[[c("y")]])
  )

  p1_g1_B <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$GRP := factor(c("G1")),
    !!CNT_ROC$RVAL := factor(c("B")),
    !!CNT_ROC$DENS_X := c(stats::density(c(2, 4))[[c("x")]]),
    !!CNT_ROC$DENS_Y := c(stats::density(c(2, 4))[[c("y")]])
  )

  p1_g2_A <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$GRP := factor(c("G2")),
    !!CNT_ROC$RVAL := factor(c("A")),
    !!CNT_ROC$DENS_X := c(stats::density(c(5, 7))[[c("x")]]),
    !!CNT_ROC$DENS_Y := c(stats::density(c(5, 7))[[c("y")]])
  )

  p1_g2_B <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$GRP := factor(c("G2")),
    !!CNT_ROC$RVAL := factor(c("B")),
    !!CNT_ROC$DENS_X := c(stats::density(c(6, 8))[[c("x")]]),
    !!CNT_ROC$DENS_Y := c(stats::density(c(6, 8))[[c("y")]])
  )

  p3_g1_A <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P3")),
    !!CNT_ROC$GRP := factor(c("G1")),
    !!CNT_ROC$RVAL := factor(c("A")),
    !!CNT_ROC$DENS_X := c(stats::density(c(9, 11))[[c("x")]]),
    !!CNT_ROC$DENS_Y := c(stats::density(c(9, 11))[[c("y")]])
  )

  p3_g1_B <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P3")),
    !!CNT_ROC$GRP := factor(c("G1")),
    !!CNT_ROC$RVAL := factor(c("B")),
    !!CNT_ROC$DENS_X := c(stats::density(c(10, 12))[[c("x")]]),
    !!CNT_ROC$DENS_Y := c(stats::density(c(10, 12))[[c("y")]])
  )




  expected_ds <- dplyr::bind_rows(
    p1_g1_A,
    p1_g1_B,
    p1_g2_A,
    p1_g2_B,
    p3_g1_A,
    p3_g1_B
  )

  get_dens_data(
    ds
  ) %>%
    expect_identical(
      expected_ds
    )
})

test_that("function is applied per parameter and group. No grouping." |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$density$facets,
      specs$roc$outputs$density$axis,
      specs$roc$outputs$density$plot
    )
  ), {
  ds <- tibble::tibble(
    !!CNT_ROC$SBJ := factor(c("S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1")), # Subject ID is not considered in this case
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P1", "P1", "P1", "P1", "P3", "P3", "P3", "P3")),
    !!CNT_ROC$PVAL := c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
    !!CNT_ROC$RVAL := factor(c("A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B")),
    !!CNT_ROC$RPAR := factor("R1")
  )

  p1_A <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$RVAL := factor(c("A")),
    !!CNT_ROC$DENS_X := c(stats::density(c(1, 3, 5, 7))[[c("x")]]),
    !!CNT_ROC$DENS_Y := c(stats::density(c(1, 3, 5, 7))[[c("y")]])
  )

  p1_B <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$RVAL := factor(c("B")),
    !!CNT_ROC$DENS_X := c(stats::density(c(2, 4, 6, 8))[[c("x")]]),
    !!CNT_ROC$DENS_Y := c(stats::density(c(2, 4, 6, 8))[[c("y")]])
  )

  p3_A <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P3")),
    !!CNT_ROC$RVAL := factor(c("A")),
    !!CNT_ROC$DENS_X := c(stats::density(c(9, 11))[[c("x")]]),
    !!CNT_ROC$DENS_Y := c(stats::density(c(9, 11))[[c("y")]])
  )

  p3_B <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P3")),
    !!CNT_ROC$RVAL := factor(c("B")),
    !!CNT_ROC$DENS_X := c(stats::density(c(10, 12))[[c("x")]]),
    !!CNT_ROC$DENS_Y := c(stats::density(c(10, 12))[[c("y")]])
  )

  expected_ds <- dplyr::bind_rows(
    p1_A,
    p1_B,
    p3_A,
    p3_B
  )

  get_dens_data(
    ds
  ) %>%
    expect_identical(
      expected_ds
    )
})
# nolint end
