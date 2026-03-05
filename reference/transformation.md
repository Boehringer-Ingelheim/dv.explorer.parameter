# Transformation functions

Transformation functions

## Usage

``` r
tr_identity(x)

tr_z_score(x)

tr_gini(x)

tr_trunc_z_score(x, trunc_min = -3, trunc_max = 3)

tr_trunc_z_score_3_3(x)

tr_min_max(x)

tr_percentize(x)
```

## Arguments

- x:

  a vector/list

- trunc_min:

  minimum value

- trunc_max:

  maximum value

## Value

a vector/list with the transformed values

a vector/list with the transformed values

a vector/list with the transformed values truncated at the specified
cuts

a vector/list with the transformed values truncated at the (-3, 3) cuts

a vector/list with the transformed values

a vector/list with the transformed values

## Functions

- `tr_identity()`: Identity transformation

- `tr_z_score()`: Z score transformation

- `tr_gini()`: Gini's mean difference

- `tr_trunc_z_score()`: Truncated Z score transformation

- `tr_trunc_z_score_3_3()`: Truncated Z score transformation in the
  (-3, 3) range

- `tr_min_max()`: Min Max transformation

- `tr_percentize()`: Percentize transformation
