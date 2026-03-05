# ROC module

ROC module

Invoke ROC module

## Usage

``` r
mod_roc(
  module_id,
  pred_dataset_name,
  resp_dataset_name,
  group_dataset_name,
  pred_cat_var = "PARCAT",
  pred_par_var = "PARAM",
  pred_value_vars = "AVAL",
  pred_visit_var = "AVISIT",
  resp_cat_var = "PARCAT",
  resp_par_var = "PARAM",
  resp_value_vars = c("CHG1", "CHG2"),
  resp_visit_var = "AVISIT",
  subjid_var = "USUBJID",
  quantile_type = 7,
  compute_roc_fn = compute_roc_data,
  compute_metric_fn = compute_metric_data
)
```

## Arguments

- module_id:

  `[character(1)]`

  Module identificator

- pred_dataset_name, resp_dataset_name, group_dataset_name:

  Name of the dataset

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
