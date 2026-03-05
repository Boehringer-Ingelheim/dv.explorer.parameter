# Specification for a set of line plots for classification metrics

The chart consists of a faceted set of line and point charts.

## Usage

``` r
get_metric_spec(ds, param_as_cols, fig_size, limits, x_col)
```

## Arguments

- ds:

  `[data.frames()]`

  A dataframe

- param_as_cols:

  `[logical(1)]`

  Charts are faceted using parameters as columns.

- fig_size:

  `[numeric(1)]`

  Size in pixels for each of the charts in the facet

- limits:

  `[list()]`

  A vector as specified in the input section

- x_col:

  `[character(1)]`

  Column for the x axis of the graph

## Value

A
[vegawidget::vegawidget](https://vegawidget.github.io/vegawidget/reference/vegawidget.html)
specification

## Details

### Rows and columns:

- By default, predictor parameters are displayed in rows while metrics
  are displayed in columns.

## Input

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
