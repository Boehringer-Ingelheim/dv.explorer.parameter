# Automatically generated module API check functions. Think twice before editing them manually.
({
# styler: off

# dv.explorer.parameter::mod_boxplot
check_mod_boxplot_auto <- function(afmm, datasets, module_id, bm_dataset_name, group_dataset_name, receiver_id,
    cat_var, par_var, value_vars, visit_var, subjid_var, default_cat, default_par, default_visit, default_value,
    default_main_group, default_sub_group, default_page_group, server_wrapper_func, warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- CM$check_module_id("module_id", module_id, warn, err)
    flags <- structure(list(), names = character(0))
    OK[["bm_dataset_name"]] <- CM$check_dataset_name("bm_dataset_name", bm_dataset_name, flags, datasets,
        used_dataset_names, warn, err)
    flags <- list(subject_level_dataset_name = TRUE)
    OK[["group_dataset_name"]] <- CM$check_dataset_name("group_dataset_name", group_dataset_name, flags,
        datasets, used_dataset_names, warn, err)
    "NOTE: receiver_id (character) has no associated automated checks"
    "      The expectation is that it either does not require them or that"
    "      the caller of this function has written manual checks near the call site."
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["cat_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("cat_var", cat_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["par_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("par_var", par_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(one_or_more = TRUE)
    OK[["value_vars"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("value_vars", value_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor"), list(kind = "numeric",
        min = NA, max = NA)))
    flags <- structure(list(), names = character(0))
    OK[["visit_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("visit_var", visit_var,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(subjid_var = TRUE, map_character_to_factor = TRUE)
    OK[["subjid_var"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("subjid_var", subjid_var,
        subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_cat"]] <- OK[["cat_var"]] && CM$check_choice_from_col_contents("default_cat", default_cat,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], cat_var, warn, err)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_par"]] <- OK[["par_var"]] && CM$check_choice_from_col_contents("default_par", default_par,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], par_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_visit"]] <- OK[["visit_var"]] && CM$check_choice_from_col_contents("default_visit",
        default_visit, flags, "bm_dataset_name", datasets[[bm_dataset_name]], visit_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_value"]] <- OK[["value_vars"]] && CM$check_choice("default_value", default_value, flags,
        "value_vars", value_vars, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(optional = TRUE)
    OK[["default_main_group"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("default_main_group",
        default_main_group, subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn,
        err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(optional = TRUE)
    OK[["default_sub_group"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("default_sub_group",
        default_sub_group, subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn,
        err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(optional = TRUE)
    OK[["default_page_group"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("default_page_group",
        default_page_group, subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn,
        err)
    flags <- list(optional = TRUE, ignore = TRUE)
    OK[["server_wrapper_func"]] <- CM$check_function("server_wrapper_func", server_wrapper_func, 1, flags,
        warn, err)
    for (ds_name in names(used_dataset_names)) {
        OK[["subjid_var"]] <- OK[["subjid_var"]] && CM$check_subjid_col(datasets, ds_name, get(ds_name),
            "subjid_var", subjid_var, warn, err)
    }
    return(OK)
}

# dv.explorer.parameter::mod_corr_hm
check_mod_corr_hm_auto <- function(afmm, datasets, module_id, bm_dataset_name, subjid_var, cat_var, par_var,
    visit_var, value_vars, default_cat, default_par, default_visit, default_value, warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- CM$check_module_id("module_id", module_id, warn, err)
    flags <- structure(list(), names = character(0))
    OK[["bm_dataset_name"]] <- CM$check_dataset_name("bm_dataset_name", bm_dataset_name, flags, datasets,
        used_dataset_names, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(subjid_var = TRUE, map_character_to_factor = TRUE)
    OK[["subjid_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("subjid_var", subjid_var,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["cat_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("cat_var", cat_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["par_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("par_var", par_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor"), list(kind = "numeric",
        min = NA, max = NA)))
    flags <- structure(list(), names = character(0))
    OK[["visit_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("visit_var", visit_var,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(one_or_more = TRUE)
    OK[["value_vars"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("value_vars", value_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_cat"]] <- OK[["cat_var"]] && CM$check_choice_from_col_contents("default_cat", default_cat,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], cat_var, warn, err)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_par"]] <- OK[["par_var"]] && CM$check_choice_from_col_contents("default_par", default_par,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], par_var, warn, err)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_visit"]] <- OK[["visit_var"]] && CM$check_choice_from_col_contents("default_visit",
        default_visit, flags, "bm_dataset_name", datasets[[bm_dataset_name]], visit_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_value"]] <- OK[["value_vars"]] && CM$check_choice("default_value", default_value, flags,
        "value_vars", value_vars, warn, err)
    for (ds_name in names(used_dataset_names)) {
        OK[["subjid_var"]] <- OK[["subjid_var"]] && CM$check_subjid_col(datasets, ds_name, get(ds_name),
            "subjid_var", subjid_var, warn, err)
    }
    return(OK)
}

# dv.explorer.parameter::mod_forest
check_mod_forest_auto <- function(afmm, datasets, module_id, bm_dataset_name, group_dataset_name, numeric_numeric_functions,
    numeric_factor_functions, subjid_var, cat_var, par_var, visit_var, value_vars, default_cat, default_par,
    default_visit, default_value, default_var, default_group, default_categorical_A, default_categorical_B,
    warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- CM$check_module_id("module_id", module_id, warn, err)
    flags <- structure(list(), names = character(0))
    OK[["bm_dataset_name"]] <- CM$check_dataset_name("bm_dataset_name", bm_dataset_name, flags, datasets,
        used_dataset_names, warn, err)
    flags <- structure(list(), names = character(0))
    OK[["group_dataset_name"]] <- CM$check_dataset_name("group_dataset_name", group_dataset_name, flags,
        datasets, used_dataset_names, warn, err)
    flags <- list(optional = TRUE, zero_or_more = TRUE, named = TRUE)
    OK[["numeric_numeric_functions"]] <- CM$check_function("numeric_numeric_functions", numeric_numeric_functions,
        2, flags, warn, err)
    flags <- list(optional = TRUE, zero_or_more = TRUE, named = TRUE)
    OK[["numeric_factor_functions"]] <- CM$check_function("numeric_factor_functions", numeric_factor_functions,
        2, flags, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(subjid_var = TRUE, map_character_to_factor = TRUE)
    OK[["subjid_var"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("subjid_var", subjid_var,
        subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["cat_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("cat_var", cat_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["par_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("par_var", par_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor"), list(kind = "numeric",
        min = NA, max = NA)))
    flags <- structure(list(), names = character(0))
    OK[["visit_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("visit_var", visit_var,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(one_or_more = TRUE)
    OK[["value_vars"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("value_vars", value_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_cat"]] <- OK[["cat_var"]] && CM$check_choice_from_col_contents("default_cat", default_cat,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], cat_var, warn, err)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_par"]] <- OK[["par_var"]] && CM$check_choice_from_col_contents("default_par", default_par,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], par_var, warn, err)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_visit"]] <- OK[["visit_var"]] && CM$check_choice_from_col_contents("default_visit",
        default_visit, flags, "bm_dataset_name", datasets[[bm_dataset_name]], visit_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_value"]] <- OK[["value_vars"]] && CM$check_choice("default_value", default_value, flags,
        "value_vars", value_vars, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(optional = TRUE)
    OK[["default_var"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("default_var", default_var,
        subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(optional = TRUE)
    OK[["default_group"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("default_group",
        default_group, subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    flags <- list(optional = TRUE)
    OK[["default_categorical_A"]] <- OK[["default_var"]] && CM$check_choice_from_col_contents("default_categorical_A",
        default_categorical_A, flags, "group_dataset_name", datasets[[group_dataset_name]], default_var,
        warn, err)
    flags <- list(optional = TRUE)
    OK[["default_categorical_B"]] <- OK[["default_var"]] && CM$check_choice_from_col_contents("default_categorical_B",
        default_categorical_B, flags, "group_dataset_name", datasets[[group_dataset_name]], default_var,
        warn, err)
    for (ds_name in names(used_dataset_names)) {
        OK[["subjid_var"]] <- OK[["subjid_var"]] && CM$check_subjid_col(datasets, ds_name, get(ds_name),
            "subjid_var", subjid_var, warn, err)
    }
    return(OK)
}

# dv.explorer.parameter::mod_lineplot
check_mod_lineplot_auto <- function(afmm, datasets, module_id, bm_dataset_name, group_dataset_name, receiver_id,
    summary_fns, subjid_var, cat_var, par_var, visit_vars, cdisc_visit_vars, value_vars, additional_listing_vars,
    ref_line_vars, default_centrality_fn, default_dispersion_fn, default_cat, default_par, default_val,
    default_visit_var, default_visit_val, default_main_group, default_sub_group, default_transparency,
    default_y_axis_projection, warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- CM$check_module_id("module_id", module_id, warn, err)
    flags <- structure(list(), names = character(0))
    OK[["bm_dataset_name"]] <- CM$check_dataset_name("bm_dataset_name", bm_dataset_name, flags, datasets,
        used_dataset_names, warn, err)
    flags <- list(subject_level_dataset_name = TRUE)
    OK[["group_dataset_name"]] <- CM$check_dataset_name("group_dataset_name", group_dataset_name, flags,
        datasets, used_dataset_names, warn, err)
    "NOTE: receiver_id (character) has no associated automated checks"
    "      The expectation is that it either does not require them or that"
    "      the caller of this function has written manual checks near the call site."
    "NOTE: summary_fns (group) has no associated automated checks"
    "      The expectation is that it either does not require them or that"
    "      the caller of this function has written manual checks near the call site."
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(subjid_var = TRUE, map_character_to_factor = TRUE)
    OK[["subjid_var"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("subjid_var", subjid_var,
        subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["cat_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("cat_var", cat_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["par_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("par_var", par_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor"), list(kind = "numeric",
        min = NA, max = NA)))
    flags <- list(one_or_more = TRUE)
    OK[["visit_vars"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("visit_vars", visit_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(zero_or_more = TRUE)
    OK[["cdisc_visit_vars"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("cdisc_visit_vars",
        cdisc_visit_vars, subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(one_or_more = TRUE)
    OK[["value_vars"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("value_vars", value_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "anything")
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["additional_listing_vars"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("additional_listing_vars",
        additional_listing_vars, subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn,
        err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["ref_line_vars"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("ref_line_vars",
        ref_line_vars, subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    "NOTE: default_centrality_fn (character) has no associated automated checks"
    "      The expectation is that it either does not require them or that"
    "      the caller of this function has written manual checks near the call site."
    "NOTE: default_dispersion_fn (character) has no associated automated checks"
    "      The expectation is that it either does not require them or that"
    "      the caller of this function has written manual checks near the call site."
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_cat"]] <- OK[["cat_var"]] && CM$check_choice_from_col_contents("default_cat", default_cat,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], cat_var, warn, err)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_par"]] <- OK[["par_var"]] && CM$check_choice_from_col_contents("default_par", default_par,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], par_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_val"]] <- OK[["value_vars"]] && CM$check_choice("default_val", default_val, flags, "value_vars",
        value_vars, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_visit_var"]] <- OK[["visit_vars"]] && CM$check_choice("default_visit_var", default_visit_var,
        flags, "visit_vars", visit_vars, warn, err)
    "NOTE: default_visit_val (group) has no associated automated checks"
    "      The expectation is that it either does not require them or that"
    "      the caller of this function has written manual checks near the call site."
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(optional = TRUE)
    OK[["default_main_group"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("default_main_group",
        default_main_group, subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn,
        err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(optional = TRUE)
    OK[["default_sub_group"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("default_sub_group",
        default_sub_group, subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn,
        err)
    "NOTE: default_transparency (numeric) has no associated automated checks"
    "      The expectation is that it either does not require them or that"
    "      the caller of this function has written manual checks near the call site."
    "NOTE: default_y_axis_projection (character) has no associated automated checks"
    "      The expectation is that it either does not require them or that"
    "      the caller of this function has written manual checks near the call site."
    for (ds_name in names(used_dataset_names)) {
        OK[["subjid_var"]] <- OK[["subjid_var"]] && CM$check_subjid_col(datasets, ds_name, get(ds_name),
            "subjid_var", subjid_var, warn, err)
    }
    return(OK)
}

# dv.explorer.parameter::mod_roc
check_mod_roc_auto <- function(afmm, datasets, module_id, pred_dataset_name, resp_dataset_name, group_dataset_name,
    pred_cat_var, pred_par_var, pred_value_vars, pred_visit_var, resp_cat_var, resp_par_var, resp_value_vars,
    resp_visit_var, subjid_var, compute_roc_fn, compute_metric_fn, warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- CM$check_module_id("module_id", module_id, warn, err)
    flags <- structure(list(), names = character(0))
    OK[["pred_dataset_name"]] <- CM$check_dataset_name("pred_dataset_name", pred_dataset_name, flags,
        datasets, used_dataset_names, warn, err)
    flags <- structure(list(), names = character(0))
    OK[["resp_dataset_name"]] <- CM$check_dataset_name("resp_dataset_name", resp_dataset_name, flags,
        datasets, used_dataset_names, warn, err)
    flags <- list(subject_level_dataset_name = TRUE)
    OK[["group_dataset_name"]] <- CM$check_dataset_name("group_dataset_name", group_dataset_name, flags,
        datasets, used_dataset_names, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["pred_cat_var"]] <- OK[["pred_dataset_name"]] && CM$check_dataset_colum_name("pred_cat_var",
        pred_cat_var, subkind, flags, pred_dataset_name, datasets[[pred_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["pred_par_var"]] <- OK[["pred_dataset_name"]] && CM$check_dataset_colum_name("pred_par_var",
        pred_par_var, subkind, flags, pred_dataset_name, datasets[[pred_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(one_or_more = TRUE)
    OK[["pred_value_vars"]] <- OK[["pred_dataset_name"]] && CM$check_dataset_colum_name("pred_value_vars",
        pred_value_vars, subkind, flags, pred_dataset_name, datasets[[pred_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor"), list(kind = "numeric",
        min = NA, max = NA)))
    flags <- structure(list(), names = character(0))
    OK[["pred_visit_var"]] <- OK[["pred_dataset_name"]] && CM$check_dataset_colum_name("pred_visit_var",
        pred_visit_var, subkind, flags, pred_dataset_name, datasets[[pred_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["resp_cat_var"]] <- OK[["resp_dataset_name"]] && CM$check_dataset_colum_name("resp_cat_var",
        resp_cat_var, subkind, flags, resp_dataset_name, datasets[[resp_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["resp_par_var"]] <- OK[["resp_dataset_name"]] && CM$check_dataset_colum_name("resp_par_var",
        resp_par_var, subkind, flags, resp_dataset_name, datasets[[resp_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(one_or_more = TRUE)
    OK[["resp_value_vars"]] <- OK[["resp_dataset_name"]] && CM$check_dataset_colum_name("resp_value_vars",
        resp_value_vars, subkind, flags, resp_dataset_name, datasets[[resp_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor"), list(kind = "numeric",
        min = NA, max = NA)))
    flags <- structure(list(), names = character(0))
    OK[["resp_visit_var"]] <- OK[["resp_dataset_name"]] && CM$check_dataset_colum_name("resp_visit_var",
        resp_visit_var, subkind, flags, resp_dataset_name, datasets[[resp_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(subjid_var = TRUE, map_character_to_factor = TRUE)
    OK[["subjid_var"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("subjid_var", subjid_var,
        subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    flags <- list(optional = TRUE)
    OK[["compute_roc_fn"]] <- CM$check_function("compute_roc_fn", compute_roc_fn, 4, flags, warn, err)
    flags <- list(optional = TRUE)
    OK[["compute_metric_fn"]] <- CM$check_function("compute_metric_fn", compute_metric_fn, 2, flags,
        warn, err)
    for (ds_name in names(used_dataset_names)) {
        OK[["subjid_var"]] <- OK[["subjid_var"]] && CM$check_subjid_col(datasets, ds_name, get(ds_name),
            "subjid_var", subjid_var, warn, err)
    }
    return(OK)
}

# dv.explorer.parameter::mod_scatterplot
check_mod_scatterplot_auto <- function(afmm, datasets, module_id, bm_dataset_name, group_dataset_name,
    cat_var, par_var, value_vars, visit_var, subjid_var, default_x_cat, default_x_par, default_x_value,
    default_x_visit, default_y_cat, default_y_par, default_y_value, default_y_visit, default_group, default_color,
    compute_lm_cor_fn, warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- CM$check_module_id("module_id", module_id, warn, err)
    flags <- structure(list(), names = character(0))
    OK[["bm_dataset_name"]] <- CM$check_dataset_name("bm_dataset_name", bm_dataset_name, flags, datasets,
        used_dataset_names, warn, err)
    flags <- list(subject_level_dataset_name = TRUE)
    OK[["group_dataset_name"]] <- CM$check_dataset_name("group_dataset_name", group_dataset_name, flags,
        datasets, used_dataset_names, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["cat_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("cat_var", cat_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["par_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("par_var", par_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(one_or_more = TRUE)
    OK[["value_vars"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("value_vars", value_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor"), list(kind = "numeric",
        min = NA, max = NA)))
    flags <- structure(list(), names = character(0))
    OK[["visit_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("visit_var", visit_var,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(subjid_var = TRUE, map_character_to_factor = TRUE)
    OK[["subjid_var"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("subjid_var", subjid_var,
        subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    flags <- list(optional = TRUE)
    OK[["default_x_cat"]] <- OK[["cat_var"]] && CM$check_choice_from_col_contents("default_x_cat", default_x_cat,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], cat_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_x_par"]] <- OK[["par_var"]] && CM$check_choice_from_col_contents("default_x_par", default_x_par,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], par_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_x_value"]] <- OK[["value_vars"]] && CM$check_choice("default_x_value", default_x_value,
        flags, "value_vars", value_vars, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_x_visit"]] <- OK[["visit_var"]] && CM$check_choice_from_col_contents("default_x_visit",
        default_x_visit, flags, "bm_dataset_name", datasets[[bm_dataset_name]], visit_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_y_cat"]] <- OK[["cat_var"]] && CM$check_choice_from_col_contents("default_y_cat", default_y_cat,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], cat_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_y_par"]] <- OK[["par_var"]] && CM$check_choice_from_col_contents("default_y_par", default_y_par,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], par_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_y_value"]] <- OK[["value_vars"]] && CM$check_choice("default_y_value", default_y_value,
        flags, "value_vars", value_vars, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_y_visit"]] <- OK[["visit_var"]] && CM$check_choice_from_col_contents("default_y_visit",
        default_y_visit, flags, "bm_dataset_name", datasets[[bm_dataset_name]], visit_var, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(optional = TRUE)
    OK[["default_group"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("default_group",
        default_group, subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(optional = TRUE)
    OK[["default_color"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("default_color",
        default_color, subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    flags <- list(optional = TRUE)
    OK[["compute_lm_cor_fn"]] <- CM$check_function("compute_lm_cor_fn", compute_lm_cor_fn, 1, flags,
        warn, err)
    for (ds_name in names(used_dataset_names)) {
        OK[["subjid_var"]] <- OK[["subjid_var"]] && CM$check_subjid_col(datasets, ds_name, get(ds_name),
            "subjid_var", subjid_var, warn, err)
    }
    return(OK)
}

# dv.explorer.parameter::mod_scatterplotmatrix
check_mod_scatterplotmatrix_auto <- function(afmm, datasets, module_id, bm_dataset_name, group_dataset_name,
    cat_var, par_var, value_vars, visit_var, subjid_var, default_cat, default_par, default_visit, default_value,
    default_main_group, warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- CM$check_module_id("module_id", module_id, warn, err)
    flags <- structure(list(), names = character(0))
    OK[["bm_dataset_name"]] <- CM$check_dataset_name("bm_dataset_name", bm_dataset_name, flags, datasets,
        used_dataset_names, warn, err)
    flags <- list(subject_level_dataset_name = TRUE)
    OK[["group_dataset_name"]] <- CM$check_dataset_name("group_dataset_name", group_dataset_name, flags,
        datasets, used_dataset_names, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["cat_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("cat_var", cat_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["par_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("par_var", par_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(one_or_more = TRUE)
    OK[["value_vars"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("value_vars", value_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor"), list(kind = "numeric",
        min = NA, max = NA)))
    flags <- structure(list(), names = character(0))
    OK[["visit_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("visit_var", visit_var,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(subjid_var = TRUE, map_character_to_factor = TRUE)
    OK[["subjid_var"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("subjid_var", subjid_var,
        subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_cat"]] <- OK[["cat_var"]] && CM$check_choice_from_col_contents("default_cat", default_cat,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], cat_var, warn, err)
    flags <- list(zero_or_more = TRUE, optional = TRUE)
    OK[["default_par"]] <- OK[["par_var"]] && CM$check_choice_from_col_contents("default_par", default_par,
        flags, "bm_dataset_name", datasets[[bm_dataset_name]], par_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_visit"]] <- OK[["visit_var"]] && CM$check_choice_from_col_contents("default_visit",
        default_visit, flags, "bm_dataset_name", datasets[[bm_dataset_name]], visit_var, warn, err)
    flags <- list(optional = TRUE)
    OK[["default_value"]] <- OK[["value_vars"]] && CM$check_choice("default_value", default_value, flags,
        "value_vars", value_vars, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(optional = TRUE)
    OK[["default_main_group"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("default_main_group",
        default_main_group, subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn,
        err)
    for (ds_name in names(used_dataset_names)) {
        OK[["subjid_var"]] <- OK[["subjid_var"]] && CM$check_subjid_col(datasets, ds_name, get(ds_name),
            "subjid_var", subjid_var, warn, err)
    }
    return(OK)
}

# dv.explorer.parameter::mod_wfphm
check_mod_wfphm_auto <- function(afmm, datasets, module_id, bm_dataset_name, group_dataset_name, cat_var,
    par_var, visit_var, subjid_var, value_vars, bar_group_palette, cat_palette, tr_mapper, show_x_ticks,
    warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- CM$check_module_id("module_id", module_id, warn, err)
    flags <- structure(list(), names = character(0))
    OK[["bm_dataset_name"]] <- CM$check_dataset_name("bm_dataset_name", bm_dataset_name, flags, datasets,
        used_dataset_names, warn, err)
    flags <- list(subject_level_dataset_name = TRUE)
    OK[["group_dataset_name"]] <- CM$check_dataset_name("group_dataset_name", group_dataset_name, flags,
        datasets, used_dataset_names, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["cat_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("cat_var", cat_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(map_character_to_factor = TRUE)
    OK[["par_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("par_var", par_var, subkind,
        flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor"), list(kind = "numeric",
        min = NA, max = NA)))
    flags <- structure(list(), names = character(0))
    OK[["visit_var"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("visit_var", visit_var,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(subjid_var = TRUE, map_character_to_factor = TRUE)
    OK[["subjid_var"]] <- OK[["group_dataset_name"]] && CM$check_dataset_colum_name("subjid_var", subjid_var,
        subkind, flags, group_dataset_name, datasets[[group_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(one_or_more = TRUE)
    OK[["value_vars"]] <- OK[["bm_dataset_name"]] && CM$check_dataset_colum_name("value_vars", value_vars,
        subkind, flags, bm_dataset_name, datasets[[bm_dataset_name]], warn, err)
    flags <- list(optional = TRUE, zero_or_more = TRUE, named = TRUE, ignore = TRUE)
    OK[["bar_group_palette"]] <- CM$check_function("bar_group_palette", bar_group_palette, 1, flags,
        warn, err)
    flags <- list(optional = TRUE, zero_or_more = TRUE, named = TRUE, ignore = TRUE)
    OK[["cat_palette"]] <- CM$check_function("cat_palette", cat_palette, 1, flags, warn, err)
    flags <- list(optional = TRUE, zero_or_more = TRUE, named = TRUE, ignore = TRUE)
    OK[["tr_mapper"]] <- CM$check_function("tr_mapper", tr_mapper, 1, flags, warn, err)
    "NOTE: show_x_ticks (logical) has no associated automated checks"
    "      The expectation is that it either does not require them or that"
    "      the caller of this function has written manual checks near the call site."
    for (ds_name in names(used_dataset_names)) {
        OK[["subjid_var"]] <- OK[["subjid_var"]] && CM$check_subjid_col(datasets, ds_name, get(ds_name),
            "subjid_var", subjid_var, warn, err)
    }
    return(OK)
}

})
# styler: on
