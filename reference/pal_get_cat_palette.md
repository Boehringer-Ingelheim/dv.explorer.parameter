# Returns a categorical palette to use with heatmap

Returns a categorical palette to use with heatmap

## Usage

``` r
pal_get_cat_palette(d, colors)
```

## Arguments

- d:

  a vector containing the values to be colored

- colors:

  the colors to be used. They will be recycled as needed.

## Value

Vector The names of the vector are hexadecimal colors encoded as
\#rrggbb or \#rrggbbaa (red, green, blue, alpha) and the values are the
"z" values that should be mapped to that color.
