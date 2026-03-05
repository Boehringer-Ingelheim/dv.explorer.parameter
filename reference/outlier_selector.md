# Single outlier selector

A selector composed by two rows containing:

- a `label`

- two inline
  [shiny::textInput](https://rdrr.io/pkg/shiny/man/textInput.html) boxes
  for the upper and lower limit of the outliers

## Usage

``` r
outlier_ui(id, label, value_ll = "", value_ul = "")

outlier_server(id)
```

## Arguments

- id:

  Shiny ID `[character(1)]`

- label:

  label for the selectors

- value_ll:

  an initial value for the lower limit

- value_ul:

  an initial value for the upper limit

## Value

A reactive containing a list with two entries`ll` and `ul`. It returns
either NA if the box is empty or the result of applying as.numeric to
the contents of the input box. It does not return NULL values.

## Details

The UI root element is a divisor which id attribute is equal to the `id`
parameter. So it can be used with
[shiny::insertUI](https://rdrr.io/pkg/shiny/man/insertUI.html) and
[shiny::removeUI](https://rdrr.io/pkg/shiny/man/insertUI.html)
functions.

## Functions

- `outlier_ui()`: UI

- `outlier_server()`: server

## See also

outlier_container
