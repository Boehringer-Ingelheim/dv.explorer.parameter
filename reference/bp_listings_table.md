# Subsets a data.frame based on the values of a one-rowed data.frame

It subsets `ds` based on the values of `f_ds`.

## Usage

``` r
bp_listings_table(ds, f_ds)
```

## Arguments

- ds:

  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)

  data.frame to be subset

- f_ds:

  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)

  one-rowed data.frame

## Value

[`data.frame()`](https://rdrr.io/r/base/data.frame.html)

The subset dataset

## Details

No check no names of data.frames is performed (e.g.: names in `f_ds` are
names in `ds`)
