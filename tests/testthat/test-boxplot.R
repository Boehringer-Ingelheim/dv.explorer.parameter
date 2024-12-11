# bp_subset_data ----

test_that("bp_subset_data subsets and merges a bm and group dataset", {
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
    a = 1:2,
    b = 4:5,
    c = 7:8
  )

  label_list <- c(sbj = "SBJ", a = "A", b = "B", c = "C")

  grp_df <- set_lbls(grp_df, label_list)

  grp_vect <- stats::setNames("a", CNT$MAIN_GROUP)


  actual_output <- bp_subset_data(
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

  expected_output <- data.frame(row.names = 1:4)
  expected_output[[CNT$SBJ]] <- factor(c(1, 1, 2, 2))
  expected_output[[CNT$CAT]] <- factor(c("CA", "CB", "CA", "CB"), levels = c("CB", "CA"))
  expected_output[[CNT$PAR]] <- factor(c("CA-P1", "CB-P2", "CA-P1", "CB-P2"), levels = c("CB-P2", "CA-P1"))
  expected_output[[CNT$VIS]] <- factor(c("V1", "V1", "V1", "V1"))
  expected_output[[CNT$VAL]] <- paste0(
    expected_output[[CNT$PAR]], "-",
    expected_output[[CNT$SBJ]], "-",
    expected_output[[CNT$VIS]]
  )
  expected_output[[CNT$MAIN_GROUP]] <- c(1, 1, 2, 2)

  expected_output <- tibble::as_tibble(expected_output, rownames = NULL)

  expected_label_list <- stats::setNames(
    c("SBJ", "CAT", "PAR", "VIS", "VAL", "A"),
    c(CNT$SBJ, CNT$CAT, CNT$PAR, CNT$VIS, CNT$VAL, CNT$MAIN_GROUP)
  )

  expected_output <- set_lbls(expected_output, expected_label_list)


  expect_equal(actual_output, expected_output)
})

