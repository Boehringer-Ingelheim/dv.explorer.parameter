# Returns a divergent palette to use with heatmap

Returns a divergent palette to use with heatmap

## Usage

``` r
pal_div_palette(max, neut, min, colors)
```

## Arguments

- max, neut, min:

  the values to be associated with the extreme and central colors

- colors:

  the palette colors

  max, neut, min the values to be associated with the extreme and
  central colors. If the palette contains more colors, the values are
  interpolated.

## Value

Vector The names of the vector are hexadecimal colors encoded as
\#rrggbb or \#rrggbbaa (red, green, blue, alpha) and the values are the
"z" values that should be mapped to that color.
