# Server side of ggplot-only heatmap

Plot the contents of a dataframe as a heatmap, with optional legends,
palette and alignment margins. All parameters can be reactive

## Usage

``` r
HM2SVG_server(
  id,
  data,
  x_desc = "S",
  y_desc = "W",
  z_desc = "E",
  palette = NULL,
  margins = list(top = 0, bottom = 0, left = 0, right = 0),
  debug_gtable = FALSE
)
```

## Arguments

- id:

  shiny ID

- x_desc, y_desc, z_desc:

  Indicate the absence/presence and location of the axis descriptors
  (the descriptor for the x and y axes are the plot ticks; for the z
  axis it's the legend) - x_desc can take the following values: "N"
  (north), "S" (south), NULL (absent) - y_desc can take the following
  values: "W" (west), "E" (east), NULL (absent) - z_desc can take the
  following values: "N", "E", "S", "W", NULL

- palette:

  Vector that maps values to "z" colors. The names of the vector are
  hexadecimal colors encoded as \#rrggbb or \#rrggbbaa (red, green,
  blue, alpha) and the values are the "z" values that should be mapped
  to that color. If "z" is categorical, the palette should be complete
  (i.e. it should offer one color per value). If "z" is continuous, the
  palette should contain at least two values covering the min-max range
  of possible values. If it contains more, the color of each grid
  rectangle will be linearly interpolated according to where its value
  falls between the two surrounding provided colors.

- margins:

  Offset in pixels from the edges of the drawable area to the outer
  perimeter of the heatmap (excluding legends and axis descriptions).
  It's a non-reactive list of possibly reactive "top", "bottom", "left"
  and "right" numerical values.

- debug_gtable:

  Activate debug mode

## Value

List of margins (Margin in pixels this plot would have if drawn in
isolation encoded as a reactiveValues object with elements "top",
"bottom", "left" and "right") and click (reactive that returns user
click info)
