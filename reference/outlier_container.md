# A container for outlier selectors

A container for outlier selectors

## Usage

``` r
outlier_container_UI(id)

outlier_container_server(id, choices)

mock_outlier()
```

## Arguments

- id:

  Shiny ID `[character(1)]`

- choices:

  a list with the parameters for which we want to select outliers

## Value

A reactive containing a list with as many entries as choices are
selected in the selector. Each of the entries contain a list with two
entries`ll` and `ul` as described in
[outlier_selector](outlier_selector.md).

## Details

When a choice is deselected and selected again, it will retain its
previous state.

## Functions

- `outlier_container_UI()`: UI

- `outlier_container_server()`: server

- `mock_outlier()`: mock

## See also

outlier_selector
