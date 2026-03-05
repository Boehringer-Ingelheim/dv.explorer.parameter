# D3 heatmap plot

Plot the contents of a dataframe as a heatmap, with optional legends,
palette and alignment margins.

## Usage

``` r
heatmap_d3_UI(id, ...)

heatmap_d3_server(
  id,
  data,
  x_axis = "S",
  y_axis = "W",
  z_axis = "E",
  margin = list(top = 0, bottom = 0, left = 0, right = 0),
  palette = NULL,
  quiet = TRUE,
  msg_func = NULL,
  ...
)
```

## Arguments

- id:

  Shiny ID `[character(1)]`

- ...:

  Extra parameters that are passed to
  [r2d3::d3Output](https://rstudio.github.io/r2d3//reference/d3-shiny.html),
  [r2d3::renderD3](https://rstudio.github.io/r2d3//reference/d3-shiny.html)
  and [r2d3::r2d3](https://rstudio.github.io/r2d3//reference/r2d3.html)

- data:

  `[data.frame() | shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`

  dataframe to plot. It expects the following format:

  - columns names ar "x", "y", "z" and, optionally, "label" and "color"

  - There is one entry for each combination of "x" and "y" present in
    the dataset. In other words, the values for each bar are defined
    explicitly, even if they are NA

  - Axis labels and legend title are stored as the attribute "label" of
    the "x", "y" and "z" columns. (Legend title is not implemented yet)

  - "x" and "y" are factors. The order of the levels dictates the
    ordering of each axis.

  - "z" is a factor or a double.

  - "label" values are printed on top of each of cell

  - If the column "color" is included, its values override the color
    defined according to the palette parameter. For the entries that we
    do not want to override the `NA` value must be passed in the color
    column.

  - It can contain additional columns that are not used for plotting but
    can be used in the tooltip.

- x_axis, y_axis, z_axis:

  `[character(1) | NULL | shiny::reactive(character(1) | NULL) | shinymeta::metaReactive(character(1) | NULL)]`

  Indicate the absence/presence and location of the axis descriptors
  (the descriptor for the x and y axes are the plot ticks; for the z
  axis it's the legend)

  - x_desc can take the following values: "N" (north), "S" (south), NULL

  - y_desc can take the following values: "W" (west), "E" (east), NULL

  - z_desc can take the following values: "N", "E", "S", "W", NULL

- margin:

  `[numeric(4) | shiny::reactive(numeric(4)) | shinymeta::metaReactive(numeric(4))]`

  margin to be used on each of the sides.

- palette:

  `[character(1+) | numeric (1+) | shiny::reactive(character(1+) | numeric (1+)) | shinymeta::metaReactive(character(1+) | numeric (1+))]`

  Vector that maps values to "z" colors. The names of the vector are
  hexadecimal colors encoded as \#rrggbb or \#rrggbbaa (red, green,
  blue, alpha) and the values are the "z" values that should be mapped
  to that color.

  - If "z" is a factor, the palette is complete (i.e. it should offer
    one color per value).

  - If "z" is a double, the palette should contain at least two values
    covering the min-max range of possible values. If it contains more,
    the color of each cell will be linearly interpolated according to
    where its value falls between the two surrounding provided colors.

  - z values that are `NA` or `NULL` will always be colored in grey.

  - In all cases the same color can be mapped to several values

- quiet:

  `[logical(1) | shiny::reactive(logical(1)) | shinymeta::metaReactive(logical(1))]`

  A boolean indicating if javascript code should include debug output.

- msg_func:

  `[character(1) | shiny::reactive(numeric(1)) | shinymeta::metaReactive(numeric(1))]`

  A JS string that is evaluated in the client. The string must return a
  function that receives a single parameter and returns HTML code that
  is placed in the tooltip. If NULL a default tooltip is shown.

## Value

### UI

A heatmap plot

### Server

A list with one entry: margin: similar to the margin parameter with the
minimum margins for the current plot

## Details

*msg func* contains a string containing JS code. When evaluated, this
string will be evaluated in the client and must return a function that
receives a single parameter. That parameter will contain a JS object
with the same fields as columns in *data* for the point being hovered.

## Functions

- `heatmap_d3_UI()`: UI

- `heatmap_d3_server()`: Server
