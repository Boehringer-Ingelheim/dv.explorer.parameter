# Waterfall plus heatmap server function

Waterfall plus heatmap server function

## Usage

``` r
wfphm_server(
  id,
  bm_dataset,
  group_dataset,
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

- id:

  Shiny ID `[character(1)]`

- bm_dataset:

  `[shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`

- group_dataset:

  `[shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`

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
