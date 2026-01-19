# nolint start
specs <- list(
    boxplot_module = list(
    composition = "
    is composed of:
        * Boxplot Chart
        * Data Listing:
            * Single Listing
            * Group Listing
        * Data Count
        * Data Summary
        * Data Significance
    ",
    boxplot_chart = "
    The chart shall display one boxplot for each selected parameter and grouping variable.
    ",
    data_listing = "
    The data listing shall contain a table containing the subjects of a given group.
    ",
    single_listing = "
    The single listing shall contain a table containing the details of a clicked subject.
    ",
    data_count = "
    The data count shall contain a table containing the count of subjects per parameter and grouping variable.
    ",
    data_summary = "
    The data summary shall contain a table containing summary statistics per parameter and grouping variable.
    ",
    data_significance = "
    The data significance shall contain a table containing statistical comparisons per parameter and grouping variable.
    ",
    bookmark = "
    The application shall support bookmarking. Boxplot selection by click and double click are explicitly excluded.
    ",
    jumping_feature = "
    The module can communicate subject values to other modules.
    "
),

corr_hm_module = list(
    composition = "
    is composed of:
        * Correlation Heatmap Chart
        * Scatter plot
    ",
    correlation_chart = "
    The chart shall display a correlation heatmap for a given selection.
    ",
    scatter_chart = "
    The scatter shall display a scatter plot of the clicked
    ",
    bookmark = "
    The application shall support bookmarking. Clicks and brush are explicitely excluded.
    "
),

forest_module = list(
    composition = "
    is composed of:
        * Correlation Table
        * Forest Plot
    ",
    table = "
    The table shall display a correlation table for a given selection.
    ",
    forest_plot = "
    The chart shall display a forest plot for a given selection.
    ",
    bookmark = "
    The application shall support bookmarking. Clicks and brush are explicitely excluded.
    "
),

lineplot_module = list(
    composition = "
    is composed of:
        * Lineplot Chart
        * Subject-level Listing
        * Summary Listing
        * Data Count
    ",
    lineplot_chart = "
    The chart shall display one lineplot for each selected parameter.
    ",
    grouping = "
    The module shall allow data grouping.
    ",
    summarizing = "
    The chart shall summarize data using centrality and dispersion measures.
    ",
    subject_level_listing = "
    The data listing shall contain a table containing the details of selected subjects.
    ",
    summary_listing = "
    The data listing shall contain a table containing centrality and dispersion measurements when that option is selected.
    ",
    data_count = "
    The data count shall contain a table containing the count of subjects per parameter and grouping variable.
    ",
    bookmark = "
    The application shall support bookmarking. Clicks and brush are explicitely excluded.
    ",
    reference_values = "
    The chart optionally displays reference values as horizontal lines. Those are provided as separate columns of the visit-dependent dataset.
    ",
    jumping_feature = "
    The module can communicate subject values to other modules.
    "
),

scatterplot_matrix_module = list(
    composition = "
    is composed of:
        * Scatterplot Matrix
    ",
    scatterplot_matrix_chart = "
    The chart shall display a scatterplot matrix for the selected parameters.
    ",
    bookmark = "
    The application shall support bookmarking. Clicks and brush are explicitely excluded.
    "
),

scatterplot_plot_module = list(
    composition = "
    is composed of:
        * Scatterplot Plot
        * Data Listing
        * Correlation and Regression Table
    ",
    scatterplot_chart = "
    The chart shall display a scatterplot of two selected parameters with the option to group the values.
    ",
    data_listing = "
    The data listing shall contain a table containing the details of selected subjects.
    ",
    cor_reg_table = "
    The table shall contain summary statistics of the relation between the selected parameters.
    ",
    bookmark = "
    The application shall support bookmarking. Clicks and brush are explicitely excluded.
    "
)
)


# wfphm ----
wfphm <- list(
        composition = "
            is composed by four submodules:
                * waterfall Module
                * categorical Heatmap
                * continuous Heatmap
                * parameter Heatmap
            ",
        x_sorted = "
            all submodules share the same x-axis order defined by waterfall and they are vertically-aligned
            ",
        non_gxp_notification = "
            this module shall show a notification that it is a nonGxP module
        ",
        chart_download = "
            this module shall allow downloading the created charts
        "
)

