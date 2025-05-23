% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mod_roc.R
\name{roc_server}
\alias{roc_server}
\title{ROC server function}
\usage{
roc_server(
  id,
  pred_dataset,
  resp_dataset,
  group_dataset,
  dataset_name = shiny::reactive(character(0)),
  pred_cat_var = "PARCAT",
  pred_par_var = "PARAM",
  pred_value_vars = "AVAL",
  pred_visit_var = "AVISIT",
  resp_cat_var = "PARCAT",
  resp_par_var = "PARAM",
  resp_value_vars = c("CHG1", "CHG2"),
  resp_visit_var = "AVISIT",
  subjid_var = "USUBJID",
  compute_roc_fn = compute_roc_data,
  compute_metric_fn = compute_metric_data
)
}
\arguments{
\item{id}{Shiny ID \verb{[character(1)]}}

\item{pred_dataset, resp_dataset, group_dataset}{\verb{[data.frame()]}

Dataframes as described in the \verb{Input dataframes} section}

\item{dataset_name}{\verb{[shiny::reactive(*)]}

a reactive indicating when the dataset has possibly changed its columns}

\item{pred_cat_var, pred_par_var, pred_visit_var, resp_cat_var, resp_par_var, resp_visit_var}{\verb{[character(1)]}

Columns from \code{pred_dataset}/\code{resp_dataset} that correspond to the parameter category, parameter and visit}

\item{pred_value_vars, resp_value_vars}{\verb{[character(n)]}

Columns from \code{pred_dataset},\code{resp_dataset} that correspond to values of the parameters}

\item{subjid_var}{\verb{[character(1)]}

Column corresponding to subject ID}

\item{compute_roc_fn, compute_metric_fn}{\verb{[function()]}

Functions used to compute the ROC and metric analysis, please view the corresponding vignette for more details.}
}
\description{
\subsection{Input dataframes:}{
\subsection{pred_dataset}{

It expects a dataset similar to
https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192 ,
1 record per subject per parameter per analysis visit

It expects, at least, the columns passed in the parameters, \code{subjid_var}, \code{pred_cat_var}, \code{pred_par_var},
\code{pred_visit_var} and \code{pred_value_var}. The values of these variables are as described
in the CDISC standard for the variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.
}

\subsection{resp_dataset}{

It expects a dataset similar to
https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192

It expects, at least, the columns passed in the parameters, \code{subjid_var}, \code{resp_cat_var},
\code{resp_par_var}, \code{resp_visit_var} and \code{resp_value_var}.
The values of these variables are as described
in the CDISC standard for the variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.
}

\subsection{group_dataset}{

It expects a dataset with an structure similar to
https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806 ,
one record per subject

It expects to contain, at least, \code{subjid_var}
}

}
}
\keyword{developers}
