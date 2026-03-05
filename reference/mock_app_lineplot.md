# Mock lineplot app

Mock lineplot app

## Usage

``` r
mock_app_lineplot(
  dry_run = FALSE,
  update_query_string = TRUE,
  srv_defaults = list(),
  ui_defaults = list(),
  data = test_data(anlfl_flags = anlfl_flags),
  anlfl_flags = FALSE
)
```

## Arguments

- dry_run:

  Return parameters used in the call

- update_query_string:

  automatically update query string with app state

- ui_defaults, srv_defaults:

  a list of values passed to the ui/server function

- data:

  data for the mock application

- anlfl_flags:

  indicates that the input data contain analysis flag variables or not
