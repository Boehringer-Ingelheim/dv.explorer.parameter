# dv.explorer.parameter 0.1.9-9009

Remove other menu from scatterplot matrix

# dv.explorer.parameter 0.1.9-9008

Clear errors from the log

# dv.explorer.parameter 0.1.9-9007

* All modules where applicable:
    * Update screenshots in vignettes to reflect the dv.manager update
    * Update QC report according to the updated template
    
  * wfph:
    * Removed nonGxP notification   


# dv.explorer.parameter 0.1.9-9006

* roc:
    * Fix a bug in the Summary tab, so that the visualisation output is produced even when there are combinations of predictor and response where the response has only one value throughout. In this case ROC can not be calculated but the entry is presented in the plot with blank ROC. 

# dv.explorer.parameter 0.1.9-9005

* Adds support for bs5

# dv.explorer.parameter 0.1.9-9004

* roc:
    * Fix a bug in the Summary tab, so that the visualisation output is produced both when a grouping variable is selected and when "None" is selected
    * Ensure that USUBJID is removed from the grouping drop down list in the summary tab, as in spite of it being a factor it doesn't make sense to group the visualisation output by USUBJID 

# dv.explorer.parameter 0.1.9-9003

* boxplot, roc:
    * Add quantile_type to the mod signature enabling app creators to select the quantile calculation algorithm of choice 
    * Update existing test, and add additional tests using the quantile_type argument
* boxplot, line plot, scatter plot, scatter plot matrix, correlation heatmap, waterfall plus heatmap, forest plot:
    * removed unnecessary transformation of variables to factors in the documentation examples

# dv.explorer.parameter 0.1.9-9002

* lineplot:
    * Applied a fix to ensure that if the indicated ref line variables in the input data table have labels attached to them, then these labels are used in the plot's legend

# dv.explorer.parameter 0.1.9-9001

* boxplot, lineplot, scatter plot, scatter plot matrix, correlation heatmap, waterfall plus heatmap, roc :
    * Added tests for each module, to ensure an appropriate messages is displayed, when a dataset is filtered to zero records using the global filter. 

# dv.explorer.parameter 0.1.9

* boxplot, lineplot, scatter plot, scatter plot matrix, correlation heatmap, waterfall plus heatmap :
    * Added the option to filter the input dataset based on Y/N flag variables that exist in it.
* boxplot:
    * `mod_boxplot_papo` was already deprecated and now it has been completely removed

# dv.explorer.parameter 0.1.8

* lineplot:
    * Enhanced line plot visibility for user selected subjects  

# dv.explorer.parameter 0.1.6

* All modules:
    * Accept character() input for subject, category and parameter data.frame columns.
    * Reduce `value_vars` default values to "AVAL".
    * Improved error message when parameter names reoccur across categories and new helper function to address that situation.
    * De-export label helpers to avoid symbol overwritting warning for app creators that load package through `library`.

* wfphm:
    * Waterfall group menu does no longer include `character` variables.

* lineplot:
    * Improved display of simultaneous reference values.

* boxplot:
    * `mod_boxplot_papo` is deprecated and `mod_boxplot` can be used in its place.
    * Data count table headers are now shown correctly.

# dv.explorer.parameter 0.1.1

* boxplot:
    * Provide a checkbox under the "Other" UI menu to log-project the Y axis.
* lineplot:
    * Warn app creators against non-finite values in numeric visits.

# dv.explorer.parameter 0.1.0

* boxplot, correlation heatmap, forest plot, roc, scatter plot, scatter plot matrix, waterfall plus heatmap:
    * Remove support for data dispatchers.
    * Provide early feedback of module misconfiguration.

# dv.explorer.parameter 0.0.14

* lineplot, boxplot:
    * Use dv.manager's switch2mod instead of deprecated switch2.

# dv.explorer.parameter 0.0.13

* lineplot, boxplot:
    * Make receiver_id accept module identifiers instead of labels.

# dv.explorer.parameter 0.0.12

* lineplot:
    * Prevent spurious reactive update.

# dv.explorer.parameter 0.0.11

* lineplot:
    * Per-column default visit values. Breaking change, as it changes the expected type of `default_visit_val`.
    * Fixes order of x-axis visit ticks for continuous variables.

# dv.explorer.parameter 0.0.10

* lineplot hotfix:
    * Prevent suspendWhenHidden of dynamic UI.

# dv.explorer.parameter 0.0.9

* lineplot:
    * Y axis log projection menu option.
    * New `cdisc_visit_vars` parameter that accounts for missing Study Day 0 in CDISC datasets.
    * New `default_transparency_value` parameter.
    * Remove support for data dispatchers in favor of dataset names.

# dv.explorer.parameter 0.0.8

* WFPHM:
    * Fixes the error in conditional panels that prevented conditional panels in other modules to work properly.

# dv.explorer.parameter 0.0.7

* Lineplot:
    * Fix overlap of plot and data listings.

# dv.explorer.parameter 0.0.6

* Lineplot:
    * Prevent false-positive opaque error message at module startup.

* Correlation heatmap:
    * Provide clear error message when handed records with identical subject IDs, category, parameter and visit values.

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
