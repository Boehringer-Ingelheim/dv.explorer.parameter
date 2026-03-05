# A sequential palette to use with heatmap

A sequential palette to use with heatmap

## Usage

``` r
pal_seq_palette(max, min, colors)
```

## Arguments

- max, min:

  the values to be associated with the extreme and colors

- colors:

  the palette colors

  max, min the values are associated with the extreme colors. If the
  palette contains more colors, the values are interpolated.

## Value

Vector The names of the vector are hexadecimal colors encoded as
\#rrggbb or \#rrggbbaa (red, green, blue, alpha) and the values are the
"z" values that should be mapped to that color.
