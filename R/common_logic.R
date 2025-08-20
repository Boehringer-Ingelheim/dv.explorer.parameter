#' Subsets a biomarker dataset for a category, parameter, visit and value selection
#'
#' @section Input dataframe:
#'
#' It expects a dataset similar to
#' https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192 ,
#' 1 record per subject per parameter per analysis visit
#'
#' It expects, at least, the columns passed in the parameters,
#' `subj_col`, `cat_col`, `par_col`, `visit_col` and `val_col`.
#' The values of these variables are as described
#' in the CDISC standard for the variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.
#'
#' @details
#'
#' - If at least one parameter name appears under several selected categories, an error is produced
#'
#' @param ds `data.frame()`
#'
#' See *Input dataframe section*
#'
#' @param par,cat `[character*ish*(n)]`
#'
#' Values from `par_col` and `cat_col` to be subset
#'
#' @param val_col `[character*ish*(1)]`
#'
#' Column containing values for the parameters
#'
#' @param vis `[character*ish*(1)]`
#'
#' Values from `vis_col` to be subset
#'
#' @param subj_col,par_col,cat_col,vis_col `[character(1)]`
#'
#' Column for subject id, category, parameter and visit. All specified columns must be factors
#'
#' @return
#'
#' | ``r CNT$SBJ`` | ``r CNT$PAR`` | ``r CNT$CAT`` | ``r CNT$VIS`` | ``r CNT$VAL`` |
#' |            -- |            -- |            -- |            -- |            -- |
#' |             xx|             xx|             xx|            xx |            xx |
#'
#' Additionally:
#'
#' - When present `label` attributes are retained.
#' - When the same parameter is repeated across different categories an error is raised
#'
#' @keywords data, internal

