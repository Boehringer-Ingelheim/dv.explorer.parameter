# Subset datasets for scatterplot

Prepares the basic input for the rest of the scatterplot functions.

- `bm_dataset` is subset according to category, parameter and visit
  selection for x and y val

- `group_dataset` is subset according to group_selection

- both are joined using `subject_col` as a common key

- it uses a left join

It is based on [`subset_bds_param()`](subset_bds_param.md) and
[`subset_adsl()`](subset_adsl.md) with additional error checking.

## Usage

``` r
sp_subset_data(
  x_cat,
  y_cat,
  cat_col,
  x_par,
  y_par,
  par_col,
  x_val_col,
  y_val_col,
  x_vis,
  y_vis,
  vis_col,
  group_vect,
  bm_ds,
  group_ds,
  subj_col,
  anlfl_col = NULL
)
```

## Arguments

- x_cat, y_cat, x_par, y_par, x_val_col, y_val_col, x_vis, y_vis:

  Are similar to those without prefix in
  [`subset_bds_param()`](subset_bds_param.md).

- group_vect:

  `[named(character(n))]`

  Columns to be subset and renamed.

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

|              |           |           |              |             |
|--------------|-----------|-----------|--------------|-------------|
| `subject_id` | `x_value` | `y_value` | `main_group` | `sub_group` |
| xx           | xx        | xx        | xx           | xx          |

## Details

- factors from `bm_ds` are releveled so all extra levels not present
  after subsetting are dropped and are sorted according to `par` and
  `cat`. Unless parameters are renamed in
  [`subset_bds_param()`](subset_bds_param.md) then no releveling occurs.

- `group_vect` names are a subset of main_group and sub_group or empty,
  otherwise a regular error is produced.

- `label` attributes from `group_ds` and `bm_ds` are retained when
  available

### Shiny validation errors:

- The x or y fragments from bm contains more than row per subject,
  category, parameter and visit combination

- The fragment from group contains more than row per subject

- If `bm_ds` and `grp_ds` share column names, apart from `subj_col`,
  after internal renaming has occured

- If the returned dataset has 0 rows
