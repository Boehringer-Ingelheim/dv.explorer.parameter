# Subset input datasets

This functions prepares the basic input for the rest of
dv.explorer.parameter functions.

It subsets and joins the datasets based on the predictor/response
category/parameter/visit and group selections.

## Usage

``` r
roc_subset_data(
  pred_cat,
  pred_par,
  pred_val_col,
  pred_visit,
  resp_cat,
  resp_par,
  resp_val_col,
  resp_visit,
  group_col,
  pred_ds,
  resp_ds,
  group_ds,
  subj_col,
  pred_cat_col,
  pred_par_col,
  pred_vis_col,
  resp_cat_col,
  resp_par_col,
  resp_vis_col
)
```

## Arguments

- pred_par, pred_cat:

  `[character*ish*(n)]`

  Values from `pred_par_col` and `pred_cat_col` to be subset

- pred_val_col:

  `[character*ish*(1)]`

  Column containing values for the predictor parameters

- pred_visit:

  `[character*ish*(1)]`

  Values from `pred_vis_col` to be subset

- resp_par, resp_cat:

  `[character*ish*(1)]`

  Values from `resp_par_col` and `resp_cat_col` to be subset

- resp_val_col:

  `[character*ish*(1)]`

  Column containing values for the response parameter

- resp_visit:

  `[character*ish*(1)]`

  Values from `resp_vis_col` to be subset

- group_col:

  `[character*ish*(1)]`

  Column to group the data by. `"None"` for no grouping.

- pred_ds, resp_ds, group_ds:

  `[data.frame()]`

  Data frames for predictors/responses and groupings, see section *Input
  dataframes*

- subj_col, pred_par_col, pred_cat_col, pred_vis_col, resp_cat_col,
  resp_par_col, resp_vis_col:

  `[character(1)]`

  Column for predictor/response category/parameter/visit. `subj_col`
  must be a factor.

## Value

`[data.frame()]`

With columns:

- `subject_id` `[factor()]`: Subject ID

- `predictor_parameter` `[factor()]`: Predictor parameter name.

- `response_parameter` `[factor()]`: Response parameter value.

- `group` `[factor()]`: An optional column for the grouping value (if
  group is specified).

- `predictor_value` `[numeric()]`: Predictor parameter Value

- `response_value` `[factor()]`: Response parameter Value.

Additionally:

- `predictor_parameter` has a label attribute: *Parameter*

- `response_parameter` has a label attribute: *Response*

- `group` has the same label attribute as in the original dataset, if
  available, otherwise `group_col`.

## Details

- All columns but `predictor_value` are coherced into factors if they
  are not factors already.

- If at least one parameter name appears under several selected
  categories, parameter names and categories will be pasted together.

- `predictor_parameter` is releveled so all extra levels not present in
  the selection are dropped. Levels are ordered according to `pred_par`
  as long as a parameter name appears does not appear under more than
  one selected categories.

## Input dataframes

### pred_dataset

It expects a dataset similar to
https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192
, 1 record per subject per parameter per analysis visit

It expects, at least, the columns passed in the parameters, `subj_col`,
`pred_cat_col`, `pred_par_col`, `pred_vis_col` and `pred_val`. The
values of these variables are as described in the CDISC standard for the
variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.

### resp_dataset

It expects a dataset similar to
https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192

It expects, at least, the columns passed in the parameters, `subj_col`,
`resp_cat_col`, `resp_par_col`, `resp_vis_col` and `resp_val`. The
values of these variables are as described in the CDISC standard for the
variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.

### group_dataset

It expects a dataset with an structure similar to
https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806
, one record per subject

It expects to contain, at least, `subj_col` and `group_col`

## Internal checks

### Shiny validation errors:

- After selection it checks that:

  - Combination subject category parameter visit are unique for the
    predictor and response datasets

  - If grouped, that subject_id is unique for the selected group

  - The final selection contains at least one row

  - The response value is binary. Empty values are not considered for
    this check.

### Warnings:

- Subjects in the selection have an empty response value
