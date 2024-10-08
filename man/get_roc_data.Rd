% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mod_roc.R
\name{get_roc_data}
\alias{get_roc_data}
\title{Apply ROC analysis to groups}
\usage{
get_roc_data(ds, compute_fn, ci_points, do_bootstrap)
}
\arguments{
\item{ds}{\verb{[data.frame()]}
A dataframe}

\item{compute_fn}{\verb{[function(1)]}
A function that computes the ROC data}

\item{ci_points}{\verb{[list(spec = numeric(), thr = numeric())]}
Points at which 95\% confidence intervals for sensitivity and specificity will be calculated. Depending on the entry
CI will be calculated at defined specificity points or threshold points.}

\item{do_bootstrap}{\verb{[logical(1)]}
Calculate confidence intervals for sensitivity and specificity}
}
\value{
\verb{[list(data.frame())]}
A list with entries:
\subsection{roc_curve}{

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

\subsection{roc_ci}{

\verb{[data.frame()]}

With columns:
\itemize{
\item \code{predictor_parameter} \verb{[factor()]}: Predictor parameter name.
\item \code{response_parameter} \verb{[factor()]}: Response parameter name.
\item \code{group} \verb{[factor()]}: An optional column for the grouping value (if group is specified).
\item \code{ci_specificity} \verb{[numeric()]}: Specificity value
\item \code{ci_lower_specificity} \verb{[numeric()]}: Specificity lower confidence interval
\item \code{ci_upper_specificity} \verb{[numeric()]}: Specificity upper confidence interval
\item \code{ci_sensitivity} \verb{[numeric()]}: Sensitivity value
\item \code{ci_lower_sensitivity} \verb{[numeric()]}: Sensitivity lower confidence interval
\item \code{ci_upper_sensitivity} \verb{[numeric()]}: Sensitivity upper confidence interval
}

CIs are only calculated when \code{do_bootstrap} is \code{TRUE}
}

\subsection{roc_optimal_cut}{

\verb{[data.frame()]}

With columns:
\itemize{
\item \code{predictor_parameter} \verb{[factor()]}: Predictor parameter name.
\item \code{response_parameter} \verb{[factor()]}: Response parameter name.
\item \code{group} \verb{[factor()]}: An optional column for the grouping value (if group is specified).
\item \code{optimal_cut_title} \verb{[character()]}: Name of the optimal cut
\item \code{optimal_cut_specificity} \verb{[numeric()]}: Sensitivity at the optimal cut point
\item \code{optimal_cut_lower_specificity} \verb{[numeric()]}: Lower Confidence interval of sensitivity
\item \code{optimal_cut_upper_specificity} \verb{[numeric()]}: Upper Confidence interval of sensitivity
\item \code{optimal_cut_sensitivity} \verb{[numeric()]}: Specificity at the optimal cut point
\item \code{optimal_cut_lower_sensitivity} \verb{[numeric()]}: Lower Confidence interval of sensitivity
\item \code{optimal_cut_upper_sensitivity} \verb{[numeric()]}: Upper Confidence interval of sensitivity
\item \code{optimal_cut_threshold} \verb{[numeric()]}: Threshold of the optimal cut
}

CIs are only calculated when \code{do_bootstrap} is \code{TRUE}
}
}
\description{
It applies an ROC analysis over a dataset. The application is applied by groups defined by \code{predictor_parameter},
\code{response_parameter} and, if grouped, \code{group}.

This functions is prepared to be applied over a dataset that is the output of \code{roc_subset_data()}.

The function itself does not calculate the ROC analysis, it only applies \code{compute_fn} over the different groups.
\subsection{Input dataframe:}{

\verb{[data.frame()]}

With columns:
\itemize{
\item \code{subject_id} \verb{[factor()]}: Subject ID
\item \code{predictor_parameter} \verb{[factor()]}: Predictor parameter name.
\item \code{response_parameter} \verb{[factor()]}: Response parameter value.
\item \code{group} \verb{[factor()]}: An optional column for the grouping value (if group is specified).
\item \code{predictor_value} \verb{[numeric()]}: Predictor parameter Value
\item \code{response_value} \verb{[factor()]}: Response parameter Value.
}
}

\subsection{compute_fn definition:}{

For an example of a computing function please review \code{\link[=compute_roc_data]{compute_roc_data()}}.
}
}
\details{
If \code{compute_fn} returns an error when applied to any of the groups a dataset with NA is returned instead.
This controls side cases such as groups that contains a single observation.
}
\keyword{internal}
