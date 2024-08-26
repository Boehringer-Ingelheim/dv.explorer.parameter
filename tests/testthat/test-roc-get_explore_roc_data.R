# nolint start
test_that("removes cols and expands AUC, respects labels" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$explore_auc$axis,
      specs$roc$outputs$explore_auc$plot
    )
  ), {
  ds <- tibble::tibble(
    !!CNT_ROC$GRP := 0,
    !!CNT_ROC$SPEC := 1,
    !!CNT_ROC$SENS := 1,
    !!CNT_ROC$THR := 1,
    !!CNT_ROC$AUC := list(c(1, 2, 3))
  )

  # We onlyh care that labels are respected though this is not a real case
  attr(ds[[CNT_ROC$GRP]], "label") <- "dummy"

  expected_ds <- tibble::tibble(
    !!CNT_ROC$GRP := 0,
    !!CNT_ROC$AUC := 2,
    !!CNT_ROC$L_AUC := 1,
    !!CNT_ROC$U_AUC := 3
  )

  attr(expected_ds[[CNT_ROC$GRP]], "label") <- "dummy"

  get_explore_roc_data(ds) %>%
    expect_identical(
      expected_ds
    )
})

# nolint end
