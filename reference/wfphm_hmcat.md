# Categorical heatmap component of WFPHM

Presents a heatmap plot for categorical variables

## Usage

``` r
wfphm_hmcat_UI(id)

wfphm_hmcat_server(
  id,
  dataset,
  subjid_var,
  sorted_x,
  cat_palette = list(),
  margin
)
```

## Arguments

- id:

  Shiny ID `[character(1)]`

- dataset:

  `[shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`

  It expects the following format:

  - it contains, at least, the columns specified in the parameters:
    `subjid_var`

  - `subjid_var` columns is a factor

- subjid_var:

  `[character(1)]`

  column used as indicated in the details section

- sorted_x:

  `[factor(*) | shiny::reactive(factor(*)) | shinymeta::metaReactive(factor(*))]`

  indicates how the levels of `subjid_var` should be ordered in the X
  axis.

- cat_palette:

  `[list(functions)]`

  list of functions that receive the values of the variable and returns
  a vector with the colors for each of the values Each palette is
  applied when the name of the entry in the list matches the name of the
  selected categorical variable

- margin:

  `[numeric(4) | shiny::reactive(numeric(4)) | shinymeta::metaReactive(numeric(4))]`

  margin to be used on each of the sides. It must contain four entries
  named `top`, `bottom`, `left` and `right`

## Value

### UI

A heatmap plot

### Server

A list with one entry:

- `margin`: similar to the `margin` parameter with the minimum margins
  for the current plot

## Functions

- `wfphm_hmcat_UI()`: UI

- `wfphm_hmcat_server()`: Server

## Data subsetting:

- Allows selecting several columns from all factor or character columns,
  from now on **category_selection**.

  - Menu labelled: Discrete heatmap

- Subsets the dataset to the columns **category_selection**, and
  `subj_var`.

- Pivot the dataset to a longer format such that each row have:

  - column `x`: the value of `subjid_var`

  - column `y`: the value of a **category_selection**

  - column `z`: the value of the **category_selection** in `y` for the
    value in `x`

- If more than one row have the same `x` and `y` an informative error
  indicating the plot cannot be created is shown.

### X axis ordering

- `x` levels are ordered according to `sorted_x`

Then a call to [heatmap_D3](heatmap_D3.md) is done with the following
arguments:

- `data` = `subset dataset` (as described above)

- `x_axis` = `NULL`

- `y_axis` = `W`

- `z_axis` = `E`

- `margin` is the parameter passed to this same function

- `palette` is hardcoded with 8 colors. After 8 categories colors are
  repeated

- `msg_func` = NULL

- `quiet` = TRUE
