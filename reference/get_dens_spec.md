# Specification for a set of faceted probability density plots

The chart consists of a faceted set of ROC curves plotting probability
density curves for the values of the different predictor parameters.
Each facet will be grouped by the value of the response parameter.

## Usage

``` r
get_dens_spec(ds, param_as_cols, fig_size)
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

## Value

A
[vegawidget::vegawidget](https://vegawidget.github.io/vegawidget/reference/vegawidget.html)
specification

## Details

### Rows and columns:

- By default, predictor parameters are displayed in rows while grouping
  is displayed in columns.

- If no grouping is selected, then parameters are displayed in cols.

- All groups corresponding to the same parameters share the same X and Y
  axis limits.

## Input dataframe

`[data.frame()]`

With columns:

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_value` `[factor()]`: Response parameter value.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `dens_x` `[numeric()]`: Predictor parameter value.

- `dens_y` `[numeric()]`: Predictor parameter probability density.
