# Scatter plot server function

### Input dataframes:

#### bm_dataset

It expects a dataset similar to
https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192
, 1 record per subject per parameter per analysis visit

It expects, at least, the columns passed in the parameters,
`subjid_var`, `cat_var`, `par_var`, `visit_var` and `value_var`. The
values of these variables are as described in the CDISC standard for the
variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.

#### group_dataset

It expects a dataset with an structure similar to
https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806
, one record per subject

It expects to contain, at least, `subjid_var`

## Usage

``` r
scatterplot_server(
  id,
  bm_dataset,
  group_dataset,
  dataset_name = shiny::reactive(character(0)),
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

- id:

  Shiny ID `[character(1)]`

- bm_dataset, group_dataset:

  `[data.frame()]`

  Dataframes as described in the `Input dataframes` section

- dataset_name:

  `[shiny::reactive(*)]`

  a reactive indicating when the dataset has possibly changed its
  columns

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
