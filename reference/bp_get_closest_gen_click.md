# Clicking helpers

The boxplot requires several helpers to manage the clicks. The main
function is `bp_get_closest_gen_click`, and the other two are specific
calls for `click` and `double_click` events.

### bp_get_closest_gen_click

This function takes a dataset and a general click and returns the
closest row to the click. It uses the
[shiny::nearPoints](https://rdrr.io/pkg/shiny/man/brushedPoints.html).
[shiny::nearpoints](https://rdrr.io/pkg/shiny/man/brushedPoints.html)
function is not particularly well-behaved in two cases:

- The ggplot does contain several facet levels Solved by: Prefiltering
  `ds` manually so it only contains the rows corresponding to the
  clicked facet

- The ggplot lacks an `x` or `y` aesthetic Solved by: In this particular
  case the `x` aesthetic correspond to the `CNT$MAIN_GROUP` column. If
  no grouping is specified during the selection this function assumes
  that a dummy `x` aesthetic was used in
  [boxplot_chart](boxplot_chart.md). Therefore, this dummy variable is
  introduced as a column in `ds`, and
  [shiny::nearPoints](https://rdrr.io/pkg/shiny/man/brushedPoints.html)
  can be used.

- The aesthetic has been defined using the `.data` pronoun to overcome
  NSE used in
  [ggplot2::ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)
  Solved by: Stripping `.data` pronouns before passing them into
  [shiny::nearPoints](https://rdrr.io/pkg/shiny/man/brushedPoints.html)

### Specific calls:

After a click is made and a table shown, when the dataset changes, the
app reaches this function in an invalid state where `ds` contains the
new dataset and `click` contains the click from the previous dataset.
This usually provokes that a 0-row dataset is returned.

## Usage

``` r
bp_get_closest_gen_click(ds, click)

bp_get_closest_single_click(ds, click)

bp_get_closest_double_click(ds, click)
```

## Arguments

- ds:

  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)

  A data frame containing the data to be filtered.

- click:

  [`list()`](https://rdrr.io/r/base/list.html)

  A list containing the click information as received from the `Shiny`
  input

## Value

`data.frame`

A data frame containing the closest row in `ds` to the click.
