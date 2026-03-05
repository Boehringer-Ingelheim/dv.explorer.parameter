# Compute classification metrics to groups

It computes classification metrics over a dataset. The application is
applied by groups defined by CNT_ROC\$PPAR, CNT_ROC\$RPAR and, if
grouped, CNT_ROC\$GRP. These functions is prepared to be applied over a
dataset that is the output of [`roc_subset_data()`](roc_subset_data.md).
The function itself does not compute the metrics, it only applies
`compute_metric_fn` over the different groups.

## Usage

``` r
get_metric_data(ds, compute_metric_fn)
```

## Arguments

- ds:

  `[data.frame()]` A dataframe

- compute_metric_fn:

  `[function(1)]` A function that computes the metrics

## Value

`[list()]` A list with entries:

### `ds`

`[data.frame()]`

With columns:

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_parameter` `[factor()]`: Response parameter name.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `type` `[character()]`: Metric name

- `y` `[numeric()]`: Metric value

- `score`, `norm_score`, `norm_rank` `[numeric()]`: Raw, normalized, and
  normalized rank predictor value per group.

### `limits`

`[list()]`

With one entry per metric type. Each entry is a `numeric(2)` that
contains the plotting limits for the metric.

Additionally:

- `score`, `norm_score`, `norm_rank` have a `label` attribute `"Score"`,
  `"Normalized Score"` and `"Normalized Rank"` respectively.

## Input dataframe

`[data.frame()]`

With columns:

- `subject_id` `[factor()]`: Subject ID

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_parameter` `[factor()]`: Response parameter value.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `predictor_value` `[numeric()]`: Predictor parameter Value

- `response_value` `[factor()]`: Response parameter Value.

## compute_metric_fn definition

For an example of a computing function please review
[`compute_metric_data()`](compute_metric.md).
