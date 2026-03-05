# Calculate probability density per group

It calculates the probability density of the parameter value by groups
defined by `predictor_parameter`, `response_parameter` and, if grouped,
`group`. These functions is prepared to be applied over a dataset that
is the output of [`roc_subset_data()`](roc_subset_data.md).

## Usage

``` r
get_dens_data(ds)
```

## Arguments

- ds:

  `[data.frame()]` A dataframe

## Value

`[data.frame()]`

With columns:

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_value` `[factor()]`: Response parameter value.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `dens_x` `[numeric()]`: Predictor parameter value.

- `dens_y` `[numeric()]`: Predictor parameter probability density.

## Details

[stats::density](https://rdrr.io/r/stats/density.html) with default
values is used to calculate the density

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
