# Counts the number of rows grouped by all variables except `subject_id` and `value`

- Counts the number of rows grouped by all variables except `subject_id`
  and `value`.

- Throws an error if the Count column is present

- The function returns a data frame with the counts for each group.

## Usage

``` r
bp_count_table(ds)
```

## Arguments

- ds:

  [`data.frame()`](https://rdrr.io/r/base/data.frame.html) A data frame
  to count the rows over.

## Value

[`data.frame()`](https://rdrr.io/r/base/data.frame.html) A data frame
with the counts for each group.
