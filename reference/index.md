# Package index

## Modules

- [`mod_boxplot()`](mod_boxplot.md) : Boxplot module
- [`corr_hm_UI()`](mod_corr_hm.md) [`mod_corr_hm()`](mod_corr_hm.md) :
  Correlation Heatmap module
- [`mod_forest()`](mod_forest.md) : Forest plot module
- [`mod_lineplot()`](mod_lineplot.md) : Line plot module
- [`mod_roc()`](mod_roc.md) : ROC module
- [`mod_scatterplot()`](mod_scatterplot.md) : Scatterplot module
- [`mod_scatterplotmatrix()`](mod_scatterplotmatrix.md) : Matrix of
  scatterplots module
- [`mod_wfphm()`](wfphm.md) : Waterfall heatmap shiny module

## Mock Applications

- [`mock_app_boxplot()`](mock_app_boxplot.md) : Mock boxplot app
- [`mock_app_boxplot_mm()`](mock_app_boxplot_mm.md) : Mock mm boxplot
  app
- [`mock_app_corr_hm()`](mock_app_corr_hm.md) : Mock corr hm app
- [`mock_app_correlation_hm_mm()`](mock_app_correlation_hm_mm.md) : Mock
  corr hm app
- [`mock_app_forest()`](mock_app_forest.md) : Mock forestplot app
- [`mock_app_lineplot()`](mock_app_lineplot.md) : Mock lineplot app
- [`mock_app_lineplot_mm_safetyData()`](mock_app_lineplot_mm_safetyData.md)
  : Mock module manager lineplot app displaying safetyData dataset
- [`mock_app_scatterplot()`](mock_app_scatterplot.md) : Mock scatterplot
  app
- [`mock_app_scatterplotmatrix()`](mock_app_scatterplotmatrix.md) : Mock
  matrix of scatterplots app
- [`mock_roc_mm_app()`](mock_roc.md) [`mock_roc_app()`](mock_roc.md) :
  Mock functions
- [`mock_wfphm_mm_app()`](mock_wfphm.md)
  [`mock_app_wfphm2()`](mock_wfphm.md)
  [`mock_app_hmcat()`](mock_wfphm.md)
  [`mock_app_hmcont()`](mock_wfphm.md)
  [`mock_app_hmpar()`](mock_wfphm.md) [`mock_app_wf()`](mock_wfphm.md)
  [`mock_app_wfphm()`](mock_wfphm.md) : Mock functions

## For developers

- [`boxplot_UI()`](boxplot_UI.md) : Boxplot UI function
- [`boxplot_server()`](boxplot_server.md) : Boxplot server function
- [`corr_hm_server()`](corr_hm_server.md) : Correlation heatmap server
  function
- [`forest_UI()`](forest_UI.md) : Forest plot UI function
- [`forest_server()`](forest_server.md) : Forest plot server function
- [`lineplot_UI()`](lineplot_UI.md) : Lineplot UI function
- [`lineplot_server()`](lineplot_server.md) : Lineplot server function
- [`corr_hm_UI()`](mod_corr_hm.md) [`mod_corr_hm()`](mod_corr_hm.md) :
  Correlation Heatmap module
- [`roc_UI()`](roc_UI.md) : ROC UI function
- [`roc_server()`](roc_server.md) : ROC server function
- [`scatterplot_UI()`](scatterplot_UI.md) : Scatter plot UI function
- [`scatterplot_server()`](scatterplot_server.md) : Scatter plot server
  function
- [`scatterplotmatrix_UI()`](scatterplotmatrix_UI.md) : Scatter plot
  matrix UI function
- [`scatterplotmatrix_server()`](scatterplotmatrix_server.md) : Scatter
  plot matrix server function
- [`wfphm_UI()`](wfphm_UI.md) : Waterfall plus heatmap UI function
- [`wfphm_hmcat_UI()`](wfphm_hmcat.md)
  [`wfphm_hmcat_server()`](wfphm_hmcat.md) : Categorical heatmap
  component of WFPHM
- [`wfphm_server()`](wfphm_server.md) : Waterfall plus heatmap server
  function
- [`wfphm_wf()`](wfphm_wf.md) [`wfphm_wf_UI()`](wfphm_wf.md) : Waterfall
  component of WFPHM
- [`wfphm_wf_server()`](wfphm_wf_server.md) : Waterfall server function

## Additional Documentation

### Lineplot

- [`lp_mean_summary_fns`](default_lineplot_functions.md)
  [`lp_median_summary_fns`](default_lineplot_functions.md) : Default
  lineplot summary functions

### Forest plot

- [`pearson_correlation()`](fp_stats.md)
  [`spearman_correlation()`](fp_stats.md) [`odds_ratio()`](fp_stats.md)
  : Forest plot comnputing functions

### Waterfall Plus Heatmap

- [`tr_identity()`](transformation.md)
  [`tr_z_score()`](transformation.md) [`tr_gini()`](transformation.md)
  [`tr_trunc_z_score()`](transformation.md)
  [`tr_trunc_z_score_3_3()`](transformation.md)
  [`tr_min_max()`](transformation.md)
  [`tr_percentize()`](transformation.md) : Transformation functions

### ROC

- [`assert_compute_metric_data()`](compute_metric.md)
  [`compute_metric_data()`](compute_metric.md) : Helpers for computing
  metric data from the subset dataset
- [`assert_compute_roc_data()`](compute_roc.md)
  [`compute_roc_data()`](compute_roc.md) : Helpers for computing ROC
  data from the subset dataset

### Miscellaneous

- [`prefix_repeat_parameters()`](prefix_repeat_parameters.md) : Prefix
  Repeat Parameters
