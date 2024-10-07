collect_var_values_across_studies <- function(studies, domain, var) {
  # checks
  local({
    assert <- function(cond, msg) if (!isTRUE(cond)) stop(msg)
    assert(is.list(studies) && length(studies) >= 1, "Need at least one study")
    assert(is.character(domain) && length(domain) == 1, "`domain` should be a string")
    assert(is.character(var) && length(var) == 1, "`var` should be a string")
    domain_present <- sapply(studies, function(study) domain %in% names(study))
    assert(
      all(domain_present),
      sprintf(
        "Domain %s absent from studies: %s", domain,
        paste(names(domain_present[domain_present == FALSE]), collapse = ", ")
      )
    )
    var_present <- sapply(studies, function(study) var %in% names(study[[domain]]))
    assert(
      all(var_present),
      sprintf(
        "Var %s absent from studies: %s", var,
        paste(names(var_present[var_present == FALSE]), collapse = ", ")
      )
    )
    var_class <- class(studies[[1]][[domain]][[var]])

    same_classes <- sapply(studies, function(study) identical(class(study[[domain]][[var]]), var_class))
    assert(all(same_classes), sprintf("Var %s differs across studies", var))
  })

  # actual code
  res <- NULL
  first_var <- studies[[1]][[domain]][[var]]
  if (is.numeric(first_var)) {
    all_values <- lapply(studies, function(df) df[[domain]][[var]])
    res <- sort(unique(unlist(all_values)))
  } else if (is.factor(first_var)) {
    all_levels <- lapply(studies, function(df) levels(df[[domain]][[var]]))
    res <- unique(unlist(all_levels))
  } else {
    stop(sprintf("Unsupported var type: %s", paste(class(first_var), collapse = ", ")))
  }

  return(res)
}

exclude_strings_containing_substring <- function(strings, ss) {
  stopifnot(is.character(strings) || (is.character(ss) && length(ss) == 1))
  return(strings[!grepl(ss, strings, fixed = TRUE)])
}
