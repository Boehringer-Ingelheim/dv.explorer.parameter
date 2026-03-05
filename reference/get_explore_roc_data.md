# Prepare dataframe for auc exploration

Removes sensitivity, specificity, and threshold and expands auc in three
columns. Removes duplicated rows. Used on the output of
[`get_roc_data()`](get_roc_data.md)

## Usage

``` r
get_explore_roc_data(ds)
```

## Arguments

- ds:

  `[data.frame()]`

## Value

`[data.frame()]`

With columns:

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_parameter` `[factor()]`: Response parameter name.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `auc` `[numeric()]`: Area under the curve

- `lower_CI_auc` `[numeric()]`: AUC lower confidence interval

- `upper_CI_auc` `[numeric()]`: AUC upper confidence interval

## Details

It respects columns labels

## Input dataframe

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
