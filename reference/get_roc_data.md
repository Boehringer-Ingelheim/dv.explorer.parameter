# Apply ROC analysis to groups

It applies an ROC analysis over a dataset. The application is applied by
groups defined by `predictor_parameter`, `response_parameter` and, if
grouped, `group`.

This functions is prepared to be applied over a dataset that is the
output of [`roc_subset_data()`](roc_subset_data.md).

The function itself does not calculate the ROC analysis, it only applies
`compute_fn` over the different groups.

### Input dataframe:

`[data.frame()]`

With columns:

- `subject_id` `[factor()]`: Subject ID

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_parameter` `[factor()]`: Response parameter value.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `predictor_value` `[numeric()]`: Predictor parameter Value

- `response_value` `[factor()]`: Response parameter Value.

### compute_fn definition:

For an example of a computing function please review
[`compute_roc_data()`](compute_roc.md).

## Usage

``` r
get_roc_data(ds, compute_fn, ci_points, do_bootstrap)
```

## Arguments

- ds:

  `[data.frame()]` A dataframe

- compute_fn:

  `[function(1)]` A function that computes the ROC data

- ci_points:

  `[list(spec = numeric(), thr = numeric())]` Points at which 95%
  confidence intervals for sensitivity and specificity will be
  calculated. Depending on the entry CI will be calculated at defined
  specificity points or threshold points.

- do_bootstrap:

  `[logical(1)]` Calculate confidence intervals for sensitivity and
  specificity

## Value

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

## Details

If `compute_fn` returns an error when applied to any of the groups a
dataset with NA is returned instead. This controls side cases such as
groups that contains a single observation.