# wf ----
wf <- list(
        height_selection = list(
                numeric = "
            the user shall be able to choose any numerical column as values to be plotted.
            ",
                parameter = "
            the input dataset may contain parameters stored vertically as described in: https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192.
            these parameters shall be chooseable to be plotted
            the module shall allow selecting:
                * one parameter category from the dataset set of categories stored in PARCAT
                * one parameter from those parameters belonging to the selected category
                * one of the column from the set of columns that contains values for the selected parameter
                * one of the visits from the VISIT columns
            "
        ),
        grouping_selection = "
            any categorical column shall be chooseable for grouping
            ",
        plot = "
            shall contain a bar plot
            ",
        plot_x_axis = "
            x axis shall represent subjects
            ",
        plot_x_axis_sorted = "
            the x axis shall be sorted in descending order
            ",
        plot_y_axis = "
            the y axis/bar's heigth shall represent the selected height value for each subject
            ",
        plot_y_axis_label = "
        when a parameter is used the label must indicate which value column is being used
        ",
        plot_bar_color = "
            each bar shall be colored according to the grouping value of the corresponding subject
            bars with the same grouping value shall have the same color
            bars with different grouping values are not guaranteed to have different colors
            ",
        plot_bar_label = "
            each bar shall be labelled according to the grouping value of the corresponding subject
            ",
        outliers = "
            the module allows inputing a maximum and minimum value
            the plot bars with height values above the maximum or below the minimum shall be marked as outliers
            ",
        only_one_height_value = "
            the module shall show an error when there is more than one height value per subject to be plotted
            ",
        only_one_grouping_value = "
            the module shall show an error when there is more than grouping value per subject to be plotted
            ",
        custom_palette = "
            the module allows applying a custom palette for group coloring
        "
)

# hmcat ----
hmcat <- list(
        value_selection = "
            the module shall allow selecting one or several categorical columns to be plotted
            ",
        plot = "
            shall contain a heatmap
            ",
        plot_x_axis = "
            x_axis shall represent subjects
            ",
        plot_x_axis_sorted = "
            x_axis shall have the same order as the waterfall plot
            ",
        plot_y_axis = "
            y_axis shall represent the different selected categorical columns
            ",
        plot_tile_color = "
            each tile shall be colored according to the categorical value of the corresponding subject and column
            tiles with the same categorical value shall have the same color
            tiles with different categorical values are not guaranteed to have different colors
            ",
        plot_tile_label = "
            each tile shall be labelled according to the categorical value of the corresponding subject and column
            ",
        only_one_value = "
            the module shall show an error when there is more than one different value per subject and selected categorical column combination
            "
)

# hmcont ----
hmcont <- list(
        value_selection = "
            the module shall allow selecting one or several numerical columns to be plotted
            ",
        plot = "
            shall contain a heatmap
            ",
        plot_x_axis = "
            x_axis shall represent subjects
            ",
        plot_x_axis_sorted = "
            x_axis shall have the same order as the waterfall plot
            ",
        plot_y_axis = "
            y_axis shall represent the different selected numerical columns
            ",
        plot_tile_label = "
            each tile shall be labelled according to the numerical value of the corresponding subject and column
            ",
        only_one_value = "
            the module shall show an error when there is more than one different value per subject and selected numerical column combination
            "
)

# hmpar ----
hmpar <- list(
        value_selection = "
            the input dataset may contain parameters stored vertically as described in: https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192.
            these parameters shall be chooseable to be plotted
            the module shall allow selecting:
                * one/several parameter categories from the dataset set of categories stored in PARCAT
                * one/several parameters from those parameters belonging to the selected categories
                * one of the column from the set of columns that may represent a value for the selected parameter
                * one of the visits from the VISIT columns
                * a data transformation from a set of predefined data transformations
            ",
        plot = "
            shall contain a heatmap
            ",
        plot_x_axis = "
            x_axis shall represent subjects
            ",
        plot_x_axis_sorted = "
            x_axis shall have the same order as the waterfall plot
            ",
        plot_y_axis = "
            y_axis shall represent the different selected parameters
            ",
        plot_transformation = "
            a transformation can be applied to heatmap values (e.g. z-score)
        ",
        plot_tile_color = "
            each tile shall be colored according to the numerical value of the corresponding subject and parameter
            ",
        plot_tile_label = "
            each tile shall be labelled according to the numerical value of the corresponding subject and parameter
            ",
        outliers = "
            the module allows inputing a maximum and minimum value for each selected parameter
            the plot tiles with values above the maximum or below the minimum for the that parameter shall be marked as outliers
            ",
        only_one_value = "
            the module shall show an error when there is more than one value per subject and selected parameter combination to be plotted
            ",
        plot_x_axis_ticks = "
            the module shall allow the user to hide the x axis ticks
            "
)

