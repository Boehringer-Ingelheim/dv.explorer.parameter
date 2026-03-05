# Helpers for computing ROC data from the subset dataset

Helpers for computing ROC data from the subset dataset

## Usage

``` r
assert_compute_roc_data(r, with_ci)

compute_roc_data(predictor, response, do_bootstrap, ci_points)
```

## Arguments

- r:

  `[list(data.frame())]`

  dataframe resulting from compute_roc_data

- with_ci:

  `[logical(1)]`

  Indicates if CI is included in the result

- predictor:

  `[numeric(n)]`

  The scores of the predictor

- response:

  `[factor(n)]`

  The response value

- do_bootstrap:

  `[logical(1)]` Calculate confidence intervals for sensitivity and
  specificity

- ci_points:

  `[list(spec = numeric(), thr = numeric())]` Points at which 95%
  confidence intervals for sensitivity and specificity will be
  calculated. Depending on the entry CI will be calculated at defined
  specificity points or threshold points.

## Value

`[list(data.frame())]`

A list with entries:

### `roc_curve`

`[data.frame()]`

With columns:

- `specificity` `[numeric()]`: Sensitivity

- `sensitivity` `[numeric()]`: Specificity

- `threshold` `[numeric()]`: Threshold

- `auc` `[numeric(3)]`: A numeric vector of length 3 c(LOWER AUC CI,
  AUC, UPPER AUC CI)

- `direction` `[character(1)]`: The direction of the comparisons `<` or
  `>` according to `levels`

- `levels` `[character(2)]`: The sorted levels of the response variable
  according to `direction`

### `roc_ci`

`[data.frame()]`

With columns:

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

- `threshold` `[numeric()]`: Threshold

### `roc_optimal_cut`

`[data.frame()]`

With columns:

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

- `optimal_cut_threshold` `[numeric()]`: Threshold of optimal cut

## Details

- Computing CIs for sensitivity and specifity usually implies using
  bootstrap which can be too expensive, therefore the option of not
  running calculating them when the function is invoked is included.

- Response levels are selected alphabetically being `case` the first one
  alphabetically the comparison direction is selected automatically by
  [`pROC::roc()`](https://rdrr.io/pkg/pROC/man/roc.html) and related
  functions.

- CIs are expected to be 95% CIs

## Functions

- `assert_compute_roc_data()`: Assert compute_roc result data.frame
  types are correct

- `compute_roc_data()`: Compute ROC analysis
