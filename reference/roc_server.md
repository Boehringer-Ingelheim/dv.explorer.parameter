# ROC server function

### Input dataframes:

#### pred_dataset

It expects a dataset similar to
https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192
, 1 record per subject per parameter per analysis visit

It expects, at least, the columns passed in the parameters,
`subjid_var`, `pred_cat_var`, `pred_par_var`, `pred_visit_var` and
`pred_value_var`. The values of these variables are as described in the
CDISC standard for the variables USUBJID, PARCAT, PARAM, AVISIT and
AVAL.

#### resp_dataset

It expects a dataset similar to
https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192

It expects, at least, the columns passed in the parameters,
`subjid_var`, `resp_cat_var`, `resp_par_var`, `resp_visit_var` and
`resp_value_var`. The values of these variables are as described in the
CDISC standard for the variables USUBJID, PARCAT, PARAM, AVISIT and
AVAL.

#### group_dataset

It expects a dataset with an structure similar to
https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806
, one record per subject

It expects to contain, at least, `subjid_var`

## Usage

``` r
roc_server(
  id,
  pred_dataset,
  resp_dataset,
  group_dataset,
  dataset_name = shiny::reactive(character(0)),
  pred_cat_var = "PARCAT",
  pred_par_var = "PARAM",
  pred_value_vars = "AVAL",
  pred_visit_var = "AVISIT",
  resp_cat_var = "PARCAT",
  resp_par_var = "PARAM",
  resp_value_vars = c("CHG1", "CHG2"),
  resp_visit_var = "AVISIT",
  subjid_var = "USUBJID",
  quantile_type = 7L,
  compute_roc_fn = compute_roc_data,
  compute_metric_fn = compute_metric_data
)
```

## Arguments

- id:

  Shiny ID `[character(1)]`

- pred_dataset, resp_dataset, group_dataset:

  `[data.frame()]`

  Dataframes as described in the `Input dataframes` section

- dataset_name:

  `[shiny::reactive(*)]`

  a reactive indicating when the dataset has possibly changed its
  columns

- pred_cat_var, pred_par_var, pred_visit_var, resp_cat_var,
  resp_par_var, resp_visit_var:

  `[character(1)]`

  Columns from `pred_dataset`/`resp_dataset` that correspond to the
  parameter category, parameter and visit

- pred_value_vars, resp_value_vars:

  `[character(n)]`

  Columns from `pred_dataset`,`resp_dataset` that correspond to values
  of the parameters

- subjid_var:

  `[character(1)]`

  Column corresponding to subject ID

- quantile_type:

  `[integer(1)]`

  Quantile algorithm type passed to
  [`quantile`](https://rdrr.io/r/stats/quantile.html) (an integer
  between 1 and 9, default 7).

- compute_roc_fn, compute_metric_fn:

  `[function()]`

  Functions used to compute the ROC and metric analysis, please view the
  corresponding vignette for more details.
