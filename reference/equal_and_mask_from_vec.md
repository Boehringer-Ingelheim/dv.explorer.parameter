# Create a mask to filter a dataframe from a named list of values

It returns a logical mask indicating which rows have all columns in the
list equal to the value in the list. It only calculates equality with a
reducing function `&`.

## Usage

``` r
equal_and_mask_from_vec(ds, fl)
```

## Arguments

- ds:

  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)

  A dataframe

- fl:

  `named.list()|named.atomic()`

  A named list or atomic vector

## Details

Any attempt to generalize this function is very likely a mistake as it
is thought to be a shorthand for a common operation.
