#' Return the value of a reactive or regular value
#'
#' @param r a variable which can be regular or reactive
#'
#' @details It does not work with metaReactives.
#'
#' @returns the value of the variable or the reactive
#' @keywords internal
resolve_or_return <- function(r) {
  if (shiny::is.reactive(r)) {
    r()
  } else {
    r
  }
}

#' If x is `NULL`, return y, otherwise return x
#'
#' @param x,y Two elements to test, one potentially `NULL`
#'
#' @noRd
#'

#' @keywords internal
"%||%" <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}

#' If else alias for x is not `NULL`
#'
#' @param x a potentially NULL variable
#' @param true the value returned when x is not NULL
#' @param false the value returned when x is NULL, by default NULL
#'
#' @noRd
#' @keywords internal
#'
if_not_null <- function(x, true, false = NULL) {
  if (!is.null(x)) true else false
}

#' If selected is not contained in choices send a warning
#'
#' @param selected selection set
#' @param choices choices set
#' @param inputId the inputId of the shiny element being checked
#' @keywords internal

check_selected_choices <- function(selected, choices, inputId) { # nolint
  if (length(base::intersect(choices, selected)) != base::length(selected)) {
    sel_str <- paste(selected, collapse = ",")
    cho_str <- paste(choices, collapse = ",")
    rlang::warn(
      paste0(
        inputId, "selected [", sel_str, "] is not contained in choices [", cho_str, "]"
      )
    )
  }
}

#' Vectorized hash
#'
#' Uses digest with a fixed murmur32 algorithm and no serialization
#'
#' @param object object to be hashed
#' @keywords internal

str_to_hash <- function(object) {
  Vectorize(digest::digest, vectorize.args = "object", USE.NAMES = FALSE)(object, algo = "murmur32", serialize = FALSE)
}

is_validation_error <- function(x) {
  defused_x <- rlang::enquo(x)
  tried_x <- try(rlang::eval_tidy(defused_x), silent = TRUE)
  inherits(attr(tried_x, "condition"), "validation")
}

decorate_cnd <- function(fn, prefix) {
  function(...) {
    withCallingHandlers(
      {
        fn(...)
      },
      condition = function(cnd) {
        cnd[["message"]] <- paste(prefix, cnd[["message"]])
        rlang::cnd_signal(cnd) # Send a new decorated signal
        rlang::cnd_muffle(cnd) # Stop propagation of this signal
      }
    )
  }
}

# Dynamic name assignation
dc <- function(...) {
  unlist(rlang::list2(...))
}

drop_nones <- function(v) {
  purrr::keep(v, ~ .x != "None")
}

ggplot_colors <- function(n, h = c(0, 360) + 15) {
  # Imitates ggplot color scale
  if ((diff(h) %% 360) < 1) h[2] <- h[2] - 360 / n
  grDevices::hcl(h = (seq(h[1], h[2], length = n)), c = 100, l = 65)
}

# string substitution (poor man's glue)
# nolint ssub("substitute THIS and THAT", THIS="_this_", THAT="_that_")
ssub <- function(s, ...) {
  pairs <- list(...)
  for (orig in names(pairs)) {
    dest <- pairs[[orig]]
    s <- gsub(paste0("\\<", orig, "\\>"), dest, s)
  }
  s
}

# javascript identifiers don't tolerate hyphens
underscore_ns <- function(ns, s) paste0(ns(NULL), "_", s)

is_not_null <- Negate(is.null)


# It doesn't make sense for a reactive to trigger when its value has not changed,
# given the fact that every reactive caches its value.
# `reactiveVal` does not suffer from that design mistake, so we can use it to
# filter spureous reactive invalidations.
# We have to apply this treatment judiciously because it makes an extra copy of
# the value returned by the reactive it wraps around, which may prove expensive.
#
# TODO: test this when r() returns a silent error, this may crash the app, or the error value will not be propagated
# though rv()
trigger_only_on_change <- function(r) {
  rv <- shiny::reactiveVal()
  shiny::observe(rv(r()))
  rv
}

# Shiny uses two types of serialization depending on which bookmark encoding
# ('url', 'server') is chosen. 'url' goes through `jsonlite::toJSON`, which
# potentially returns something different that what went in. For storage and
# retrieval of nested types, we can avoid dealing with these two conflicting
# behaviors by making sure to turn everything into a single character string.
to_shiny_bookmark_value <- function(v) {
  serialize(v, connection = NULL) |>
    memCompress(type = "gzip") |>
    base64enc::base64encode()
}
from_shiny_bookmark_value <- function(v) {
  list(unsafe = base64enc::base64decode(v) |> memDecompress(type = "gzip") |> unserialize())
}

drop_columns_by_name <- function(df, col_names) {
  df[col_names] <- list(NULL)
  return(df)
}

# Pseudolog projection. Alternative to log projection that handles non-positive values.
# (see https://win-vector.com/2012/03/01/modeling-trick-the-signed-pseudo-logarithm/amp/)
#
# We could use `scales::pseudo_log_trans(base = 10)`, but its default breaks are bad and won't get fixed:
#  https://github.com/r-lib/scales/issues/219
# We could also take the object returned by that function and modify its `breaks` field, but the structure of ggtplot2
# transform objects is not documented and we can't assume it will remain stable.
# The ggplot2 manual (`?ggplot2::scale_y_continuous`) says transformations must be created through calls to
# `scales::trans_new` (ggplot2 >= 3.5.0) or `scales::new_transform` (ggplot2 >= 3.5.0).
pseudo_log <- function(x, base = 10) asinh(x / 2) / log(base)
inverse_pseudo_log <- function(x, base = 10) 2 * sinh(x * log(base))

pseudo_log_projection <- function(base = 10) {
  breaks <- function(x) {
    res <- NULL
    if (all(x >= 0)) {
      res <- scales::log_breaks(base)(x)
    } else if (all(x <= 0)) {
      res <- -scales::log_breaks(base)(abs(x))
    } else {
      max_limit <- max(c(2, abs(x)))
      breaks <- scales::log_breaks(base)(c(1, max_limit))
      res <- unique(c(-breaks, 0, breaks))
    }
    return(res)
  }

  scales::trans_new(
    name = paste0("pseudolog-", format(base)),
    transform = pseudo_log, inverse = inverse_pseudo_log,
    breaks = breaks, domain = c(-Inf, Inf)
  )
}

