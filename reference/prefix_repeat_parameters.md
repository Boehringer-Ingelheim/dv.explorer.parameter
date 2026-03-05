# Prefix Repeat Parameters

This function modifies a given dataset by prefixing repeating parameter
values with their corresponding category values.

## Usage

``` r
prefix_repeat_parameters(dataset, cat_var, par_var)
```

## Arguments

- dataset:

  Input data frame.

- cat_var:

  Dataset column name that contains the category values.

- par_var:

  Dataset column name that contains the parameter values.

## Value

Modified dataset where the repeated parameter values have been prefixed
with their corresponding category values.
