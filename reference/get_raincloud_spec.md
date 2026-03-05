# Specification for a set of raincloud plots

The chart consists of a faceted set of raincloud. Each facet will be
grouped by the value of the response parameter.

## Usage

``` r
get_raincloud_spec(area_ds, quantile_ds, point_ds, param_as_cols, fig_size)
```

## Arguments

- area_ds, quantile_ds, point_ds:

  `[data.frames()]`

  A dataframe

- param_as_cols:

  `[logical(1)]`

  Charts are faceted using parameters as columns.

- fig_size:

  `[numeric(1)]`

  Size in pixels for each of the charts in the facet

## Value

A
[vegawidget::vegawidget](https://vegawidget.github.io/vegawidget/reference/vegawidget.html)
specification

## Details

### Rows and columns:

- By default, predictor parameters are displayed in rows while grouping
  is displayed in columns.

- If no grouping is selected, then parameters are displayed in cols.

## Input dataframe list

### `area_ds`

`[data.frame()]`

With columns:

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_value` `[factor()]`: Response parameter value.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `dens_x` `[numeric()]`: Predictor parameter value.

- `dens_y` `[numeric()]`: Predictor parameter probability density.

### `quantile_ds`

`[data.frame()]`

With columns:

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_value` `[factor()]`: Response parameter value.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `mean` `[numeric()]`: Mean of the predictor parameter value

- `q05`, `q25`, `q50`, `q75`, `q95` `[numeric()]`: Quantiles of the
  predictor parameter value

### `point_ds`

`[data.frame()]`

With columns:

- `subject_id` `[factor()]`: Subject ID

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_parameter` `[factor()]`: Response parameter value.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `predictor_value` `[numeric()]`: Predictor parameter Value

- `response_value` `[factor()]`: Response parameter Value.
