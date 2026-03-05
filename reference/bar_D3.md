# D3 bar plot

Plot the contents of a dataframe as a bar plot, with optional legend,
palette and alignment margins.

## Usage

``` r
bar_d3_UI(id, ...)

bar_d3_server(
  id,
  data,
  x_axis,
  y_axis,
  z_axis,
  margin,
  palette,
  msg_func,
  quiet = TRUE,
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

  - columns names are "x", "y", "z" and, optionally, "label" and "color"

  - There is one entry for each "x" present in the dataset. In other
    words, the values for each bar are defined explicitly, even if they
    are NA

  - Axis labels and legend title are stored as the attribute "label" of
    the "x", "y" and "z" columns. (Legend title is not implemented yet)

  - "x" is a factor. The order of the levels dictates the ordering of
    the x axis.

  - "z" is be a factor

  - "label" values are printed on top of each of the bars

  - If the column is included, "color" values override the color defined
    according to the palette paremeter. For the entries that we do not
    want to override the `NA` value must be passed in the color column.

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

  margin to be used on each of the sides. It must contain four entries
  named `top`, `bottom`, `left` and `right`

- palette:

  `[character(1+) | shiny::reactive(character(1+)) | shinymeta::metaReactive(character(1+))]`

  Vector that maps values to "z" colors. The names of the vector are
  hexadecimal colors encoded as \#rrggbb or \#rrggbbaa (red, green,
  blue, alpha) and the values are the "z" values that should be mapped
  to that color.

  - the palette is complete (i.e. it should offer one color per value)

  - z values that are `NA` or `NULL` are colored in grey.

- msg_func:

  `[character(1) | shiny::reactive(numeric(1)) | shinymeta::metaReactive(numeric(1))]`

  A JS string that is evaluated in the client. The string must return a
  function that receives a single parameter and returns HTML code that
  is placed in the tooltip. If NULL a default tooltip is shown.

- quiet:

  `[logical(1) | shiny::reactive(logical(1)) | shinymeta::metaReactive(logical(1))]`

  A boolean indicating if javascript code should include debug output.

## Value

### UI

A bar plot

### Server

A list with one entry: margin: similar to the margin parameter with the
minimum margins for the current plot

A reactive list similar to that in the margin param, but indicating
which margin is needed to safely plot the figure. This value is only
returned inside a Shiny application.

## Details

This plot always include the value 0 as baseline.

*msg func* contains a string containing JS code. When evaluated, this
string will be evaluated in the client and must return a function that
receives a single parameter. That parameter will contain a JS object
with the same fields as columns in *data* for the point being hovered.

## Functions

- `bar_d3_UI()`: UI

- `bar_d3_server()`: Server
