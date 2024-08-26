test_that("errors only for parameters under different categories", {
  ill_ds <- tibble::tibble(P = c("1", "2", "1"), C = c("A", "B", "B"))
  correct_ds <- tibble::tibble(P = c("1", "2", "1"), C = c("A", "B", "A"))

  test_one_cat_per_par(ds = correct_ds, cat_col = "C", par_col = "P") %>%
    expect_true()

  test_one_cat_per_par(ds = ill_ds, cat_col = "C", par_col = "P") %>%
    expect_false()
})
