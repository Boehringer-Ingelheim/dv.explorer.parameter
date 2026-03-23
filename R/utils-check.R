# Function check unicity of rows for specific groups
# It is only used in this

check_unique_cat_par_combinations <- function(dataset, cat_var, par_var) {

  unique_cat_par_combinations <- vctrs::vec_unique(dataset[c(cat_var, par_var)])
  any_dup <- vctrs::vec_duplicate_any(unique_cat_par_combinations[par_var])

  if (any_dup) {
    dup_mask <- vctrs::vec_duplicate_id(unique_cat_par_combinations[par_var]) != seq_len(nrow(unique_cat_par_combinations))
  } else {
    dup_mask <- FALSE
  }

  list(
    unique = unique_cat_par_combinations,
    any_dup = any_dup,
    dup_mask = dup_mask
  )
}

check_unique_sub_cat_par_vis_combinations <- function(dataset, sub_var, cat_var, par_var, vis_var) {
  supposedly_unique <- dataset[c(sub_var, cat_var, par_var, vis_var)]
  any_dup <- vctrs::vec_duplicate_any(supposedly_unique)

  if (any_dup) {
    dup_mask <- dup_mask <- vctrs::vec_duplicate_id(supposedly_unique) != seq_len(nrow(supposedly_unique))
  } else {
    dup_mask <- FALSE
  }

  list(
    any_dup = any_dup,
    dup_mask = dup_mask
  )
}

CM_check_unique_sub_cat_par_vis <- function(datasets, ds_name, ds_value, sub, cat, par, vis, anlfl = NULL, warn, err) {
    ok <- TRUE
    df_to_string <- function(df) {
      names(df) <- sprintf("[%s] ", names(df))
      lines <- utils::capture.output(print(as.data.frame(df), right = FALSE, row.names = FALSE, quote = TRUE)) |>
        trimws()
      return(paste(lines, collapse = "\n"))
    }
  
    dataset <- datasets[[ds_value]]

    # If specified, filter on analysis flag
    if (!is.null(anlfl)) {
      dataset <- dataset[dataset[[anlfl]] %in% "Y", ]
    }
  
  # Text to indicate filter on analysis flag
    if (is.null(anlfl)) {
      ds_filter <- ""
    } else {
      ds_filter <- paste0(" filtered on `", CM$format_inline_asis(sprintf('%s = "Y"', anlfl)), "`")
    }

    ok <- local({        
      cat_par_combinations <- check_unique_cat_par_combinations(dataset, cat, par)      

      CM$assert(err, !cat_par_combinations[["any_dup"]], {
        cat_par_combinations[["unique"]]        
        unique_repeat_params <- vctrs::vec_unique(cat_par_combinations[["unique"]][[par]][cat_par_combinations[["dup_mask"]]])
        dups <- df_to_string(
          data.frame(
            check.names = FALSE,
            Parameter = unique_repeat_params,
            "Inside categories" = sapply(
              unique_repeat_params,
              function(param) {
                dup_mask <- (cat_par_combinations[["unique"]][[par]] == param)
                return(paste(cat_par_combinations[["unique"]][dup_mask, ][[cat]], collapse = ", "))
              }
            )
          )
        )
        prefix_repeat_params_command <-
          sprintf(
            '%s <- dv.explorer.parameter::prefix_repeat_parameters(%s, cat_var = "%s", par_var = "%s")',
            ds_value,
            ds_value,
            cat,
            par
          )

        mask <- cat_par_combinations[["unique"]][[par]] %in% unique_repeat_params
        deduplicated_table <- df_to_string({
          cats <- cat_par_combinations[["unique"]][mask, ][[cat]]
          pars <- cat_par_combinations[["unique"]][mask, ][[par]]
          data.frame(
            check.names = FALSE,
            Category = cats,
            "Old parameter name" = pars,
            "New parameter name" = paste0(cats, "-", pars)
          )
        })

        paste(
          sprintf("The dataset provided by `%s` (%s)%s", ds_name, ds_value, ds_filter),
          "contains parameter names that repeat across categories.",
          "This module expects them to be unique. This is the list of duplicates:",
          paste0("<pre>", dups, "</pre>"),
          "In order to bypass this issue, we suggest you preprocess that dataset with this command:",
          paste0("<pre>", prefix_repeat_params_command, "</pre>"),
          sprintf(
            '<small><i>In case the dataset labeled as "%s" has a different name in your application code,',
            ds_value
          ),
          "substitute it with the actual name of the variable holding that dataset.</i></small><br>",
          "The",
          CM$format_inline_asis("dv.explorer.parameter::prefix_repeat_parameters"),
          "function",
          "will rename the repeat parameters by prefixing them with the category they belong to, as shown on this table:",
          "<pre>",
          deduplicated_table,
          "</pre>"
        )
      })
      
    })

    

    ok <- ok &&
      local({
        sub_cat_par_vis_combinations <- check_unique_sub_cat_par_vis_combinations(dataset, sub, cat, par, vis)        

        CM$assert(err, !sub_cat_par_vis_combinations[["any_dup"]], {          
          prefixes <- c(
            rep("Subject:", length(sub)),
            rep("Category:", length(cat)),
            rep("Parameter:", length(par)),
            rep("Visit:", length(vis))
          )

          first_duplicates <- head(supposedly_unique[sub_cat_par_vis_combinations[["dup_mask"]], ], 5)
          names(first_duplicates) <- paste(prefixes, names(first_duplicates))
          dups <- df_to_string(first_duplicates)

          unique_repeats <- unique(supposedly_unique[sub_cat_par_vis_combinations[["dup_mask"]], ])
          target <- unique_repeats[1, ]
          target_rows <- which(
            supposedly_unique[[sub]] == target[[sub]] &
              supposedly_unique[[cat]] == target[[cat]] &
              supposedly_unique[[par]] == target[[par]] &
              supposedly_unique[[vis]] == target[[vis]]
          )
          target_rownames <- attr(dataset[target_rows, ], "row.names")

          row_a <- dataset[target_rows[1], ]
          row_b <- dataset[target_rows[2], ]
          diff_cols <- character(0)
          for (col in names(row_a)) {
            if (!identical(row_a[[col]], row_b[[col]])) diff_cols <- c(diff_cols, col)
          }

          col_diff_report <- "are identical."
          if (length(diff_cols)) {
            col_diff_report <- paste0(
              "have indeed identical subject, category, parameter and visit values, but differ in columns: ",
              paste(diff_cols, collapse = ", "),
              ".",
              "<pre>",
              df_to_string(dataset[target_rows[1:2], c(sub, cat, par, vis, anlfl, diff_cols)]),
              "</pre>"
            )
          }

          paste(
            sprintf("The dataset provided by `%s` (%s)%s", ds_name, ds_value, ds_filter),
            "contains repeated rows with identical subject, category, parameter and visit values.",
            "This module expects them to be unique.",
            sprintf("There are a total of %d duplicates.", sum(sub_cat_par_vis_combinations[["dup_mask"]])),
            "Here are the first few:",
            paste0("<pre>", dups, "</pre>"),
            sprintf(
              "These findings can be partially confirmed by examining that rows <b>%d</b> and <b>%d</b> of that dataset",
              target_rownames[1],
              target_rownames[2]
            ),
            col_diff_report
          )
        })
      })

    return(ok)
}