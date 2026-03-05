# Waterfall heatmap shiny module

A module that creates the following plots with its corresponding menus:

- A waterfall [wfphm_wf](wfphm_wf.md)

- A heatmap for categorical variables [wfphm_hmcat](wfphm_hmcat.md)

- A heatmap for continuous variables [wfphm_hmcont](wfphm_hmcont.md)

- A heatmap that displays a set of parameters
  [wfphm_hmpar](wfphm_hmpar.md)

## Usage

``` r
mod_wfphm(
  module_id,
  bm_dataset_name,
  group_dataset_name,
  cat_var = "PARCAT1",
  par_var = "PARAM",
  visit_var = "AVISIT",
  anlfl_vars = NULL,
  subjid_var = "USUBJID",
  value_vars = "AVAL",
  bar_group_palette = list(),
  cat_palette = list(),
  tr_mapper = tr_mapper_def(),
  show_x_ticks = TRUE
)
```

## Arguments

- module_id:

  Shiny ID `[character(1)]`

  It expects the following format:

  - it contains, at least, the columns specified in the parameters:
    `cat_var`, `par_var`, `value_vars`, `visit_var` and `subjid_var`

  - `cat_var`, `par_var`, `visit_var` and `subjid_var` columns are
    factors

  - It contains at least 1 row

  It expects the following format:

  - it contains, at least, the columns specified in the parameters:
    `subjid_var`

  - `subjid_var` columns is a factors

  - It contains at least 1 row

- bm_dataset_name, group_dataset_name:

  The name of the dataset

- cat_var, par_var, visit_var, subjid_var:

  `[character(1)]`

  columns used as indicated in each of the subplots

- anlfl_vars:

  `[character(n)]`

  Columns from `bm_dataset` that correspond to analysis flags

- value_vars:

  `[character(1+)]`

  possible colum values. If column is labelled, label will be displayed
  in the value menu

- bar_group_palette:

  `[list(palettes)]`

  list of custom palettes to apply to bar_grouping. It receives the
  values used for grouping and must return a DaVinci palette. Each
  palette is applied when the name of the entry in the list matches the
  name of the column used for grouping

- cat_palette:

  `[list(functions)]`

  list of functions that receive the values of the variable and returns
  a vector with the colors for each of the values. Each palette is
  applied when the name of the entry in the list matches the name of the
  selected categorical variable

- tr_mapper:

  `[function(1+)]`

  named vector containing a set of transformation where the name is the
  string shown in the selector and the value is function to be applied
  according to details section.

- show_x_ticks:

  `[logical(1)]`

  show x ticks in the parameter heatmap

## Value

### UI

The menus and plots

### Server

NULL

## Details

See the subsections for each of plots particularities

### X axis

All charts share the same x-axis order as defined by the value
`sorted_x` returned by the [wfphm_wf](wfphm_wf.md).

### Margins

All four plots are aligned on their left and right sides so their x axis
are also aligned. Each plot returns their required margins and we
calculate the maximum for each side and return it in the `margin`
argument of each plot.

## Functions

- `mod_wfphm()`: dv.manager wrapper for the module
