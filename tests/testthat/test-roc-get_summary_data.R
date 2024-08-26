# nolint start
test_that("function is applied per parameter and group" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$summary
    )
  ), {
  ds_roc_curve <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P2")),
    !!CNT_ROC$GRP := factor(c("G1", "G2", "G1")),
    !!CNT_ROC$AUC := list(c(1, 2, 3), c(4, 5, 6), c(7, 8, 9)),
    !!CNT_ROC$DIR := c("1", "2", "3"),
    !!CNT_ROC$LEV := list(c("a", "b"), c("c", "d"), c("e", "f"))
  )

  # Test explicitely for repeated oc titles with same parameter and group related to DVCD-3109 ahyodae
  ds_roc_oc <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P2")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G1")),
    !!CNT_ROC$OC_SPEC := factor(paste(.data[[CNT_ROC$PPAR]], .data[[CNT_ROC$GRP]], sep = "-")),
    !!CNT_ROC$OC_TITLE := "Youden"
  )

  ds_list <- list(
    roc_curve = ds_roc_curve,
    roc_ci = NA,
    roc_optimal_cut = ds_roc_oc
  )

  expected_ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P2")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G1")),
    !!CNT_ROC$AUC := c(2, 2, 5, 8),
    !!CNT_ROC$DIR := c("1", "1", "2", "3"),
    !!CNT_ROC$LEV := list(c("a", "b"), c("a", "b"), c("c", "d"), c("e", "f")),
    !!CNT_ROC$L_AUC := c(1, 1, 4, 7),
    !!CNT_ROC$U_AUC := c(3, 3, 6, 9),
    !!CNT_ROC$OC_SPEC := factor(paste(.data[[CNT_ROC$PPAR]], .data[[CNT_ROC$GRP]], sep = "-")),
    !!CNT_ROC$OC_TITLE := "Youden"
  )

  get_summary_data(ds_list) %>%
    expect_identical(
      expected_ds
    )
})

test_that("function is applied per parameter and group. No grouping." |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$summary
    )
  ), {
  ds_roc_curve <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2")),
    !!CNT_ROC$AUC := list(c(1, 2, 3), c(4, 5, 6)),
    !!CNT_ROC$DIR := c("1", "2"),
    !!CNT_ROC$LEV := list(c("a", "b"), c("c", "d"))
  )

  # Test explicitely for repeated oc titles with same parameter and group related to DVCD-3109 ahyodae
  ds_roc_oc <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P2")),
    !!CNT_ROC$OC_SPEC := factor(paste(.data[[CNT_ROC$PPAR]], sep = "-")),
    !!CNT_ROC$OC_TITLE := "Youden"
  )

  ds_list <- list(
    roc_curve = ds_roc_curve,
    roc_ci = NA,
    roc_optimal_cut = ds_roc_oc
  )

  expected_ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P2")),
    !!CNT_ROC$AUC := c(2, 2, 5),
    !!CNT_ROC$DIR := c("1", "1", "2"),
    !!CNT_ROC$LEV := list(c("a", "b"), c("a", "b"), c("c", "d")),
    !!CNT_ROC$L_AUC := c(1, 1, 4),
    !!CNT_ROC$U_AUC := c(3, 3, 6),
    !!CNT_ROC$OC_SPEC := factor(paste(.data[[CNT_ROC$PPAR]], sep = "-")),
    !!CNT_ROC$OC_TITLE := "Youden"
  )

  get_summary_data(ds_list) %>%
    expect_identical(
      expected_ds
    )
})
# nolint end
