# Correlation heatmap server function

Correlation heatmap server function

## Usage

``` r
corr_hm_server(
  id,
  bm_dataset,
  subjid_var = "USUBJID",
  cat_var = "PARCAT",
  par_var = "PARAM",
  visit_var = "AVISIT",
  anlfl_vars = NULL,
  value_vars = "AVAL",
  default_value = NULL
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
