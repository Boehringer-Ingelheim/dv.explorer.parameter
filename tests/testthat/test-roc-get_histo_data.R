# nolint start
test_that("function is applied per parameter and group" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$histogram$facets,
      specs$roc$outputs$histogram$axis,
      specs$roc$outputs$histogram$plot
    )
  ), {
  testthat::expect_snapshot(tibble::tibble(
    !!CNT_ROC$SBJ := factor(c("S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1")), # Subject ID is not considered in this case
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P1", "P1", "P1", "P1", "P3", "P3", "P3", "P3")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G1", "G1", "G2", "G2", "G2", "G2", "G1", "G1", "G1", "G1")),
    !!CNT_ROC$PVAL := c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
    !!CNT_ROC$RVAL := factor(c("A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B")),
    !!CNT_ROC$RPAR := factor("R1")
  ) %>% get_histo_data())
})

test_that("function is applied per parameter. No grouping" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$histogram$facets,
      specs$roc$outputs$histogram$axis,
      specs$roc$outputs$histogram$plot
    )
  ), {
  testthat::expect_snapshot(tibble::tibble(
    !!CNT_ROC$SBJ := factor(c("S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1", "S1")), # Subject ID is not considered in this case
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P1", "P1", "P1", "P1", "P3", "P3", "P3", "P3")),
    !!CNT_ROC$PVAL := c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
    !!CNT_ROC$RVAL := factor(c("A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B")),
    !!CNT_ROC$RPAR := factor("R1")
  ) %>% get_histo_data())
})
# nolint end
