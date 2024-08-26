# subset_bds_param  ----
test_that("subset_bds_param subsets a biomarker dataset, retaining labels", {
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

  actual_output <- subset_bds_param(
    cat = c("CA", "CB"),
    cat_col = "cat",
    par = c("CB-P3", "CA-P2", "CA-P1"),
    par_col = "par",
    val_col = "val",
    vis = c("V1", "V3"),
    vis_col = "vis",
    ds = bm_df,
    subj_col = "sbj"
  )

  expected_label_list <- label_list
  names(expected_label_list) <- c(CNT$CAT, CNT$PAR, CNT$VIS, CNT$SBJ, CNT$VAL)


  # Fix levels
  expected_output <- data.frame(row.names = 1:12)
  expected_output[[CNT$SBJ]] <- factor(c(1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2))
  expected_output[[CNT$CAT]] <- factor(
    c("CA", "CA", "CB", "CA", "CA", "CB", "CA", "CA", "CB", "CA", "CA", "CB"),
    levels = c("CA", "CB", "CC")
  )
  expected_output[[CNT$PAR]] <- factor(
    c("CA-P1", "CA-P2", "CB-P3", "CA-P1", "CA-P2", "CB-P3", "CA-P1", "CA-P2", "CB-P3", "CA-P1", "CA-P2", "CB-P3"),
    levels = c("CA-P1", "CA-P2", "CA-P3", "CB-P1", "CB-P2", "CB-P3", "CC-P1", "CC-P2", "CC-P3")
  )
  expected_output[[CNT$VIS]] <- factor(
    c("V1", "V1", "V1", "V3", "V3", "V3", "V1", "V1", "V1", "V3", "V3", "V3"),
    levels = c("V1", "V2", "V3")
  )
  expected_output[[CNT$VAL]] <- paste0(
    expected_output[[CNT$PAR]],
    "-",
    expected_output[[CNT$SBJ]],
    "-",
    expected_output[[CNT$VIS]]
  )

  expected_output <- tibble::as_tibble(expected_output, rownames = NULL)

  expected_output <- set_lbls(expected_output, expected_label_list)

  expect_equal(actual_output, expected_output)
})


test_that("subset_bds_param subsets errors when parameters are repeated across categories", {
  bm_df <- tibble::as_tibble(expand.grid(
    cat = factor(c("CA", "CB", "CC")),
    par = factor(c("P1", "P2", "P3")),
    vis = factor(c("V1", "V2", "V3")),
    sbj = factor(1:2)
  ))
  # Remove parameter added by expand.grid
  attr(bm_df, "out.attrs") <- NULL # nolint

  bm_df[["val"]] <- paste0(
    bm_df[["cat"]],
    "-",
    bm_df[["par"]],
    "-",
    bm_df[["sbj"]],
    "-",
    bm_df[["vis"]]
  )

  expect_error(
    subset_bds_param(
      cat = c("CA", "CB"),
      cat_col = "cat",
      par = c("P3", "P1"),
      par_col = "par",
      val_col = "val",
      vis = c("V1"),
      vis_col = "vis",
      ds = bm_df,
      subj_col = "sbj"
    ),
    regexp = "^Repeated parameter names.*"
  )
})

test_that("subset_bds_param subsets renames repeated parameters", {
  testthat::skip("This behavior is not implemented until required")

  bm_df <- tibble::as_tibble(expand.grid(
    cat = factor(c("CA", "CB", "CC")),
    par = factor(c("P1", "P2", "P3")),
    vis = factor(c("V1", "V2", "V3")),
    sbj = factor(1:2)
  ))
  # Remove parameter added by expand.grid
  attr(bm_df, "out.attrs") <- NULL # nolint

  bm_df[["val"]] <- paste0(
    bm_df[["cat"]],
    "-",
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

  actual_output <- subset_bds_param(
    cat = c("CA", "CB"),
    cat_col = "cat",
    par = c("P3", "P1"),
    par_col = "par",
    val_col = "val",
    vis = c("V1"),
    vis_col = "vis",
    ds = bm_df,
    subj_col = "sbj"
  )

  expected_label_list <- label_list
  names(expected_label_list) <- c(CNT$CAT, CNT$PAR, CNT$VIS, CNT$SBJ, CNT$VAL)


  # Fix levels
  expected_output <- data.frame(row.names = 1:8)
  expected_output[[CNT$SBJ]] <- factor(c(1, 1, 1, 1, 2, 2, 2, 2))
  expected_output[[CNT$CAT]] <- factor(c("CA", "CB", "CA", "CB", "CA", "CB", "CA", "CB"), levels = c("CA", "CB", "CC"))
  expected_output[[CNT$PAR]] <- factor(c("CA-P1", "CB-P1", "CA-P3", "CB-P3", "CA-P1", "CB-P1", "CA-P3", "CB-P3"),
    levels = c("CA-P1", "CA-P3", "CB-P1", "CB-P3")
  )
  expected_output[[CNT$VIS]] <- factor(c("V1", "V1", "V1", "V1", "V1", "V1", "V1", "V1"), levels = c("V1", "V2", "V3"))
  expected_output[[CNT$VAL]] <- paste0(
    expected_output[[CNT$PAR]],
    "-",
    expected_output[[CNT$SBJ]],
    "-",
    expected_output[[CNT$VIS]]
  )

  expected_output <- tibble::as_tibble(expected_output, rownames = NULL)

  expected_output <- set_lbls(expected_output, expected_label_list)
  attr(expected_output, "parameter_renamed") <- TRUE

  expect_equal(actual_output, expected_output)
})

# subset_group ----

test_that("subset_adsl subsets and renames subset variables", {
  grp_df <- tibble::tibble(
    sbj = 1:3,
    a = 1:3,
    b = 4:6,
    c = 7:9
  )

  label_list <- c(sbj = "SBJ", a = "A", b = "B", c = "C")

  grp_df <- set_lbls(grp_df, label_list)

  actual_output <- subset_adsl(
    grp_df,
    c(bb = "b", cc = "c"),
    "sbj"
  )

  expected_output <- data.frame(row.names = 1:3)
  expected_output[[CNT$SBJ]] <- 1:3
  expected_output[["bb"]] <- 4:6
  expected_output[["cc"]] <- 7:9

  expected_output <- tibble::as_tibble(expected_output)

  expected_label_list <- c("SBJ", "B", "C")
  names(expected_label_list) <- c(CNT$SBJ, "bb", "cc")
  expected_output <- set_lbls(expected_output, expected_label_list)

  expect_equal(actual_output, expected_output)
})
