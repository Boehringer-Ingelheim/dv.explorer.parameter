# Specification for an ordered AUC value plus CI chart

The chart consists of a set of points with confidence intervals
representing the AUC and its confidence interval.

## Usage

``` r
get_explore_roc_spec(ds, fig_size, sort_alph)
```

## Arguments

- ds:

  `[data.frame()]`

  A data.frame

- fig_size:

  `[numeric(1)]`

  Size in pixels for the chart

- sort_alph:

  `[logical(1)]`

  Sort chart by parameter name

## Value

A
[vegawidget::vegawidget](https://vegawidget.github.io/vegawidget/reference/vegawidget.html)
specification

## Details

Parameters, by default, are vertically ordered from highest to lowest
AUC curve. When grouped, parameters will be combined with the grouping
variable.

## Internal checks

### Shiny validation errors:

- If the number of rows returned is greater than
  `ROC_VAL$MAX_ROWS_EXPLORE` a validation error is produced. Otherwise
  the chart is too large, for greater limits than
  `ROC_VAL$MAX_ROWS_EXPLORE` the session may crash.

## Input dataframe list

### `ds`

`[data.frame()]`

With columns:

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_parameter` `[factor()]`: Response parameter name.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `specificity` `[numeric()]`: Sensitivity

- `sensitivity` `[numeric()]`: Specificity

- `threshold` `[numeric()]`: Threshold

- `auc` `[numeric(3)]`: A numeric vector of length 3 c(LOWER AUC CI,
  AUC, UPPER AUC CI)
