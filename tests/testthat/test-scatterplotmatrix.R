# bp_subset_data ----

test_that("spm_subset_data subsets and merges a bm and group dataset", {
  # CONSIDER Break in to several tests one for each case? Maybe less Arrange in test?
  # Check at once:
  # - Labels are respected
  # - Level dropping and reordering
  # - Rename and group selection

  # BM dataset ----

  bm_df <- tibble::as_tibble(expand.grid(
    cat = factor(c("CA", "CB")),
    par = factor(c("P1", "P2")),
    vis = factor(c("V1", "V2")),
    sbj = factor(1:2)
  ))
  # Remove parameter added by expand.grid
  attr(bm_df, "out.attrs") <- NULL # nolint

  bm_df[["par"]] <- factor(paste0(as.character(bm_df[["cat"]]), "-", as.character(bm_df[["par"]])))
  bm_df[["val"]] <- paste0(
    bm_df[["par"]],
    "-",
    bm_df[["sbj"]],
    "-",
    bm_df[["vis"]]
  )

  label_list <- list(
    cat = "CAT",
    par = "PAR",
    vis = "VIS",
    sbj = "SBJ",
    val = "VAL"
  )

  bm_df <- set_lbls(bm_df, label_list)

  # group dataset ----

  grp_df <- tibble::tibble(
    sbj = factor(1:2),
    a = c(1, 1)
  )

  label_list <- c(sbj = "SBJ", a = "A")

  grp_df <- set_lbls(grp_df, label_list)

  grp_vect <- stats::setNames("a", CNT$MAIN_GROUP)


  actual_output <- spm_subset_data(
    cat = c("CB", "CA"),
    cat_col = "cat",
    par = c("CB-P2", "CA-P1"),
    par_col = "par",
    vis = c("V1"),
    vis_col = "vis",
    val_col = "val",
    group_vect = grp_vect,
    bm_ds = bm_df,
    group_ds = grp_df,
    subj_col = "sbj"
  )

  expected_output <- data.frame(row.names = 1:2)
  expected_output[[CNT$VIS]] <- factor("V1")
  expected_output[[CNT$MAIN_GROUP]] <- c(1, 1)
  expected_output[["CA-P1"]] <- c("CA-P1-1-V1", "CA-P1-2-V1")
  expected_output[["CB-P2"]] <- c("CB-P2-1-V1", "CB-P2-2-V1")

  expected_output <- tibble::as_tibble(expected_output, rownames = NULL)

  expected_label_list <- stats::setNames(
    c("A", "VAL", "VAL", "VIS"),
    c(CNT$MAIN_GROUP, "CA-P1", "CB-P2", CNT$VIS)
  )

  expected_output <- set_lbls(expected_output, expected_label_list)

  expect_equal(actual_output, expected_output)
})

test_that("spm_subset_data errors when there is more than one row per sbj,cat,par,vis combination", {
  bm_df <- tibble::tibble(
    sbj = factor(c(1, 1)),
    cat = factor(c("A", "A")),
    par = factor(c("B", "B")),
    vis = factor(c("V1", "V1")),
    val = 1:2
  )

  grp_df <- tibble::tibble(
    sbj = factor(1),
    a = 1
  )

  expect_error(
    spm_subset_data(
      cat = "A",
      cat_col = "cat",
      par = "B",
      par_col = "par",
      vis = "V1",
      vis_col = "vis",
      val_col = "val",
      group_vect = c(),
      bm_ds = bm_df,
      group_ds = grp_df,
      subj_col = "sbj"
    ),
    regexp = CMN$MSG$VALIDATE$BM_TOO_MANY_ROWS,
    fixed = TRUE
  )
})

test_that("spm_subset_data errors when there is more than row per subject in group_ds", {
  bm_df <- tibble::tibble(
    sbj = factor(c(1)),
    cat = factor(c("A", "A")),
    par = factor(c("B", "C")),
    vis = factor(c("V1")),
    val = 1
  )

  grp_df <- tibble::tibble(
    sbj = factor(c(1, 1)),
    a = 1:2
  )

  expect_error(
    spm_subset_data(
      cat = "A",
      cat_col = "cat",
      par = c("B", "C"),
      par_col = "par",
      vis = "V1",
      vis_col = "vis",
      val_col = "val",
      group_vect = stats::setNames("a", CNT$MAIN_GROUP),
      bm_ds = bm_df,
      group_ds = grp_df,
      subj_col = "sbj"
    ),
    regexp = CMN$MSG$VALIDATE$GROUP_TOO_MANY_ROWS,
    fixed = TRUE
  )
})

