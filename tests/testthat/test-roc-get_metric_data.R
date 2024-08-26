# nolint start

dummy_fn <- function(predictor, response) {
  ds <- tibble::tibble(
    score = c(11, 22),
    norm_score = c(111, 222),
    norm_rank = c(1111, 2222),
    type = paste(response, c("metric_1", "metric_2"), sep = "-"),
    y = c(1, 2)
  )

  limits <- c(
    metric_1 = c(0, 1),
    metric_2 = c(2, 3)
  )

  structure(
    ds,
    limits = limits
  )
}

# The nest apply and unnest pattern is the core of the testing for this function
# Wether ROC is properly calculated or not belongs to compute_roc testing
test_that("function is applied per parameter and group" |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$metrics$facets,
      specs$roc$outputs$metrics$axis,
      specs$roc$outputs$metrics$plot
    )
  ), {
  ds <- tibble::tibble(
    !!CNT_ROC$SBJ := factor(c("S1", "S1", "S2")),
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P3")),
    !!CNT_ROC$GRP := factor(c("G1", "G2", "G1")),
    !!CNT_ROC$PVAL := c(1, 2, 3),
    !!CNT_ROC$RPAR := factor("R1"),
    !!CNT_ROC$RVAL := factor(paste(.data[[CNT_ROC$PPAR]], .data[[CNT_ROC$RPAR]], .data[[CNT_ROC$GRP]], sep = "-"))
  )

  expected_ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P1", "P1", "P3", "P3")),
    !!CNT_ROC$RPAR := factor("R1"),
    !!CNT_ROC$GRP := factor(c("G1", "G1", "G2", "G2", "G1", "G1")),
    score = c(11, 22, 11, 22, 11, 22),
    norm_score = c(111, 222, 111, 222, 111, 222),
    norm_rank = c(1111, 2222, 1111, 2222, 1111, 2222),
    type = paste(paste(.data[[CNT_ROC$PPAR]], .data[[CNT_ROC$RPAR]], .data[[CNT_ROC$GRP]], c("metric_1", "metric_2"), sep = "-")),
    y = c(1, 2, 1, 2, 1, 2)
  )

  attr(expected_ds[["score"]], "label") <- "Score"
  attr(expected_ds[["norm_score"]], "label") <- "Normalized Score"
  attr(expected_ds[["norm_rank"]], "label") <- "Normalized Rank"

  limits <- c(
    metric_1 = c(0, 1),
    metric_2 = c(2, 3)
  )

  get_metric_data(
    ds,
    dummy_fn
  ) %>%
    expect_identical(
      list(ds = expected_ds, limits = limits)
    )
})

test_that("function is applied per parameter and group. No grouping." |>
  vdoc[["add_spec"]](
    c(
      specs$roc$outputs$metrics$facets,
      specs$roc$outputs$metrics$axis,
      specs$roc$outputs$metrics$plot
    )
  ), {
  ds <- tibble::tibble(
    !!CNT_ROC$SBJ := factor(c("S1", "S1", "S2")),
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P3")),
    !!CNT_ROC$PVAL := c(1, 2, 3),
    !!CNT_ROC$RPAR := factor("R1"),
    !!CNT_ROC$RVAL := factor(paste(.data[[CNT_ROC$PPAR]], .data[[CNT_ROC$RPAR]], sep = "-"))
  )

  expected_ds <- tibble::tibble(
    !!CNT_ROC$PPAR := factor(c("P1", "P1", "P3", "P3")),
    !!CNT_ROC$RPAR := factor("R1"),
    score = c(11, 22, 11, 22),
    norm_score = c(111, 222, 111, 222),
    norm_rank = c(1111, 2222, 1111, 2222),
    type = paste(paste(.data[[CNT_ROC$PPAR]], .data[[CNT_ROC$RPAR]], c("metric_1", "metric_2"), sep = "-")),
    y = c(1, 2, 1, 2)
  )

  attr(expected_ds[["score"]], "label") <- "Score"
  attr(expected_ds[["norm_score"]], "label") <- "Normalized Score"
  attr(expected_ds[["norm_rank"]], "label") <- "Normalized Rank"

  limits <- c(
    metric_1 = c(0, 1),
    metric_2 = c(2, 3)
  )

  get_metric_data(
    ds,
    dummy_fn
  ) %>%
    expect_identical(
      list(ds = expected_ds, limits = limits)
    )
})

# Errors in the roc data function.

# test_that("when compute_fn throws an error NA values are returned", {

#   dummy_fn <- function(predictor, response, ci_points, do_bootstrap) {

#     if(length(predictor)==1) stop("dummy error")

#     roc_curve <- tibble::tibble(
#       !!CNT_ROC$SPEC := droplevels(unique(response)),
#       !!CNT_ROC$SENS := sum(predictor),
#       !!CNT_ROC$THR := ci_points,
#       !!CNT_ROC$AUC := do_bootstrap
#     )

#     checkmate::assert_data_frame(roc_curve, nrows = 1)

#     roc_ci <- tibble::tibble(
#       !!CNT_ROC$CI_SPEC := droplevels(unique(response))
#     )

#     roc_oc <- tibble::tibble(
#       !!CNT_ROC$OC_SPEC := droplevels(unique(response))
#     )

#     list(
#       roc_curve = roc_curve,
#       roc_ci = roc_ci,
#       roc_optimal_cut = roc_oc
#     )
#   }

#   ds <- tibble::tibble(
#   !!CNT_ROC$SBJ := factor( c("S1", "S1", "S2", "S3", "S4")),
#   !!CNT_ROC$PPAR := factor(c("P1", "P2", "P2", "P2", "P2")),
#   !!CNT_ROC$PVAL :=        c(   1,    2,    4,    6,    8),
#   !!CNT_ROC$RPAR := factor("R1"),
#   !!CNT_ROC$RVAL := factor(paste(.data[[CNT_ROC$PPAR]], .data[[CNT_ROC$RPAR]], sep = "-"))
# )

#   expected_roc_curve <- tibble::tibble(
#     !!CNT_ROC$PPAR := factor(c("P2", "P1")),
#     !!CNT_ROC$RPAR := factor("R1"),
#     !!CNT_ROC$SPEC := factor(c("P2-R1", NA)),
#     !!CNT_ROC$SENS := c(20, NA),
#     !!CNT_ROC$THR := c("quantiles", NA),
#     !!CNT_ROC$AUC := c(TRUE, NA)
#   )
#   # Order changes because get_roc_data sorts rows by spec and sens, if this arranged is moved out the test changes

#   expected_roc_ci <- tibble::tibble(
#     !!CNT_ROC$PPAR := factor(c("P1", "P2")),
#     !!CNT_ROC$RPAR := factor("R1"),
#     !!CNT_ROC$CI_SPEC := factor(c(NA, "P2-R1"))
#   )

#   expected_roc_oc <- tibble::tibble(
#     !!CNT_ROC$PPAR := factor(c("P1", "P2")),
#     !!CNT_ROC$RPAR := factor("R1"),
#     !!CNT_ROC$OC_SPEC := factor(c(NA, "P2-R1"))
#   )

#   expected_list <- list(
#     roc_curve = expected_roc_curve,
#     roc_ci = expected_roc_ci,
#     roc_optimal_cut = expected_roc_oc
#   )

#   get_roc_data(
#     ds,
#     dummy_fn,
#     "quantiles",
#     TRUE
#   ) %>%
#   expect_identical(
#     expected_list
#   ) %>%
#   expect_message(regexp = "Error: dummy error", fixed = TRUE) # The error from the function must appear as a message
# })

# nolint end
