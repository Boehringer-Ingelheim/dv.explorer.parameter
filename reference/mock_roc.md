# Mock functions

Mock functions

## Usage

``` r
mock_roc_mm_app(
  adbm = test_roc_data()[["adbm"]],
  adbin = test_roc_data()[["adbin"]],
  group = test_roc_data()[["adsl"]]
)

mock_roc_app()
```

## Arguments

- adbm, adbin, group:

  Datasets for the mock app

## Functions

- `mock_roc_mm_app()`: Mock app running the module inside dv.manager

- `mock_roc_app()`: Mock app running the module standalone
