# Waterfall component of WFPHM

Waterfall component of WFPHM

Waterfall UI function

## Usage

``` r
wfphm_wf(
  id,
  dataset,
  cat_var,
  par_var,
  visit_var,
  subjid_var,
  value_vars,
  bar_group_palette,
  margin
)

wfphm_wf_UI(id)
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

- cat_var, par_var, visit_var, subjid_var:

  `[character(1)]`

  columns used as indicated in the details section

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

- margin:

  `[numeric(4) | shiny::reactive(numeric(4)) | shinymeta::metaReactive(numeric(4))]`

  margin to be used on each of the sides. It must contain four entries
  named `top`, `bottom`, `left` and `right`

## Value

### UI

A bar plot

### Server

A list with two entries:

- `margin`: similar to the `margin` parameter with the minimum margins
  for the current plot

- `sorted_x`: From the subsetted data the `x` levels sorted from high to
  low by `y`

## Details

Data subsetting:

- Allows selecting a column from all factor or character columns, from
  now on **grouping_selection**.

  - Menu labelled: Grouping

- Data selection for plotting can be done in two modes switched by:

  - Menu labelled: Display demographic baseline information

### Mode 1:

- Allows selecting a column from the set of all numerical columns, from
  now on **value_selection**.

  - Menu labelled: Value

- Subsets the dataset to the columns **grouping_selection**, `subj_var`
  and **value_selection**.

- Removes all repeated rows from the dataset

- If more than one row have the same `subj_var` an informative error
  indicating the plot cannot be created is shown.

### Mode 2:

- Allows selecting a value from the `cat_var` column, from now on
  **cat_selection** and a value from the `par_var` column from the
  subset of rows where `par_cat` is equal to **cat_selection** from now
  on **par_selection**.

  - Menu labelled: Category and Parameter

- Allows selecting between the columns defined in `val_var` from now on
  **value_selection**.

  - Menu labelled: Value

- Allows selecting a value from `visit_var` column, from now on
  **visit_selection**.

  - Menu labelled: Visit

- Subsets the dataset rows where:

  - `visit_var` equal to **visit_selection**

  - `par_var` equal to **par_selection**

- Subsets the dataset to the **grouping_selection**, the `subj_var` and
  the **value_selection**.

- If more than one row have the same `subj_var` an informative error
  indicating the plot cannot be created is shown.

Then the dataset is prepared to be passed to [bar_D3](bar_D3.md):

- `subj_var` becomes `x` column

- `val_selection` becomes `y` column

- the label attribute of `y` column is either `value_selection` in *Mode
  1* or `par_selection` in *Mode 2*

- `grouping_selection` becomes `z` column

- `grouping_selection` becomes `label` column

### Completing the dataset:

- Subset dataset will be completed in the following way. If any level in
  `x` is not present in the subset dataset, but it was present in the
  `subj_var` column in the original dataset, a row is added where `x` is
  equal to the missing value `y` is NA and `z` is NA.

### Data outliers:

- Allows setting two limits upper and lower, values above or below in
  the subsetted dataset will be considered outliers. Rows considered
  outliers will have the column:

  - `label` replaced by "outlier"

  - `color` equal to "gray"

- Rows not considered outliers will have the column:

  - `color` equal to NA

### X axis sorting

- `x` levels are sorted from greater to lower value in `y`

Then a call to [bar_D3](bar_D3.md) is done with the following arguments:

- `data` = `subset dataset` (as described above)

- `x_axis` = `NULL`

- `y_axis` = `W`

- `z_axis` = NULL

- `margin` is the parameter passed to this same function

- `palette` is hardcoded with 8 colors. After 8 categories colors are
  repeated

- `msg_func` = NULL

- `quiet` = TRUE

## Functions

- `wfphm_wf_UI()`: UI
