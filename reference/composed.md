# Composed functions

Functions that creates and output to be displayed in the app, usually,
by composing data and plotting calls.

## Usage

``` r
get_roc_plot_output(ds_list, param_as_cols, fig_size, is_sorted)

get_dens_plot_output(ds, param_as_cols, fig_size)

get_histo_plot_output(ds, param_as_cols, fig_size)

get_raincloud_output(ds, param_as_cols, fig_size, quantile_type)

get_metrics_output(
  ds,
  param_as_cols,
  fig_size,
  x_metrics_col,
  compute_metric_fn
)

get_gt_summary_output(ds_list, sort_alph)

get_info_panel_output(ds)
```

## Functions

- `get_roc_plot_output()`: ROC plot

- `get_dens_plot_output()`: Density plot

- `get_histo_plot_output()`: Density plot

- `get_raincloud_output()`: Raincloud plot

- `get_metrics_output()`: Metrics plot

- `get_gt_summary_output()`: GT Summary

- `get_info_panel_output()`: Info Panel
