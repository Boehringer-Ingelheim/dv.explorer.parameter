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

  # Checks that API spec does not (yet?) capture
  if(OK[["bm_dataset_name"]] && OK[["subjid_var"]]) {
    dataset <- datasets[[bm_dataset_name]]
    C_assert(err, is.factor(dataset[[subjid_var]]), 'Column referenced by `subjid_var` should be a factor.')
  }

  if(OK[["bm_dataset_name"]] && OK[["subjid_var"]] && OK[["cat_var"]] && OK[["par_var"]] && OK[["visit_var"]]) {
    dataset <- datasets[[bm_dataset_name]]
    supposedly_unique <- dataset[c(subjid_var, cat_var, par_var, visit_var)]
    dups <- duplicated(supposedly_unique)

    C_assert(err, !any(dups), {
      dups <- capture.output(print(head(supposedly_unique[dups, ], 5))) |> paste(collapse = '\n')
      paste("The dataset provided contains repeated rows with identical subject, category, parameter and",
            "visit values. This module expects them to be unique. Here are the first few duplicates:",
            paste('<pre>', dups, '</pre>'))
    })
  }


  res <- list(warnings = warn[["messages"]], errors = err[["messages"]])
  return(res)
  # styler: on
}

# nolint end
