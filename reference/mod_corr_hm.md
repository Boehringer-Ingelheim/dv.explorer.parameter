# Correlation Heatmap module

Display a heatmap of correlation coefficients (Pearson, Spearman) along
with confidence intervals and p-values between dataset parameters over a
single visit.

## Usage

``` r
corr_hm_UI(
  id,
  default_cat = NULL,
  default_par = NULL,
  default_visit = NULL,
  default_corr_method = NULL
)

mod_corr_hm(
  module_id,
  bm_dataset_name,
  subjid_var = "USUBJID",
  cat_var = "PARCAT",
  par_var = "PARAM",
  visit_var = "AVISIT",
  anlfl_vars = NULL,
  value_vars = "AVAL",
  default_cat = NULL,
  default_par = NULL,
  default_visit = NULL,
  default_value = NULL
)
```

## Arguments

- id:

  `[character(1)]`

- default_cat:

  Default selected categories

- default_par:

  Default selected parameters

- default_visit:

  Default selected visits

- default_corr_method:

  Default correlation method `[character(1)]`

  Shiny ID

- module_id:

  Shiny ID `[character(1)]`

  Module identifier

- bm_dataset_name:

  `[character(1)]`

  Biomarker dataset name

- subjid_var:

  `[character(1)]`

  Column corresponding to the subject ID

- cat_var, par_var, visit_var:

  `[character(1)]`

  Columns from `bm_dataset` that correspond to the parameter category,
  parameter and visit

- anlfl_vars:

  `[character(n)]`

  Columns from `bm_dataset` that correspond to analysis flags

- value_vars:

  `[character(n)]`

  Columns from `bm_dataset` that correspond to values of the parameters

- default_value:

  `[character(1)|NULL]`

  Default values for the selectors

## Functions

- `corr_hm_UI()`: UI
