# nolint start

# TODO: Generate from mod_corr_hm_API
# This function has been written manually, but mod_corr_hm_API carries
# enough information to derive most of it automatically

C_check_call <- list()
C_check_call[["dv.explorer.parameter::mod_corr_hm"]] <- function(
    afmm, datasets, module_id, bm_dataset_name, subjid_var, cat_var, par_var, visit_var,
    value_vars, default_cat, default_par, default_visit, default_value) {
  # styler: off
  warn <- C_container()
  err <- C_container()

  check_corr_hm_call_auto()

  # is_date_lower_or_equal <- function(a, b) all(as.POSIXct(a) <= as.POSIXct(b), na.rm = TRUE)

  # allowed_classes_logical <- c("logical")
  # allowed_classes_character <- c("character")
  # allowed_classes_character_factor <- c("character", "factor")
  # allowed_classes_numeric <- c("integer", "numeric")
  # allowed_classes_date <- c("Date", "POSIXt")

  # afmm_datasets <- paste(names(datasets), collapse = ", ")

  used_dataset_names <- list() # name identifies parameter, value stores dataset name

  # module_id
  C_assert(err, !missing(module_id), "`module_id` missing") &&
    C_assert(err, checkmate::test_string(module_id), "`module_id` should be a string") &&
    C_assert(warn, nchar(module_id) > 0, "Consider providing a non-empty `module_id`.") &&
    C_assert(err,
      C_is_valid_shiny_id(module_id),
      paste(
        "`module_id` should be a valid identifier, starting with a letter and followed by",
        "alphanumeric characters, hyphens and underscores"
      )
    )

  # bm_dataset_name
  bm_dataset_ok <- (
    C_assert(err, !missing(bm_dataset_name), "`bm_dataset_name` missing") &&
      C_assert(err,
        checkmate::test_string(bm_dataset_name, min.chars = 1),
        "`bm_dataset_name` should be a non-empty string"
      ) &&
      C_assert(err,
        bm_dataset_name %in% names(datasets),
        paste(
          "`bm_dataset_name` does not refer to any of the available datasets:",
          afmm_datasets
        )
      )
  )
  if (bm_dataset_ok) {
    used_dataset_names[["bm_dataset_name"]] <- bm_dataset_name
  }

  # # group_dataset_name
  # group_dataset_ok <- (
  #   C_assert(err, !missing(group_dataset_name), "`group_dataset_name` missing") &&
  #     C_assert(err,
  #       checkmate::test_string(group_dataset_name, min.chars = 1),
  #       "`group_dataset_name` should be a non-empty string"
  #     ) &&
  #     C_assert(err,
  #       group_dataset_name %in% names(datasets),
  #       paste(
  #         "`group_dataset_name` does not refer to any of the available datasets:",
  #         afmm_datasets
  #       )
  #     )
  # )
  # if (group_dataset_ok) {
  #   used_dataset_names[["group_dataset_name"]] <- group_dataset_name
  # }

  # # receiver_id
  # allowed_receiver_ids <- names(afmm$module_names)
  # C_assert(err, is.null(receiver_id) || (checkmate::test_string(receiver_id) && receiver_id %in% allowed_receiver_ids),
  #            sprintf("`receiver_id` (%s) not found among module list. Possible choices are: %s",
  #                    receiver_id, paste(allowed_receiver_ids, collapse = ", ")))

  # # TODO: summary_functions

  # # subjid_var
  # subjid_var_ok <- (
  #   C_assert(err, !missing(subjid_var), "`subjid_var` missing") &&
  #     C_assert(err, checkmate::test_string(subjid_var, min.chars = 1), "`subjid_var` should be a non-empty string") &&
  #     group_dataset_ok
  # )

  # if (subjid_var_ok) {
  #   dataset <- datasets[[group_dataset_name]]
  #   C_assert(err, subjid_var %in% names(dataset), "`subjid_var` not a column of `group_dataset_name`")
  #   C_assert(err,
  #     !any(duplicated(dataset[[subjid_var]])),
  #     sprintf(
  #       "`subjid_var` (%s) does not uniquely identify rows of `group_dataset_name` (%s)",
  #       subjid_var, group_dataset_name
  #     )
  #   )
  # }

  # cat_var
  cat_var_ok <- FALSE
  if (bm_dataset_ok &&
      C_assert(err, checkmate::test_string(cat_var, min.chars = 1), "`cat_var` should be a non-empty string")){
    dataset <- datasets[[bm_dataset_name]]
    cat_var_ok <- C_assert(err, cat_var %in% names(dataset),
                             sprintf("`cat_var` refers to unknown dataset variable (%s)", cat_var))
  }

  # par_var
  par_var_ok <- FALSE
  if (bm_dataset_ok &&
      C_assert(err, checkmate::test_string(par_var, min.chars = 1), "`par_var` should be a non-empty string")){
    dataset <- datasets[[bm_dataset_name]]
    par_var_ok <- C_assert(err, par_var %in% names(dataset),
                             sprintf("`par_var` refers to unknown dataset variable (%s)", par_var))
  }

  # visit_var
  visit_var_ok <- FALSE
  if (bm_dataset_ok &&
      C_assert(err, checkmate::test_string(visit_var, min.chars = 1),
                 "`visit_vars` should be a non-empty string")){
    dataset <- datasets[[bm_dataset_name]]
    visit_var_ok <- C_assert(err, visit_var %in% names(dataset),
                               sprintf("`par_var` refers to unknown dataset variable (%s)", visit_var))
  }

  # # cdisc_visit_vars
  # cdisc_visit_vars_ok <- FALSE
  # if (bm_dataset_ok &&
  #     C_assert(err, checkmate::test_character(cdisc_visit_vars, min.chars = 1, unique = TRUE),
  #                "`cdisc_visit_vars` should be a non-empty character array")){
  #   dataset <- datasets[[bm_dataset_name]]
  #   excess_cols <- setdiff(cdisc_visit_vars, names(dataset))

  #   cdisc_visit_vars_ok <- C_assert(err,
  #     length(excess_cols) == 0,
  #     sprintf("`cdisc_visit_vars` refers to unknown dataset variables (%s)", paste(excess_cols, collapse = ", "))
  #   )
  # }

  # # visit_vars + cdisc_visit_vars # NOTE: Automating this one would be going too far
  # if (visit_vars_ok || cdisc_visit_vars_ok) {
  #   C_assert(err, length(visit_vars) + length(cdisc_visit_vars) > 0,
  #              "Either `visit_vars` or `cdisc_visit_vars` should be a non-empty character array")
  # }
  # if (visit_vars_ok && cdisc_visit_vars_ok) {
  #   C_assert(err, length(intersect(visit_vars, cdisc_visit_vars)) == 0,
  #              "`visit_vars` and `cdisc_visit_vars` should be disjunct")
  # }

  # # value_vars
  # if (bm_dataset_ok &&
  #     C_assert(err, checkmate::test_character(value_vars, min.len = 1, min.chars = 1, unique = TRUE),
  #                "`value_vars` should be a non-empty character array")){
  #   dataset <- datasets[[bm_dataset_name]]
  #   excess_cols <- setdiff(value_vars, names(dataset))

  #   C_assert(err,
  #     length(excess_cols) == 0,
  #     sprintf("`value_vars` refers to unknown dataset variables (%s)", paste(excess_cols, collapse = ", "))
  #   )
  # }

  # # additional_listing_vars
  # if (bm_dataset_ok &&
  #     C_assert(err, checkmate::test_character(additional_listing_vars, min.chars = 1, unique = TRUE),
  #                "`additional_listing_vars` should be a non-empty character array")){
  #   dataset <- datasets[[bm_dataset_name]]
  #   excess_cols <- setdiff(additional_listing_vars, names(dataset))

  #   C_assert(err,
  #     length(excess_cols) == 0,
  #     sprintf("`additional_listing_vars` refers to unknown dataset variables (%s)", paste(excess_cols, collapse = ", "))
  #   )
  # }
  # # ref_line_vars
  # ref_line_vars_ok <- FALSE
  # if (bm_dataset_ok &&
  #     C_assert(err, checkmate::test_character(ref_line_vars, min.chars = 1, unique = TRUE),
  #                "`ref_line_vars` should be a non-empty character array")){
  #   dataset <- datasets[[bm_dataset_name]]
  #   excess_cols <- setdiff(ref_line_vars, names(dataset))

  #   ref_line_vars_ok <- C_assert(err,
  #     length(excess_cols) == 0,
  #     sprintf("`ref_line_vars` refers to unknown dataset variables (%s)", paste(excess_cols, collapse = ", "))
  #   )
  # }

  # # Check that ref_line_vars contain the same value for all records of the same parameter
  # if(ref_line_vars_ok && visit_vars_ok && cat_var_ok && par_var_ok){
  #   unique_ref_values <- local({
  #     dataset <- datasets[[bm_dataset_name]]
  #     return(nrow(unique(dataset[c(cat_var, par_var, ref_line_vars)])) == nrow(unique(dataset[c(cat_var, par_var)])))
  #   })
  #   #browser()

  #   # TODO: Provide more detail
  #   ref_line_vars_ok <- C_assert(err,
  #     unique_ref_values,
  #     sprintf("`ref_line_vars` (%s) are not unique across combinations of category and parameter",
  #             paste(ref_line_vars, collapse = ", "))
  #   )
  # }


  # # TODO(miguel): the intersection of visit_vars and cdisc_visit_vars should be empty
  # #               their union should be non-empty
  # #               probably not worth to expand the API description macros to account for this

  # # TODO: default_centrality_function
  # # TODO: default_dispersion_function
  # # TODO: default_cat
  # # TODO: default_par
  # # TODO: default_val
  # # TODO: default_visit_var
  # # TODO: default_visit_val
  # # TODO: default_main_group
  # # TODO: default_sub_group

  # # default_transparency
  # C_assert(err, checkmate::test_number(default_transparency, lower = 0.05, upper = 1.0),
  #            "`default_transparency` should be a number between 0.05 and 1.00")

  # # TODO: default_y_axis_projection

  res <- list(warnings = warn[["messages"]], errors = err[["messages"]])
  return(res)
  # styler: on
}

# nolint end
