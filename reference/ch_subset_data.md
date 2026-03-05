# Subset datasets for correlation heatmap

Prepares the main data frame for the rest of the correlation heatmap
functions by subsetting `bm_dataset` according to the category,
parameter and visit combinations captured by the rows of the `sel`
parameter.

## Usage

``` r
ch_subset_data(
  sel,
  cat_col,
  par_col,
  val_col,
  vis_col,
  bm_ds,
  subj_col,
  anlfl_col = NULL
)
```

## Arguments

- sel:

  a data.frame with three columns CNT\$CAT, CMT\$PAR, CNT\$VIS.

- val_col:

  `[character*ish*(1)]`

  Column containing values for the parameters

- bm_ds:

  `data.frame`

  data frames to be used as inputs in
  [subset_bds_param](subset_bds_param.md)

- subj_col, par_col, cat_col, vis_col, anlfl_col:

  `[character(1)]`

  Column for subject id, category, parameter, visit and analysis flag.
  All specified columns must be factors. Analysis flag is optional.

## Value

`[data.frame()]`

|            |             |              |         |         |
|------------|-------------|--------------|---------|---------|
| `category` | `parameter` | `subject_id` | `value` | `visit` |
| xx         | xx          | xx           | xx      | xx      |

## Details

- factors from `bm_ds` are releveled so all extra levels not present
  after subsetting are dropped and are sorted according to `par` and
  `cat`. Unless parameters are renamed in
  [`subset_bds_param()`](subset_bds_param.md) then no releveling occurs.

- `label` attributes from `bm_ds` are retained when available.
