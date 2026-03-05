# Test if a parameter only appears under one category

It contains at least the subject id. It includes a need to use inside a
validate body

It contains at least the subject id

## Usage

``` r
test_one_cat_per_par(ds, cat_col, par_col)

need_one_cat_per_var(..., msg)

test_one_cat_per_par(ds, cat_col, par_col)
```

## Arguments

- ds:

  `[data.frame()]` The dataset to be tested

- cat_col:

  `[character(1)]` Name of the column containing the category name

- par_col:

  `[character(1)]` Name of the column containing the parameter name

- ...:

  arguments passed to test_one_cat_per_par

- msg:

  `[character(1)]`

  Validation message to be diplayed

## Value

`[logical(1)]` `TRUE` if a parameter appears under a single category,
`FALSE` otherwise

`[logical(1)]` `TRUE` if a parameter appears under a single category,
`FALSE` otherwise
