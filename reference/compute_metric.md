# Helpers for computing metric data from the subset dataset

Helpers for computing metric data from the subset dataset

## Usage

``` r
assert_compute_metric_data(r)

compute_metric_data(predictor, response)
```

## Arguments

- r:

  `[data.frame()]`

  dataframe resulting from compute_metric_data

- predictor:

  `[numeric()]`

  The scores of the predictor

- response:

  `[factor()]`

  The response value

## Value

`[data.frame()]`

With columns:

- `type` `[character()]`: Metric name

- `y` `[numeric()]`: Metric value

- `score`, `norm_score`, `norm_rank` `[numeric()]`: Raw, normalized, and
  normalized rank predictor value per group.

With an attribute:

- `limits` `[list()]`: With one entry per metric type. Each entry is a
  `numeric(2)` that contains the plotting limits for the metric.

## Functions

- `assert_compute_metric_data()`: Assert compute_metric result
  data.frame types are correct

- `compute_metric_data()`: Compute metric analysis
