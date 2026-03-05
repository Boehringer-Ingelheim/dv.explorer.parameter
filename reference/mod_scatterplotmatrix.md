# Matrix of scatterplots module

`mod_scatterplotmatrix` is a Shiny module prepared to display data in a
matrix of scatterplots with different levels of grouping. It also
includes correlation stats.

## Usage

``` r
mod_scatterplotmatrix(
  module_id,
  bm_dataset_name,
  group_dataset_name,
  cat_var = "PARCAT",
  par_var = "PARAM",
  value_vars = "AVAL",
  visit_var = "AVISIT",
  anlfl_vars = NULL,
  subjid_var = "USUBJID",
  default_cat = NULL,
  default_par = NULL,
  default_visit = NULL,
  default_value = NULL,
  default_main_group = NULL
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

- default_cat, default_par, default_visit, default_value,
  default_main_group:

  `[character(1)|NULL]`

  Default values for the selectors
