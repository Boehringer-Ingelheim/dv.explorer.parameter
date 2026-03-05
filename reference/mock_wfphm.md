# Mock functions

Mock functions

## Usage

``` r
mock_wfphm_mm_app(anlfl_flags = FALSE)

mock_app_wfphm2(
  dry_run = FALSE,
  update_query_string = TRUE,
  srv_defaults = list(),
  ui_defaults = list(),
  anlfl_flags = FALSE
)

mock_app_hmcat(
  dry_run = FALSE,
  update_query_string = TRUE,
  srv_args = list(),
  ui_args = list()
)

mock_app_hmcont(
  dry_run = FALSE,
  update_query_string = TRUE,
  srv_args = list(),
  ui_args = list()
)

mock_app_hmpar(
  dry_run = FALSE,
  update_query_string = TRUE,
  srv_args = list(),
  ui_args = list(),
  anlfl_flags = FALSE
)

mock_app_wf(
  dry_run = FALSE,
  update_query_string = TRUE,
  srv_args = list(),
  ui_args = list(),
  anlfl_flags = FALSE
)

mock_app_wfphm(
  dry_run = FALSE,
  update_query_string = TRUE,
  srv_args = list(),
  ui_args = list(),
  anlfl_flags = FALSE
)
```

## Arguments

- anlfl_flags:

  indicates that the input data contain analysis flag variables or not

- dry_run:

  Return parameters used in the call

- update_query_string:

  automatically update query string with app state

- ui_defaults, srv_defaults:

  a list of values passed to the ui/server function

- ui_args, srv_args:

  a list of arguments passed to the ui/server function.

## Functions

- `mock_wfphm_mm_app()`: Mock app running the module inside dv.manager

- `mock_app_wfphm2()`: Mock app running the waterfall plus heatmap
  module

- `mock_app_hmcat()`: Mock app running categorical heatmap module

- `mock_app_hmcont()`: Mock app running continuous heatmap module

- `mock_app_hmpar()`: Mock app running parameter heatmap module

- `mock_app_wf()`: Mock app running waterfall module

- `mock_app_wfphm()`: Mock app running the waterfall plus heatmap module
