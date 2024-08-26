#' @keywords internal
is_outlier <- function(df, outlier_crit, detailed = FALSE) {
  if (detailed) {
    outlier_up <- rep(FALSE, nrow(df))
    outlier_lo <- rep(FALSE, nrow(df))

    purrr::iwalk(outlier_crit, ~ {
      out_up <- if (!is.na(.x[[2]])) df[["z"]] > .x[[2]] else rep(FALSE, nrow(df))
      out_lo <- if (!is.na(.x[[1]])) .x[[1]] > df[["z"]] else rep(FALSE, nrow(df))
      outlier_up <<- outlier | (df[["y"]] == .y & (out_up))
      outlier_lo <<- outlier | (df[["y"]] == .y & (out_lo))
    })

    outlier <- list(up = outlier_up, lo = outlier_lo)
  } else {
    outlier <- rep(FALSE, nrow(df))

    purrr::iwalk(outlier_crit, ~ {
      out_up <- if (!is.na(.x[[2]])) df[["z"]] > .x[[2]] else rep(FALSE, nrow(df))
      out_lo <- if (!is.na(.x[[1]])) .x[[1]] > df[["z"]] else rep(FALSE, nrow(df))
      outlier <<- outlier | (df[["y"]] == .y & (out_up | out_lo))
      outlier[is.na(outlier)] <- FALSE
      outlier
    })
  }

  outlier
}
