% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mod_roc.R
\name{get_explore_roc_spec}
\alias{get_explore_roc_spec}
\title{Specification for an ordered AUC value plus CI chart}
\usage{
get_explore_roc_spec(ds, fig_size, sort_alph)
}
\arguments{
\item{ds}{\verb{[data.frame()]}

A data.frame}

\item{fig_size}{\verb{[numeric(1)]}

Size in pixels for the chart}

\item{sort_alph}{\verb{[logical(1)]}

Sort chart by parameter name}
}
\value{
A \link{vegawidget} specification
}
\description{
The chart consists of a set of points with confidence intervals representing the AUC and its confidence interval.
}
\details{
Parameters, by default, are vertically ordered from highest to lowest AUC curve.
When grouped, parameters will be combined with the grouping variable.
}
\section{Internal checks}{

\subsection{Shiny validation errors:}{
\itemize{
\item If the number of rows returned is greater than \code{ROC_VAL$MAX_ROWS_EXPLORE} a validation error is produced.
Otherwise the chart is too large, for greater limits than \code{ROC_VAL$MAX_ROWS_EXPLORE} the session may crash.
}
}
}

\section{Input dataframe list}{

\subsection{\code{ds}}{

\verb{[data.frame()]}

With columns:
\itemize{
\item \code{predictor_parameter} \verb{[factor()]}: Predictor parameter name.
\item \code{response_parameter} \verb{[factor()]}: Response parameter name.
\item \code{group} \verb{[factor()]}: An optional column for the grouping value (if group is specified).
\item \code{specificity} \verb{[numeric()]}: Sensitivity
\item \code{sensitivity} \verb{[numeric()]}: Specificity
\item \code{threshold} \verb{[numeric()]}: Threshold
\item \code{auc} \verb{[numeric(3)]}: A numeric vector of length 3 c(LOWER AUC CI, AUC, UPPER AUC CI)
}
}
}

\keyword{internal}
