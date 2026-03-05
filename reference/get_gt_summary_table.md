# GT Summary table for the area under the curve, optimal cut data and their confidence intervals

The table summarizes the AUC, the optimal cut data, for each parameter
and grouping combination

## Usage

``` r
get_gt_summary_table(ds, rounder = function(x) round(x, digits = 2), sort_alph)
```

## Arguments

- ds:

  `[data.frames()]`

  A dataframe

- rounder:

  `[function()]`

  Single parameter function that rounds a numeric vector for
  rendendering

- sort_alph:

  `[logical(1)]`

  Sort summary table by parameter name

## Value

A
[vegawidget::vegawidget](https://vegawidget.github.io/vegawidget/reference/vegawidget.html)
specification

## Details

Numerical values are rounded to two decimals

## Input

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
