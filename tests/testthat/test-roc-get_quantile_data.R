# nolint start
test_that("function is applied per parameter and group" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$raincloud$facets,
      specs$roc$outputs$raincloud$axis,
      specs$roc$outputs$raincloud$plot
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

  d_p1_g1_A <- c(1, 3)
  p1_g1_A <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$GRP := factor(c("G1")),
    !!CNT_ROC$RVAL := factor(c("A")),
    mean = mean(d_p1_g1_A),
    q05 = unname(stats::quantile(d_p1_g1_A, probs = .05)),
    q25 = unname(stats::quantile(d_p1_g1_A, probs = .25)),
    q50 = unname(stats::quantile(d_p1_g1_A, probs = .50)),
    q75 = unname(stats::quantile(d_p1_g1_A, probs = .75)),
    q95 = unname(stats::quantile(d_p1_g1_A, probs = .95))
  )

  d_p1_g1_B <- c(2, 4)
  p1_g1_B <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$GRP := factor(c("G1")),
    !!CNT_ROC$RVAL := factor(c("B")),
    mean = mean(d_p1_g1_B),
    q05 = unname(stats::quantile(d_p1_g1_B, probs = .05)),
    q25 = unname(stats::quantile(d_p1_g1_B, probs = .25)),
    q50 = unname(stats::quantile(d_p1_g1_B, probs = .50)),
    q75 = unname(stats::quantile(d_p1_g1_B, probs = .75)),
    q95 = unname(stats::quantile(d_p1_g1_B, probs = .95))
  )

  d_p1_g2_A <- c(5, 7)
  p1_g2_A <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$GRP := factor(c("G2")),
    !!CNT_ROC$RVAL := factor(c("A")),
    mean = mean(d_p1_g2_A),
    q05 = unname(stats::quantile(d_p1_g2_A, probs = .05)),
    q25 = unname(stats::quantile(d_p1_g2_A, probs = .25)),
    q50 = unname(stats::quantile(d_p1_g2_A, probs = .50)),
    q75 = unname(stats::quantile(d_p1_g2_A, probs = .75)),
    q95 = unname(stats::quantile(d_p1_g2_A, probs = .95))
  )

  d_p1_g2_B <- c(6, 8)
  p1_g2_B <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$GRP := factor(c("G2")),
    !!CNT_ROC$RVAL := factor(c("B")),
    mean = mean(d_p1_g2_B),
    q05 = unname(stats::quantile(d_p1_g2_B, probs = .05)),
    q25 = unname(stats::quantile(d_p1_g2_B, probs = .25)),
    q50 = unname(stats::quantile(d_p1_g2_B, probs = .50)),
    q75 = unname(stats::quantile(d_p1_g2_B, probs = .75)),
    q95 = unname(stats::quantile(d_p1_g2_B, probs = .95))
  )

  d_p3_g1_A <- c(9, 11)
  p3_g1_A <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P3")),
    !!CNT_ROC$GRP := factor(c("G1")),
    !!CNT_ROC$RVAL := factor(c("A")),
    mean = mean(d_p3_g1_A),
    q05 = unname(stats::quantile(d_p3_g1_A, probs = .05)),
    q25 = unname(stats::quantile(d_p3_g1_A, probs = .25)),
    q50 = unname(stats::quantile(d_p3_g1_A, probs = .50)),
    q75 = unname(stats::quantile(d_p3_g1_A, probs = .75)),
    q95 = unname(stats::quantile(d_p3_g1_A, probs = .95))
  )

  d_p3_g1_B <- c(10, 12)
  p3_g1_B <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P3")),
    !!CNT_ROC$GRP := factor(c("G1")),
    mean = mean(d_p3_g1_B),
    !!CNT_ROC$RVAL := factor(c("B")),
    q05 = unname(stats::quantile(d_p3_g1_B, probs = .05)),
    q25 = unname(stats::quantile(d_p3_g1_B, probs = .25)),
    q50 = unname(stats::quantile(d_p3_g1_B, probs = .50)),
    q75 = unname(stats::quantile(d_p3_g1_B, probs = .75)),
    q95 = unname(stats::quantile(d_p3_g1_B, probs = .95))
  )

  expected_ds <- dplyr::bind_rows(
    p1_g1_A,
    p1_g1_B,
    p1_g2_A,
    p1_g2_B,
    p3_g1_A,
    p3_g1_B
  )

  get_quantile_data(
    ds
  ) %>%
    expect_identical(
      expected_ds
    )
})

test_that("function is applied per parameter and group. No grouping." |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$raincloud$facets,
      specs$roc$outputs$raincloud$axis,
      specs$roc$outputs$raincloud$plot
    )
  ), {
  ds <- tibble::tibble(
    !!CNT_ROC$SBJ := factor(c("S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1")), # Subject ID is not considered in this case
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P1", "P1", "P1", "P1", "P3", "P3", "P3", "P3")),
    !!CNT_ROC$PVAL := c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
    !!CNT_ROC$RVAL := factor(c("A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B")),
    !!CNT_ROC$RPAR := factor("R1")
  )

  d_p1_A <- c(1, 3, 5, 7)
  p1_A <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$RVAL := factor(c("A")),
    mean = mean(d_p1_A),
    q05 = unname(stats::quantile(d_p1_A, probs = .05)),
    q25 = unname(stats::quantile(d_p1_A, probs = .25)),
    q50 = unname(stats::quantile(d_p1_A, probs = .50)),
    q75 = unname(stats::quantile(d_p1_A, probs = .75)),
    q95 = unname(stats::quantile(d_p1_A, probs = .95))
  )

  d_p1_B <- c(2, 4, 6, 8)
  p1_B <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1")),
    !!CNT_ROC$RVAL := factor(c("B")),
    mean = mean(d_p1_B),
    q05 = unname(stats::quantile(d_p1_B, probs = .05)),
    q25 = unname(stats::quantile(d_p1_B, probs = .25)),
    q50 = unname(stats::quantile(d_p1_B, probs = .50)),
    q75 = unname(stats::quantile(d_p1_B, probs = .75)),
    q95 = unname(stats::quantile(d_p1_B, probs = .95))
  )

  d_p3_A <- c(9, 11)
  p3_A <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P3")),
    !!CNT_ROC$RVAL := factor(c("A")),
    mean = mean(d_p3_A),
    q05 = unname(stats::quantile(d_p3_A, probs = .05)),
    q25 = unname(stats::quantile(d_p3_A, probs = .25)),
    q50 = unname(stats::quantile(d_p3_A, probs = .50)),
    q75 = unname(stats::quantile(d_p3_A, probs = .75)),
    q95 = unname(stats::quantile(d_p3_A, probs = .95))
  )

  d_p3_B <- c(10, 12)
  p3_B <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P3")),
    mean = mean(d_p3_B),
    !!CNT_ROC$RVAL := factor(c("B")),
    q05 = unname(stats::quantile(d_p3_B, probs = .05)),
    q25 = unname(stats::quantile(d_p3_B, probs = .25)),
    q50 = unname(stats::quantile(d_p3_B, probs = .50)),
    q75 = unname(stats::quantile(d_p3_B, probs = .75)),
    q95 = unname(stats::quantile(d_p3_B, probs = .95))
  )

  expected_ds <- dplyr::bind_rows(
    p1_A,
    p1_B,
    p3_A,
    p3_B
  )

  get_quantile_data(
    ds
  ) %>%
    expect_identical(
      expected_ds
    )
})
# nolint end
