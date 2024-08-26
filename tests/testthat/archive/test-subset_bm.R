test_that("subset with no parameter repetition in two categories", {
  ds <- tidyr::crossing(
    subj_id = factor(c(1, 1, 2, 2)),
    par = c("A", "B", "C"),
    cat = c("C"),
    visit = c("V1", "V2")
  ) %>% dplyr::mutate(
    value1 = as.double(seq_len(dplyr::n())),
    value2 = as.double(-(seq_len(dplyr::n()))),
  )

  actual <- subset_bds_param(
    ds,
    par = c("A", "B"),
    cat = c("C"),
    vis = "V1",
    par_col = "par",
    cat_col = "cat",
    vis_col = "visit",
    val_col = "value1",
    subj_col = "subj_id"
  )
  expected <- tibble::tibble(
    !!CNT$SBJ := factor(c(1, 1, 2, 2)), # nolint
    !!CNT$PAR := factor(c("A", "B", "A", "B")), # nolint
    !!CNT$VAL := c(1, 3, 7, 9) # nolint
  )

  expect_identical(actual, expected)
})

test_that("subset with parameter repetition in two categories", {
  ds <- tidyr::crossing(
    subj_id = factor(c(1, 1, 2, 2)),
    par = c("A", "B", "C"),
    cat = c("C", "D"),
    visit = c("V1", "V2")
  ) %>% dplyr::mutate(
    value1 = as.double(seq_len(dplyr::n())),
    value2 = as.double(-(seq_len(dplyr::n()))),
  )

  actual <- subset_bds_param(
    ds,
    par = c("A", "B"),
    cat = c("C", "D"),
    vis = "V1",
    par_col = "par",
    cat_col = "cat",
    vis_col = "visit",
    val_col = "value1",
    subj_col = "subj_id"
  )

  expected <- tibble::tibble(
    !!CNT$SBJ := factor(c(1, 1, 2, 2, 1, 1, 2, 2)), # nolint
    !!CNT$PAR := factor(c("C-A", "C-B", "C-A", "C-B", "D-A", "D-B", "D-A", "D-B")), # nolint
    !!CNT$VAL := c(1, 3, 7, 9, 1, 3, 7, 9) # nolint
  )

  expect_identical(actual, expected)
})
