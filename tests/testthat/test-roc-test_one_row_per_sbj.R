test_that("errors only for repeated combinations", {
  ds1 <- tibble::tibble(
    sbj = c("S1", "S2", "S3")
  )

  ds2 <- tibble::tibble(
    sbj = c("S1", "S2", "S2"),
    grp1 = c("A", "B", "C"),
    grp2 = c("A", "B", "B")
  )

  test_one_row_per_sbj(ds = ds1, subj_col = "sbj") %>%
    expect_true()

  test_one_row_per_sbj(ds = ds2, subj_col = "sbj") %>%
    expect_false()

  test_one_row_per_sbj(ds = ds2, subj_col = "sbj", "grp1") %>%
    expect_true()

  test_one_row_per_sbj(ds = ds2, subj_col = "sbj", "grp2") %>%
    expect_false()
})
