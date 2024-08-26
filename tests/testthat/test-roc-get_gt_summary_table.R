# nolint start
test_that("produce gt summary table (Snapshot)" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$summary
    )
  ), {
  roc_curve <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2")),
    !!CNT_ROC$SPEC := c(.1, .3, .11, .33),
    !!CNT_ROC$SENS := c(.2, .4, .22, .44),
    !!CNT_ROC$AUC := list(c(0, .1, .2), c(.1, .2, .3), c(.2, .3, .4), c(.5, .6, .7)),
    !!CNT_ROC$THR := c(1, 2, 3, 4),
    !!CNT_ROC$DIR := c("1", "2", "3", "4"),
    !!CNT_ROC$LEV := list(c("a", "b"), c("c", "d"), c("e", "f"), c("g", "h"))
  )

  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Parameter"
  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Group"

  roc_ci <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2")),
    !!CNT_ROC$CI_SPEC := c(.0, .01, .02, .03),
    !!CNT_ROC$CI_SENS := c(.1, .11, .12, .13),
    !!CNT_ROC$CI_L_SPEC := c(.2, .21, .22, .23),
    !!CNT_ROC$CI_L_SENS := c(.3, .31, .32, .33),
    !!CNT_ROC$CI_U_SPEC := c(.4, .41, .42, .43),
    !!CNT_ROC$CI_U_SENS := c(.5, .51, .52, .53)
  )

  # Test explicitely for repeated oc titles with same parameter and group related to DVCD-3109 ahyodae
  roc_oc <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P2", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G1", "G2", "G2")),
    !!CNT_ROC$OC_TITLE := c("OC_P1_G1", "OC_P1_G1", "OC_P2_G1", "OC_P1_G2", "OC_P2_G2"),
    !!CNT_ROC$OC_SPEC := c(.1, .2, .3, .4, .5),
    !!CNT_ROC$OC_SENS := c(.5, .6, .7, .8, .9),
    !!CNT_ROC$OC_L_SPEC := c(.2, .21, .22, .23, .24),
    !!CNT_ROC$OC_L_SENS := c(.3, .31, .32, .33, .34),
    !!CNT_ROC$OC_U_SPEC := c(.4, .41, .42, .43, 44),
    !!CNT_ROC$OC_U_SENS := c(.5, .51, .52, .53, .54),
    !!CNT_ROC$OC_THR := c(1, 2, 3, 4, 5)
  )

  ds_list <-
    list(
      roc_curve = roc_curve,
      roc_ci = roc_ci,
      roc_optimal_cut = roc_oc
    )

  withr::local_seed(seed = 1) # gt creates random ids for the divs containing tables
  expect_snapshot(ds_list %>%
    get_summary_data() %>%
    get_gt_summary_table(sort_alph = FALSE) %>% gt::as_raw_html())
})

test_that("produce gt summary table. Ungrouped (Snapshot)", {
  roc_curve <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$SPEC := c(.1, .3),
    !!CNT_ROC$SENS := c(.2, .4),
    !!CNT_ROC$AUC := list(c(0, .1, .2), c(.1, .2, .3)),
    !!CNT_ROC$THR := c(1, 2),
    !!CNT_ROC$DIR := c("1", "2"),
    !!CNT_ROC$LEV := list(c("a", "b"), c("c", "d"))
  )

  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Parameter"

  roc_ci <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$CI_SPEC := c(.0, .01),
    !!CNT_ROC$CI_SENS := c(.1, .11),
    !!CNT_ROC$CI_L_SPEC := c(.2, .21),
    !!CNT_ROC$CI_L_SENS := c(.3, .31),
    !!CNT_ROC$CI_U_SPEC := c(.4, .41),
    !!CNT_ROC$CI_U_SENS := c(.5, .51)
  )

  # Test explicitely for repeated oc titles with same parameter and group related to DVCD-3109 ahyodae
  roc_oc <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$OC_TITLE := c("OC_P1", "OC_P1", "OC_P2"),
    !!CNT_ROC$OC_SPEC := c(.1, .2, .3),
    !!CNT_ROC$OC_SENS := c(.5, .6, .7),
    !!CNT_ROC$OC_L_SPEC := c(.2, .21, .22),
    !!CNT_ROC$OC_L_SENS := c(.3, .31, .32),
    !!CNT_ROC$OC_U_SPEC := c(.4, .41, .42),
    !!CNT_ROC$OC_U_SENS := c(.5, .51, .52),
    !!CNT_ROC$OC_THR := c(1, 2, 3)
  )

  ds_list <-
    list(
      roc_curve = roc_curve,
      roc_ci = roc_ci,
      roc_optimal_cut = roc_oc
    )

  withr::local_seed(seed = 1) # gt creates random ids for the divs containing tables
  expect_snapshot(ds_list %>%
    get_summary_data() %>%
    get_gt_summary_table(sort_alph = FALSE) %>% gt::as_raw_html())
})
test_that("produce gt summary table. Alphabetical order (Snapshot)", {
  roc_curve <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$SPEC := c(.1, .3),
    !!CNT_ROC$SENS := c(.2, .4),
    !!CNT_ROC$AUC := list(c(0, .1, .2), c(.1, .2, .3)),
    !!CNT_ROC$THR := c(1, 2),
    !!CNT_ROC$DIR := c("1", "2"),
    !!CNT_ROC$LEV := list(c("a", "b"), c("c", "d"))
  )

  attr(roc_curve[[CNT_ROC$PPAR]], "label") <- "Parameter"

  roc_ci <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$CI_SPEC := c(.0, .01),
    !!CNT_ROC$CI_SENS := c(.1, .11),
    !!CNT_ROC$CI_L_SPEC := c(.2, .21),
    !!CNT_ROC$CI_L_SENS := c(.3, .31),
    !!CNT_ROC$CI_U_SPEC := c(.4, .41),
    !!CNT_ROC$CI_U_SENS := c(.5, .51)
  )

  # Test explicitely for repeated oc titles with same parameter and group related to DVCD-3109 ahyodae
  roc_oc <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P2")),
    !!CNT_ROC$RPAR := factor(c("R1")),
    !!CNT_ROC$OC_TITLE := c("OC_P1", "OC_P1", "OC_P2"),
    !!CNT_ROC$OC_SPEC := c(.1, .2, .3),
    !!CNT_ROC$OC_SENS := c(.5, .6, .7),
    !!CNT_ROC$OC_L_SPEC := c(.2, .21, .22),
    !!CNT_ROC$OC_L_SENS := c(.3, .31, .32),
    !!CNT_ROC$OC_U_SPEC := c(.4, .41, .42),
    !!CNT_ROC$OC_U_SENS := c(.5, .51, .52),
    !!CNT_ROC$OC_THR := c(1, 2, 3)
  )

  ds_list <-
    list(
      roc_curve = roc_curve,
      roc_ci = roc_ci,
      roc_optimal_cut = roc_oc
    )

  withr::local_seed(seed = 1) # gt creates random ids for the divs containing tables

  expect_snapshot(ds_list %>%
    get_summary_data() %>%
    get_gt_summary_table(sort_alph = TRUE) %>% gt::as_raw_html())
})
# nolint end
