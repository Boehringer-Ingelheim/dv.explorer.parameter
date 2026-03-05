# Subsets a biomarker dataset for a category, parameter, visit and value selection

Subsets a biomarker dataset for a category, parameter, visit and value
selection

## Usage

``` r
subset_bds_param(
  ds,
  par,
  par_col,
  cat,
  cat_col,
  val_col,
  vis,
  vis_col,
  subj_col,
  anlfl_col = NULL
)
```

## Arguments

- ds:

  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)

  See *Input dataframe section*

- par, cat:

  `[character*ish*(n)]`

  Values from `par_col` and `cat_col` to be subset

- val_col:

  `[character*ish*(1)]`

  Column containing values for the parameters

- vis:

  `[character*ish*(1)]`

  Values from `vis_col` to be subset

- subj_col, par_col, cat_col, vis_col, anlfl_col:

  `[character(1)]`

  Column for subject id, category, parameter, visit and analysis flag.
  All specified columns must be factors. Analysis flag is optional.

## Value

|              |             |            |         |         |
|--------------|-------------|------------|---------|---------|
| `subject_id` | `parameter` | `category` | `visit` | `value` |
| xx           | xx          | xx         | xx      | xx      |

Additionally:

- When present `label` attributes are retained.

- When the same parameter is repeated across different categories an
  error is raised

## Details

- If at least one parameter name appears under several selected
  categories, an error is produced

## Input dataframe

It expects a dataset similar to
https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192
, 1 record per subject per parameter per analysis visit

It expects, at least, the columns passed in the parameters, `subj_col`,
`cat_col`, `par_col`, `visit_col` and `val_col`. The values of these
variables are as described in the CDISC standard for the variables
USUBJID, PARCAT, PARAM, AVISIT and AVAL.
