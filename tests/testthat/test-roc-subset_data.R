# nolint start
grp_ds <- tibble::tribble(
  ~SUBJID, ~GRP1, ~GRP2,
  "S1", "G11", "G21",
  "S2", "G12", "G22"
) %>%
  dplyr::mutate(
    dplyr::across(where(is.character), as.factor)
  )

test_that("subset data to the selected parameters visits with no grouping" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$selection$predictor,
      specs$roc$selection$response,
      specs$roc$selection$grouping
    )
  ), {
  pred_ds <- tibble::tribble(
    ~SUBJID, ~P_PARCAT, ~P_PARAM, ~P_VAL, ~P_VISIT,
    "S1", "PC1", "P1", 1, "PV1",
    "S2", "PC1", "P1", 2, "PV1",
    "S1", "PC1", "P1", 3, "PV2", # Different visits are not subset
    "S1", "PC1", "P2", 4, "PV1", # Different parameters are not subset
    "S1", "PC2", "P1", 5, "PV1", # Different categories are not subset
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  resp_ds <- tibble::tribble(
    ~SUBJID, ~R_PARCAT, ~R_PARAM, ~R_VAL, ~R_VISIT,
    "S1", "RC1", "R1", "A", "RV1",
    "S2", "RC1", "R1", "B", "RV1",
    "S1", "RC1", "R2", "C", "RV1",
    "S1", "RC1", "R1", "C", "RV2",
    "S1", "RC1", "R2", "C", "RV2",
    "S2", "RC1", "R2", "C", "RV1",
    "S2", "RC1", "R1", "C", "RV2",
    "S2", "RC1", "R2", "C", "RV2"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )
  expected_ds <- tibble::tibble(
    !!CNT_ROC$SBJ := c("S1", "S2"),
    !!CNT_ROC$PPAR := c("P1", "P1"),
    !!CNT_ROC$PVAL := c(1, 2),
    !!CNT_ROC$RPAR := c("R1", "R1"),
    !!CNT_ROC$RVAL := c("A", "B")
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  attr(expected_ds[[CNT_ROC$PPAR]], "label") <- COL_LABELS$PRED_PAR
  attr(expected_ds[[CNT_ROC$RPAR]], "label") <- COL_LABELS$RESP_PAR

  roc_subset_data(
    pred_par = "P1",
    pred_cat = "PC1",
    pred_val_col = "P_VAL",
    pred_visit = "PV1",
    resp_cat = "RC1",
    resp_par = "R1",
    resp_val_col = "R_VAL",
    resp_visit = "RV1",
    group_col = "None",
    pred_ds = pred_ds,
    resp_ds = resp_ds,
    group_ds = grp_ds,
    subj_col = "USUBJID",
    pred_cat_col = "P_PARCAT",
    pred_par_col = "P_PARAM",
    pred_vis_col = "P_VISIT",
    resp_cat_col = "R_PARCAT",
    resp_par_col = "R_PARAM",
    resp_vis_col = "R_VISIT"
  ) %>%
    expect_identical(expected_ds)
})

test_that("subset data to the selected parameters visits with grouping" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$selection$predictor,
      specs$roc$selection$response,
      specs$roc$selection$grouping
    )
  ), {
  pred_ds <- tibble::tribble(
    ~SUBJID, ~P_PARCAT, ~P_PARAM, ~P_VAL, ~P_VISIT,
    "S1", "PC1", "P1", 1, "PV1",
    "S2", "PC1", "P1", 2, "PV1",
    "S1", "PC1", "P1", 3, "PV2", # Different visits are not subset
    "S1", "PC1", "P2", 4, "PV1", # Different parameters are not subset
    "S1", "PC2", "P1", 5, "PV1", # Different categories are not subset
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  resp_ds <- tibble::tribble(
    ~SUBJID, ~R_PARCAT, ~R_PARAM, ~R_VAL, ~R_VISIT,
    "S1", "RC1", "R1", "A", "RV1",
    "S2", "RC1", "R1", "B", "RV1",
    "S1", "RC1", "R2", "C", "RV1",
    "S1", "RC1", "R1", "C", "RV2",
    "S1", "RC1", "R2", "C", "RV2",
    "S2", "RC1", "R2", "C", "RV1",
    "S2", "RC1", "R1", "C", "RV2",
    "S2", "RC1", "R2", "C", "RV2"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  grp_ds <- tibble::tribble(
    ~SUBJID, ~GRP1, ~GRP2,
    "S1", "G11", "G21",
    "S2", "G12", "G22"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  expected_ds <- tibble::tibble(
    !!CNT_ROC$SBJ := c("S1", "S2"),
    !!CNT_ROC$PPAR := c("P1", "P1"),
    !!CNT_ROC$PVAL := c(1, 2),
    !!CNT_ROC$RPAR := c("R1", "R1"),
    !!CNT_ROC$RVAL := c("A", "B"),
    !!CNT_ROC$GRP := c("G11", "G12")
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  attr(expected_ds[[CNT_ROC$PPAR]], "label") <- COL_LABELS$PRED_PAR
  attr(expected_ds[[CNT_ROC$RPAR]], "label") <- COL_LABELS$RESP_PAR
  attr(expected_ds[[CNT_ROC$GRP]], "label") <- "GRP1"

  roc_subset_data(
    pred_par = "P1",
    pred_cat = "PC1",
    pred_val_col = "P_VAL",
    pred_visit = "PV1",
    resp_cat = "RC1",
    resp_par = "R1",
    resp_val_col = "R_VAL",
    resp_visit = "RV1",
    group_col = "GRP1",
    pred_ds = pred_ds,
    resp_ds = resp_ds,
    group_ds = grp_ds,
    subj_col = "USUBJID",
    pred_cat_col = "P_PARCAT",
    pred_par_col = "P_PARAM",
    pred_vis_col = "P_VISIT",
    resp_cat_col = "R_PARCAT",
    resp_par_col = "R_PARAM",
    resp_vis_col = "R_VISIT"
  ) %>%
    expect_identical(expected_ds)
})

test_that("subset data with pasted parameters and categories when there is repetition" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$selection$predictor,
      specs$roc$selection$response,
      specs$roc$selection$grouping
    )
  ), {
  pred_ds <- tibble::tribble(
    ~SUBJID, ~P_PARCAT, ~P_PARAM, ~P_VAL, ~P_VISIT,
    "S1", "PC1", "P1", 1, "PV1",
    "S2", "PC1", "P1", 2, "PV1",
    "S1", "PC2", "P1", 3, "PV1",
    "S2", "PC2", "P1", 4, "PV1"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  resp_ds <- tibble::tribble(
    ~SUBJID, ~R_PARCAT, ~R_PARAM, ~R_VAL, ~R_VISIT,
    "S1", "RC1", "R1", "A", "RV1",
    "S2", "RC1", "R1", "B", "RV1"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  expected_ds <- tibble::tibble(
    !!CNT_ROC$SBJ := c("S1", "S2", "S1", "S2"),
    !!CNT_ROC$PPAR := c("PC1 - P1", "PC1 - P1", "PC2 - P1", "PC2 - P1"),
    !!CNT_ROC$PVAL := c(1, 2, 3, 4),
    !!CNT_ROC$RPAR := c("R1", "R1", "R1", "R1"),
    !!CNT_ROC$RVAL := c("A", "B", "A", "B")
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  attr(expected_ds[[CNT_ROC$PPAR]], "label") <- COL_LABELS$PRED_PAR
  attr(expected_ds[[CNT_ROC$RPAR]], "label") <- COL_LABELS$RESP_PAR

  roc_subset_data(
    pred_par = "P1",
    pred_cat = c("PC1", "PC2"),
    pred_val_col = "P_VAL",
    pred_visit = "PV1",
    resp_cat = "RC1",
    resp_par = "R1",
    resp_val_col = "R_VAL",
    resp_visit = "RV1",
    group_col = "None",
    pred_ds = pred_ds,
    resp_ds = resp_ds,
    group_ds = grp_ds,
    subj_col = "USUBJID",
    pred_cat_col = "P_PARCAT",
    pred_par_col = "P_PARAM",
    pred_vis_col = "P_VISIT",
    resp_cat_col = "R_PARCAT",
    resp_par_col = "R_PARAM",
    resp_vis_col = "R_VISIT"
  ) %>%
    expect_identical(expected_ds)
})

test_that("subset data is correct when param_name repeats across categories" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$selection$predictor,
      specs$roc$selection$response,
      specs$roc$selection$grouping
    )
  ), {
  # An strange side case that can produce erroneous results when a parameters with same names belong to different categories
  # If selection is not done using both category and parameter name then extra rows may appear in particular cases such as the
  # one below.

  pred_ds <- tibble::tribble(
    ~SUBJID, ~P_PARCAT, ~P_PARAM, ~P_VAL, ~P_VISIT,
    # Note that S1 has P1 in PC2 but not PC1, if selected only considering PARAM, even when PC1 is selected and P1 too, the line from S1 would be included
    # Additionally it would not be captured by the too much row validations as there would still be one row per participant.
    # This is controlled since 0.0.1-14 as selection is done considering both PARAM and PARCAT.
    "S1", "PC2", "P1", 1, "PV1",
    "S2", "PC1", "P1", 11, "PV1",
    "S3", "PC1", "P1", 111, "PV1"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  resp_ds <- tibble::tribble(
    ~SUBJID, ~R_PARCAT, ~R_PARAM, ~R_VAL, ~R_VISIT,
    "S1", "RC1", "R1", " 10", "RV1",
    "S2", "RC1", "R1", "110", "RV1",
    "S3", "RC1", "R1", "111", "RV1"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  expected_ds <- tibble::tibble(
    !!CNT_ROC$SBJ := c("S2", "S3"),
    !!CNT_ROC$PPAR := c("P1", "P1"),
    !!CNT_ROC$PVAL := c(11, 111),
    !!CNT_ROC$RPAR := c("R1", "R1"),
    !!CNT_ROC$RVAL := c("110", "111")
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  attr(expected_ds[[CNT_ROC$PPAR]], "label") <- COL_LABELS$PRED_PAR
  attr(expected_ds[[CNT_ROC$RPAR]], "label") <- COL_LABELS$RESP_PAR

  roc_subset_data(
    pred_cat = "PC1",
    pred_par = "P1",
    pred_val_col = "P_VAL",
    pred_visit = "PV1",
    resp_par = "R1",
    resp_val_col = "R_VAL",
    resp_visit = "RV1",
    group_col = "None",
    pred_ds = pred_ds,
    resp_ds = resp_ds,
    group_ds = grp_ds,
    subj_col = "USUBJID",
    pred_cat_col = "P_PARCAT",
    pred_par_col = "P_PARAM",
    pred_vis_col = "P_VISIT",
    resp_cat_col = "R_PARCAT",
    resp_par_col = "R_PARAM",
    resp_vis_col = "R_VISIT"
  ) %>%
    expect_identical(expected_ds)
})

test_that("validation error when there is more than one row per subject", {
  ill_pred_ds <- tibble::tribble(
    ~SUBJID, ~P_PARCAT, ~P_PARAM, ~P_VAL, ~P_VISIT,
    "S1", "PC1", "P1", 1, "PV1",
    "S1", "PC1", "P1", 2, "PV1" # Repeated subject
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  pred_ds <- tibble::tribble(
    ~SUBJID, ~P_PARCAT, ~P_PARAM, ~P_VAL, ~P_VISIT,
    "S1", "PC1", "P1", 1, "PV1",
    "S2", "PC1", "P1", 2, "PV1" # Repeated subject
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  resp_ds <- tibble::tribble(
    ~SUBJID, ~R_PARCAT, ~R_PARAM, ~R_VAL, ~R_VISIT,
    "S1", "RC1", "R1", "A", "RV1",
    "S2", "RC1", "R1", "B", "RV1"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  ill_resp_ds <- tibble::tribble(
    ~SUBJID, ~R_PARCAT, ~R_PARAM, ~R_VAL, ~R_VISIT,
    "S1", "RC1", "R1", "A", "RV1",
    "S1", "RC1", "R1", "B", "RV1",
    "S2", "RC1", "R1", "A", "RV1"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  roc_subset_data(
    pred_cat = "PC1",
    pred_par = "P1",
    pred_val_col = "P_VAL",
    pred_visit = "PV1",
    resp_par = "R1",
    resp_val_col = "R_VAL",
    resp_visit = "RV1",
    group_col = "None",
    pred_ds = ill_pred_ds,
    resp_ds = resp_ds,
    group_ds = grp_ds,
    subj_col = "USUBJID",
    pred_cat_col = "P_PARCAT",
    pred_par_col = "P_PARAM",
    pred_vis_col = "P_VISIT",
    resp_cat_col = "R_PARCAT",
    resp_par_col = "R_PARAM",
    resp_vis_col = "R_VISIT"
  ) %>%
    expect_error(
      class = "shiny.silent.error",
      regexp = ROC_MSG$ROC$VALIDATE$PRED_TOO_MANY_ROWS,
      fixed = TRUE
    )

  roc_subset_data(
    pred_cat = "PC1",
    pred_par = "P1",
    pred_val_col = "P_VAL",
    pred_visit = "PV1",
    resp_par = "R1",
    resp_val_col = "R_VAL",
    resp_visit = "RV1",
    group_col = "None",
    pred_ds = pred_ds,
    resp_ds = ill_resp_ds,
    group_ds = grp_ds,
    subj_col = "USUBJID",
    pred_cat_col = "P_PARCAT",
    pred_par_col = "P_PARAM",
    pred_vis_col = "P_VISIT",
    resp_cat_col = "R_PARCAT",
    resp_par_col = "R_PARAM",
    resp_vis_col = "R_VISIT"
  ) %>%
    expect_error(
      class = "shiny.silent.error",
      regexp = ROC_MSG$ROC$VALIDATE$RESP_TOO_MANY_ROWS,
      fixed = TRUE
    )
})

test_that("validation error when the response is not binary, warn when empty response", {
  pred_ds <- tibble::tribble(
    ~SUBJID, ~P_PARCAT, ~P_PARAM, ~P_VAL, ~P_VISIT,
    "S1", "PC1", "P1", 1, "PV1",
    "S2", "PC1", "P1", 2, "PV1",
    "S3", "PC1", "P1", 2, "PV1"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  resp_ds <- tibble::tribble(
    ~SUBJID, ~R_PARCAT, ~R_PARAM, ~R_VAL, ~R_VISIT,
    "S1", "RC1", "R1", "A", "RV1",
    "S2", "RC1", "R1", "B", "RV1",
    "S3", "RC1", "R1", "", "RV1"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  ill_resp_ds <- tibble::tribble(
    ~SUBJID, ~R_PARCAT, ~R_PARAM, ~R_VAL, ~R_VISIT,
    "S1", "RC1", "R1", "A", "RV1",
    "S2", "RC1", "R1", "B", "RV1",
    "S3", "RC1", "R1", "C", "RV1" # Third response level
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  roc_subset_data(
    pred_cat = "PC1",
    pred_par = "P1",
    pred_val_col = "P_VAL",
    pred_visit = "PV1",
    resp_par = "R1",
    resp_val_col = "R_VAL",
    resp_visit = "RV1",
    group_col = "None",
    pred_ds = pred_ds,
    resp_ds = resp_ds,
    group_ds = grp_ds,
    subj_col = "USUBJID",
    pred_cat_col = "P_PARCAT",
    pred_par_col = "P_PARAM",
    pred_vis_col = "P_VISIT",
    resp_cat_col = "R_PARCAT",
    resp_par_col = "R_PARAM",
    resp_vis_col = "R_VISIT"
  ) %>%
    expect_error(regexp = NA) %>%
    expect_warning(regexp = ROC_MSG$ROC$VALIDATE$N_SUBJECT_EMPTY_RESPONSES(1), fixed = TRUE)

  roc_subset_data(
    pred_cat = "PC1",
    pred_par = "P1",
    pred_val_col = "P_VAL",
    pred_visit = "PV1",
    resp_par = "R1",
    resp_val_col = "R_VAL",
    resp_visit = "RV1",
    group_col = "None",
    pred_ds = pred_ds,
    resp_ds = ill_resp_ds,
    group_ds = grp_ds,
    subj_col = "USUBJID",
    pred_cat_col = "P_PARCAT",
    pred_par_col = "P_PARAM",
    pred_vis_col = "P_VISIT",
    resp_cat_col = "R_PARCAT",
    resp_par_col = "R_PARAM",
    resp_vis_col = "R_VISIT"
  ) %>%
    expect_error(
      class = "shiny.silent.error",
      regexp = ROC_MSG$ROC$VALIDATE$MUST_BE_BINARY_ENDPOINT(c("A", "B", "C")),
      fixed = TRUE
    )
})

test_that("warn when  error when the returned dataframe has 0 rows", {
  pred_ds <- tibble::tribble(
    ~SUBJID, ~P_PARCAT, ~P_PARAM, ~P_VAL, ~P_VISIT,
    "S1", "PC1", "P1", 1, "PV1",
    "S2", "PC1", "P1", 2, "PV1",
    "S3", "PC1", "P1", 2, "PV1"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  resp_ds <- tibble::tribble(
    ~SUBJID, ~R_PARCAT, ~R_PARAM, ~R_VAL, ~R_VISIT,
    "S1", "RC1", "R1", "A", "RV1",
    "S2", "RC1", "R1", "B", "RV1",
    "S3", "RC1", "R1", "", "RV1"
  ) %>%
    dplyr::mutate(
      dplyr::across(where(is.character), as.factor)
    )

  roc_subset_data(
    pred_cat = "CATEGORY NOT PRESENT", # Force 0 rows with incorrect selection
    pred_par = "P1",
    pred_val_col = "P_VAL",
    pred_visit = "PV1",
    resp_par = "R1",
    resp_val_col = "R_VAL",
    resp_visit = "RV1",
    group_col = "None",
    pred_ds = pred_ds,
    resp_ds = resp_ds,
    group_ds = grp_ds,
    subj_col = "USUBJID",
    pred_cat_col = "P_PARCAT",
    pred_par_col = "P_PARAM",
    pred_vis_col = "P_VISIT",
    resp_cat_col = "R_PARCAT",
    resp_par_col = "R_PARAM",
    resp_vis_col = "R_VISIT"
  ) %>%
    expect_error(regexp = ROC_MSG$ROC$VALIDATE$NO_ROWS, fixed = TRUE)
})
# nolint end
