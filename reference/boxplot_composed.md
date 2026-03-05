# Composes data selection and charting for boxplot

This is a set of *glue* functions that in most cases follow the pattern
of receiving data, calculating data in an independent/several
independent functions

## Usage

``` r
bp_get_boxplot_output(ds, violin, show_points, log_project_y, title_data)

bp_get_listings_output(ds, closest_point)

bp_get_single_listings_output(ds, closest_point, input_id)

bp_get_count_output(ds)

bp_get_summary_output(ds, quantile_type)

bp_get_significance_output(ds)
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

- input_id:

  Shiny ID for the single listing button

- quantile_type:

  `[integer(1)]`

  Quantile algorithm type (an integer between 1 and 9).

## Details

In some cases aesthetic or simple error validations can occur

This set of functions is not directly tested as they are indirectly
tested in the running app
