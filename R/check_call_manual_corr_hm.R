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

  OK <- check_mod_corr_hm_auto(
    afmm, datasets, module_id, bm_dataset_name, subjid_var, cat_var, par_var, visit_var,
    value_vars, default_cat, default_par, default_visit, default_value,
    warn, err
  )

  # TODO: Add checks that mod_API does not capture


  res <- list(warnings = warn[["messages"]], errors = err[["messages"]])
  return(res)
  # styler: on
}

# nolint end