test_that("bp_subset_data errors when there is more than one row per sbj,cat,par,vis combination", {
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
    bp_subset_data(
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

test_that("bp_subset_data errors when there is more than row per subject in group_ds", {
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
    bp_subset_data(
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
    regexp = CMN$MSG$VALIDATE$GROUP_TOO_MANY_ROWS,
    fixed = TRUE
  )
})

test_that("bp_subset_data errors when the returned dataset has 0 rows", {
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

test_that("bp_subset_data errors when bm_ds and group_ds share column names after selection", {
  skip("This case is untestable it seems impossible for both ds to have conflicting names as they renamed internally")

  bm_df <- tibble::tibble(
    sbj = factor(c(1)),
    COMMON = factor(c("A")),
    par = factor(c("B")),
    vis = factor(c("V1")),
    val = 1
  )

  grp_df <- tibble::tibble(
    sbj = factor(c(1)),
    COMMON = 1
  )

  expect_error(
    bp_subset_data(
      cat = "A",
      cat_col = "COMMON",
      par = "B",
      par_col = "par",
      vis = "V1",
      vis_col = "vis",
      val_col = "val",
      group_vect = stats::setNames("COMMON", CNT$MAIN_GROUP),
      bm_ds = bm_df,
      group_ds = grp_df,
      subj_col = "sbj"
    ),
    regexp = CMN$MSG$VALIDATE$GROUP_COL_REPEATED,
    fixed = TRUE
  )
})

test_that("bp_subset_data errors when group_vect names are not a subset of CNT$MAIN/SUB/PAGE_GROUP", {
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

# bp_boxplot_chart ----

local({
  eg_args <- list()
  eg_args[[CNT$SBJ]] <- 1:2
  eg_args[[CNT$PAR]] <- c("PA", "PB")
  eg_args[[CNT$MAIN_GROUP]] <- c("MA", "MB")
  eg_args[[CNT$SUB_GROUP]] <- c("SA", "SB")
  eg_args[[CNT$PAGE_GROUP]] <- c("PA", "PB")
  df <- do.call(expand.grid, eg_args)
  df[[CNT$VAL]] <- seq_len(nrow(df))

  test_that("boxplot_chart produces a boxplot", {
    vdiffr::expect_doppelganger(
      "boxplot",
      boxplot_chart(df, FALSE, FALSE, FALSE)
    )
  })

  test_that("boxplot_chart produces a violinplot", {
    vdiffr::expect_doppelganger(
      "violin plot",
      boxplot_chart(df, TRUE, FALSE, FALSE)
    )
  })

  test_that("boxplot_chart produces a boxplot with individual points", {
    set.seed(1)
    vdiffr::expect_doppelganger(
      "boxplot individual points",
      boxplot_chart(df, FALSE, TRUE, FALSE)
    )
  })
  
  test_that("boxplot_chart produces a boxplot with a log-projected Y axis", {
    set.seed(1)
    vdiffr::expect_doppelganger(
      "boxplot Y-axis log projection",
      boxplot_chart(df, FALSE, FALSE, TRUE)
    )
  })
})


test_that("boxplot_chart injects a dummy main group when there is none", {
  df <- data.frame(
    parameter = c(rep("PA", 5), rep("PB", 5)),
    subject_id = 1,
    value = 1:10
  )

  p <- boxplot_chart(df, FALSE, FALSE, FALSE)

  expect_true(CNT$MAIN_GROUP %in% names(p$data))
})

# bp_listings table ----

# Most of the functionality in this element is provided by equal_and_mask_from_vec
# Should the tests be focused here or in the low level implementation?

test_that("bp_listings_table subsets a data frame based on the values of a one-rowed data frame", {
  # Done on tibbles otherwise it complains about row names
  df <- tibble::tibble(A = c(1, 2, 3), B = c(4, 5, 6), C = c(7, 8, 9))
  f_df <- tibble::tibble(A = 2, B = 5, C = 8)
  expected_output <- tibble::tibble(A = 2, B = 5, C = 8)
  actual_output <- bp_listings_table(df, f_df)
  expect_equal(actual_output, expected_output)
})

# bp_count_table ----

test_that("bp_count_table counts the number of rows grouped by all variables except CNT$SBJ and CNT$VAL", {
  df <- data.frame(g = c(1, 1, 2, 2, 2, 2))
  df[CNT$SBJ] <- 1:6
  df[CNT$VAL] <- 1:6
  expected_output <- data.frame(
    g = c(1, 2),
    Count = c(2, 4)
  )
  actual_output <- bp_count_table(df)
  expect_equal(actual_output, expected_output)
})

# bp_summary_table ----
test_that("bp_summary_table calculates summary statistics correctly", {
  pa_val <- c(1:4, NA)
  pb_val <- c(6:9)

  df <- data.frame(
    parameter = c(rep("PA", 5), rep("PB", 4)),
    subject_id = 1,
    value = c(pa_val, pb_val)
  )

  actual_output <- bp_summary_table(df)
  expected_output <- tibble::tibble(
    parameter = c("PA", "PB"),
    N = c(5, 4),
    Mean = c(mean(pa_val, na.rm = TRUE), mean(pb_val, na.rm = TRUE)),
    SD = c(sd(pa_val, na.rm = TRUE), sd(pb_val, na.rm = TRUE)),
    Min = c(min(pa_val, na.rm = TRUE), min(pb_val, na.rm = TRUE)),
    Q1 = c(stats::quantile(pa_val, probs = .25, na.rm = TRUE), stats::quantile(pb_val, probs = .25, na.rm = TRUE)),
    Median = c(median(pa_val, na.rm = TRUE), median(pb_val, na.rm = TRUE)),
    Q3 = c(stats::quantile(pa_val, probs = .75, na.rm = TRUE), stats::quantile(pb_val, probs = .75, na.rm = TRUE)),
    Max = c(max(pa_val, na.rm = TRUE), max(pb_val, na.rm = TRUE)),
    "NA Values" = c(1, 0)
  )

  expect_equal(actual_output, expected_output)
})

# bp_significance_table ----

test_that("bp_significance_table calculate t.tests correctly", {
  # Check common and NA values for group not present or single value groups

  pa_val <- c(1:4, NA)
  pb_val <- c(6, 6, 6, 7, 8)

  df <- data.frame(
    parameter = c(rep("PA", 5), rep("PB", 5)),
    main_group = c("A", "A", "B", "B", "B", "A", "A", "B", "B", "C"),
    subject_id = 1,
    value = c(pa_val, pb_val)
  )

  actual_output <- bp_significance_table(df)
  expected_output <- tibble::tibble(
    parameter = c("PA", "PA", "PA", "PB", "PB", "PB"),
    Test = "t.test",
    Comparison = c("A vs. B", "A vs. C", "B vs. C", "A vs. B", "A vs. C", "B vs. C"),
    "P Value" = c(t.test(c(1, 2), c(3, 4))$p.value, NA, NA, t.test(c(6, 6), c(6, 7))$p.value, NA, NA)
  )

  expect_equal(actual_output, expected_output)
})

# bp_get_closest_gen_click ----

test_that("bp_get_closest_gen_click", {
  skip("Not thouroughly tested as it is yet to be decided if ggplot will be used")
})

test_that("bp_get_closest_single_click", {
  skip("Not thouroughly tested as it is yet to be decided if ggplot will be used")
})

test_that("bp_get_closest_double_click", {
  skip("Not thouroughly tested as it is yet to be decided if ggplot will be used")
})
