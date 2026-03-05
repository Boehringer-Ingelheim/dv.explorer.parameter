# Boxplot module

`mod_boxplot` is a Shiny module prepared to display data with boxplot
charts with different levels of grouping. It also includes a set of
listings with information about the population, distribution and
statistical comparisons.

## Usage

``` r
mod_boxplot(
  module_id,
  bm_dataset_name,
  group_dataset_name,
  receiver_id = NULL,
  cat_var = "PARCAT",
  par_var = "PARAM",
  value_vars = "AVAL",
  visit_var = "AVISIT",
  anlfl_vars = NULL,
  subjid_var = "SUBJID",
  quantile_type = 7L,
  default_cat = NULL,
  default_par = NULL,
  default_visit = NULL,
  default_value = NULL,
  default_main_group = NULL,
  default_sub_group = NULL,
  default_page_group = NULL,
  server_wrapper_func = function(x) list(subj_id = x)
)
```

## Arguments

- module_id:

  `[character(1)]`

  Module Shiny id

- bm_dataset_name, group_dataset_name:

  `[character(1)]`

  Name of the dataset

- receiver_id:

  `[character(1)]`

  Shiny ID of the module receiving the selected subject ID in the data
  listing. This ID must be present in the app or be NULL.

  inheritParams boxplot_server

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

- quantile_type:

  `[integer(1)]`

  Quantile algorithm type passed to
  [`quantile`](https://rdrr.io/r/stats/quantile.html) (an integer
  between 1 and 9, default 7).

- default_cat, default_par, default_visit, default_value,
  default_main_group, default_sub_group, default_page_group:

  `[character(1)|NULL]`

  Default values for the selectors

- server_wrapper_func:

  `[function()]`

  A function that will be applied to the server returned value. Its
  default value will work for the current cases.
