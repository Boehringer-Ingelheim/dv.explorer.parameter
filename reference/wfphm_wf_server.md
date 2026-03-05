# Waterfall server function

Waterfall server function

## Usage

``` r
wfphm_wf_server(
  id,
  bm_dataset,
  group_dataset,
  cat_var,
  par_var,
  visit_var,
  subjid_var,
  value_vars,
  .default_group_palette = function(x) {
     pal_get_cat_palette(x,
    viridisLite::viridis(length(unique(x))))
 },
  bar_group_palette = list(),
  anlfl_reactive = NULL,
  margin
)
```

## Arguments

- id:

  Shiny ID `[character(1)]`

- bm_dataset, group_dataset:

  `[data.frame()]`

- cat_var, par_var, visit_var:

  `[character(1)]`

  Columns from `bm_dataset` that correspond to the parameter category,
  parameter and visit

- subjid_var:

  `[character(1)]`

  Column corresponding to subject ID

- value_vars:

  `[character(n)]`

  Columns from `bm_dataset` that correspond to values of the parameters

- .default_group_palette:

  Function defining the default color palette for groups.

- bar_group_palette:

  Named list mapping each group to a color Used to override default
  colors returned by `.default_group_palette` For example:
  `list("Placebo" = "#999999", "Treatment" = "#E69F00")`

- anlfl_reactive:

  Optional reactive flag variable

- margin:

  Numeric vector of plot margins (top, bottom, left, right)
