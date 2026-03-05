# Parameter heatmap component of WFPHM

Parameter heatmap component of WFPHM

## Usage

``` r
wfphm_hmpar_UI(id, tr_choices)

wfphm_hmpar_server(
  id,
  dataset,
  cat_var,
  par_var,
  visit_var,
  anlfl_reactive = NULL,
  subjid_var,
  value_vars,
  sorted_x,
  tr_mapper,
  margin,
  show_x_ticks
)
```

## Arguments

- id:

  Shiny ID `[character(1)]`

- dataset:

  `[shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`

  It expects the following format:

  - it contains, at least, the columns specified in the parameters:
    `cat_var`, `par_var`, `value_vars`, `visit_var` and `subjid_var`

  - `cat_var`, `par_var`, `visit_var` and `subjid_var` columns are
    factors

  - `value_vars` must be numeric

- cat_var, par_var, visit_var, subjid_var:

  `[character(1)]`

- value_vars:

  `[character(1+)]`

  possible colum values. If column is labelled, label will be displayed
  in the value menu

- tr_mapper:

  `[function(1+)]`

  named list containing a set of unary functions to transform the data.
  The name is the string shown in a selector and the value is the
  function to be applied according to details section.

- margin:

  `[numeric(4) | shiny::reactive(numeric(4)) | shinymeta::metaReactive(numeric(4))]`

  margin to be used on each of the sides. It must contain four entries
  named `top`, `bottom`, `left` and `right`

- show_x_ticks:

  `[logical(1)]`

  show x ticks in the parameter heatmap

## Value

### UI

A heatmap plot

### Server

A list with one entry:

- `margin`: similar to the `margin` parameter with the minimum margins
  for the current plot

## Details

### Data subsetting:

- Allows selecting several values from the `cat_var` column, from now on
  **cat_selection** and several values from the `par_var` column from
  the subset of rows where `par_cat` is equal to **cat_selection** from
  now on **par_selection**.

  - Menu labelled: Category and Parameter

- Allows selecting between the columns defined in `value_vars` from now
  on **value_selection**.

  - Menu labelled: Value

- Allows selecting a value from `visit_var` column, from now on
  **visit_selection**.

  - Menu labelled: Visit

- Subsets the dataset rows where:

  - `visit_var` equal to **visit_selection**

  - `par_var` equal to **par_selection**

- Subsets the dataset to `par_var`, `subj_var` and the
  **value_selection**.

- If more than one row have the same combination `subj_var` and
  `par_var` an informative error indicating the plot cannot be created
  is shown.

Then the dataset is prepared to be passed to
[heatmap_D3](heatmap_D3.md):

- `subj_var` becomes `x` column

- the label attribute of `x` column is `Subject ID`

- `par_var` becomes `y` column

- `value_selection` becomes `z` column

- `z` becomes `label` column

### Completing the dataset:

- Subset dataset will be completed in the following way. All non-present
  combination of the original levels of `x` and 'y' is are added with
  rows where:

- `x` and `y` are equal to the missing combination

- `z` is NA

### Data outliers:

- Allows setting two limits upper and lower for `y` value, values above
  or below in the subsetted dataset will be considered outliers. Rows
  considered outliers will have the column:

  - `label` replaced by "x"

  - `color` equal to "fill: white; font-weight: bold;"

- Rows not considered outliers will have the column:

  - `color` equal to NA

### Data transformation:

- Allows selecting between a set of functions as defined in `tr_mapper`
  from now on **transformation_function**.

  - Menu labelled: Transformation

- This transformation is applied to the subset dataset grouped by the
  `y` column. i.e. each row of the heatmap is transformed independently.

- The function must be unary, and the unique argument will be the
  numerical values of a given row of the hetamap.

### X axis ordering

- `x` levels are ordered according to `sorted_x`

Then a call to [heatmap_D3](heatmap_D3.md) is done with the following
arguments:

- `data` = `subset dataset` (as described above)

- `x_axis` = `S`

- `y_axis` = `W`

- `z_axis` = `E`

- `margin` is the parameter passed to this same function

- `palette` is hardcoded to
  `RColorBrewer::brewer.pal(n = 8, name = "Set2")` after 8 categories
  colors are repeated

- `msg_func` = NULL

- `quiet` = TRUE

## Functions

- `wfphm_hmpar_UI()`: UI

- `wfphm_hmpar_server()`: server
