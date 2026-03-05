# Prepare dataframe for summary table exploration

Expands auc from roc_curve in three columns and joins the dataset with
roc_optimal_cut Used on the output of
[`get_roc_data()`](get_roc_data.md)

## Usage

``` r
get_summary_data(ds_list)
```

## Arguments

- ds_list:

  `[list(data.frame)]`

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

## Input dataframe list

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
