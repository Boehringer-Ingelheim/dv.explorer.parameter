# types for mod_forest and mod_corr_hm
TYPES <- poc( # nolint
  size = function(e) {
    checkmate::qassert(e, "N2")
    checkmate::assert_set_equal(names(e), c("w", "h"))
  },
  result_table = function(e) {
    checkmate::assert_data_frame(e)
    checkmate::assert_subset(c("result", "CI_lower_limit", "CI_upper_limit"), names(e)) # TODO: POC
    checkmate::assert_numeric(e[["result"]], ) # TODO: POC
    checkmate::assert_numeric(e[["CI_lower_limit"]]) # TODO: POC
    checkmate::assert_numeric(e[["CI_upper_limit"]]) # TODO: POC
  },
  data_subset = function(e) {
    checkmate::assert_data_frame(e)
    checkmate::assert_subset(c("subject_id", "category", "parameter", "value"), names(e)) # TODO: POC
    checkmate::assert_factor(e[["subject_id"]]) # TODO: POC
    checkmate::assert_factor(e[["category"]]) # TODO: POC
    checkmate::assert_factor(e[["parameter"]]) # TODO: POC
    checkmate::assert_numeric(e[["value"]]) # TODO: POC
  },
  sl_df = function(e) {
    checkmate::assert_data_frame(e)
    checkmate::assert_subset(c(CNT$SBJ, "var2"), names(e)) # TODO: POC
  },
  named_function_list = function(e) {
    checkmate::assert_list(e, names = "unique")
    for (element in e) {
      checkmate::assert_class(element, "function")
    }
  },
  axis_config = function(e) {
    checkmate::assert_numeric(e, names = "unique")
    checkmate::assert_subset(c("x_min", "x_max", "ref_line_x", "tick_count"), names(e))
  },
  fun = function(e) {
    checkmate::assert_function(e)
  },
  forest_kind = function(e) {
    checkmate::qassert(e, "S")
  },
  sequence_permutation = function(e) {
    checkmate::qassert(e, "I")
    checkmate::assert_true(min(e) == 1)
    checkmate::assert_true(all(diff(sort(e)) == 1))
  },
  svg = function(e) {
    checkmate::assert_string(e)
    checkmate::assert_class(e, "html")
  },
  S = function(e) {
    checkmate::qassert(e, "S")
  },
  heatmap_df = function(e) {
    checkmate::assert_data_frame(e, min.rows = 1)
    checkmate::assert_subset(c("x", "y", "z"), names(e))
  },
  corr_listing_df = function(e) {
    checkmate::assert_data_frame(e, min.rows = 1)
    checkmate::assert_subset(c("x", "y", "N"), names(e))
  },
  ggplot = function(e) {
    checkmate::assert_class(e, "ggplot")
  }
)

# Functions marked as strict disallow reactive evaluation and
# require its arguments and return value to be tagged with the _type attribute
strict <- function(f) {
  f_name <- deparse(substitute(f))
  typechecked_f <- function(...) {
    args <- list(...)

    caller_args <- as.list(match.call())[-1]
    resolved_args <- as.list(match.call(f, do.call(call, c("f", args)), expand.dots = TRUE))[-1]
    arg_names <- names(resolved_args)

    if (length(caller_args) != length(resolved_args) || (!is.null(arg_names) && "" %in% arg_names)) {
      stop('"strict" function is trying to be too clever. Please, contact the author')
    }

    for (i_arg in seq_along(arg_names)) {
      arg_name <- arg_names[[i_arg]]
      arg <- resolved_args[[arg_name]]
      type <- attr(arg, "_type")
      if (is.null(type)) {
        stop(
          paste0(
            'Untyped argument "',
            arg_name, '" in call to ',
            f_name, '; expression at call site is "',
            caller_args[[i_arg]], '"'
          )
        )
      }
    }

    res <- shiny::maskReactiveContext(do.call(f, args))

    type <- attr(res, "_type")
    if (is.null(type)) {
      stop(paste0("Untyped return value in call to ", f_name))
    }

    res
  }
  typechecked_f
}

check_type <- function(e, t) {
  if (attr(e, "_type") != t) {
    stop(paste0('Expected type "', t, '" for argument "', deparse(substitute(e))), '"')
  }
  if (!t %in% names(TYPES)) {
    stop(paste0('Missing function to check type "', t, '"'))
  }
  TYPES[[t]](e)
}

type <- function(e, t, allow_NULL = FALSE) { # nolint
  if (allow_NULL == FALSE || !is.null(e)) {
    attr(e, "_type") <- t # nolint
    check_type(e, t)
  }
  e
}

if (!isTRUE(as.logical(Sys.getenv("STRICT_TYPES")))) { # deactivate strict types
  # can't .onLoad() this thing, because that happens at the end
  # and we've already stricted some top-level functions
  strict <- identity
  check_type <- function(e, ...) e
  type <- function(e, ...) e
}
