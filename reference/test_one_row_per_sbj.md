# Test if a group has a single row for the combinations of a set of grouping variables

It contains at least the subject id. It includes a need version to
include in a validate body.

## Usage

``` r
test_one_row_per_sbj(ds, subj_col, ...)

need_one_row_per_sbj(..., msg)
```

## Arguments

- ds:

  `[data.frame()]` The dataset to be tested

- subj_col:

  `[character(1)]` Name of the column containing the subject_id

- ...:

  `[character(1)]` Other column names for grouping

- msg:

  `[character(1)]` Validation message

## Value

`[logical(1)]` `TRUE` if a single row is found, `FALSE` otherwise
