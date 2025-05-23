% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mod_scatter_matrix.R
\name{mod_scatterplotmatrix}
\alias{mod_scatterplotmatrix}
\title{Matrix of scatterplots module}
\usage{
mod_scatterplotmatrix(
  module_id,
  bm_dataset_name,
  group_dataset_name,
  cat_var = "PARCAT",
  par_var = "PARAM",
  value_vars = "AVAL",
  visit_var = "AVISIT",
  subjid_var = "USUBJID",
  default_cat = NULL,
  default_par = NULL,
  default_visit = NULL,
  default_value = NULL,
  default_main_group = NULL
)
}
\arguments{
\item{module_id}{\verb{[character(1)]}

Module Shiny id}

\item{bm_dataset_name, group_dataset_name}{\verb{[character(1)]}

Name of the dataset}

\item{cat_var, par_var, visit_var}{\verb{[character(1)]}

Columns from \code{bm_dataset} that correspond to the parameter category, parameter and visit}

\item{value_vars}{\verb{[character(n)]}

Columns from \code{bm_dataset} that correspond to values of the parameters}

\item{subjid_var}{\verb{[character(1)]}

Column corresponding to subject ID}

\item{default_cat, default_par, default_visit, default_value, default_main_group}{\verb{[character(1)|NULL]}

Default values for the selectors}
}
\description{
\code{mod_scatterplotmatrix} is a Shiny module prepared to display data in a matrix of scatterplots with different levels
of grouping. It also includes correlation stats.
}
\keyword{main}
