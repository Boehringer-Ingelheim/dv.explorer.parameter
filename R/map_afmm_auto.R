# Automatically generated module API afmm mapping functions. Think twice before editing them manually.
({
# styler: off

# dv.explorer.parameter::mod_boxplot
map_afmm_mod_boxplot_auto <- function(afmm, module_id, bm_dataset_name, group_dataset_name, receiver_id,
    cat_var, par_var, anlfl_vars, value_vars, visit_var, subjid_var, default_cat, default_par, default_visit,
    default_value, default_main_group, default_sub_group, default_page_group, server_wrapper_func) {
    res <- afmm
    mapping_summary <- character(0)
    for (ds_name in names(afmm[["data"]])) {
        ds <- afmm[["data"]][[ds_name]]
        if (is.character(ds[[bm_dataset_name]][[cat_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                cat_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[par_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                par_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[visit_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                visit_var, "\"]]"))
        }
        if (is.character(ds[[group_dataset_name]][[subjid_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", group_dataset_name, "[[\"",
                subjid_var, "\"]]"))
        }
    }
    if (length(mapping_summary)) {
        warning_message <- paste0("[mod_boxplot] This module will map the following dataset columns from `character` to `factor`:\n",
            paste(mapping_summary, collapse = ", "), ".\nThe extra memory cost associated to this operation can be avoided by turning those columns into factors during data pre-processing.")
        warning(warning_message)
        res[["filtered_dataset"]] <- shiny::reactive({
            res <- afmm[["filtered_dataset"]]()
            if (is.character(res[[bm_dataset_name]][[cat_var]])) {
                res[[bm_dataset_name]][[cat_var]] <- as.factor(res[[bm_dataset_name]][[cat_var]])
            }
            if (is.character(res[[bm_dataset_name]][[par_var]])) {
                res[[bm_dataset_name]][[par_var]] <- as.factor(res[[bm_dataset_name]][[par_var]])
            }
            if (is.character(res[[bm_dataset_name]][[visit_var]])) {
                res[[bm_dataset_name]][[visit_var]] <- as.factor(res[[bm_dataset_name]][[visit_var]])
            }
            if (is.character(res[[group_dataset_name]][[subjid_var]])) {
                res[[group_dataset_name]][[subjid_var]] <- as.factor(res[[group_dataset_name]][[subjid_var]])
            }
            return(res)
        })
    }
    return(res)
}

# dv.explorer.parameter::mod_corr_hm
map_afmm_mod_corr_hm_auto <- function(afmm, module_id, bm_dataset_name, subjid_var, cat_var, par_var,
    visit_var, value_vars, default_cat, default_par, default_visit, default_value) {
    res <- afmm
    mapping_summary <- character(0)
    for (ds_name in names(afmm[["data"]])) {
        ds <- afmm[["data"]][[ds_name]]
        if (is.character(ds[[bm_dataset_name]][[subjid_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                subjid_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[cat_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                cat_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[par_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                par_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[visit_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                visit_var, "\"]]"))
        }
    }
    if (length(mapping_summary)) {
        warning_message <- paste0("[mod_corr_hm] This module will map the following dataset columns from `character` to `factor`:\n",
            paste(mapping_summary, collapse = ", "), ".\nThe extra memory cost associated to this operation can be avoided by turning those columns into factors during data pre-processing.")
        warning(warning_message)
        res[["filtered_dataset"]] <- shiny::reactive({
            res <- afmm[["filtered_dataset"]]()
            if (is.character(res[[bm_dataset_name]][[subjid_var]])) {
                res[[bm_dataset_name]][[subjid_var]] <- as.factor(res[[bm_dataset_name]][[subjid_var]])
            }
            if (is.character(res[[bm_dataset_name]][[cat_var]])) {
                res[[bm_dataset_name]][[cat_var]] <- as.factor(res[[bm_dataset_name]][[cat_var]])
            }
            if (is.character(res[[bm_dataset_name]][[par_var]])) {
                res[[bm_dataset_name]][[par_var]] <- as.factor(res[[bm_dataset_name]][[par_var]])
            }
            if (is.character(res[[bm_dataset_name]][[visit_var]])) {
                res[[bm_dataset_name]][[visit_var]] <- as.factor(res[[bm_dataset_name]][[visit_var]])
            }
            return(res)
        })
    }
    return(res)
}

# dv.explorer.parameter::mod_forest
map_afmm_mod_forest_auto <- function(afmm, module_id, bm_dataset_name, group_dataset_name, numeric_numeric_functions,
    numeric_factor_functions, subjid_var, cat_var, par_var, visit_var, value_vars, default_cat, default_par,
    default_visit, default_value, default_var, default_group, default_categorical_A, default_categorical_B) {
    res <- afmm
    mapping_summary <- character(0)
    for (ds_name in names(afmm[["data"]])) {
        ds <- afmm[["data"]][[ds_name]]
        if (is.character(ds[[group_dataset_name]][[subjid_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", group_dataset_name, "[[\"",
                subjid_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[cat_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                cat_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[par_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                par_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[visit_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                visit_var, "\"]]"))
        }
    }
    if (length(mapping_summary)) {
        warning_message <- paste0("[mod_forest] This module will map the following dataset columns from `character` to `factor`:\n",
            paste(mapping_summary, collapse = ", "), ".\nThe extra memory cost associated to this operation can be avoided by turning those columns into factors during data pre-processing.")
        warning(warning_message)
        res[["filtered_dataset"]] <- shiny::reactive({
            res <- afmm[["filtered_dataset"]]()
            if (is.character(res[[group_dataset_name]][[subjid_var]])) {
                res[[group_dataset_name]][[subjid_var]] <- as.factor(res[[group_dataset_name]][[subjid_var]])
            }
            if (is.character(res[[bm_dataset_name]][[cat_var]])) {
                res[[bm_dataset_name]][[cat_var]] <- as.factor(res[[bm_dataset_name]][[cat_var]])
            }
            if (is.character(res[[bm_dataset_name]][[par_var]])) {
                res[[bm_dataset_name]][[par_var]] <- as.factor(res[[bm_dataset_name]][[par_var]])
            }
            if (is.character(res[[bm_dataset_name]][[visit_var]])) {
                res[[bm_dataset_name]][[visit_var]] <- as.factor(res[[bm_dataset_name]][[visit_var]])
            }
            return(res)
        })
    }
    return(res)
}

# dv.explorer.parameter::mod_lineplot
map_afmm_mod_lineplot_auto <- function(afmm, module_id, bm_dataset_name, group_dataset_name, receiver_id,
    summary_fns, subjid_var, cat_var, par_var, anlfl_vars, visit_vars, cdisc_visit_vars, value_vars,
    additional_listing_vars, ref_line_vars, default_centrality_fn, default_dispersion_fn, default_cat,
    default_par, default_val, default_visit_var, default_visit_val, default_main_group, default_sub_group,
    default_transparency, default_y_axis_projection) {
    res <- afmm
    mapping_summary <- character(0)
    for (ds_name in names(afmm[["data"]])) {
        ds <- afmm[["data"]][[ds_name]]
        if (is.character(ds[[group_dataset_name]][[subjid_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", group_dataset_name, "[[\"",
                subjid_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[cat_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                cat_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[par_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                par_var, "\"]]"))
        }
        for (.elem in visit_vars) {
            if (is.character(ds[[bm_dataset_name]][[.elem]])) {
                mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                  .elem, "\"]]"))
            }
        }
    }
    if (length(mapping_summary)) {
        warning_message <- paste0("[mod_lineplot] This module will map the following dataset columns from `character` to `factor`:\n",
            paste(mapping_summary, collapse = ", "), ".\nThe extra memory cost associated to this operation can be avoided by turning those columns into factors during data pre-processing.")
        warning(warning_message)
        res[["filtered_dataset"]] <- shiny::reactive({
            res <- afmm[["filtered_dataset"]]()
            if (is.character(res[[group_dataset_name]][[subjid_var]])) {
                res[[group_dataset_name]][[subjid_var]] <- as.factor(res[[group_dataset_name]][[subjid_var]])
            }
            if (is.character(res[[bm_dataset_name]][[cat_var]])) {
                res[[bm_dataset_name]][[cat_var]] <- as.factor(res[[bm_dataset_name]][[cat_var]])
            }
            if (is.character(res[[bm_dataset_name]][[par_var]])) {
                res[[bm_dataset_name]][[par_var]] <- as.factor(res[[bm_dataset_name]][[par_var]])
            }
            for (.elem in visit_vars) {
                if (is.character(res[[bm_dataset_name]][[.elem]])) {
                  res[[bm_dataset_name]][[.elem]] <- as.factor(res[[bm_dataset_name]][[.elem]])
                }
            }
            return(res)
        })
    }
    return(res)
}

# dv.explorer.parameter::mod_roc
map_afmm_mod_roc_auto <- function(afmm, module_id, pred_dataset_name, resp_dataset_name, group_dataset_name,
    pred_cat_var, pred_par_var, pred_value_vars, pred_visit_var, resp_cat_var, resp_par_var, resp_value_vars,
    resp_visit_var, subjid_var, compute_roc_fn, compute_metric_fn) {
    res <- afmm
    mapping_summary <- character(0)
    for (ds_name in names(afmm[["data"]])) {
        ds <- afmm[["data"]][[ds_name]]
        if (is.character(ds[[pred_dataset_name]][[pred_cat_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", pred_dataset_name, "[[\"",
                pred_cat_var, "\"]]"))
        }
        if (is.character(ds[[pred_dataset_name]][[pred_par_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", pred_dataset_name, "[[\"",
                pred_par_var, "\"]]"))
        }
        if (is.character(ds[[resp_dataset_name]][[resp_cat_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", resp_dataset_name, "[[\"",
                resp_cat_var, "\"]]"))
        }
        if (is.character(ds[[resp_dataset_name]][[resp_par_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", resp_dataset_name, "[[\"",
                resp_par_var, "\"]]"))
        }
        if (is.character(ds[[group_dataset_name]][[subjid_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", group_dataset_name, "[[\"",
                subjid_var, "\"]]"))
        }
    }
    if (length(mapping_summary)) {
        warning_message <- paste0("[mod_roc] This module will map the following dataset columns from `character` to `factor`:\n",
            paste(mapping_summary, collapse = ", "), ".\nThe extra memory cost associated to this operation can be avoided by turning those columns into factors during data pre-processing.")
        warning(warning_message)
        res[["filtered_dataset"]] <- shiny::reactive({
            res <- afmm[["filtered_dataset"]]()
            if (is.character(res[[pred_dataset_name]][[pred_cat_var]])) {
                res[[pred_dataset_name]][[pred_cat_var]] <- as.factor(res[[pred_dataset_name]][[pred_cat_var]])
            }
            if (is.character(res[[pred_dataset_name]][[pred_par_var]])) {
                res[[pred_dataset_name]][[pred_par_var]] <- as.factor(res[[pred_dataset_name]][[pred_par_var]])
            }
            if (is.character(res[[resp_dataset_name]][[resp_cat_var]])) {
                res[[resp_dataset_name]][[resp_cat_var]] <- as.factor(res[[resp_dataset_name]][[resp_cat_var]])
            }
            if (is.character(res[[resp_dataset_name]][[resp_par_var]])) {
                res[[resp_dataset_name]][[resp_par_var]] <- as.factor(res[[resp_dataset_name]][[resp_par_var]])
            }
            if (is.character(res[[group_dataset_name]][[subjid_var]])) {
                res[[group_dataset_name]][[subjid_var]] <- as.factor(res[[group_dataset_name]][[subjid_var]])
            }
            return(res)
        })
    }
    return(res)
}

# dv.explorer.parameter::mod_scatterplot
map_afmm_mod_scatterplot_auto <- function(afmm, module_id, bm_dataset_name, group_dataset_name, cat_var,
    par_var, value_vars, visit_var, subjid_var, default_x_cat, default_x_par, default_x_value, default_x_visit,
    default_y_cat, default_y_par, default_y_value, default_y_visit, default_group, default_color, compute_lm_cor_fn) {
    res <- afmm
    mapping_summary <- character(0)
    for (ds_name in names(afmm[["data"]])) {
        ds <- afmm[["data"]][[ds_name]]
        if (is.character(ds[[bm_dataset_name]][[cat_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                cat_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[par_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                par_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[visit_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                visit_var, "\"]]"))
        }
        if (is.character(ds[[group_dataset_name]][[subjid_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", group_dataset_name, "[[\"",
                subjid_var, "\"]]"))
        }
    }
    if (length(mapping_summary)) {
        warning_message <- paste0("[mod_scatterplot] This module will map the following dataset columns from `character` to `factor`:\n",
            paste(mapping_summary, collapse = ", "), ".\nThe extra memory cost associated to this operation can be avoided by turning those columns into factors during data pre-processing.")
        warning(warning_message)
        res[["filtered_dataset"]] <- shiny::reactive({
            res <- afmm[["filtered_dataset"]]()
            if (is.character(res[[bm_dataset_name]][[cat_var]])) {
                res[[bm_dataset_name]][[cat_var]] <- as.factor(res[[bm_dataset_name]][[cat_var]])
            }
            if (is.character(res[[bm_dataset_name]][[par_var]])) {
                res[[bm_dataset_name]][[par_var]] <- as.factor(res[[bm_dataset_name]][[par_var]])
            }
            if (is.character(res[[bm_dataset_name]][[visit_var]])) {
                res[[bm_dataset_name]][[visit_var]] <- as.factor(res[[bm_dataset_name]][[visit_var]])
            }
            if (is.character(res[[group_dataset_name]][[subjid_var]])) {
                res[[group_dataset_name]][[subjid_var]] <- as.factor(res[[group_dataset_name]][[subjid_var]])
            }
            return(res)
        })
    }
    return(res)
}

# dv.explorer.parameter::mod_scatterplotmatrix
map_afmm_mod_scatterplotmatrix_auto <- function(afmm, module_id, bm_dataset_name, group_dataset_name,
    cat_var, par_var, value_vars, visit_var, subjid_var, default_cat, default_par, default_visit, default_value,
    default_main_group) {
    res <- afmm
    mapping_summary <- character(0)
    for (ds_name in names(afmm[["data"]])) {
        ds <- afmm[["data"]][[ds_name]]
        if (is.character(ds[[bm_dataset_name]][[cat_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                cat_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[par_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                par_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[visit_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                visit_var, "\"]]"))
        }
        if (is.character(ds[[group_dataset_name]][[subjid_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", group_dataset_name, "[[\"",
                subjid_var, "\"]]"))
        }
    }
    if (length(mapping_summary)) {
        warning_message <- paste0("[mod_scatterplotmatrix] This module will map the following dataset columns from `character` to `factor`:\n",
            paste(mapping_summary, collapse = ", "), ".\nThe extra memory cost associated to this operation can be avoided by turning those columns into factors during data pre-processing.")
        warning(warning_message)
        res[["filtered_dataset"]] <- shiny::reactive({
            res <- afmm[["filtered_dataset"]]()
            if (is.character(res[[bm_dataset_name]][[cat_var]])) {
                res[[bm_dataset_name]][[cat_var]] <- as.factor(res[[bm_dataset_name]][[cat_var]])
            }
            if (is.character(res[[bm_dataset_name]][[par_var]])) {
                res[[bm_dataset_name]][[par_var]] <- as.factor(res[[bm_dataset_name]][[par_var]])
            }
            if (is.character(res[[bm_dataset_name]][[visit_var]])) {
                res[[bm_dataset_name]][[visit_var]] <- as.factor(res[[bm_dataset_name]][[visit_var]])
            }
            if (is.character(res[[group_dataset_name]][[subjid_var]])) {
                res[[group_dataset_name]][[subjid_var]] <- as.factor(res[[group_dataset_name]][[subjid_var]])
            }
            return(res)
        })
    }
    return(res)
}

# dv.explorer.parameter::mod_wfphm
map_afmm_mod_wfphm_auto <- function(afmm, module_id, bm_dataset_name, group_dataset_name, cat_var, par_var,
    visit_var, subjid_var, value_vars, bar_group_palette, cat_palette, tr_mapper, show_x_ticks) {
    res <- afmm
    mapping_summary <- character(0)
    for (ds_name in names(afmm[["data"]])) {
        ds <- afmm[["data"]][[ds_name]]
        if (is.character(ds[[bm_dataset_name]][[cat_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                cat_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[par_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                par_var, "\"]]"))
        }
        if (is.character(ds[[bm_dataset_name]][[visit_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", bm_dataset_name, "[[\"",
                visit_var, "\"]]"))
        }
        if (is.character(ds[[group_dataset_name]][[subjid_var]])) {
            mapping_summary <- c(mapping_summary, paste0("(", ds_name, ") ", group_dataset_name, "[[\"",
                subjid_var, "\"]]"))
        }
    }
    if (length(mapping_summary)) {
        warning_message <- paste0("[mod_wfphm] This module will map the following dataset columns from `character` to `factor`:\n",
            paste(mapping_summary, collapse = ", "), ".\nThe extra memory cost associated to this operation can be avoided by turning those columns into factors during data pre-processing.")
        warning(warning_message)
        res[["filtered_dataset"]] <- shiny::reactive({
            res <- afmm[["filtered_dataset"]]()
            if (is.character(res[[bm_dataset_name]][[cat_var]])) {
                res[[bm_dataset_name]][[cat_var]] <- as.factor(res[[bm_dataset_name]][[cat_var]])
            }
            if (is.character(res[[bm_dataset_name]][[par_var]])) {
                res[[bm_dataset_name]][[par_var]] <- as.factor(res[[bm_dataset_name]][[par_var]])
            }
            if (is.character(res[[bm_dataset_name]][[visit_var]])) {
                res[[bm_dataset_name]][[visit_var]] <- as.factor(res[[bm_dataset_name]][[visit_var]])
            }
            if (is.character(res[[group_dataset_name]][[subjid_var]])) {
                res[[group_dataset_name]][[subjid_var]] <- as.factor(res[[group_dataset_name]][[subjid_var]])
            }
            return(res)
        })
    }
    return(res)
}

})
# styler: on
