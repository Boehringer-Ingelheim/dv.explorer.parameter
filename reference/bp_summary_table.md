# Calculates a set of summary statistics grouped by all variables except `subject_id` and `value`

- Calculates a set of summary statistics grouped by all variables except
  `subject_id` and `value`.

- The summary statistics include `N`, `Mean`, `Median`, `SD`, `Min`,
  `Q1`, `Median`, `Q3`, `Max` and `NA Values`.

- `NA` values are ignored when calculating stats

## Usage

``` r
bp_summary_table(ds, quantile_type)
```

## Arguments

- ds:

  [`data.frame()`](https://rdrr.io/r/base/data.frame.html) A data frame
  to perform the summary over.

- quantile_type:

  `[integer(1)]`

  Quantile algorithm type (an integer between 1 and 9).

## Value

[`data.frame()`](https://rdrr.io/r/base/data.frame.html) A data frame
with the summary statistics.
