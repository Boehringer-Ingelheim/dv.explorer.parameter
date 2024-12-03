#' Transformation auxiliary functions
#' @name transformation_utils
#' @keywords internal
NULL

#' @describeIn transformation_utils Transformation selecting function
#'
#' @param s the selected transformation
#'
#' @return a function from [get_tr_apply]
#'
#' @keywords internal
#'
get_tr_fun <- function(s) {
  tr <- switch(s,
    "original" = get_tr_apply(tr_identity),
    "scaley" = get_tr_apply(tr_z_score),
    "scale_t" = get_tr_apply(tr_trunc_z_score),
    "norm" = get_tr_apply(tr_min_max),
    "percent" = get_tr_apply(tr_percentize)
  )
  tr
}

#' @describeIn transformation_utils Transformation apply function
#'
#' Get a function that applies a transformation to a given column grouped by another column
#'
#' @param tr a function that has as first parameter the values to transform.
#'
#' @return a function with the following interface `function(df, group_col, val_col, ...)` where `...` is passed to as
#' extra parameters to tr
#'
#' @keywords internal
#'
get_tr_apply <- function(tr) {
  function(df, group_col, val_col, ...) {
    df <- dplyr::group_by(df, .data[[group_col]])
    df <- dplyr::mutate(df, !!val_col := tr(.data[[val_col]], ...))
    df <- dplyr::ungroup(df)
    df
  }
}

#' Transformation functions
#' @name transformation
NULL

#' @describeIn transformation Identity transformation
#' @export
tr_identity <- base::identity

#' @describeIn transformation Z score transformation
#' @param x a vector/list
#' @return a vector/list with the transformed values
#' @export
tr_z_score <- function(x) {
  (x - mean(x, na.rm = TRUE)) / stats::sd(x, na.rm = TRUE)
}

#' @describeIn transformation Gini's mean difference
#' @param x a vector/list
#' @return a vector/list with the transformed values
#' @export
tr_gini <- function(x) {
  x / Hmisc::GiniMd(x, na.rm = TRUE)
}

#' @describeIn transformation Truncated Z score transformation
#'
#' @param x a vector/list
#' @param trunc_min minimum value
#' @param trunc_max maximum value
#' @return a vector/list with the transformed values truncated at the specified cuts
#' @export
tr_trunc_z_score <- function(x, trunc_min = -3, trunc_max = 3) {
  z <- tr_z_score(x)
  z[z > trunc_max] <- trunc_max
  z[z < trunc_min] <- trunc_min
  z
}

#' @describeIn transformation Truncated Z score transformation in the (-3, 3) range
#'
#' @param x a vector/list
#' @return a vector/list with the transformed values truncated at the (-3, 3) cuts
#' @export
tr_trunc_z_score_3_3 <- function(x) tr_trunc_z_score(x, -3, 3)

#' @describeIn transformation Min Max transformation
#' @param x a vector/list
#' @return a vector/list with the transformed values
#' @export
tr_min_max <- function(x) {
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

#' @describeIn transformation Percentize transformation
#' @param x a vector/list
#' @return a vector/list with the transformed values
#' @export
tr_percentize <- function(x) {
  if (!all(is.na(x))) {
    return(stats::ecdf(x)(x))
  } else {
    return(rep(NA, length(x)))
  }
}
