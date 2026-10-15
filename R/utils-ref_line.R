generate_ref_line_data <- function(df, show_all_ref_vals) {
  checkmate::assert_subset(CNT$PAR, names(df))
  checkmate::assert_logical(show_all_ref_vals, len = 1)
  
  originally_grouped <- (CNT$MAIN_GROUP %in% names(df))

  # Introduce artificial grouping. It is removed from the result before exiting this function
  if (!originally_grouped) df[[CNT$MAIN_GROUP]] <- as.factor("Common reference value")

  # Introduce extra level to customize color of reference lines that would otherwise overlap
  df[[CNT$MAIN_GROUP]] <- factor(df[[CNT$MAIN_GROUP]],
                                 levels = union(levels(df[[CNT$MAIN_GROUP]]), "Common reference value"))
  if (show_all_ref_vals) { # Make all lines apply to all groups
    df[[CNT$MAIN_GROUP]] <- factor("Common reference value", levels = levels(df[[CNT$MAIN_GROUP]]))
  }

  common_vars <- c(CNT$PAR, CNT$MAIN_GROUP)
  ref_line_vars <- setdiff(names(df), common_vars)

  res <- list() # one data.frame per ref_line_var indicating which ref lines to draw for each parameter

  for (var in ref_line_vars){
    entry_name <- get_lbl_robust(df, var)
    if (show_all_ref_vals) entry_name <- paste0(entry_name, "\n(all ref. values)")
    var_df <- unique(df[c(common_vars, var)])
    names(var_df)[names(var_df) == var] <- CNT$VAL

    res[[entry_name]] <- var_df[FALSE, ] # data.frame without rows
    for (param in unique(df[[CNT$PAR]])){
      var_param_df <- var_df[var_df[[CNT$PAR]] == param, ]

      if (length(unique(var_param_df[[CNT$VAL]])) == 1) {
        # All groups share the same reference value so we group them as one
        row <- var_param_df[1, ]
        row[1, CNT$MAIN_GROUP] <- "Common reference value"
        res[[entry_name]] <- rbind(res[[entry_name]], row)
      } else if (show_all_ref_vals) {
        res[[entry_name]] <- rbind(res[[entry_name]], var_param_df)
      } else {
        # Collect all group levels with a single assigned reference value
        for (group in unique(var_param_df[[CNT$MAIN_GROUP]])){
          mask <- (var_param_df[[CNT$MAIN_GROUP]] == group)
          if (sum(mask) == 1) {
            res[[entry_name]] <- rbind(res[[entry_name]], var_param_df[mask, ])
          }
        }
      }
    }
    if (nrow(res[[entry_name]]) == 0) res[[entry_name]] <- NULL # Drop empty ref_line_vars
  }

  if (!originally_grouped) for (i in seq_along(res)) res[[i]][[CNT$MAIN_GROUP]] <- NULL

  return(res)
}

compute_overlap_of_ref_line_data <- function(ref_line_data) {
  overlap_info <- list()
  for (name in names(ref_line_data)){
    element <- ref_line_data[[name]]
    if (CNT$MAIN_GROUP %in% names(element)) {
      repeat_mask <- duplicated(element[c(CNT$PAR, CNT$VAL)])
      repeat_vals_per_par <- unique(element[c(CNT$PAR, CNT$VAL)][repeat_mask, ])

      for (i_row in seq_len(nrow(repeat_vals_per_par))){
        row <- repeat_vals_per_par[i_row, ]
        mask <- element[[CNT$PAR]] == row[[CNT$PAR]] & element[[CNT$VAL]] == row[[CNT$VAL]]
        repeat_groups <- element[mask, CNT$MAIN_GROUP]
        if (length(repeat_groups)) {
          overlap_info[[length(overlap_info) + 1]] <- list(parameter = row[[CNT$PAR]], value = row[[CNT$VAL]],
                                                           groups = repeat_groups)
        }
      }
    }
  }
  return(overlap_info)
}

