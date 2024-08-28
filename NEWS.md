# dv.explorer.parameter 0.0.5

* First Github release
* Renamed to dv.explorer.parameter


# dv.biomarker.general 0.0.4

* Correlation heatmap:
    * NA and Inf values are removed before the scatterplot to avoid spurious points
* Lineplot:
    * Lineplot does no longer crash when dataset is empty
    * Populates inline titles with column names when labels are not available
    * Brush selection behaves correctly when sidebar is expanded in dv.manager and it does not crash when the selection
      is empty
    * Prevents visit reset when dataset changes in module manager


* Migrated Waterfall plus heatmap module to dv.biomarker.general
* Migrated dv.roc to dv.biomarker.general

# dv.biomarker.general 0.0.3

* Lineplot:
    * Added summary data listing with aggregated centrality (mean, median, ...) and 
      dispersion (standard deviation, confidence interval, ...) scores.

* Correlation heatmap:
    * Selection interface now allows multiple, independent cross-visit and cross-parameter combinations.
    * Faster plot rendering.
    * Cleaner graphic output and better management of long axis labels.

# dv.biomarker.general 0.0.2

* Common:
    * Each module now explicitly specifies the value column used to generate the figures.
    * Default values are included in all modules.
    * Menus have been redesigned using shinyvalidate to provide more informative feedback regarding errors or missing selections.

* Boxplot:
    * Added functionality for saving/loading visualization states.

* Lineplot:
    * Added functionality for integration with other modules
    * Supports custom centrality and dispersion measures

* Fix:
    * Rectified issue where Boxplot added jitter in the y-axis unnecessarily.
    * Renamed `value_var` to `value_vars` in the Scatter Plot Matrix module to adhere to DV standards.
    * Improved error handling for correlation calculations in Scatter plot matrix

* Other:
    * Replaced the magrittr pipeline `%>%` with the base pipeline `|>`.
    * Resolved the issue with `subset_ds` for single column selections.
    * Implemented new synthetic datasets in mock_* functions and testing procedures.
    * Replaced `dv.selector` with locally developed selectors

# dv.biomarker.general 0.0.1

* Initial release with the following modules:
    * Boxplot: `vignette("boxplot")`
    * Scatterplot: `vignette("scatterplot")`
    * Lineplot: `vignette("lineplot")`
    * Scatterplotmatrix: `vignette("scatterplotmatrix")`
    * Forest plot: `vignette("forest")`
    * Scatterplot heatmap plot: `vignette("correlation_heatmap")`
