# Scatterplot module

`mod_scatterplot` is a Shiny module prepared to display a scatterplot of
two biomarkers with different levels of grouping. It also includes a set
of listings with information about the population and the regression and
correlation estimates.

## Usage

``` r
mod_scatterplot(
  module_id,
  bm_dataset_name,
  group_dataset_name,
  cat_var = "PARCAT",
  par_var = "PARAM",
  value_vars = "AVAL",
  visit_var = "AVISIT",
  anlfl_vars = NULL,
  subjid_var = "USUBJID",
  default_x_cat = NULL,
  default_x_par = NULL,
  default_x_value = NULL,
  default_x_visit = NULL,
  default_y_cat = NULL,
  default_y_par = NULL,
  default_y_value = NULL,
  default_y_visit = NULL,
  default_group = NULL,
  default_color = NULL,
  compute_lm_cor_fn = sp_compute_lm_cor_default
)
```

## Arguments

- module_id:

  `[character(1)]`

  Module Shiny id

- bm_dataset_name, group_dataset_name:

  `[character(1)]`

  Name of the dataset

- cat_var, par_var, visit_var:

  `[character(1)]`

  Columns from `bm_dataset` that correspond to the parameter category,
  parameter and visit

- value_vars:

  `[character(n)]`

  Columns from `bm_dataset` that correspond to values of the parameters

- anlfl_vars:

  `[character(n)]`

  Columns from `bm_dataset` that correspond to analysis flags

- subjid_var:

  `[character(1)]`

  Column corresponding to subject ID

- default_x_cat, default_x_par, default_x_visit, default_x_value,
  default_y_cat, default_y_par:

  `[character(1)|NULL]`

  Default values for the selectors

- default_y_visit, default_y_value, default_group, default_color:

  `[character(1)|NULL]`

  Default values for the selectors

- compute_lm_cor_fn:

  `[function()]`

  Function used to compute the linear regression model and correlation
  statistics, please view the corresponding vignette for more details.