test_that("spm_subset_data errors when the returned dataset has 0 rows", {
  bm_df <- tibble::tibble(
    sbj = factor(c(1)),
    cat = factor(c("A")),
    par = factor(c("B")),
    vis = factor(c("V1")),
    val = 1
  )

  grp_df <- tibble::tibble(
    sbj = factor(c(1)),
    a = 1
  )

  expect_error(
    spm_subset_data(
      cat = "A",
      cat_col = "cat",
      par = "NON EXISTANT",
      par_col = "par",
      vis = "V1",
      vis_col = "vis",
      val_col = "val",
      group_vect = stats::setNames("a", CNT$MAIN_GROUP),
      bm_ds = bm_df,
      group_ds = grp_df,
      subj_col = "sbj"
    ),
    regexp = CMN$MSG$VALIDATE$NO_ROWS,
    fixed = TRUE
  )
})

test_that("spm_subset_data errors when bm_ds and group_ds share column names after selection", {
  skip("This case is untestable it seems impossible for both ds to have conflicting names as they renamed internally")
})

test_that("spm_subset_data errors when group_vect names are not a subset of CNT$MAIN_GROUP", {
  bm_df <- tibble::tibble(
    sbj = factor(c(1)),
    cat = factor(c("A")),
    par = factor(c("B")),
    vis = factor(c("V1")),
    val = 1
  )

  grp_df <- tibble::tibble(
    sbj = factor(c(1)),
    a = 1
  )

  expect_error(
    bp_subset_data(
      cat = "A",
      cat_col = "cat",
      par = "B",
      par_col = "par",
      vis = "V1",
      vis_col = "vis",
      val_col = "val",
      group_vect = stats::setNames("a", "INCORRECT GROUP NAME"),
      bm_ds = bm_df,
      group_ds = grp_df,
      subj_col = "sbj"
    ),
    regexp = "^Assertion on 'names\\(group_vect\\)'"
  )
})

test_that("spm_subset_data errors when only one parameter is selected", {
  # BM dataset ----

  bm_df <- tibble::as_tibble(expand.grid(
    cat = factor(c("CA", "CB")),
    par = factor(c("P1", "P2")),
    vis = factor(c("V1", "V2")),
    sbj = factor(1:2)
  ))
  # Remove parameter added by expand.grid
  attr(bm_df, "out.attrs") <- NULL # nolint

  bm_df[["par"]] <- factor(paste0(as.character(bm_df[["cat"]]), "-", as.character(bm_df[["par"]])))
  bm_df[["val"]] <- paste0(
    bm_df[["par"]],
    "-",
    bm_df[["sbj"]],
    "-",
    bm_df[["vis"]]
  )

  label_list <- list(
    cat = "CAT",
    par = "PAR",
    vis = "VIS",
    sbj = "SBJ",
    val = "VAL"
  )

  bm_df <- set_lbls(bm_df, label_list)

  # group dataset ----

  grp_df <- tibble::tibble(
    sbj = factor(1:2),
    a = c(1, 1)
  )

  label_list <- c(sbj = "SBJ", a = "A")

  grp_df <- set_lbls(grp_df, label_list)

  grp_vect <- stats::setNames("a", CNT$MAIN_GROUP)

  expect_error(
    spm_subset_data(
      cat = "A",
      cat_col = "cat",
      par = "B",
      par_col = "par",
      vis = "V1",
      vis_col = "vis",
      val_col = "val",
      group_vect = stats::setNames("a", CNT$MAIN_GROUP),
      bm_ds = bm_df,
      group_ds = grp_df,
      subj_col = "sbj"
    ),
    regexp = SPM$MSG$VALIDATE$LESS_THAN_2_PARAMETER,
    fixed = TRUE
  )
})

# scatterplot_matrix_boxplot_chart ----
test_that("scatteplotmatrix_chart produces a ggmatrix", {
  df <- data.frame(
    par_A = c(1, 2, 3),
    par_B = c(2, 1, 3),
    main_group = factor(c(1, 1, 1))
  )

  p <- scatterplotmatrix_chart(df)

  expect_true("ggmatrix" %in% class(p))
})
