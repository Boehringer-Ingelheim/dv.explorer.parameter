# Calculate quantiles per group

It calculates the quantiles `c(.05, .25, .50, .75, .95)` and the mean of
the parameter value by groups defined by CNT_ROC\$PPAR, CNT_ROC\$RPAR
and, if grouped, CNT_ROC\$GRP. These functions is prepared to be applied
over a dataset that is the output of
[`roc_subset_data()`](roc_subset_data.md).

## Usage

``` r
get_quantile_data(ds, quantile_type)
```

## Arguments

- ds:

  `[data.frame()]`

  A dataframe

- quantile_type:

  `[integer(1)]`

  Quantile algorithm type (an integer between 1 and 9).

## Value

`[data.frame()]`

With columns:

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_value` `[factor()]`: Response parameter value.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `mean` `[numeric()]`: Mean of the predictor parameter value

- `q05`, `q25`, `q50`, `q75`, `q95` `[numeric()]`: Quantiles of the
  predictor parameter value

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
