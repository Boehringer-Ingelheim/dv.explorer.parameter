# Subsets data for hmpar module

Subsets data for hmpar module

## Usage

``` r
wfphm_hmpar_subset(
  data,
  cat_selection,
  cat_var,
  par_selection,
  par_var,
  visit_selection,
  visit_var,
  value_var,
  subjid_var,
  sorted_x,
  out_criteria,
  scale,
  anlfl_col = NULL
)
```

## Arguments

- data:

  the bsd param dataset

- cat_selection, par_selection, visit_selection:

  the selected category, parameter and visit selections

- cat_var, par_var, visit_var, value_var, subjid_var:

  the corresponding columns

- sorted_x:

  the ordered subject ids

- out_criteria:

  the outlier criteria

- scale:

  a scaling function that will rescale the values in the heatmap