# roc_module ----
roc_module <- list(
        composition = "
            is composed by seven charts:
                * ROC curve
                * Histogram
                * Density
                * Raincloud
                * Metrics
                * Exploration
                * Summary
            ",
        selection = list(
            predictor = "
            from the predictor dataset:
                - the user shall be able to choose N parameters as predictors
                - the user shall be able to choose a single numerical column containing the value of the parameter
                - the user shall be able to choose a single value from the visit column
                "
            ,
            response = "
             from the response dataset:
                - the user shall be able to choose a single parameter as predictors
                - the user shall be able to choose a single numerical column containing the value of the parameter
                - the user shall be able to choose a single value from the visit column
                "
            ,
            grouping = "
            from the grouping dataset:
                - the user shall be able to choose a single categorical column for grouping
            "
            ),
        outputs = list(
            roc_curve = list(
                facets = "
                the plot shall be facetted by parameters and groups
                the rows and columns in the facets shall have the option to be swapped
                ",
                axis = "
                the x axis shall represent 1-Specificity
                the y axis shall represent Sensitivity
                both axis limits shall be 0 and 1
                ",
                plot = "
                the plot shall contain a line plot
                the plot shall contain a point plot
                the plot shall represent a ROC curve
                the plot shall represent the direction of the comparison and the levels used
                ",
                optimal_cut = "
                the plot shall represent optimal cut points
                each optimal cut point shall inform of the threshold sensitivity and specificity at the point. CI of sensitivity and specifity is included
                ",
                CI ="
                the plot shall, optionally, represent the CI for the specificity and sensitivity at user-defined points
                "
            ),
            histogram = list(
                facets = "
                the plot shall be facetted by parameters and groups
                the rows and columns in the facets shall have the option to be swapped
                ",
                axis = "
                the x axis shall represent the binned response parameter value
                the y axis shall represent the counting
                x-axis limits shall be shared within the same parameter
                bars shall be colored according to the value of the response parameter
                ",
                plot = "
                the plot shall contain a histogram
                "
            ),
            density = list(
                facets = "
                the plot shall be facetted by parameters and groups
                the rows and columns in the facets shall have the option to be swapped
                ",
                axis = "
                the x axis shall represent the response parameter value
                the y axis shall represent the probability density
                x-axis limits shall be shared within the same parameter
                areas shall be colored according to the value of the response parameter
                ",
                plot = "
                the plot shall contain a probability density histogram
                "
            ),
            raincloud = list(
                facets = "
                the plot shall be facetted by parameters and groups
                the rows and columns in the facets shall have the option to be swapped
                ",
                axis = "
                the x axis shall represent the response parameter value
                the y axis shall represent the value of the response parameter
                x-axis limits shall be shared within the same parameter
                elements shall be colored according to the value of the response parameter
                ",
                plot = "
                the plot shall contain:
                  - a probability density
                  - raw data points
                  - a set of markers for the .05,.25,.5,.75 and .95 quantiles
                  - the mean
                "
            ),
            metrics = list(
                facets = "
                the plot shall be facetted by parameters and metrics
                the rows and columns in the facets shall have the option to be swapped
                ",
                axis = "
                the x axis shall represent the response parameter value, normalized parameter value or normalized paremeter value based on the user selection
                the y axis shall represent the value of the metric
                x-axis limits shall be shared within the same parameter
                y-axis limits shall be shared across metrics
                elements shall be colored according to the value of the grouping
                ",
                plot = "
                the plot shall contain a line plot
                the plot shall contain a point plot
                "
            ),
            explore_auc = list(
                axis = "
                the x axis shall represent the AUC
                the y axis shall represent the value of the parameter or pameter-group combination
                elements shall be colored according to the value of the grouping
                ",
                plot = "
                the plot shall contain a point plot
                a set of markers indicating the CI of the AUC
                "
            ),
            summary = "
            the summary must contain for each parameter and group:
              - the AUC and its CI
              - each optimal cut point shall with the threshold,sensitivity and specificity at the point. CI of sensitivity and specifity is included
              - summary shall be sortable by parameter name and AUC value
            ",
            info_panel = "
            an information panel shall indicate the response values used in the ROC curve
            "
        ),
        bookmark = "The module shall allow bookmarking"
)

# common_logic ----
common_logic <- list(
  anlfl_col_data_filtering = "
        The function shall subset a biomarker dataset using the provided category, parameter, visit, and subject selections as well as the specified analysis flag column.
        Only rows with a value of 'Y' in the analysis flag column are retained.
    "
)

specs[["common_logic"]] <- common_logic

# specs ----
specs[["wfphm"]] <- list(
        wfphm = wfphm,
        wf = wf,
        hmcat = hmcat,
        hmcont = hmcont,
        hmpar = hmpar
)

specs[["roc"]] <- roc_module

specs



# nolint end
