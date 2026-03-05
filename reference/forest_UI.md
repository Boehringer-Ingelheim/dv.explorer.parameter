# Forest plot UI function

Forest plot UI function

## Usage

``` r
forest_UI(
  id,
  numeric_numeric_function_names = character(0),
  numeric_factor_function_names = character(0),
  default_function = NULL
)
```

## Arguments

- id:

  `[character(1)]`

  Shiny ID

- numeric_numeric_function_names, numeric_factor_function_names:

  `[character(1)]`

  Vectors of names of functions passed as `numeric_numeric_functions`
  and `numeric_factor_functions` to `forest_server`

- default_function:

  `[character(1)]`

  Default function
