# Specification for a set of faceted ROC curves

The chart consists of a faceted set of ROC curves plotting the:

## Usage

``` r
get_roc_spec(ds_list, param_as_cols, fig_size)

get_roc_sorted_spec(ds_list, param_as_cols, fig_size)
```

## Arguments

- ds_list:

  `[list(data.frames())]`

  A list of dataframes

- param_as_cols:

  `[logical(1)]`

  Charts are faceted using parameters as columns. This parameter is
  ignored in the sorted version.

- fig_size:

  `[numeric(1)]`

  Size in pixels for each of the charts in the facet

## Value

A
[vegawidget::vegawidget](https://vegawidget.github.io/vegawidget/reference/vegawidget.html)
specification

## Details

- ROC curves

- The confidence intervals

- The set of optimal cuts

### Rows and columns:

- By default, predictor parameters are displayed in rows while grouping
  is displayed in columns.

- If no grouping is selected, then parameters are displayed in cols.

- If `ds_list[[`r CNT_ROC\$ROC_CI\]\]“ is `NULL` then confidence
  intervals are not presented.

### Rows and columns:

- Charts are ordered from left to right and top to bottom from the
  highest to lowest area under the curve

## Functions

- `get_roc_sorted_spec()`: Specification for a set of sorted ROC curves

## Input dataframe list

### `ds_list`

`[list(data.frame())]` A list with entries:

### roc_curve

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

### roc_ci

`[data.frame()]`

With columns:

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_parameter` `[factor()]`: Response parameter name.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `ci_specificity` `[numeric()]`: Specificity value

- `ci_lower_specificity` `[numeric()]`: Specificity lower confidence
  interval

- `ci_upper_specificity` `[numeric()]`: Specificity upper confidence
  interval

- `ci_sensitivity` `[numeric()]`: Sensitivity value

- `ci_lower_sensitivity` `[numeric()]`: Sensitivity lower confidence
  interval

- `ci_upper_sensitivity` `[numeric()]`: Sensitivity upper confidence
  interval

CIs are only calculated when `do_bootstrap` is `TRUE`

### roc_optimal_cut

`[data.frame()]`

With columns:

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_parameter` `[factor()]`: Response parameter name.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `optimal_cut_title` `[character()]`: Name of the optimal cut

- `optimal_cut_specificity` `[numeric()]`: Sensitivity at the optimal
  cut point

- `optimal_cut_lower_specificity` `[numeric()]`: Lower Confidence
  interval of sensitivity

- `optimal_cut_upper_specificity` `[numeric()]`: Upper Confidence
  interval of sensitivity

- `optimal_cut_sensitivity` `[numeric()]`: Specificity at the optimal
  cut point

- `optimal_cut_lower_sensitivity` `[numeric()]`: Lower Confidence
  interval of sensitivity

- `optimal_cut_upper_sensitivity` `[numeric()]`: Upper Confidence
  interval of sensitivity

- `optimal_cut_threshold` `[numeric()]`: Threshold of the optimal cut

CIs are only calculated when `do_bootstrap` is `TRUE`
