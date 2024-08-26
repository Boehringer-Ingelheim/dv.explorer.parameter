test_that("tr_apply applies the transformation to each of the groups independently and accepts extra params", {
  x <- tibble::tibble(v = c(0, 1, 2, 3, NA), g = c("A", "A", "B", "B", "B"))
  expect_identical(
    get_tr_apply(sum)(x, "g", "v", na.rm = TRUE),
    tibble::tibble(v = c(1, 1, 5, 5, 5), g = c("A", "A", "B", "B", "B"))
  )
})

test_that("tr_identity returns the argument itself", {
  expect_identical(tr_identity(1), 1)
})

test_that("tr_z_score returns the argument itself", {
  expect_identical(tr_z_score(c(1:3, NA)), c(-1, 0, 1, NA))
})

test_that("tr_z_score transform a column to a zscore grouped by a variable", {
  expect_identical(
    tr_trunc_z_score(c(-1e6, rep(0, 10), NA, 1e6), trunc_min = -2, trunc_max = 2),
    c(-2, rep(0, 10), NA, 2)
  )
})

test_that("tr_min_max applies min max transformation", {
  expect_identical(tr_min_max(c(1:3, NA)), c(0, 1, 2, NA) / 2)
})

test_that("tr_percentize applies percentize transformation", {
  expect_identical(
    tr_percentize(c(1, 5, 4, 20, 3, NA, 20)),
    c(1, 4, 3, 6, 2, NA, 6) / 6 # One less than length because of NA
  )
})

test_that("tr_percentize supports all NA vectors", {
  expect_identical(
    tr_percentize(rep(NA, 10)),
    rep(NA, 10)
  )
})
