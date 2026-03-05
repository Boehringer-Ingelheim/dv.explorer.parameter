# Strip ".data" pronoun from a string

This function removes the `.data` pronoun and the `[[]]` accesor from a
string using a regular expression pattern. It works also when the .data
is surrounded by [`c()`](https://rdrr.io/r/base/c.html). If there is no
match the string is returned unmodified.

## Usage

``` r
strip_data_pronoun(x)
```

## Arguments

- x:

  A character string to be processed.

## Value

A character string with the ".data" pronoun removed.
