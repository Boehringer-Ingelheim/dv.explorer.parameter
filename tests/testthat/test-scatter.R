# bp_subset_data ----

test_that("sp_subset_data subsets and merges a bm and group dataset", {
  # CONSIDER Break in to several tests one for each case? Maybe less Arrange in test?
  # Check at once:
  # - Labels are respected
  # - Level dropping and reordering
  # - Rename and group selection

  # BM dataset ----

  bm_df <- tibble::as_tibble(expand.grid(
    cat = factor(c("CA", "CB", "CC")),
    par = factor(c("P1", "P2", "P3")),
    vis = factor(c("V1", "V2", "V3")),
    sbj = factor(1:2)
  ))
  # Remove parameter added by expand.grid
  attr(bm_df, "out.attrs") <- NULL # nolint

  bm_df[["par"]] <- factor(paste0(as.character(bm_df[["cat"]]), "-", as.character(bm_df[["par"]])))
  bm_df[["y_val"]] <- paste0(
    "y",
    bm_df[["par"]],
    "-",
    bm_df[["sbj"]],
    "-",
    bm_df[["vis"]]
  )
  bm_df[["x_val"]] <- paste0(
    "x",
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
    x_val = "XVAL",
    y_val = "YVAL"
  )

  bm_df <- set_lbls(bm_df, label_list)

  # group dataset ----

  grp_df <- tibble::tibble(
    sbj = factor(1:2),
    a = 1:2,
    b = 4:5,
    c = 7:8
  )

  label_list <- c(sbj = "SBJ", a = "A", b = "B", c = "C")

  grp_df <- set_lbls(grp_df, label_list)

  grp_vect <- stats::setNames("a", CNT$MAIN_GROUP)


  actual_output <- sp_subset_data(
    x_cat = "CB",
    y_cat = "CA",
    cat_col = "cat",
    x_par = "CB-P2",
    y_par = "CA-P1",
    par_col = "par",
    x_val_col = "x_val",
    y_val_col = "y_val",
    x_vis = "V1",
    y_vis = "V2",
    vis_col = "vis",
    group_vect = grp_vect,
    bm_ds = bm_df,
    group_ds = grp_df,
    subj_col = "sbj"
  )

  expected_output <- data.frame(row.names = 1:2)
  expected_output[[CNT$SBJ]] <- factor(c(1, 2))
  expected_output[[CNT$X_VAL]] <- c("xCB-P2-1-V1", "xCB-P2-2-V1")
  expected_output[[CNT$Y_VAL]] <- c("yCA-P1-1-V2", "yCA-P1-2-V2")

  expected_output[[CNT$MAIN_GROUP]] <- c(1, 2)

  expected_output <- tibble::as_tibble(expected_output, rownames = NULL)

  expected_label_list <- stats::setNames(
    c("SBJ", "CB-P2 [XVAL]", "CA-P1 [YVAL]", "A"),
    c(CNT$SBJ, CNT$X_VAL, CNT$Y_VAL, CNT$MAIN_GROUP)
  )

  expected_output <- set_lbls(expected_output, expected_label_list)


  expect_equal(actual_output, expected_output)
})

test_that("sp_subset_data errors when there is more than one row per sbj,cat,par,vis combination", {
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
    sp_subset_data(
      x_cat = "A",
      y_cat = "A",
      cat_col = "cat",
      x_par = "B",
      y_par = "B",
      par_col = "par",
      x_vis = "V1",
      y_vis = "V1",
      vis_col = "vis",
      x_val_col = "val",
      y_val_col = "val",
      group_vect = c(),
      bm_ds = bm_df,
      group_ds = grp_df,
      subj_col = "sbj"
    ),
    regexp = CMN$MSG$VALIDATE$BM_TOO_MANY_ROWS,
    fixed = TRUE
  )
})

test_that("sp_subset_data errors when there is more than row per subject in group_ds", {
  bm_df <- tibble::tibble(
    sbj = factor(c(1)),
    cat = factor(c("A")),
    par = factor(c("B")),
    vis = factor(c("V1")),
    val = 1
  )

  grp_df <- tibble::tibble(
    sbj = factor(c(1, 1)),
    a = 1:2
  )

  expect_error(
    sp_subset_data(
      x_cat = "A",
      y_cat = "A",
      cat_col = "cat",
      x_par = "B",
      y_par = "B",
      par_col = "par",
      x_vis = "V1",
      y_vis = "V1",
      vis_col = "vis",
      x_val_col = "val",
      y_val_col = "val",
      group_vect = c(),
      bm_ds = bm_df,
      group_ds = grp_df,
      subj_col = "sbj"
    ),
    regexp = CMN$MSG$VALIDATE$GROUP_TOO_MANY_ROWS,
    fixed = TRUE
  )
})

test_that("sp_subset_data errors when the returned dataset has 0 rows", {
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
    sp_subset_data(
      x_cat = "A",
      y_cat = "A",
      cat_col = "cat",
      x_par = "NONEXISTANT",
      y_par = "B",
      par_col = "par",
      x_vis = "V1",
      y_vis = "V1",
      vis_col = "vis",
      x_val_col = "val",
      y_val_col = "val",
      group_vect = c(),
      bm_ds = bm_df,
      group_ds = grp_df,
      subj_col = "sbj"
    ),
    regexp = CMN$MSG$VALIDATE$NO_ROWS,
    fixed = TRUE
  )
})

test_that("sp_subset_data errors when bm_ds and group_ds share column names after selection", {
  skip("This case is untestable it seems impossible for both ds to have conflicting names as they renamed internally")
})

test_that("sp_subset_data errors when group_vect names are not a subset of CNT$MAIN/SUB_GROUP", {
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
    sp_subset_data(
      x_cat = "A",
      y_cat = "A",
      cat_col = "cat",
      x_par = "B",
      y_par = "B",
      par_col = "par",
      x_vis = "V1",
      y_vis = "V1",
      vis_col = "vis",
      x_val_col = "val",
      y_val_col = "val",
      group_vect = c(NON_EXISTANT = "A"),
      bm_ds = bm_df,
      group_ds = grp_df,
      subj_col = "sbj"
    ),
    regexp = "^Assertion on 'names\\(group_vect\\)'"
  )
})

# bp_boxplot_chart ----
test_that("scatterplot_chart produces a ggplot", {
  df <- data.frame(
    x_value = 1,
    y_value = 1,
    subject_id = 1
  )

  p <- scatterplot_chart(df)

  expect_true("ggplot" %in% class(p))
})

# sp_stats ----

test_that("sp_compute_lm_cor_default returns a list with the regression and correlation", {
  d <- data.frame(row.names = 1:3)
  d[[CNT$X_VAL]] <- c(1, 2, 3)
  d[[CNT$Y_VAL]] <- c(5, 7, 6)
  d[[CNT$SBJ]] <- 7:9
  d[[CNT$MAIN_GROUP]] <- c("A", "B", "C")
  actual <- sp_compute_lm_cor_default(d)

  expect_true(is.list(actual))
  expect_true(setequal(names(actual), c("lm", "cor")))
})
