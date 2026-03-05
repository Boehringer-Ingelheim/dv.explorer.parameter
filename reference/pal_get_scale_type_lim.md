# Return the type of scale and its limits

Inferes the type of scale and its limits based on the the data

## Usage

``` r
pal_get_scale_type_lim(d)
```

## Arguments

- d:

  the data from which the scale will be inferred

## Value

A list with the entries:

### type:

- divergent: It has both positive, negative and 0 values

- seq_positive: It has positive or 0 values

- seq_negative: It has negative or 0 values

- seq_positive: It has positive or 0 values

- all_zero: It has only 0 values

### lim:

- If **divergent**: c(-max_abs, 0, max_abs) when max_abs is the maximum
  absolute value of all data

- If **seq_positive** or **seq_negative**: c(min(d), max(d)) when
  max_abs is the maximum absolute value of all data

- if **all_zerp**: c(0,0)
