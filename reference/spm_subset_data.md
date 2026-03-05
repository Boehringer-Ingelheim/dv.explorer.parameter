# Subset datasets for scatterplot matrix

Prepares the basic input for the rest of the scatterplot matrix
functions.

- `bm_dataset` is subset according to category, parameter and visit
  selection

- `group_dataset` is subset according to group_selection

- both are joined using `subject_col` as a common key

- it uses a left join

It is based on [`subset_bds_param()`](subset_bds_param.md) and
[`subset_adsl()`](subset_adsl.md) with additional error checking.

## Usage

``` r
spm_subset_data(
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

|        |        |        |              |
|--------|--------|--------|--------------|
| `PAR1` | `PAR2` | `PAR3` | `main_group` |
| xx     | xx     | xx     | xx           |

## Details

- factors from `bm_ds` are releveled so all extra levels not present
  after subsetting are dropped and are sorted according to `par` and
  `cat`. Unless parameters are renamed in
  [`subset_bds_param()`](subset_bds_param.md) then no releveling occurs.

- `group_vect` names are a subset of main_group or empty, otherwise a
  regular error is produced.

- `label` attributes from `group_ds` and `bm_ds` are retained when
  available

### Shiny validation errors:

- The bm_dataset fragments from bm contains more than row per subject,
  category, parameter and visit combination

- The fragment from group contains more than row per subject

- If `bm_ds` and `grp_ds` share column names, apart from `subj_col`,
  after internal renaming has occured

- If the returned dataset has 0 rows

- If the returned dataset has a single parameter column
