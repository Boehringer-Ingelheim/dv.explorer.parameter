# Subsets a group dataset, usually adsl, for a group_column_selection

Subsets a group dataset, usually adsl, for a group_column_selection

## Usage

``` r
subset_adsl(ds, group_vect, subj_col)
```

## Arguments

- ds:

  `[data.frame()]`

  Data frame to be subset, see section *Input dataframes*

- group_vect:

  `[named(character(n))]`

  Columns to be subset and renamed.

- subj_col:

  `[character(1)]`

  Column for subject id. `subj_col` must be a factor

## Value

[`data.frame()`](https://rdrr.io/r/base/data.frame.html)

|              |                         |                         |     |
|--------------|-------------------------|-------------------------|-----|
| `subject_id` | `names(group_vec)[[1]]` | `names(group_vec)[[2]]` | ... |
| xx           | xx                      | xx                      | xx  |

- When present `label` attribute is retained.

## Input dataframe

It expects a dataset with an structure similar to
https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806
, one record per subject

It expects to contain, at least, `subj_col` and all entries in
`group_vect` as columns
