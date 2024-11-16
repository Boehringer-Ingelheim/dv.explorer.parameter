# Automatically generated module API check functions. Think twice before editing them manually.
({
# styler: off

# dv.explorer.parameter::mod_corr_hm
check_mod_corr_hm_auto <- function(afmm, datasets, module_id, bm_dataset_name, subjid_var, cat_var, par_var,
    visit_var, value_vars, default_cat, default_par, default_visit, default_val, warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- C_check_module_id("module_id", module_id, warn, err)
    OK[["bm_dataset_name"]] <- C_check_dataset_name("bm_dataset_name", bm_dataset_name, datasets, used_dataset_names,
        warn, err)
    subkind <- list(kind = "factor")
    flags <- list(subjid_var = TRUE)
    OK[["subjid_var"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("subjid_var", subjid_var,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- structure(list(), names = character(0))
    OK[["cat_var"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("cat_var", cat_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- structure(list(), names = character(0))
    OK[["par_var"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("par_var", par_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor"), list(kind = "numeric",
        min = NA, max = NA)))
    flags <- structure(list(), names = character(0))
    OK[["visit_var"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("visit_var", visit_var,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(one_or_more = TRUE)
    OK[["value_vars"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("value_vars", value_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    "TODO: default_cat (choice_from_col_contents)"
    "TODO: default_par (choice_from_col_contents)"
    "TODO: default_visit (choice_from_col_contents)"
    "TODO: default_val (choice)"
    return(OK)
}

# dv.explorer.parameter::mod_lineplot
check_mod_lineplot_auto <- function(afmm, datasets, module_id, bm_dataset_name, group_dataset_name, receiver_id,
    subjid_var, cat_var, par_var, visit_vars, cdisc_visit_vars, value_vars, additional_listing_vars,
    ref_line_vars, default_transparency, warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- C_check_module_id("module_id", module_id, warn, err)
    OK[["bm_dataset_name"]] <- C_check_dataset_name("bm_dataset_name", bm_dataset_name, datasets, used_dataset_names,
        warn, err)
    OK[["group_dataset_name"]] <- C_check_dataset_name("group_dataset_name", group_dataset_name, datasets,
        used_dataset_names, warn, err)
    "TODO: receiver_id (character)"
    subkind <- list(kind = "factor")
    flags <- list(subjid_var = TRUE)
    OK[["subjid_var"]] <- OK[["group_dataset_name"]] && C_check_dataset_colum_name("subjid_var", subjid_var,
        subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- structure(list(), names = character(0))
    OK[["cat_var"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("cat_var", cat_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- structure(list(), names = character(0))
    OK[["par_var"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("par_var", par_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor"), list(kind = "numeric",
        min = NA, max = NA)))
    flags <- list(zero_or_more = TRUE)
    OK[["visit_vars"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("visit_vars", visit_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "numeric", min = NA, max = NA)))
    flags <- list(zero_or_more = TRUE)
    OK[["cdisc_visit_vars"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("cdisc_visit_vars",
        cdisc_visit_vars, subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(zero_or_more = TRUE)
    OK[["value_vars"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("value_vars", value_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "anything")
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["additional_listing_vars"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("additional_listing_vars",
        additional_listing_vars, subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn,
        err)
    subkind <- list(kind = "anything")
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["ref_line_vars"]] <- OK[["bm_dataset_name"]] && C_check_dataset_colum_name("ref_line_vars", ref_line_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    "TODO: default_transparency (numeric)"
    return(OK)
}

})
# styler: on