subset_bds_param <- function(ds, par, par_col, cat, cat_col,
                             val_col, vis, vis_col, subj_col,
                             anlfl_col = NULL) {
  # Check types
  ac <- checkmate::makeAssertCollection()
  checkmate::qassert(ds, "d")
  required_cols <- c(par_col, cat_col, val_col, vis_col, subj_col)
  if (!is.null(anlfl_col)) {
    required_cols <- c(required_cols, anlfl_col)
  }
  checkmate::assert_subset(required_cols, names(ds))
  checkmate::reportAssertions(ac)

  ac <- checkmate::makeAssertCollection()
  checkmate::qassert(subj_col, "S1")
  checkmate::qassert(par_col, "S1")
  checkmate::qassert(cat_col, "S1")
  checkmate::qassert(vis_col, "S1")
  checkmate::qassert(ds[[subj_col]], "f")
  checkmate::qassert(ds[[par_col]], "f")
  checkmate::qassert(ds[[cat_col]], "f")
  checkmate::qassert(ds[[vis_col]], "f")
  if (!is.null(anlfl_col) && anlfl_col %in% names(ds)) {
    checkmate::qassert(anlfl_col, "S1")
    checkmate::qassert(ds[[anlfl_col]], "f")
  }
  checkmate::reportAssertions(ac)

  selected_cols <- character(0)
  selected_cols[[CNT$SBJ]] <- subj_col
  selected_cols[[CNT$CAT]] <- cat_col
  selected_cols[[CNT$PAR]] <- par_col
  selected_cols[[CNT$VIS]] <- vis_col
  selected_cols[[CNT$VAL]] <- val_col

  if (!is.null(anlfl_col)) {
    selected_cols[[CNT$ANLFL]] <- anlfl_col
  }

  mask <- ds[[cat_col]] %in% cat & ds[[par_col]] %in% par & ds[[vis_col]] %in% vis
  if (!is.null(anlfl_col) && anlfl_col %in% names(ds)) {
    mask <- mask & ds[[anlfl_col]] %in% "Y"
  }
  subset_ds <- ds[mask, selected_cols]
  colnames(subset_ds) <- names(selected_cols)

  par_in_several_cat <- !test_one_cat_per_par(ds = subset_ds, cat_col = CNT$CAT, par_col = CNT$PAR)
  if (par_in_several_cat) {
    rlang::abort("Repeated parameter names in different categories is not supported
Please contact the DaVinci team if this must be implemented
A possible solution is to paste the category in the parameter name during preprocessing")
    #     This piece of logic is complicated and needs input from the user, initially this seems like an unlikely case.
    # nolint start
    # - Factors are releved when parameter is repeated across categories
    # - If parameters are renamed an attribute `parameter_renamed` is set to TRUE
    #      log_inform("Renaming parameters repeated across categories", class = "DEBUG")
    #      subset_ds[[CNT$PAR]] <- factor(paste0(subset_ds[[CNT$CAT]], "-", subset_ds[[CNT$PAR]])) # nolint
    #      attr(subset_ds, "parameter_renamed") <- TRUE
    # nolint end
  }

  # Columns are renamed therefore direct labelling does not work
  renamed_labels <- stats::setNames(get_lbls_robust(ds)[selected_cols], names(selected_cols))
  subset_ds <- set_lbls(subset_ds, renamed_labels)
  subset_ds
}

#' Subsets a group dataset, usually adsl, for a group_column_selection
#'
#' @section Input dataframe:
#'
#' It expects a dataset with an structure similar to
#' https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806 , one record per subject
#'
#' It expects to contain, at least, `subj_col` and all entries in `group_vect` as columns
#'
#' @param group_vect `[named(character(n))]`
#'
#' Columns to be subset and renamed.
#'
#' @param ds `[data.frame()]`
#'
#' Data frame to be subset, see section *Input dataframes*
#'
#' @param subj_col `[character(1)]`
#'
#' Column for subject id. `subj_col` must be a factor
#'
#' @returns
#'
#' `data.frame()`
#'
#'
#' | ``r CNT$SBJ`` | `names(group_vec)[[1]]` | `names(group_vec)[[2]]` | ... |
#' |            -- |                      -- |                      -- |  -- |
#' |             xx|                       xx|                       xx|  xx |
#'
#' - When present `label` attribute is retained.
#'
#' @keywords internal


subset_adsl <- function(ds, group_vect, subj_col) {
  checkmate::assert_subset(c(group_vect, subj_col), names(ds))

  selected_cols <- c(
    stats::setNames(subj_col, CNT$SBJ),
    group_vect
  )

  subset_ds <- ds[, selected_cols, drop = FALSE]
  colnames(subset_ds) <- names(selected_cols)
  # Columns are renamed therefore direct labelling does not work
  renamed_labels <- stats::setNames(get_lbls_robust(ds)[selected_cols], names(selected_cols))

  subset_ds <- set_lbls(subset_ds, renamed_labels)
  subset_ds
}

# Helper functions ----

#' Test if a group has a single row for the combinations of a set of grouping variables
#'
#' It contains at least the subject id. It includes a need version to include in a validate body.
#'
#' @param ds `[data.frame()]`
#'  The dataset to be tested
#'
#' @param subj_col `[character(1)]`
#'  Name of the column containing the subject_id
#'
#' @param ... `[character(1)]`
#' Other column names for grouping
#'
#' @param msg `[character(1)]`
#' Validation message
#'
#' @returns `[logical(1)]`
#' `TRUE` if a single row is found, `FALSE` otherwise
#'
#' @keywords internal
#'
#'
test_one_row_per_sbj <- function(ds, subj_col, ...) {
  all(
    dplyr::count(
      ds,
      dplyr::across(dplyr::all_of(c(subj_col, ...))),
      name = "n"
    )[["n"]] == 1
  )
}

#' @rdname test_one_row_per_sbj
need_one_row_per_sbj <- function(..., msg) {
  shiny::need(
    test_one_row_per_sbj(...),
    msg
  )
}

#' Test if a parameter only appears under one category
#'
#' It contains at least the subject id. It includes a need to use inside a validate body
#'
#' @param ds `[data.frame()]`
#'  The dataset to be tested
#'
#' @param par_col `[character(1)]`
#'  Name of the column containing the parameter name
#'
#' @param cat_col `[character(1)]`
#'  Name of the column containing the category name
#'
#' @param ... arguments passed to test_one_cat_per_par
#'
#' @param msg `[character(1)]`
#'
#' Validation message to be diplayed
#'
#'
#' @returns `[logical(1)]`
#' `TRUE` if a parameter appears under a single category, `FALSE` otherwise
#'
#' @keywords helper
#'
#'
test_one_cat_per_par <- function(ds, cat_col, par_col) {
  d <- ds |>
    dplyr::distinct(
      dplyr::across(
        dplyr::all_of(
          c(par_col, cat_col)
        )
      )
    ) |>
    dplyr::count(
      dplyr::across(
        dplyr::all_of(
          c(par_col)
        )
      )
    ) |>
    dplyr::pull(.data[["n"]])

  all(d == 1)
}
#' @rdname test_one_cat_per_par
need_one_cat_per_var <- function(..., msg) {
  shiny::need(
    test_one_cat_per_par(...),
    msg
  )
}

# Force factors from the beginning if they are not factors
as_factor_if_not_factor <- function(x) {
  if (!is.factor(x)) {
    log_inform("Cohercing to factor")
    as.factor(x)
  } else {
    x
  }
}

need_rows <- function(ds, msg = CMN$MSG$VALIDATE$NO_ROWS) {
  shiny::need(
    nrow(ds) > 0,
    msg
  )
}

#' Test has repeated cols
#' @param ds1,ds2 datframes to test
#' @param ignore columns to ignore while testing
#' @param ... Argument forwarded to test_disjunct_cols
#' @param msg Validation message
#' @keywords internal
test_disjunct_cols <- function(ds1, ds2, ignore = NULL) {
  n1 <- setdiff(names(ds1), ignore)
  n2 <- setdiff(names(ds2), ignore)
  checkmate::test_disjunct(n1, n2)
}
#' @rdname test_disjunct_cols
need_disjunct_cols <- function(..., msg) {
  shiny::need(
    test_disjunct_cols(...),
    msg
  )
}


# Get names of numerical columns
get_num_cols <- function(d) {
  purrr::keep(names(d), function(x) {
    is.numeric(d[[x]])
  })
}

need_no_rep_names_but_sbj <- function(d1, d2, msg) {
  shiny::need(
    {
      d1_names <- names(d1)
      d2_names <- names(d2)
      d1_names <- d1_names[d1_names != c(CNT$SBJ)]
      d2_names <- d2_names[d2_names != c(CNT$SBJ)]
      checkmate::test_disjunct(d1_names, d2_names)
    },
    msg
  )
}

# Helpers ----

#' Strip ".data" pronoun from a string
#'
#' This function removes the `.data` pronoun and the `[[]]` accesor from a string using a regular expression pattern.
#' It works also when the .data is surrounded by `c()`. If there is no match the string is returned unmodified.
#'
#' @param x A character string to be processed.
#'
#' @return A character string with the ".data" pronoun removed.
#'
#' @keywords internal
#'

strip_data_pronoun <- function(x) {
  # A functional albeit complicated regexp
  if (is.null(x)) {
    return(NULL)
  }

  sub(
    pattern = "^\\.data\\[\\[[\"\']{1}(.*)[[\"\']{1}]]$|^c\\(\\.data\\[\\[[\"\']{1}(.*)[[\"\']{1}]]\\)$", # nolint
    replacement = "\\1\\2", # When there is no match for a group "" is returned. Matches are mutually exclusive therefore only one will match #nolint
    x = x
  )
}

#' Rename a data frame with a list/character vector of new names
#'
#' The names are the old names and the values are the new names. `rename_vec` names not present in `ds` are ignored.
#'
#' @param ds `data.frame()`
#'
#' A dataframe
#'
#' @param rename_vec `named.list()|named.character()`
#'
#' A named list or character vector with the new names
#'
#' @return
#'
#' `data.frame()`
#'
#' Returns renamed `ds`
#'
#' @keywords internal
#'
rename_with_list <- function(ds, rename_vec) {
  if (is.list(rename_vec)) {
    rename_vec <- stats::setNames(as.character(rename_vec), names(rename_vec))
  }
  dplyr::rename_with(ds, .fn = function(x) {
    rename_vec[x]
  }, .cols = intersect(names(ds), names(rename_vec)))
}

#' Create a mask to filter a dataframe from a named list of values
#'
#' It returns a logical mask indicating which rows have all columns in the list equal to the value in the list. It only
#' calculates equality with a reducing function `&`.
#'
#' Any attempt to generalize this function is very likely a mistake as it is thought to be a shorthand
#' for a common operation.
#'
#' @param ds `data.frame()`
#'
#' A dataframe
#'
#' @param fl `named.list()|named.atomic()`
#'
#' A named list or atomic vector
#'
#'
#' @keywords internal
equal_and_mask_from_vec <- function(ds, fl) {
  if (!checkmate::test_subset(names(fl), names(ds))) {
    # Trivial case in which we try to filter for a column not present in ds
    # This condition can never be met therefore we return FALSE mask
    # This cannot be handled by the general case as c(TRUE, TRUE) & NULL == logical(0)
    return(rep(FALSE, nrow(ds)))
  }
  mask <- rep_len(TRUE, nrow(ds))
  mask <- purrr::reduce2(names(fl), fl, function(m, n, v) {
    m & ds[[n]] == v
  }, .init = mask)
}
