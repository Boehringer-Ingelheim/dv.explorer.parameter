# ggplot for a set of faceted boxplots

The chart consists of a faceted set of boxplots for biomarker data

## Usage

``` r
boxplot_chart(ds, violin, show_points, log_project_y, title_data = NULL)
```

## Arguments

- ds:

  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)

  A dataframe as output by [bp_subset_data](bp_subset_data.md)

- violin:

  `logical(1)`

  Shows a violin plot instead of a boxplot

- show_points:

  `logical(1)`

  Shows individual points in the boxplot chart

- title_data:

  [`list()`](https://rdrr.io/r/base/list.html)

  Shows a title summarising parameter values.

## Value

A ggplot chart

## Details

### Labels:

- X axis and color aesthetic are labelled using the label atttribute
  from `main_group` column from `ds`

- Y axis is labelled using the label atttribute from `value` column from
  `ds`

### Aesthetics:

- `parameter` is coded as 1st level row facets

- `main_group` is coded as colors and x axis

- `sub_group` is coded as 1st level column facets

- `page_group` is coded as 2nd level row facets

### Hack:

[shiny::nearPoints](https://rdrr.io/pkg/shiny/man/brushedPoints.html) do
not manage well charts with no x aesthetic. Therefore when no
`main_group` is present in `ds` a dummy one is added.
