# Calculate binned count per group

It calculates the binned count of the parameter value by groups defined
by `predictor_parameter`, `response_parameter` and if grouped, `group`.
These functions is prepared to be applied over a dataset that is the
output of `subset_data()`.

## Usage

``` r
get_histo_data(ds)
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

- `bin_start` `[numeric()]`: Predictor parameter bin start.

- `bin_end` `[numeric()]`: Predictor parameter bin end.

- `bin_count` `[numeric()]`: Predictor parameter bin count.

## Details

[graphics::hist](https://rdrr.io/r/graphics/hist.html) with default
values is used to calculate the binning

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
