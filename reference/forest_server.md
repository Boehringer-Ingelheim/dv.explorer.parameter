# Forest plot server function

Forest plot server function

## Usage

``` r
forest_server(
  id,
  bm_dataset,
  group_dataset,
  dataset_name = shiny::reactive(character(0)),
  numeric_numeric_functions = list(),
  numeric_factor_functions = list(),
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

- id:

  `[character(1)]`

  Shiny ID

- bm_dataset:

  `[data.frame()]`

  An ADBM-like dataset similar in structure to the one in [this
  example](https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192),
  with one record per subject per parameter per analysis visit.

  It should have, at least, the columns specified by the parameters
  `subjid_var`, `cat_var`, `par_var`, `visit_var` and `value_vars`. The
  semantics of these columns are as described in the CDISC standard for
  variables USUBJID, PARCAT, PARAM, AVISIT and AVAL, respectively.

- group_dataset:

  `[data.frame()]`

  An ADSL-like dataset similar in structure to the one in [this
  example](https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806),
  with one record per subject.

  It should contain, at least, the column specified by the parameter
  `subjid_var`.

- dataset_name:

  `[shiny::reactive(*)]`

  A reactive that indicates a possible change in the column structure of
  any of the two datasets

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
