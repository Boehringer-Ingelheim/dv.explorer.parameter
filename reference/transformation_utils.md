# Transformation auxiliary functions

Transformation auxiliary functions

## Usage

``` r
get_tr_fun(s)

get_tr_apply(tr)
```

## Arguments

- s:

  the selected transformation

- tr:

  a function that has as first parameter the values to transform.

## Value

a function from get_tr_apply

a function with the following interface
`function(df, group_col, val_col, ...)` where `...` is passed to as
extra parameters to tr

## Functions

- `get_tr_fun()`: Transformation selecting function

- `get_tr_apply()`: Transformation apply function

  Get a function that applies a transformation to a given column grouped
  by another column
