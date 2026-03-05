# Subset datasets for correlation heatmap

TODO: Update this roxygen description to match the function

## Usage

``` r
fp_subset_data(
  cat,
  cat_col,
  par,
  par_col,
  val_col,
  vis,
  vis_col,
  group_vect,
  bm_ds,
  group_ds,
  subj_col
)
```

## Arguments

- par, cat:

  `[character*ish*(n)]`

  Values from `par_col` and `cat_col` to be subset

- val_col:

  `[character*ish*(1)]`

  Column containing values for the parameters

- vis:

  `[character*ish*(1)]`

  Values from `vis_col` to be subset

- group_vect:

  `[named(character(n))]`

  Columns to be subset and renamed.

- bm_ds, group_ds:

  `data.frame`

  data frames to be used as inputs in
  [subset_bds_param](subset_bds_param.md) and
  [subset_adsl](subset_adsl.md)
