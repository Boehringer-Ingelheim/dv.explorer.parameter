# Boxplot server function

### Input dataframes:

#### bm_dataset

It expects a dataset similar to
https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192
, 1 record per subject per parameter per value of the selected x-axis
variable.

It must contain, at least, the columns passed in the parameters,
`subjid_var`, `cat_var`, `par_var`, `x_axis_vars` and `value_vars`.
These correspond respectively to the subject identifier, parameter
category, parameter, x-axis grouping variables, and parameter values.

#### group_dataset

It expects a dataset with an structure similar to
https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806
, one record per subject.

It must contain, at least, the column passed in the parameter,
`subjid_var`.

## Usage

``` r
boxplot_server(
  id,
  bm_dataset,
  group_dataset,
  dataset_name = shiny::reactive(character(0)),
  cat_var = "PARCAT",
  par_var = "PARAM",
  value_vars = "AVAL",
  x_axis_vars = NULL,
  anlfl_vars = NULL,
  subjid_var = "USUBJID",
  quantile_type = 7L,
  default_cat = NULL,
  default_par = NULL,
  default_x_axis_var = NULL,
  default_x_axis_vals = NULL,
  default_value = NULL,
  default_main_group = NULL,
  default_sub_group = NULL,
  default_page_group = NULL,
  on_sbj_click = function(x) {
 }
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

- cat_var, par_var:

  `[character(1)]`

  Columns from `bm_dataset` that correspond to the parameter category
  and parameter

- value_vars:

  `[character(n)]`

  Columns from `bm_dataset` that correspond to values of the parameters

- x_axis_vars:

  `[character(n)]`

  Columns from `bm_dataset` that correspond to x-axis variables

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

- default_cat, default_par, default_x_axis_var, default_value,
  default_main_group, default_sub_group, default_page_group:

  `[character(1)|NULL]`

  Default values for the selectors

- default_x_axis_vals:

  `[character(n)|NULL]`

  Default values for the x-axis variable

- on_sbj_click:

  `[function()]`

  Function to invoke when a subject is clicked in the single subject
  listing
