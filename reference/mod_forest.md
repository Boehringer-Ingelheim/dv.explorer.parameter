# Forest plot module

Display a hybrid table/forest plot of arbitrary statistics
(correlations, odds ratios, ...) computed on dataset parameters over a
single visit.

## Usage

``` r
mod_forest(
  module_id,
  bm_dataset_name,
  group_dataset_name,
  numeric_numeric_functions = list(`Pearson Correlation` =
    dv.explorer.parameter::pearson_correlation, `Spearman Correlation` =
    dv.explorer.parameter::spearman_correlation),
  numeric_factor_functions = list(`Odds Ratio` = dv.explorer.parameter::odds_ratio),
  subjid_var = "USUBJID",
  cat_var = "PARCAT",
  par_var = "PARAM",
  visit_var = "AVISIT",
  value_vars = "AVAL",
  default_cat = NULL,
  default_par = NULL,
  default_visit = NULL,
  default_value = NULL,
  default_var = NULL,
  default_group = NULL,
  default_categorical_A = NULL,
  default_categorical_B = NULL
)
```

## Arguments

- module_id:

  Shiny ID `[character(1)]`

  Module identifier

- bm_dataset_name, group_dataset_name:

  `[character(1)]`

  Dataset names

- numeric_numeric_functions, numeric_factor_functions:

  `[function(n)]`

  Named lists of functions. Each function needs to take two parameters
  and produce a list of four numbers with the following names:

  - result, CI_lower_limit, CI_upper_limit and p_value

  The module will offer the functions as part of its interface and will
  run each function if selected.

  The values returned by the functions are be captured on the output
  table and are also displayed as part of the forest plot.

  `numeric_numeric_functions` take two numeric parameters (e.g.
  [`dv.explorer.parameter::pearson_correlation`](fp_stats.md)) and
  `numeric_factor_functions` should accept a numeric first parameter and
  a categorical (factor) second parameter (e.g.
  [`dv.explorer.parameter::odds_ratio`](fp_stats.md)).

- subjid_var:

  `[character(1)]`

  Column corresponding to the subject ID

- cat_var, par_var, visit_var:

  `[character(1)]`

  Columns from `bm_dataset` that correspond to the parameter category,
  parameter and visit

- value_vars:

  `[character(n)]`

  Columns from `bm_dataset` that correspond to values of the parameters

- default_cat, default_par, default_visit, default_value:

  `[character(1)|NULL]`

  Default values for the selectors

- default_var, default_group, default_categorical_A,
  default_categorical_B:

  `[character(1)|NULL]`

  Default values for the selectors
