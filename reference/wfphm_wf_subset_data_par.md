# Subset datasets for waterfall in waterfall plus heatmap

Prepares the basic input for the rest of waterfall heatmap functions

- `bm_dataset` is subset according to category, parameter and visit
  selection

- `group_dataset` is subset according to group_selection

- both are joined using `subject_col` as a common key

- it uses a full join to include the subjects that has no parameter
  value for that parameter visit combination

It is based on [`subset_bds_param()`](subset_bds_param.md) and
[`subset_adsl()`](subset_adsl.md) with additional error checking.

## Usage

``` r
wfphm_wf_subset_data_par(
  cat,
  cat_col,
  par,
  par_col,
  val_col,
  vis,
  vis_col,
  color_col,
  bm_ds,
  group_ds,
  subj_col,
  anlfl_col = NULL
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

- color_col:

  the column used to color the bars

- bm_ds, group_ds:

  `data.frame`

  data frames to be used as inputs in
  [subset_bds_param](subset_bds_param.md) and
  [subset_adsl](subset_adsl.md)

- subj_col, par_col, cat_col, vis_col, anlfl_col:

  `[character(1)]`

  Column for subject id, category, parameter, visit and analysis flag.
  All specified columns must be factors. Analysis flag is optional.

## Value

`[data.frame()]`

The `_group` columns depend on the names in `group_vect`

|     |     |     |         |
|-----|-----|-----|---------|
| `x` | `y` | `z` | `color` |
| xx  | xx  | xx  | xx      |

## Details

- columns are renamed to `x`, `y`, `z` and `color`

- `label` attributes from `group_ds` and `bm_ds` are retained when
  available

### Shiny validation errors:

- The fragment from bm contains more than row per subject, category,
  parameter and visit combination

- The fragment from group contains more than row per subject

- If `bm_ds` and `grp_ds` share column names, apart from `subj_col`,
  after internal renaming has occured

- If the returned dataset has 0 rows
