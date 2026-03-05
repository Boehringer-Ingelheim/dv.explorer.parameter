# Create a table of t-test results for pairwise comparisons for `main_group` in a data frame

Creates a table of t-test results for pairwise comparisons for the
groups defined by `main_group` groups in a data frame and values in
`value`

Each of the pairwise comparison is performed for each of groups defined
by the columns that are not `main_group`, `value` and `subject_id`.

If no or a single data point for a group is present for a given group
`NA` values are returned

## Usage

``` r
bp_significance_table(ds)
```

## Arguments

- ds:

  [`data.frame()`](https://rdrr.io/r/base/data.frame.html) A data frame
  to be analyzed.

## Value

[`data.frame()`](https://rdrr.io/r/base/data.frame.html) A data frame
with the test results. The returned data frame will have one row for
each pairwise comparison and group, and three additional columns `Test`,
`Comparison`, and `P Value`.
