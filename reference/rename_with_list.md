# Rename a data frame with a list/character vector of new names

The names are the old names and the values are the new names.
`rename_vec` names not present in `ds` are ignored.

## Usage

``` r
rename_with_list(ds, rename_vec)
```

## Arguments

- ds:

  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)

  A dataframe

- rename_vec:

  `named.list()|named.character()`

  A named list or character vector with the new names

## Value

[`data.frame()`](https://rdrr.io/r/base/data.frame.html)

Returns renamed `ds`
