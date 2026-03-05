# Line plot module

Display line plots of raw or summary data over time. Summaries include
measures of central tendency (mean, median) and optional deviation and
confidence estimators.

## Usage

``` r
mod_lineplot(
  module_id,
  bm_dataset_name,
  group_dataset_name,
  receiver_id = NULL,
  summary_fns = list(Mean = lp_mean_summary_fns, Median = lp_median_summary_fns),
  subjid_var = "USUBJID",
  cat_var = "PARCAT",
  par_var = "PARAM",
  visit_vars = c("AVISIT"),
  cdisc_visit_vars = character(0),
  anlfl_vars = NULL,
  value_vars = "AVAL",
  additional_listing_vars = character(0),
  ref_line_vars = character(0),
  default_centrality_fn = NULL,
  default_dispersion_fn = NULL,
  default_cat = NULL,
  default_par = NULL,
  default_val = NULL,
  default_visit_var = NULL,
  default_visit_val = NULL,
  default_main_group = NULL,
  default_sub_group = NULL,
  default_transparency = 1,
  default_y_axis_projection = "Linear"
)
```

## Arguments

- module_id:

  Shiny ID `[character(1)]`

  Module identifier

- bm_dataset_name, group_dataset_name:

  `[character(1)]`

  Dataset names

- receiver_id:

  `[character(1)]`

  Shiny ID of the module receiving the selected subject ID in the single
  subject listing. This ID must be present in the app or be NULL.

- summary_fns:

  `[list()]`

  Each element of this named list contains a summary function (e.g. a
  mean) and a collection of dispersion functions (e.g. standard
  deviation) defining ranges around the values returned by the summary
  function.

  The structure of each element is then a named list with the following
  elements:

  - `fn`: Function that takes a numeric vector as its sole parameter and
    produces a scalar number.

  - `dispersion`: Named list of pairs functions that return the *top*
    and *bottom* dispersion ranges. They also take a numeric vector as
    input and return a single numeric scalar

  - `y_prefix`: Prefix that will be prepended the Y axis label of the
    generated plot

  For an example, see
  [`dv.explorer.parameter::lp_mean_summary_fns`](default_lineplot_functions.md).

- subjid_var:

  `[character(1)]`

  Column corresponding to the subject ID

- cat_var, par_var, visit_vars:

  `[character(1)]`

  Columns from `bm_dataset` that correspond to the parameter category,
  parameter and visit

- cdisc_visit_vars:

  `[character(1)]`

  Column from `bm_dataset` that correspond to the parameter visit and is
  interpreted as a CDISC Visit Days (skipping day 0; jumping from value
  -1 to value 1 in the X axis)

- anlfl_vars:

  `[character(n)]`

  Columns from `bm_dataset` that correspond to analysis flags

- value_vars:

  `[character(n)]`

  Columns from `bm_dataset` that correspond to values of the parameters

- additional_listing_vars:

  `[character(n)]`

  Columns from `bm_dataset` that will be appended to the single-subject
  listing

- ref_line_vars:

  `[character(n)]`

  Columns for `bm_dataset` specifying reference values for parameters.
  See [this article](../articles/lineplot_reference_values.md) for more
  details

- default_cat, default_par, default_visit_var, default_main_group:

  `[character(1)|NULL]`

  Default values for the selectors

- default_visit_val:

  `list([character(n)|numeric(n)])`

  Named list of default values associated to specific `visit_var`s, e.g.
  `default_visit_val = list(VISIT = c('VISIT1', 'VISIT2'), AVISITN = c(1, 2))`

- default_sub_group, default_val, default_centrality_fn,
  default_dispersion_fn:

  `[character(1)|NULL]`

  Default values for the selectors

- default_transparency:

  `[numeric(1)]`

  Default values for the selectors

- default_y_axis_projection:

  `["Linear"|"Logarithmic"]`

  Default projection for the Y axis
