# Constants

poc <- pack_of_constants

# nocov start
# dv.explorer.parameter

# IDs

ROC_ID <- poc(
  ROC = poc(
    PRED_PAR = "pred_par",
    PRED_VALUE = "pred_value",
    RESP_PAR = "resp_par",
    RESP_VALUE = "resp_value",
    GROUP = "group",
    PRED_VISIT = "pred_visit",
    RESP_VISIT = "resp_visit",
    CI_SPEC_POINTS = "ci_spec_points",
    CI_THR_POINTS = "ci_raw_points",
    CHART = "chart",
    VEGA_ROC_PLOT = "vega_roc_plot",
    HISTO_PLOT = "histo_plot",
    VEGA_HISTO_PLOT = "vega_histo_plot",
    DENSITY_PLOT = "density_plot",
    VEGA_DENSITY_PLOT = "vega_density_plot",
    PRED_BUTTON = "pred_button",
    RESP_BUTTON = "resp_button",
    OTHER_BUTTON = "other_button",
    INFO_PANEL = "info_panel",
    INVERT_ROW_COL = "invert_row_col",
    FIG_SIZE = "fig_size",
    SORT_AUC = "sort_auc",
    X_COL_METRICS = "x_col_metrics",
    SUMMARY_TABLE = "summary_stat",
    METRICS_PLOT = "metrics_plot",
    RAINCLOUD_PLOT = "raincloud_plot",
    GT_SUMMARY_TABLE = "gt_summary_table",
    GT_SUMMARY_TABLE_ALPH = "gt_summary_table_alph",
    VEGA_EXPLORE_ROC_PLOT = "explore_roc_plot",
    VEGA_EXPLORE_ROC_ALPH = "explore_roc_alph"
  )
)

# Values

ROC_VAL <- poc(
  RANDOM_SEED = 123,
  NO_GROUP_VAL = "None",
  MAX_ROWS_EXPLORE = 1000,
  CI_SPEC_DEFAULT = ".25;.50;.75",
  CI_THR_DEFAULT = ""
)

# Messages and labels

ROC_MSG <- poc(
  ROC = poc(
    LABEL = poc(
      GROUP = "Grouping",
      VISIT = "Visit",
      OTHER_BUTTON = "Other",
      PRED_PAR = c("Category", "Parameter"),
      PRED_VALUE = "Value",
      PRED_BUTTON = "Predictor",
      RESP_PAR = c("Category", "Parameter"),
      RESP_VALUE = "Value",
      RESP_BUTTON = "Response",
      RESP_VAL = c("Response Value"),
      CI_SPEC_POINTS = "Specificity",
      CI_THR_POINTS = "Threshold",
      INVERT_ROW_COL = htmltools::HTML("Row&DoubleLeftRightArrow;Col"),
      FIG_SIZE = "Figure size (px)",
      SORT_AUC = "Sort",
      X_COL_METRICS = "Select Metrics X axis",
      GT_SUMMARY_TABLE_ALPH = "Sort summary alphabetically",
      VEGA_EXPLORE_ROC_ALPH = "Sort explore alphabetically"
    ),
    VALIDATE = poc(
      NO_PRED_CAT_SEL = "(Predictor) Select a category",
      NO_PRED_PAR_SEL = "(Predictor) Select a parameter",
      NO_PRED_VALUE_SEL = "(Predictor) Value selection does not exist",
      UKNOWN_PRED_VALUE_SEL = "(Predictor) Select a value",
      NO_RESP_CAT_SEL = "(Response) Select a category",
      NO_RESP_PAR_SEL = "(Response) Select a parameter",
      NO_RESP_VALUE_SEL = "(Response) Select a value",
      UKNOWN_RESP_VALUE_SEL = "(Response) Value selection does not exist",
      NO_VISIT_SEL = "Select a visit",
      NO_GROUP_SEL = "Select a group",
      PRED_TOO_MANY_ROWS = "(Predictor) The selection returns more than 1 row per subject and cannot be plotted",
      RESP_TOO_MANY_ROWS = "(Response) The selection returns more than 1 row per subject and cannot be plotted",
      GROUP_TOO_MANY_ROWS = "(Group) The selection returns more than 1 row per subject and cannot be plotted",
      GROUP_COL_REPEATED = "(Group) Selected group is already a column in resp or pred datasets",
      NOT_INVARIANT_N_SBJ = "The number of subjects differ between datasets",
      NO_ROWS = "Current selection returns 0 rows",
      NON_POS_SIZE = "Figure size must be positive",
      X_COL_METRICS_NOT_IN_DS = "The selected column for the metrics X axis does not exist in the metrics dataset",
      N_SUBJECT_EMPTY_RESPONSES = function(x) {
        paste(x, "subjects with empty responses!")
      },
      MUST_BE_BINARY_ENDPOINT = function(x) {
        paste(
          "The current selection has a non-binary response. It contains the following different values: ",
          paste(x, collapse = "; ")
        )
      },
      TOO_MANY_ROWS_EXPLORE = glue::glue("Cannot present more than {ROC_VAL$MAX_ROWS_EXPLORE} parameters.
      Please use a smaller dataset")
    )
  )
)

ROC_PLOT_VAL <- poc(
  STR_FMT = poc(
    TWO_DEC = ".2f"
  ),
  ROC = poc(
    LABELS = poc(
      X_AXIS = "1 - Specificity",
      Y_AXIS = "Sensitivity",
      PRED_TOOLTIP = "Predictor",
      RESP_TOOLTIP = "Response",
      AUC_TOOLTIP = "AUC",
      SENS_TOOLTIP = "Sensitivity",
      SPEC_TOOLTIP = "Specificity",
      THR_TOOLTIP = "Threshold",
      DIR_TOOLTIP = "Direction",
      TITLE_CI_TOOLTIP = "95% CI",
      OC_TITLE = "Optimal Cut"
    )
  ),
  RAINCLOUD = poc(
    LABELS = poc(
      SBJ_TOOLTIP = "Subject ID",
      PPAR_TOOLTIP = "Predictor",
      PVAL_TOOLTIP = "Predictor Value",
      RVAL_TOOLTIP = "Response Value",
      RESP_TOOLTIP = "Response"
    )
  )
)

# nocov end


# UI and server functions

#' ROC module
#'
#' @inheritParams roc_server
#'
#' @name mod_roc
#'
#' @keywords main
#'
NULL

#' ROC UI function
#' @keywords developers
#' @inheritParams roc_server
#' @export
roc_UI <- function(id) {
  # id assert  It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  # argument asserts

  # UI
  ns <- shiny::NS(id)

  drop_menu_helper <- function(id, label, ...) {
    shiny::tagAppendAttributes(
      shinyWidgets::dropMenu(
        shiny::actionButton(id, label),
        ...,
        arrow = TRUE
      ),
      style = "display:inline"
    )
  }

  # Menu

  roc_menu <- shiny::tagList(
    drop_menu_helper(
      ns(ROC_ID$ROC$PRED_BUTTON), ROC_MSG$ROC$LABEL$PRED_BUTTON,
      parameter_UI(id = ns(ROC_ID$ROC$PRED_PAR)),
      col_menu_UI(ns(ROC_ID$ROC$PRED_VALUE)),
      val_menu_UI(id = ns(ROC_ID$ROC$PRED_VISIT))
    ),
    drop_menu_helper(
      ns(ROC_ID$ROC$RESP_BUTTON), ROC_MSG$ROC$LABEL$RESP_BUTTON,
      parameter_UI(id = ns(ROC_ID$ROC$RESP_PAR)),
      col_menu_UI(ns(ROC_ID$ROC$RESP_VALUE)),
      val_menu_UI(id = ns(ROC_ID$ROC$RESP_VISIT))
    ),
    drop_menu_helper(
      ns(ROC_ID$ROC$OTHER_BUTTON),
      ROC_MSG$ROC$LABEL$OTHER_BUTTON,
      col_menu_UI(id = ns(ROC_ID$ROC$GROUP)),
      shiny::checkboxInput(
        inputId = ns(ROC_ID$ROC$INVERT_ROW_COL),
        label = ROC_MSG$ROC$LABEL$INVERT_ROW_COL,
        value = FALSE
      ),
      shiny::checkboxInput(
        inputId = ns(ROC_ID$ROC$SORT_AUC),
        label = ROC_MSG$ROC$LABEL$SORT_AUC,
        value = FALSE
      ),
      shiny::tags[["hr"]](),
      shiny::textInput(
        inputId = ns(ROC_ID$ROC$CI_SPEC_POINTS),
        label = ROC_MSG$ROC$LABEL$CI_SPEC_POINTS,
        value = ROC_VAL$CI_SPEC_DEFAULT
      ),
      shiny::textInput(
        inputId = ns(ROC_ID$ROC$CI_THR_POINTS),
        label = ROC_MSG$ROC$LABEL$CI_THR_POINTS,
        value = ROC_VAL$CI_THR_DEFAULT
      ),
      shiny::tags[["hr"]](),
      shiny::selectInput(
        ns(ROC_ID$ROC$X_COL_METRICS),
        label = ROC_MSG$ROC$LABEL$X_COL_METRICS,
        choices = list(
          "Normalized Rank" = "norm_rank",
          "Normalized Score" = "norm_score",
          "Score" = "score"
        )
      ),
      shiny::tags[["hr"]](),
      shiny::checkboxInput(
        inputId = ns(ROC_ID$ROC$GT_SUMMARY_TABLE_ALPH),
        label = ROC_MSG$ROC$LABEL$GT_SUMMARY_TABLE_ALPH,
        value = FALSE
      ),
      shiny::tags[["hr"]](),
      shiny::checkboxInput(
        inputId = ns(ROC_ID$ROC$VEGA_EXPLORE_ROC_ALPH),
        label = ROC_MSG$ROC$LABEL$VEGA_EXPLORE_ROC_ALPH,
        value = FALSE
      ),
      shiny::tags[["hr"]](),
      shiny::textInput(
        inputId = ns(ROC_ID$ROC$FIG_SIZE),
        label = ROC_MSG$ROC$LABEL$FIG_SIZE,
        value = "200"
      )
    )
  )

  # Info panel
  info_panel <- shiny::fluidRow(
    shiny::column(
      width = 3,
      shiny::div(
        shiny::div(shiny::uiOutput(ns(ROC_ID$ROC$INFO_PANEL)), class = "panel-body"),
        class = "panel panel-default"
      )
    )
  )

  # Tabs

  tabs <- shiny::div(shiny::tabsetPanel(
    id = ns("chart_panel"),
    header = shiny::div(
      style = "min-height: 20px"
    ), # Used as separator
    shiny::tabPanel(
      "ROC",
      shiny::div(
        style = "min-height: 50px",
        shiny::column(
          vegawidget_hack_output(ns(ROC_ID$ROC$VEGA_ROC_PLOT)),
          width = 12,
          align = "center"
        )
      )
    ),
    shiny::tabPanel(
      "Histogram",
      shiny::div(
        style = "min-height: 50px",
        shiny::column(
          vegawidget_hack_output(ns(ROC_ID$ROC$VEGA_HISTO_PLOT), width = "auto", height = "auto"),
          width = 12,
          align = "center"
        )
      )
    ),
    shiny::tabPanel(
      "Density",
      shiny::div(
        style = "min-height: 50px",
        shiny::column(
          vegawidget_hack_output(ns(ROC_ID$ROC$VEGA_DENSITY_PLOT), width = "auto", height = "auto"),
          width = 12,
          align = "center"
        )
      )
    ),
    shiny::tabPanel(
      "Raincloud",
      shiny::div(
        style = "min-height: 50px",
        shiny::column(
          vegawidget_hack_output(ns(ROC_ID$ROC$RAINCLOUD_PLOT), width = "auto", height = "auto"),
          width = 12,
          align = "center"
        )
      )
    ),
    shiny::tabPanel(
      "Metrics",
      shiny::div(
        style = "min-height: 50px",
        shiny::column(
          vegawidget_hack_output(ns(ROC_ID$ROC$METRICS_PLOT), width = "auto", height = "auto"),
          width = 12,
          align = "center"
        )
      )
    ),
    shiny::tabPanel(
      "Explore ROC",
      shiny::div(
        style = "min-height: 50px",
        shiny::column(
          vegawidget_hack_output(ns(ROC_ID$ROC$VEGA_EXPLORE_ROC_PLOT)),
          width = 12,
          align = "center"
        )
      )
    ),
    shiny::tabPanel(
      "Summary",
      gt::gt_output((ns(ROC_ID$ROC$GT_SUMMARY_TABLE)))
    )
  ))

  # main_ui

  main_ui <- shiny::tagList(
    roc_dependencies(),
    shiny::div(roc_menu, class = "roc_menu_bar"),
    info_panel,
    tabs
  )

  if (..__is_db()) {
    ..__db_UI(ns("debug"), main_ui) # Debugging
  } else {
    main_ui
  }
}

#' ROC server function
#' @keywords developers
#' @description
#'
#' ## Input dataframes:
#'
#' ### pred_dataset
#'
#' It expects a dataset similar to
#' https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192 ,
#' 1 record per subject per parameter per analysis visit
#'
#' It expects, at least, the columns passed in the parameters, `subjid_var`, `pred_cat_var`, `pred_par_var`,
#' `pred_visit_var` and `pred_value_var`. The values of these variables are as described
#' in the CDISC standard for the variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.
#'
#' ### resp_dataset
#'
#' It expects a dataset similar to
#' https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192
#'
#' It expects, at least, the columns passed in the parameters, `subjid_var`, `resp_cat_var`,
#' `resp_par_var`, `resp_visit_var` and `resp_value_var`.
#' The values of these variables are as described
#' in the CDISC standard for the variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.
#'
#' ### group_dataset
#'
#' It expects a dataset with an structure similar to
#' https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806 ,
#' one record per subject
#'
#' It expects to contain, at least, `subjid_var`
#' @param id Shiny ID `[character(1)]`
#'
#' @param pred_dataset,resp_dataset,group_dataset `[data.frame()]`
#'
#' Dataframes as described in the `Input dataframes` section
#'
#' @param dataset_name `[shiny::reactive(*)]`
#'
#' a reactive indicating when the dataset has possibly changed its columns
#'
#' @param pred_cat_var,pred_par_var,pred_visit_var,resp_cat_var,resp_par_var,resp_visit_var `[character(1)]`
#'
#' Columns from `pred_dataset`/`resp_dataset` that correspond to the parameter category, parameter and visit
#'
#' @param pred_value_vars,resp_value_vars `[character(n)]`
#'
#' Columns from `pred_dataset`,`resp_dataset` that correspond to values of the parameters
#'
#' @param subjid_var `[character(1)]`
#'
#' Column corresponding to subject ID
#'
#' @param compute_roc_fn,compute_metric_fn `[function()]`
#'
#' Functions used to compute the ROC and metric analysis, please view the corresponding vignette for more details.
#'
#' @export
#'
roc_server <- function(id,
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
                       compute_metric_fn = compute_metric_data) {
  ac <- checkmate::makeAssertCollection()
  # id assert  It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1, add = ac)
  # non reactive asserts
  ###### Check types of reactive variables, pred_dataset, ...
  checkmate::assert_string(pred_cat_var, min.chars = 1, add = ac)
  checkmate::assert_string(pred_par_var, min.chars = 1, add = ac)
  checkmate::assert_character(
    pred_value_vars,
    min.chars = 1, any.missing = FALSE,
    all.missing = FALSE, unique = TRUE, min.len = 1, add = ac
  )
  checkmate::assert_string(pred_visit_var, min.chars = 1, add = ac)
  checkmate::assert_string(resp_cat_var, min.chars = 1, add = ac)
  checkmate::assert_string(resp_par_var, min.chars = 1, add = ac)
  checkmate::assert_character(
    resp_value_vars,
    min.chars = 1, any.missing = FALSE, all.missing = FALSE, unique = TRUE, min.len = 1, add = ac
  )
  checkmate::assert_string(subjid_var, min.chars = 1, add = ac)
  checkmate::assert_function(
    compute_roc_fn,
    args = c("predictor", "response", "do_bootstrap", "ci_points"), nargs = 4, add = ac
  )
  checkmate::assert_function(compute_metric_fn, args = c("predictor", "response"), nargs = 2, ordered = TRUE, add = ac)
  checkmate::reportAssertions(ac)

  # module constants
  VAR <- poc( # Parameters from the function that will be considered constant across the function
    PRED = poc(
      CAT = pred_cat_var,
      PAR = pred_par_var,
      VAL = pred_value_vars,
      VIS = pred_visit_var
    ),
    RESP = poc(
      CAT = resp_cat_var,
      PAR = resp_par_var,
      VAL = resp_value_vars,
      VIS = resp_visit_var
    ),
    SBJ = subjid_var
  )

  module <- function(input, output, session) {
    # sessions
    ns <- session[["ns"]]

    # paste ctxt
    paste_ctxt <- paste_ctxt_factory(ns(""))

    # argument asserts

    # dataset validation

    v_group_dataset <- shiny::reactive(
      {
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_data_frame(group_dataset(), min.rows = 1, .var.name = paste_ctxt(group_dataset))
        checkmate::assert_names(
          names(group_dataset()),
          type = "unique",
          must.include = c(VAR$SBJ), .var.name = paste_ctxt(group_dataset)
        )
        checkmate::assert_factor(group_dataset()[[VAR$SBJ]], add = ac, .var.name = paste_ctxt(group_dataset))
        checkmate::reportAssertions(ac)
        group_dataset()
      },
      label = ns(" v_group_dataset")
    )

    v_resp_dataset <- shiny::reactive(
      {
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_data_frame(resp_dataset(), min.rows = 1, .var.name = paste_ctxt(resp_dataset))
        checkmate::assert_names(
          names(resp_dataset()),
          type = "unique",
          must.include = c(
            VAR$RESP$CAT, VAR$RESP$PAR, VAR$SBJ, VAR$RESP$VIS, VAR$RESP$VAL
          ),
          .var.name = paste_ctxt(resp_dataset)
        )
        unique_par_names <- resp_dataset() |>
          dplyr::distinct(dplyr::across(c(VAR$RESP$CAT, VAR$RESP$PAR))) |>
          dplyr::group_by(dplyr::across(c(VAR$RESP$PAR))) |>
          dplyr::tally() |>
          dplyr::pull(.data[["n"]]) |>
          max() |>
          (function(x) x == 1)()

        checkmate::assert_true(unique_par_names, .var.name = paste_ctxt(resp_dataset))
        checkmate::assert_factor(resp_dataset()[[VAR$SBJ]], add = ac, .var.name = paste_ctxt(resp_dataset))
        checkmate::reportAssertions(ac)
        resp_dataset()
      },
      label = ns("v_resp_dataset")
    )

    v_pred_dataset <- shiny::reactive(
      {
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_data_frame(pred_dataset(), min.rows = 1, .var.name = paste_ctxt(pred_dataset))
        checkmate::assert_names(
          names(pred_dataset()),
          type = "unique",
          must.include = c(VAR$PRED$CAT, VAR$PRED$PAR, VAR$SBJ, VAR$PRED$VIS), .var.name = paste_ctxt(pred_dataset)
        )
        unique_par_names <- pred_dataset() |>
          dplyr::distinct(dplyr::across(c(VAR$PRED$CAT, VAR$PRED$PAR))) |>
          dplyr::group_by(dplyr::across(c(VAR$PRED$PAR))) |>
          dplyr::tally() |>
          dplyr::pull(.data[["n"]]) |>
          max() |>
          (function(x) x == 1)()
        checkmate::assert_true(unique_par_names, .var.name = paste_ctxt(pred_dataset))
        checkmate::assert_factor(pred_dataset()[[VAR$SBJ]], add = ac, .var.name = paste_ctxt(pred_dataset))
        checkmate::reportAssertions(ac)
        pred_dataset()
      },
      label = ns("v_pred_dataset")
    )

    # input

    input_roc <- list()
    input_roc[[ROC_ID$ROC$GROUP]] <- col_menu_server(
      id = ROC_ID$ROC$GROUP, data = v_group_dataset,
      label = ROC_MSG$ROC$LABEL$GROUP,
      include_func = function(x) {
        is.factor(x) || is.character(x)
      }
    )

    input_roc[[ROC_ID$ROC$PRED_PAR]] <- parameter_server(
      id = ROC_ID$ROC$PRED_PAR,
      data = v_pred_dataset,
      cat_var = VAR$PRED$CAT,
      par_var = VAR$PRED$PAR
    )

    input_roc[[ROC_ID$ROC$RESP_PAR]] <- parameter_server(
      id = ROC_ID$ROC$RESP_PAR,
      data = v_resp_dataset,
      cat_var = VAR$RESP$CAT,
      par_var = VAR$RESP$PAR,
      multi_cat = FALSE,
      multi_par = FALSE
    )

    input_roc[[ROC_ID$ROC$PRED_VISIT]] <- val_menu_server(
      id = ROC_ID$ROC$PRED_VISIT,
      label = ROC_MSG$ROC$LABEL$VISIT,
      data = v_pred_dataset,
      var = VAR$PRED$VIS
    )

    input_roc[[ROC_ID$ROC$RESP_VISIT]] <- val_menu_server(
      id = ROC_ID$ROC$RESP_VISIT,
      label = ROC_MSG$ROC$LABEL$VISIT,
      data = v_resp_dataset,
      var = VAR$RESP$VIS
    )

    input_roc[[ROC_ID$ROC$PRED_VALUE]] <- col_menu_server(
      id = ROC_ID$ROC$PRED_VALUE,
      data = v_pred_dataset,
      label = ROC_MSG$ROC$LABEL$PRED_VALUE,
      include_func = function(val, name) {
        name %in% VAR$PRED$VAL
      }, include_none = FALSE
    )

    input_roc[[ROC_ID$ROC$RESP_VALUE]] <- col_menu_server(
      id = ROC_ID$ROC$RESP_VALUE,
      data = v_resp_dataset,
      label = ROC_MSG$ROC$LABEL$RESP_VALUE,
      include_func = function(val, name) {
        name %in% VAR$RESP$VAL
      }, include_none = FALSE
    )

    # input validation

    v_input_subset <- shiny::reactive(
      {
        shiny::validate(
          shiny::need(
            checkmate::test_string(input_roc[[ROC_ID$ROC$PRED_VALUE]](), min.chars = 1),
            ROC_MSG$ROC$VALIDATE$NO_PRED_VALUE_SEL
          ),
          shiny::need(
            isTRUE(input_roc[[ROC_ID$ROC$PRED_VALUE]]() %in% names(v_pred_dataset())),
            paste(input_roc[[ROC_ID$ROC$PRED_VALUE]](), ROC_MSG$ROC$VALIDATE$UKNOWN_PRED_VALUE_SEL)
          ),
          shiny::need(
            checkmate::test_string(input_roc[[ROC_ID$ROC$RESP_VALUE]](), min.chars = 1),
            ROC_MSG$ROC$VALIDATE$NO_RESP_VALUE_SEL
          ),
          shiny::need(
            isTRUE(input_roc[[ROC_ID$ROC$RESP_VALUE]]() %in% names(v_resp_dataset())),
            paste(input_roc[[ROC_ID$ROC$RESP_VALUE]](), ROC_MSG$ROC$VALIDATE$UKNOWN_RESP_VALUE_SEL)
          ),
          shiny::need(
            checkmate::test_character(
              input_roc[[ROC_ID$ROC$PRED_PAR]][["par"]](),
              min.len = 1, any.missing = FALSE, unique = TRUE, min.chars = 1
            ),
            ROC_MSG$ROC$VALIDATE$NO_PRED_PAR_SEL
          ),
          shiny::need(
            checkmate::test_string(
              input_roc[[ROC_ID$ROC$RESP_PAR]][["par"]](),
              min.chars = 1
            ),
            ROC_MSG$ROC$VALIDATE$NO_RESP_PAR_SEL
          ),
          shiny::need(
            checkmate::test_string(input_roc[[ROC_ID$ROC$PRED_VISIT]](), min.chars = 1),
            ROC_MSG$ROC$VALIDATE$NO_VISIT_SEL
          ),
          shiny::need(
            checkmate::test_string(input_roc[[ROC_ID$ROC$RESP_VISIT]](), min.chars = 1),
            ROC_MSG$ROC$VALIDATE$NO_VISIT_SEL
          ),
          shiny::need(
            checkmate::test_string(input_roc[[ROC_ID$ROC$GROUP]](), min.chars = 1),
            ROC_MSG$ROC$VALIDATE$NO_GROUP_SEL
          )
        )
        input_roc
      },
      label = ns("input_roc")
    )
    v_input_ci_spec_points <- shiny::reactive(
      {
        list(
          spec = parse_ci(input[[ROC_ID$ROC$CI_SPEC_POINTS]]),
          thr = parse_ci(input[[ROC_ID$ROC$CI_THR_POINTS]])
        )
      },
      label = ns(" ci_points")
    )

    v_input_invert_row_col <- shiny::reactive(
      {
        input[[ROC_ID$ROC$INVERT_ROW_COL]]
      },
      label = ns(" invert_row_col")
    )
    v_input_fig_size <- shiny::reactive({
      as.numeric(input[[ROC_ID$ROC$FIG_SIZE]])
    })
    v_input_sort_auc <- shiny::reactive({
      input[[ROC_ID$ROC$SORT_AUC]]
    })
    v_input_x_metrics_col <- shiny::reactive({
      input[[ROC_ID$ROC$X_COL_METRICS]]
    })
    v_input_sort_summary <- shiny::reactive({
      input[[ROC_ID$ROC$GT_SUMMARY_TABLE_ALPH]]
    })
    v_input_sort_explore <- shiny::reactive({
      input[[ROC_ID$ROC$VEGA_EXPLORE_ROC_ALPH]]
    })

    # data reactives

    data_subset <- shiny::reactive({
      # Reactive is resolved first as nested reactives do no "react"
      # (pun intented) properly when used inside dplyr::filter
      # The suspect is NSE, but further testing is needed.

      l_input_roc <- v_input_subset()
      roc_subset_data(
        pred_cat = l_input_roc[[ROC_ID$ROC$PRED_PAR]][["cat"]](),
        pred_par = l_input_roc[[ROC_ID$ROC$PRED_PAR]][["par"]](),
        pred_val_col = l_input_roc[[ROC_ID$ROC$PRED_VALUE]](),
        pred_visit = l_input_roc[[ROC_ID$ROC$PRED_VISIT]](),
        resp_cat = l_input_roc[[ROC_ID$ROC$RESP_PAR]][["cat"]](),
        resp_par = l_input_roc[[ROC_ID$ROC$RESP_PAR]][["par"]](),
        resp_val_col = l_input_roc[[ROC_ID$ROC$RESP_VALUE]](),
        resp_visit = l_input_roc[[ROC_ID$ROC$RESP_VISIT]](),
        group_col = l_input_roc[[ROC_ID$ROC$GROUP]](),
        pred_ds = v_pred_dataset(),
        resp_ds = v_resp_dataset(),
        group_ds = v_group_dataset(),
        subj_col = VAR$SBJ,
        pred_cat_col = VAR$PRED$CAT,
        pred_par_col = VAR$PRED$PAR,
        pred_vis_col = VAR$PRED$VIS,
        resp_cat_col = VAR$RESP$CAT,
        resp_par_col = VAR$RESP$PAR,
        resp_vis_col = VAR$RESP$VIS
      )
    })

    roc_data <- shiny::reactive({
      ds <- data_subset()
      ci_points <- v_input_ci_spec_points()
      get_roc_data(ds, compute_roc_fn, ci_points, TRUE)
    })

    roc_data_explore <- shiny::reactive({
      # TODO: Should not respond to changes in category etc, maybe it should not respond to the whole input subset
      # list of reactives instead of reactive list?
      # REFACT: Consider moving validation next to the call of the input
      # ENTRY_NAME := shiny::reactive(dv.selector::server; validation)
      l_input_roc <- v_input_subset()
      ds <- roc_subset_data(
        pred_cat = unique(v_pred_dataset()[[pred_cat_var]]),
        pred_par = unique(v_pred_dataset()[[pred_par_var]]),
        pred_val_col = l_input_roc[[ROC_ID$ROC$PRED_VALUE]](),
        pred_visit = l_input_roc[[ROC_ID$ROC$PRED_VISIT]](),
        resp_cat = l_input_roc[[ROC_ID$ROC$RESP_PAR]][["cat"]](),
        resp_par = l_input_roc[[ROC_ID$ROC$RESP_PAR]][["par"]](),
        resp_val_col = l_input_roc[[ROC_ID$ROC$RESP_VALUE]](),
        resp_visit = l_input_roc[[ROC_ID$ROC$RESP_VISIT]](),
        group_col = l_input_roc[[ROC_ID$ROC$GROUP]](),
        pred_ds = v_pred_dataset(),
        resp_ds = v_resp_dataset(),
        group_ds = v_group_dataset(),
        subj_col = VAR$SBJ,
        pred_cat_col = VAR$PRED$CAT,
        pred_par_col = VAR$PRED$PAR,
        pred_vis_col = VAR$PRED$VIS,
        resp_cat_col = VAR$RESP$CAT,
        resp_par_col = VAR$RESP$PAR,
        resp_vis_col = VAR$RESP$VIS
      )

      ci_points <- v_input_ci_spec_points()
      rd <- get_roc_data(ds, compute_roc_fn, ci_points, FALSE)
      get_explore_roc_data(rd[["roc_curve"]])
    })

    # List of output arguments
    output_arguments <- list()

    # vega roc plot
    output_arguments[[ROC_ID$ROC$VEGA_ROC_PLOT]] <- shiny::reactive(
      list(
        ds_list = roc_data(),
        param_as_cols = v_input_invert_row_col(),
        fig_size = v_input_fig_size(),
        is_sorted = v_input_sort_auc()
      )
    )

    # TODO: This structure repeats across several blocks. I am unsure if this is incidental or a function would
    # be more appropriate

    output[[ROC_ID$ROC$VEGA_ROC_PLOT]] <- render_vegawidget_hack({
      # Things must be resolved outside of the renderVegaWidget otherwise it is tried to resolved inside
      spec <- do.call(get_roc_plot_output, output_arguments[[ROC_ID$ROC$VEGA_ROC_PLOT]]())

      #### Hack Territory
      chart_id <- ns_vegawidget_hack(ROC_ID$ROC$VEGA_ROC_PLOT)
      output[[chart_id]] <- vegawidget::renderVegawidget({
        # No reactive should be resolved in here
        spec
      })
      ns <- session[["ns"]]
      vegawidget::vegawidgetOutput(ns(chart_id))
      ####
    })

    # vega histogram plot
    output_arguments[[ROC_ID$ROC$VEGA_HISTO_PLOT]] <- shiny::reactive(
      list(ds = data_subset(), param_as_cols = v_input_invert_row_col(), fig_size = v_input_fig_size())
    )
    output[[ROC_ID$ROC$VEGA_HISTO_PLOT]] <- render_vegawidget_hack({
      # Things must be resolved outside of the renderVegaWidget otherwise it is tried to resolved inside
      spec <- do.call(get_histo_plot_output, output_arguments[[ROC_ID$ROC$VEGA_HISTO_PLOT]]())
      #### Hack Territory
      chart_id <- ns_vegawidget_hack(ROC_ID$ROC$VEGA_HISTO_PLOT)
      output[[chart_id]] <- vegawidget::renderVegawidget({
        # No reactive should be resolved in here
        spec
      })
      ns <- session[["ns"]]
      vegawidget::vegawidgetOutput(ns(chart_id))
      ####
    })

    # vega density plot
    output_arguments[[ROC_ID$ROC$VEGA_DENSITY_PLOT]] <- shiny::reactive(
      list(
        ds = data_subset(),
        param_as_cols = v_input_invert_row_col(),
        fig_size = v_input_fig_size()
      )
    )
    output[[ROC_ID$ROC$VEGA_DENSITY_PLOT]] <- render_vegawidget_hack({
      # Things must be resolved outside of the renderVegaWidget otherwise it is tried to resolved inside
      spec <- do.call(get_dens_plot_output, output_arguments[[ROC_ID$ROC$VEGA_DENSITY_PLOT]]())

      #### Hack Territory
      chart_id <- ns_vegawidget_hack(ROC_ID$ROC$VEGA_DENSITY_PLOT)
      output[[chart_id]] <- vegawidget::renderVegawidget({
        # No reactive should be resolved in here
        spec
      })
      ns <- session[["ns"]]
      vegawidget::vegawidgetOutput(ns(chart_id))
      ####
    })

    # vega raincloud plot
    output_arguments[[ROC_ID$ROC$RAINCLOUD_PLOT]] <- shiny::reactive(
      list(
        ds = data_subset(),
        param_as_cols = v_input_invert_row_col(),
        fig_size = v_input_fig_size()
      )
    )
    output[[ROC_ID$ROC$RAINCLOUD_PLOT]] <- render_vegawidget_hack({
      # Things must be resolved outside of the renderVegaWidget otherwise it is tried to resolved inside
      spec <- do.call(get_raincloud_output, output_arguments[[ROC_ID$ROC$RAINCLOUD_PLOT]]())

      #### Hack Territory
      chart_id <- ns_vegawidget_hack(ROC_ID$ROC$RAINCLOUD_PLOT)
      output[[chart_id]] <- vegawidget::renderVegawidget({
        # No reactive should be resolved in here
        spec
      })
      ns <- session[["ns"]]
      vegawidget::vegawidgetOutput(ns(chart_id))
      ####
    })

    # vega metric plot
    output_arguments[[ROC_ID$ROC$METRICS_PLOT]] <- shiny::reactive(
      list(
        ds = data_subset(),
        param_as_cols = v_input_invert_row_col(),
        fig_size = v_input_fig_size(),
        x_metrics_col = v_input_x_metrics_col(),
        compute_metric_fn = compute_metric_fn
      )
    )
    output[[ROC_ID$ROC$METRICS_PLOT]] <- render_vegawidget_hack({
      # Things must be resolved outside of the renderVegaWidget otherwise it is tried to resolved inside

      spec <- do.call(get_metrics_output, output_arguments[[ROC_ID$ROC$METRICS_PLOT]]())

      #### Hack Territory
      chart_id <- ns_vegawidget_hack(ROC_ID$ROC$METRICS_PLOT)
      output[[chart_id]] <- vegawidget::renderVegawidget({
        # No reactive should be resolved in here
        spec
      })
      ns <- session[["ns"]]
      vegawidget::vegawidgetOutput(ns(chart_id))
      ####
    })

    # AUC Explore ROC
    output_arguments[[ROC_ID$ROC$VEGA_EXPLORE_ROC_PLOT]] <- shiny::reactive(
      list(ds = roc_data_explore(), fig_size = v_input_fig_size(), sort_alph = v_input_sort_explore())
    )
    output[[ROC_ID$ROC$VEGA_EXPLORE_ROC_PLOT]] <- render_vegawidget_hack({
      # Things must be resolved outside of the renderVegaWidget otherwise it is tried to resolved inside
      spec <- do.call(get_explore_roc_spec, output_arguments[[ROC_ID$ROC$VEGA_EXPLORE_ROC_PLOT]]())

      #### Hack Territory
      chart_id <- ns_vegawidget_hack(ROC_ID$ROC$VEGA_EXPLORE_ROC_PLOT)
      output[[chart_id]] <- vegawidget::renderVegawidget({
        # No reactive should be resolved in here
        spec
      })
      ns <- session[["ns"]]
      vegawidget::vegawidgetOutput(ns(chart_id))
      ####
    })

    # GT Summary table
    output_arguments[[ROC_ID$ROC$GT_SUMMARY_TABLE]] <- shiny::reactive(
      list(ds_list = roc_data(), sort_alph = v_input_sort_summary())
    )
    output[[ROC_ID$ROC$GT_SUMMARY_TABLE]] <- gt::render_gt({
      do.call(get_gt_summary_output, output_arguments[[ROC_ID$ROC$GT_SUMMARY_TABLE]]())
    })

    # info panel
    # NOT USING DO.CALL STRATEGY
    output[[ROC_ID$ROC$INFO_PANEL]] <- shiny::renderUI({
      # do.call does resolve the reactive and possible errors cannot be captured inside ROC_ID$ROC$INFO_PANEL
      # For now it will be called without using the output arguments, but maybe the problem is capturing an error
      # inside get_info_panel_output
      get_info_panel_output(ds = data_subset())
    })

    # debug tab
    if (..__is_db()) {
      ..__db_server(
        id = "debug",
        debug_list = list(
          list(
            name = "Data subset",
            ui = DT::DTOutput,
            server = DT::renderDT({
              data_subset()
            })
          ),
          list(
            name = "ROC Curve(RC)",
            ui = DT::DTOutput,
            server = DT::renderDT({
              roc_data() |>
                (function(x) x[["roc_curve"]])()
            })
          ),
          list(
            name = "Optimal Cut(RC)",
            ui = DT::DTOutput,
            server = DT::renderDT({
              roc_data() |>
                (function(x) x[["optimal_cut"]])()
            })
          ),
          list(
            name = "CI Rules(RC)",
            ui = DT::DTOutput,
            server = DT::renderDT({
              roc_data() |>
                (function(x) x[["ci_rules"]])()
            })
          ),
          list(
            name = "Density",
            ui = DT::DTOutput,
            server = DT::renderDT({
              get_dens_data(data_subset())
            })
          ),
          list(
            name = "Metrics",
            ui = DT::DTOutput,
            server = DT::renderDT({
              get_metric_data(data_subset())
            })
          ),
          list(
            name = "Summary",
            ui = DT::DTOutput,
            server = DT::renderDT({
              DT::datatable(data = get_summary_data(ds_list = roc_data()), filter = "top")
            })
          )
        )
      )
    }

    # test values
    shiny::exportTestValues(
      data_subset = data_subset(),
      v_group_dataset = v_group_dataset(),
      v_resp_dataset = v_resp_dataset(),
      v_pred_dataset = v_pred_dataset(),
      input_roc = input_roc,
      v_input_subset = v_input_subset(),
      v_input_ci_points = v_input_ci_spec_points(),
      v_input_invert_row_col = v_input_invert_row_col(),
      v_input_fig_size = v_input_fig_size(),
      v_input_sort_auc = v_input_sort_auc(),
      v_input_x_metrics_col = v_input_x_metrics_col(),
      data_subset = data_subset(),
      roc_data = roc_data(),
      roc_data_noci = roc_data_explore(),
      output_arguments = output_arguments
    )

    # return
    NULL
  }

  shiny::moduleServer(id, module)
}

#' Invoke ROC module
#'
#' @param module_id `[character(1)]`
#'
#' Module identificator
#'
#' @param pred_dataset_name,resp_dataset_name,group_dataset_name
#'
#' Name of the dataset
#'
#' @keywords main
#'
#' @export

mod_roc <- function(
    module_id, pred_dataset_name, resp_dataset_name, group_dataset_name,
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
    compute_metric_fn = compute_metric_data) {
  mod <- list(
    ui = roc_UI,
    server = function(afmm) {
      roc_server(
        id = module_id,
        pred_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[pred_dataset_name]]),
        resp_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[resp_dataset_name]]),
        group_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[group_dataset_name]]),
        dataset_name = afmm[["dataset_name"]],
        pred_cat_var = pred_cat_var,
        pred_par_var = pred_par_var,
        pred_value_vars = pred_value_vars,
        pred_visit_var = pred_visit_var,
        resp_cat_var = resp_cat_var,
        resp_par_var = resp_par_var,
        resp_value_vars = resp_value_vars,
        resp_visit_var = resp_visit_var,
        subjid_var = subjid_var,
        compute_roc_fn = compute_roc_fn,
        compute_metric_fn = compute_metric_fn
      )
    },
    module_id = module_id
  )
  mod
}

# ROC module interface description ----
# TODO: Fill in
mod_roc_API_docs <- list(
  "ROC",
  module_id = "",
  pred_dataset_name = "",
  resp_dataset_name = "",
  group_dataset_name = "",
  pred_cat_var = "",
  pred_par_var = "",
  pred_value_vars = "",
  pred_visit_var = "",
  resp_cat_var = "",
  resp_par_var = "",
  resp_value_vars = "",
  resp_visit_var = "",
  subjid_var = "",
  compute_roc_fn = "",
  compute_metric_fn = ""
)

mod_roc_API_spec <- TC$group(
  module_id = TC$mod_ID(),
  pred_dataset_name = TC$dataset_name(),
  resp_dataset_name = TC$dataset_name(),
  group_dataset_name = TC$dataset_name() |> TC$flag("subject_level_dataset_name"),
  pred_cat_var = TC$col("pred_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("map_character_to_factor"),
  pred_par_var = TC$col("pred_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("map_character_to_factor"),
  pred_value_vars = TC$col("pred_dataset_name", TC$numeric()) |> TC$flag("one_or_more"),
  pred_visit_var = TC$col("pred_dataset_name", TC$or(TC$character(), TC$factor(), TC$numeric())),
  resp_cat_var = TC$col("resp_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("map_character_to_factor"),
  resp_par_var = TC$col("resp_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("map_character_to_factor"),
  resp_value_vars = TC$col("resp_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("one_or_more"),
  resp_visit_var = TC$col("resp_dataset_name", TC$or(TC$character(), TC$factor(), TC$numeric())),
  subjid_var = TC$col("group_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("subjid_var", "map_character_to_factor"),
  compute_roc_fn = TC$fn(arg_count = 4) |> TC$flag("optional"),
  compute_metric_fn = TC$fn(arg_count = 2) |> TC$flag("optional")
) |> TC$attach_docs(mod_roc_API_docs)

check_mod_roc <- function(
    afmm, datasets, module_id, pred_dataset_name, resp_dataset_name, group_dataset_name, pred_cat_var,
    pred_par_var, pred_value_vars, pred_visit_var, resp_cat_var, resp_par_var, resp_value_vars,
    resp_visit_var, subjid_var, compute_roc_fn, compute_metric_fn) {
  warn <- CM$container()
  err <- CM$container()

  # TODO: Replace this function with a generic one that performs the checks based on mod_boxplot_API_spec.
  # Something along the lines of OK <- CM$check_API(mod_corr_hm_API_spec, args = match.call(), warn, err)
  OK <- check_mod_roc_auto(
    afmm, datasets, module_id, pred_dataset_name, resp_dataset_name, group_dataset_name, pred_cat_var,
    pred_par_var, pred_value_vars, pred_visit_var, resp_cat_var, resp_par_var, resp_value_vars,
    resp_visit_var, subjid_var, compute_roc_fn, compute_metric_fn, warn, err
  )

  # Checks that API spec does not (yet?) capture

  # #ouhigo
  if (OK[["subjid_var"]] && OK[["pred_cat_var"]] && OK[["pred_par_var"]] && OK[["pred_visit_var"]]) {
    CM$check_unique_sub_cat_par_vis(
      datasets, "pred_dataset_name", pred_dataset_name,
      subjid_var, cat_var, par_var, visit_var, NULL, warn = warn, err = err
    )
  }

  if (OK[["subjid_var"]] && OK[["resp_cat_var"]] && OK[["resp_par_var"]] && OK[["resp_visit_var"]]) {
    CM$check_unique_sub_cat_par_vis(
      datasets, "resp_dataset_name", resp_dataset_name,
      subjid_var, resp_cat_var, resp_par_var, resp_visit_var,
      warn, err
    )
  }

  # TODO: check resp_value_vars are binary?

  res <- list(warnings = warn[["messages"]], errors = err[["messages"]])
  return(res)
}

dataset_info_roc <- function(pred_dataset_name, resp_dataset_name, group_dataset_name, ...) {
  # TODO: Replace this function with a generic one that builds the list based on mod_boxplot_API_spec.
  # Something along the lines of CM$dataset_info(mod_roc_API_spec, args = match.call())
  return(list(
    all = unique(c(pred_dataset_name, resp_dataset_name, group_dataset_name)),
    subject_level = group_dataset_name
  ))
}

mod_roc <- CM$module(mod_roc, check_mod_roc, dataset_info_roc, map_afmm_mod_roc_auto)

# Server Logic

# Constants

CNT_ROC <- poc(
  SBJ = "subject_id",
  GRP = "group",
  PCAT = "predictor_category",
  PPAR = "predictor_parameter",
  PVAL = "predictor_value",
  VIS = "visit",
  RCAT = "response_category",
  RPAR = "response_parameter",
  RVAL = "response_value",
  SPEC = "specificity",
  SENS = "sensitivity",
  THR = "threshold",
  DIR = "direction",
  LEV = "levels",
  AUC = "auc",
  L_AUC = "lower_CI_auc",
  U_AUC = "upper_CI_auc",
  ROC_OC = "roc_optimal_cut",
  ROC_CURVE = "roc_curve",
  ROC_CI = "roc_ci",
  CI_L_SPEC = "ci_lower_specificity",
  CI_U_SPEC = "ci_upper_specificity",
  CI_L_SENS = "ci_lower_sensitivity",
  CI_U_SENS = "ci_upper_sensitivity",
  CI_SPEC = "ci_specificity",
  CI_SENS = "ci_sensitivity",
  DENS_X = "dens_x",
  DENS_Y = "dens_y",
  BIN_START = "bin_start",
  BIN_END = "bin_end",
  BIN_COUNT = "bin_count",
  OC_TITLE = "optimal_cut_title",
  OC_SPEC = "optimal_cut_specificity",
  OC_L_SPEC = "optimal_cut_lower_specificity",
  OC_U_SPEC = "optimal_cut_upper_specificity",
  OC_SENS = "optimal_cut_sensitivity",
  OC_L_SENS = "optimal_cut_lower_sensitivity",
  OC_U_SENS = "optimal_cut_upper_sensitivity",
  OC_THR = "optimal_cut_threshold"
)

CNT_VAL <- poc(
  EMBED_OPTIONS = vegawidget::vega_embed(renderer = "svg", actions = list(editor = FALSE)),
  COLOR_SCHEME = "magma",
  ASCII_DELIM = "\001"
)

COL_LABELS <- poc(
  PRED_PAR = "Parameter",
  RESP_PAR = "Response"
)

# Helper functions

#' Test if a parameter only appears under one category
#'
#' It contains at least the subject id
#'
#' @param ds `[data.frame()]`
#'  The dataset to be tested
#'
#' @param par_col `[character(1)]`
#'  Name of the column containing the parameter name
#'
#' @param cat_col `[character(1)]`
#'  Name of the column containing the category name
#'
#' @returns `[logical(1)]`
#' `TRUE` if a parameter appears under a single category, `FALSE` otherwise
#'
#' @keywords internal
#'
test_one_cat_per_par <- function(ds, cat_col, par_col) {
  ds |>
    dplyr::distinct(
      dplyr::across(
        dplyr::all_of(
          c(par_col, cat_col)
        )
      )
    ) |>
    dplyr::count(
      dplyr::across(
        dplyr::all_of(
          c(par_col)
        )
      )
    ) |>
    dplyr::pull(.data[["n"]]) |>
    (function(x) x == 1)() |>
    all()
}

# Data manipulation

#' Subset input datasets
#'
#' @description
#'
#' This functions prepares the basic input for the rest of dv.explorer.parameter functions.
#'
#'
#' It subsets and joins the datasets based on the predictor/response category/parameter/visit and group selections.
#'
#' @section Input dataframes:
#'
#' ## pred_dataset
#'
#' It expects a dataset similar to
#' https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192 ,
#' 1 record per subject per parameter per analysis visit
#'
#' It expects, at least, the columns passed in the parameters,
#' `subj_col`, `pred_cat_col`, `pred_par_col`, `pred_vis_col` and `pred_val`.
#' The values of these variables are as described
#' in the CDISC standard for the variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.
#'
#' ## resp_dataset
#'
#' It expects a dataset similar to
#' https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192
#'
#' It expects, at least, the columns passed in the parameters,
#' `subj_col`, `resp_cat_col`, `resp_par_col`, `resp_vis_col` and `resp_val`.
#' The values of these variables are as described
#' in the CDISC standard for the variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.
#'
#' ## group_dataset
#'
#' It expects a dataset with an structure similar to
#' https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806 , one record per subject
#'
#' It expects to contain, at least, `subj_col` and `group_col`
#'
#' @section Internal checks:
#'
#' ## Shiny validation errors:
#'
#' - After selection it checks that:
#'   - Combination subject category parameter visit are unique for the predictor and response datasets
#'   - If grouped, that subject_id is unique for the selected group
#'
#'   - The final selection contains at least one row
#'   - The response value is binary. Empty values are not considered for this check.
#'
#' ## Warnings:
#' - Subjects in the selection have an empty response value
#'
#' @details
#'
#' - All columns but ``r CNT_ROC$PVAL`` are coherced into factors if they are not factors already.
#'
#' - If at least one parameter name appears under several selected categories,
#' parameter names and categories will be pasted together.
#'
#' - ``r CNT_ROC$PPAR`` is releveled so all extra levels not present in the selection are dropped.
#' Levels are ordered according to `pred_par` as long as a parameter name appears does not appear
#' under more than one selected categories.
#'
#' @param pred_par,pred_cat `[character*ish*(n)]`
#'
#' Values from `pred_par_col` and `pred_cat_col` to be subset
#'
#' @param pred_val_col `[character*ish*(1)]`
#'
#' Column containing values for the predictor parameters
#'
#' @param pred_visit `[character*ish*(1)]`
#'
#' Values from `pred_vis_col` to be subset
#'
#' @param resp_par,resp_cat `[character*ish*(1)]`
#'
#'  Values from `resp_par_col` and `resp_cat_col` to be subset
#'
#' @param resp_val_col `[character*ish*(1)]`
#'
#' Column containing values for the response parameter
#'
#' @param resp_visit `[character*ish*(1)]`
#'
#' Values from `resp_vis_col` to be subset
#'
#' @param group_col `[character*ish*(1)]`
#'
#' Column to group the data by. `"None"` for no grouping.
#'
#' @param pred_ds,resp_ds,group_ds `[data.frame()]`
#'
#' Data frames for predictors/responses and groupings, see section *Input dataframes*
#'
#' @param subj_col,pred_par_col,pred_cat_col,pred_vis_col,resp_cat_col,resp_par_col,resp_vis_col `[character(1)]`
#'
#'  Column for predictor/response category/parameter/visit. `subj_col` must be a factor.
#'
#' @returns
#'
#' `r doc_templates()[["subset_data_return"]]`
#'
#' Additionally:
#'
#' - ``r CNT_ROC$PPAR`` has a label attribute: *`r COL_LABELS$PRED_PAR`*
#' - ``r CNT_ROC$RPAR`` has a label attribute: *`r COL_LABELS$RESP_PAR`*
#' - ``r CNT_ROC$GRP`` has the same label attribute as in the original dataset, if available, otherwise `group_col`.
#'
#' @keywords internal
#'

roc_subset_data <- function(pred_cat,
                            pred_par,
                            pred_val_col,
                            pred_visit,
                            resp_cat,
                            resp_par,
                            resp_val_col,
                            resp_visit,
                            group_col,
                            pred_ds,
                            resp_ds,
                            group_ds,
                            subj_col,
                            pred_cat_col,
                            pred_par_col,
                            pred_vis_col,
                            resp_cat_col,
                            resp_par_col,
                            resp_vis_col) {
  # REFACT: This function is candidate for refactoring and the subsetting functionality, repeated in pred and resp,
  # can be extracted


  # Force factors from the beginning if they are not factors
  as_factor_if_not_factor <- function(x) {
    if (!is.factor(x)) {
      log_inform("Cohercing to factor")
      as.factor(x)
    } else {
      x
    }
  }

  # Pred and resp
  pred_data <- pred_ds |>
    dplyr::filter(
      .data[[pred_cat_col]] %in% pred_cat,
      .data[[pred_par_col]] %in% pred_par,
      .data[[pred_vis_col]] == pred_visit
    ) |>
    dplyr::select(
      dplyr::all_of(
        dc(
          !!CNT_ROC$SBJ := subj_col,
          !!CNT_ROC$PCAT := pred_cat_col,
          !!CNT_ROC$PPAR := pred_par_col,
          !!CNT_ROC$PVAL := pred_val_col
        )
      )
    )

  dplyr::all_of

  rename_ppar <- !test_one_cat_per_par(ds = pred_data, cat_col = CNT_ROC$PCAT, par_col = CNT_ROC$PPAR)

  if (rename_ppar) {
    pred_data <- dplyr::mutate(
      pred_data,
      !!CNT_ROC$PPAR := factor(paste(.data[[CNT_ROC$PCAT]], "-", .data[[CNT_ROC$PPAR]]))
    )
  }

  pred_data <- pred_data |>
    dplyr::select(
      -dplyr::all_of(CNT_ROC$PCAT)
    ) |>
    dplyr::mutate(
      dplyr::across(dplyr::where(is.character), as_factor_if_not_factor)
    )

  resp_data <- resp_ds |>
    dplyr::filter(
      .data[[resp_par_col]] %in% resp_par,
      .data[[resp_vis_col]] == resp_visit
    ) |>
    dplyr::select(
      dplyr::all_of(
        dc(
          !!CNT_ROC$SBJ := subj_col,
          !!CNT_ROC$RCAT := resp_cat_col,
          !!CNT_ROC$RPAR := resp_par_col,
          !!CNT_ROC$RVAL := resp_val_col
        )
      )
    )


  rename_rpar <- !test_one_cat_per_par(ds = resp_data, cat_col = CNT_ROC$RCAT, par_col = CNT_ROC$RPAR)

  # In the current setup this cannot happen as only single category and parameter are allowed for response
  if (rename_rpar) {
    resp_data <- dplyr::mutate(
      resp_data,
      !!CNT_ROC$RPAR := paste(.data[[CNT_ROC$RCAT]], "-", .data[[CNT_ROC$RPAR]])
    )
  }

  resp_data <- resp_data |>
    dplyr::select(
      -dplyr::all_of(CNT_ROC$RCAT)
    ) |>
    dplyr::mutate(
      dplyr::across(dplyr::where(is.character), as_factor_if_not_factor)
    ) |>
    dplyr::mutate(
      !!CNT_ROC$RVAL := droplevels(.data[[CNT_ROC$RVAL]])
    )

  # Check no duplicated subjects
  # - Combination subject parameter visit are not unique

  shiny::validate(
    shiny::need(
      test_one_row_per_sbj(pred_data, CNT_ROC$SBJ, CNT_ROC$PPAR), # Covered by #ouhigo
      ROC_MSG$ROC$VALIDATE$PRED_TOO_MANY_ROWS
    ),
    shiny::need(
      test_one_row_per_sbj(resp_data, CNT_ROC$SBJ, CNT_ROC$RPAR), # Covered by #ouhigo
      ROC_MSG$ROC$VALIDATE$RESP_TOO_MANY_ROWS
    )
  )

  # Generate the intersected dataset
  joint_data <- dplyr::inner_join(
    pred_data,
    resp_data,
    by = c(CNT_ROC$SBJ)
  )

  # Group data
  is_grouped <- group_col != ROC_VAL$NO_GROUP_VAL

  if (is_grouped) {
    group_data <- group_ds |>
      dplyr::select(
        dplyr::all_of(
          dc(
            !!CNT_ROC$SBJ := subj_col,
            !!CNT_ROC$GRP := group_col
          )
        )
      ) |>
      dplyr::mutate(
        dplyr::across(c(CNT_ROC$GRP), as_factor_if_not_factor)
      )

    shiny::validate(
      shiny::need(
        test_one_row_per_sbj(group_data, CNT_ROC$SBJ, CNT_ROC$GRP),
        ROC_MSG$ROC$VALIDATE$GROUP_TOO_MANY_ROWS
      ),
      # This is a very unlikely case, and now that these functions uses internal names can probably be eliminated
      shiny::need(
        checkmate::test_names(names(joint_data),
          disjunct.from = group_col
        ),
        ROC_MSG$ROC$VALIDATE$GROUP_COL_REPEATED
      )
    )

    joint_data <- dplyr::left_join(
      joint_data,
      group_data,
      by = c(CNT_ROC$SBJ)
    )
  }

  if (rename_ppar) {
    pred_par_levels <- tidyr::expand_grid(pred_cat, sep = "-", pred_par) |>
      dplyr::mutate(
        united = paste(.data[["pred_cat"]], .data[["sep"]], .data[["pred_par"]])
      ) |>
      dplyr::filter(.data[["united"]] %in% levels(joint_data[[CNT_ROC$PPAR]])) |>
      dplyr::pull("united")
  } else {
    pred_par_levels <- pred_par
  }

  joint_data <- dplyr::mutate(
    joint_data,
    !!CNT_ROC$PPAR := factor(.data[[CNT_ROC$PPAR]], levels = pred_par_levels)
  ) |>
    dplyr::ungroup()

  clean_data <- joint_data |>
    dplyr::filter(.data[[CNT_ROC$RVAL]] != "") |>
    dplyr::mutate(!!CNT_ROC$RVAL := droplevels(.data[[CNT_ROC$RVAL]]))

  diff_rows <- nrow(joint_data) - nrow(clean_data)

  if (diff_rows > 0) {
    rlang::warn(ROC_MSG$ROC$VALIDATE$N_SUBJECT_EMPTY_RESPONSES(diff_rows))
    if (shiny::isRunning()) {
      shiny::showNotification(ROC_MSG$ROC$VALIDATE$N_SUBJECT_EMPTY_RESPONSES(diff_rows), type = "warning")
    }
  }

  # Drop levels for all factors
  clean_data <- clean_data |>
    dplyr::mutate(dplyr::across(dplyr::where(is.factor), droplevels)) |>
    set_lbl(CNT_ROC$PPAR, COL_LABELS$PRED_PAR) |> # Add labels always in last place
    set_lbl(CNT_ROC$RPAR, COL_LABELS$RESP_PAR) |>
    set_lbl(CNT_ROC$GRP, get_lbl_robust(group_ds, group_col)) # Use the label of column in the original dataset


  clean_data

  shiny::validate(
    shiny::need(
      nrow(clean_data) > 0,
      ROC_MSG$ROC$VALIDATE$NO_ROWS
    )
  )

  # Validate selected value column for RVAL do not contain more than two different values

  shiny::validate(
    shiny::need(
      length(unique(clean_data[[CNT_ROC$RVAL]])) == 2,
      ROC_MSG$ROC$VALIDATE$MUST_BE_BINARY_ENDPOINT(unique(joint_data[[CNT_ROC$RVAL]]))
    )
  )

  clean_data
}

#' Apply ROC analysis to groups
#'
#' @description
#'
#' It applies an ROC analysis over a dataset. The application is applied by groups defined by ``r CNT_ROC$PPAR``,
#' ``r CNT_ROC$RPAR`` and, if grouped, ``r CNT_ROC$GRP``.
#'
#' This functions is prepared to be applied over a dataset that is the output of `roc_subset_data()`.
#'
#' The function itself does not calculate the ROC analysis, it only applies `compute_fn` over the different groups.
#'
#' ## Input dataframe:
#'
#' `r doc_templates()[["subset_data_return"]]`
#'
#' ## compute_fn definition:
#'
#' For an example of a computing function please review [compute_roc_data()].
#'
#' @details
#'
#' If `compute_fn` returns an error when applied to any of the groups a dataset with NA is returned instead.
#' This controls side cases such as groups that contains a single observation.
#'
#' @param ds `[data.frame()]`
#' A dataframe
#'
#' @param compute_fn `[function(1)]`
#' A function that computes the ROC data
#'
#' @param ci_points `[list(spec = numeric(), thr = numeric())]`
#' Points at which 95% confidence intervals for sensitivity and specificity will be calculated. Depending on the entry
#' CI will be calculated at defined specificity points or threshold points.
#'
#' @param do_bootstrap `[logical(1)]`
#' Calculate confidence intervals for sensitivity and specificity
#'
#' @return
#'
#' `r doc_templates()[["get_roc_data_return"]]`
#'
#'
#' @keywords internal
#'
get_roc_data <- function(ds, compute_fn, ci_points, do_bootstrap) {
  is_grouped <- CNT_ROC$GRP %in% names(ds)
  nest_by_vars <- if (is_grouped) c(CNT_ROC$PPAR, CNT_ROC$RPAR, CNT_ROC$GRP) else c(CNT_ROC$PPAR, CNT_ROC$RPAR)

  otherwise_val <- rlang::list2(
    !!CNT_ROC$ROC_CURVE := tibble::tibble(
      !!CNT_ROC$SPEC := NA,
      !!CNT_ROC$SENS := NA,
      !!CNT_ROC$THR := NA,
      !!CNT_ROC$AUC := NA
    ),
    !!CNT_ROC$ROC_CI := NA,
    !!CNT_ROC$ROC_OC := NA
  )

  possibly_roc <- purrr::possibly(
    decorate_cnd(compute_fn, "(Compute ROC):"),
    otherwise = otherwise_val,
    quiet = FALSE
  )

  roc_data <- ds |>
    dplyr::nest_by(dplyr::across(dplyr::all_of(nest_by_vars)), .key = "data") |>
    dplyr::mutate(
      computed_roc = list({
        possibly_roc(
          response = .data[["data"]][[CNT_ROC$RVAL]],
          predictor = .data[["data"]][[CNT_ROC$PVAL]],
          do_bootstrap = do_bootstrap,
          ci_points = ci_points
        )
      }),
      !!CNT_ROC$ROC_CURVE := list(.data[["computed_roc"]][[CNT_ROC$ROC_CURVE]]),
      !!CNT_ROC$ROC_CI := list(.data[["computed_roc"]][[CNT_ROC$ROC_CI]]),
      !!CNT_ROC$ROC_OC := list(.data[["computed_roc"]][[CNT_ROC$ROC_OC]])
    ) |>
    dplyr::select(
      -dplyr::all_of(c("computed_roc", "data"))
    )

  roc_curve <- roc_data |>
    dplyr::select(
      -dplyr::all_of(c(CNT_ROC$ROC_CI, CNT_ROC$ROC_OC))
    ) |>
    tidyr::unnest(dplyr::all_of(CNT_ROC$ROC_CURVE)) |>
    dplyr::ungroup() |>
    dplyr::arrange(
      dplyr::desc(.data[[CNT_ROC$SPEC]]),
      .data[[CNT_ROC$SENS]]
    ) # Move this arrange to the relevant place (roc spec)

  optimal_cut <- roc_data |>
    dplyr::select(-dplyr::all_of(c(CNT_ROC$ROC_CI, CNT_ROC$ROC_CURVE))) |>
    tidyr::unnest(dplyr::all_of(CNT_ROC$ROC_OC)) |>
    dplyr::ungroup()

  if (do_bootstrap) {
    ci_rules <- roc_data |>
      dplyr::select(
        -dplyr::all_of(c(CNT_ROC$ROC_CURVE, CNT_ROC$ROC_OC))
      ) |>
      tidyr::unnest(dplyr::all_of(CNT_ROC$ROC_CI)) |>
      dplyr::ungroup()

    r <- rlang::list2(
      !!CNT_ROC$ROC_CURVE := roc_curve,
      !!CNT_ROC$ROC_CI := ci_rules,
      !!CNT_ROC$ROC_OC := optimal_cut
    )
  } else {
    r <- rlang::list2(
      !!CNT_ROC$ROC_CURVE := roc_curve,
      !!CNT_ROC$ROC_OC := optimal_cut
    )
  }
  r
}

#' Prepare dataframe for auc exploration
#'
#' Removes `r CNT_ROC$SENS`, `r CNT_ROC$SPEC`, and `r CNT_ROC$THR` and expands `r CNT_ROC$AUC` in three columns.
#' Removes duplicated rows.
#' Used on the output of [get_roc_data()]
#'
#' @details
#'
#' It respects columns labels
#'
#' @section Input dataframe:
#'
#' `r doc_templates()[["get_roc_data_return_roc_curve"]]`
#'
#' @param ds `[data.frame()]`
#'
#' @return
#'
#' `r doc_templates()[["get_explore_roc_data_return"]]`
#'
#' @keywords internal
#'
get_explore_roc_data <- function(ds) {
  # Some AUCS are below .% or similar and the youden fails or similar
  prev_labels <- get_lbls(ds)
  dplyr::select(ds, -dplyr::all_of(c(CNT_ROC$SENS, CNT_ROC$SPEC, CNT_ROC$THR))) |>
    dplyr::distinct() |>
    dplyr::mutate(
      !!CNT_ROC$L_AUC := purrr::map_dbl(.data[[CNT_ROC$AUC]], ~ .x[1]),
      !!CNT_ROC$U_AUC := purrr::map_dbl(.data[[CNT_ROC$AUC]], ~ .x[3]),
      !!CNT_ROC$AUC := purrr::map_dbl(.data[[CNT_ROC$AUC]], ~ .x[2])
    ) |>
    set_lbls(prev_labels)
}

#' Calculate probability density per group
#'
#' It calculates the probability density of the parameter value by groups defined by ``r CNT_ROC$PPAR``,
#' ``r CNT_ROC$RPAR`` and, if grouped, ``r CNT_ROC$GRP``.
#' These functions is prepared to be applied over a dataset that is the output of `roc_subset_data()`.
#'
#' @details
#'
#' [stats::density] with default values is used to calculate the density
#'
#' @section Input dataframe:
#'
#' `r doc_templates()[["subset_data_return"]]`
#'
#' @param ds `[data.frame()]`
#' A dataframe
#'
#' @return
#'
#' `r doc_templates()[["get_dens_data_return"]]`
#'
#' @keywords internal
#'
get_dens_data <- function(ds) {
  is_grouped <- CNT_ROC$GRP %in% names(ds)
  grp_var <- if (is_grouped) c(CNT_ROC$PPAR, CNT_ROC$GRP, CNT_ROC$RVAL) else c(CNT_ROC$PPAR, CNT_ROC$RVAL)

  ds <- ds |>
    dplyr::group_by(
      dplyr::across(
        dplyr::all_of(grp_var)
      )
    ) |>
    dplyr::reframe(
      d = data.frame(stats::density(.data[[CNT_ROC$PVAL]])[c("x", "y")])
    ) |>
    tidyr::unnest(dplyr::all_of(c("d"))) |>
    dplyr::rename(
      dplyr::all_of(dc(
        !!CNT_ROC$DENS_X := "x",
        !!CNT_ROC$DENS_Y := "y"
      ))
    ) |>
    dplyr::ungroup()

  ds
}

#' Calculate binned count per group
#'
#' It calculates the binned count of the parameter value by groups defined by ``r CNT_ROC$PPAR``, ``r CNT_ROC$RPAR`` and
#' if grouped, ``r CNT_ROC$GRP``. These functions is prepared to be applied over a dataset that is the output of
#' `subset_data()`.
#'
#' @details
#'
#' [graphics::hist] with default values is used to calculate the binning
#'
#' @section Input dataframe:
#'
#' `r doc_templates()[["subset_data_return"]]`
#'
#' @param ds `[data.frame()]`
#' A dataframe
#'
#' @return
#'
#' `r doc_templates()[["get_histo_data_return"]]`
#'
#' @keywords internal
#'
get_histo_data <- function(ds) {
  is_grouped <- CNT_ROC$GRP %in% names(ds)
  grp_var <- if (is_grouped) c(CNT_ROC$PPAR, CNT_ROC$GRP, CNT_ROC$RVAL) else c(CNT_ROC$PPAR, CNT_ROC$RVAL)
  grp_brk <- if (is_grouped) c(CNT_ROC$PPAR) else c(CNT_ROC$PPAR)

  breaks <- ds |>
    dplyr::group_by(dplyr::across(dplyr::all_of(grp_brk))) |>
    dplyr::summarise(
      breaks = list(base::pretty(.data[[CNT_ROC$PVAL]], n = ceiling(1 + log2(dplyr::n())))), # Prettified Sturges rule
    ) |>
    dplyr::ungroup()

  ds <- ds |>
    dplyr::group_by(dplyr::across(dplyr::all_of(grp_var))) |>
    dplyr::reframe(
      d = {
        cur_par <- dplyr::cur_group()[[CNT_ROC$PPAR]]
        b <- (dplyr::filter(
          breaks,
          .data[[CNT_ROC$PPAR]] == cur_par
        ))[["breaks"]][[1]]
        bin_start <- b[-length(b)]
        bin_end <- b[-1]
        bin_count <- graphics::hist(.data[[CNT_ROC$PVAL]], plot = FALSE, breaks = b)[["counts"]]
        data.frame(
          bin_start,
          bin_end,
          bin_count
        )
      }
    ) |>
    tidyr::unnest(dplyr::all_of("d")) |>
    dplyr::rename(
      dplyr::all_of(
        dc(
          !!CNT_ROC$BIN_START := "bin_start",
          !!CNT_ROC$BIN_END := "bin_end",
          !!CNT_ROC$BIN_COUNT := "bin_count"
        )
      )
    )
  ds
}

#' Calculate quantiles per group
#'
#' It calculates the quantiles `c(.05, .25, .50, .75, .95)` and the mean of the parameter value by groups defined by
#' CNT_ROC$PPAR, CNT_ROC$RPAR and, if grouped, CNT_ROC$GRP. These functions is prepared to be applied over a dataset
#' that is the output of `roc_subset_data()`.
#'
#' @section Input dataframe:
#'
#' `r doc_templates()[["subset_data_return"]]`
#'
#' @param ds `[data.frame()]`
#' A dataframe
#'
#' @return
#'
#' `r doc_templates()[["get_quantile_data_return"]]`
#'
#'
#' @keywords internal
#'
get_quantile_data <- function(ds) {
  is_grouped <- CNT_ROC$GRP %in% names(ds)
  grp_var <- if (is_grouped) c(CNT_ROC$PPAR, CNT_ROC$GRP, CNT_ROC$RVAL) else c(CNT_ROC$PPAR, CNT_ROC$RVAL)
  ds <- dplyr::group_by(ds, dplyr::across(dplyr::all_of(grp_var)))
  ds <- dplyr::summarise(
    ds,
    mean = mean(.data[[CNT_ROC$PVAL]]),
    q = {
      probs <- c(.05, .25, .50, .75, .95)
      n_probs <- c("q05", "q25", "q50", "q75", "q95")
      q <- stats::quantile(.data[[CNT_ROC$PVAL]], probs = probs)
      q <- stats::setNames(q, n_probs)
      q <- as.list(q)
      tibble::as_tibble(q)
    }
  )
  ds <- tidyr::unnest(ds, dplyr::all_of("q"))
  ds <- dplyr::ungroup(ds)
  ds
}

#' Compute classification metrics to groups
#'
#' It computes classification metrics over a dataset. The application is applied by groups defined by CNT_ROC$PPAR,
#' CNT_ROC$RPAR and, if grouped, CNT_ROC$GRP. These functions is prepared to be applied over a dataset that is the
#' output of `roc_subset_data()`. The function itself does not compute the metrics, it only applies `compute_metric_fn`
#' over the different groups.
#'
#' @section Input dataframe:
#'
#' `r doc_templates()[["subset_data_return"]]`
#'
#' @section compute_metric_fn definition:
#'
#' For an example of a computing function please review [compute_metric_data()].
#'
#' @param ds `[data.frame()]`
#' A dataframe
#'
#' @param compute_metric_fn `[function(1)]`
#' A function that computes the metrics
#'
#' @return
#'
#' `r doc_templates()[["get_metric_data_return"]]`
#'
#' Additionally:
#'
#' - `score`, `norm_score`, `norm_rank` have a `label` attribute `"Score"`, `"Normalized Score"`
#' and `"Normalized Rank"` respectively.
#'
#' @keywords internal
#'
get_metric_data <- function(ds, compute_metric_fn) {
  is_grouped <- CNT_ROC$GRP %in% names(ds)
  nest_by_vars <- if (is_grouped) c(CNT_ROC$PPAR, CNT_ROC$RPAR, CNT_ROC$GRP) else c(CNT_ROC$PPAR, CNT_ROC$RPAR)

  dec_compute_metric_fn <- decorate_cnd(compute_metric_fn, "(Compute Metric):")

  metrics_data <- ds |>
    dplyr::nest_by(dplyr::across(dplyr::all_of(nest_by_vars)), .key = "data") |>
    dplyr::mutate(
      metrics = list({
        dec_compute_metric_fn(
          .data[["data"]][[CNT_ROC$PVAL]],
          .data[["data"]][[CNT_ROC$RVAL]]
        )
      })
    )

  limits <- attr(metrics_data[["metrics"]][[1]], "limits")

  # Move all this transformations in the computation function

  metrics_data <- metrics_data |>
    dplyr::select(-dplyr::all_of("data")) |>
    tidyr::unnest(dplyr::all_of("metrics")) |>
    dplyr::ungroup() |>
    possibly_set_lbls(get_lbls(ds))

  metrics_data <- set_lbl(df = metrics_data, var = "score", lbl = "Score")
  metrics_data <- set_lbl(df = metrics_data, var = "norm_score", lbl = "Normalized Score")
  metrics_data <- set_lbl(df = metrics_data, var = "norm_rank", lbl = "Normalized Rank")

  list(ds = metrics_data, limits = limits)
}

#' Prepare dataframe for summary table exploration
#'
#' Expands `r CNT_ROC$AUC` from `r CNT_ROC$ROC_CURVE` in three columns and joins the dataset with `r CNT_ROC$ROC_OC`
#' Used on the output of [get_roc_data()]
#'
#' @section Input dataframe list:
#'
#' `r doc_templates()[["get_roc_data_return"]]`
#'
#' @param ds_list `[list(data.frame)]`
#'
#' @return
#'
#' `r doc_templates()[["get_summary_data_return"]]`
#'
#' @keywords internal
#'
get_summary_data <- function(ds_list) {
  is_grouped <- if (CNT_ROC$GRP %in% names(ds_list[[CNT_ROC$ROC_OC]])) TRUE else FALSE
  selected <- if (is_grouped) {
    c(CNT_ROC$PPAR, CNT_ROC$GRP, CNT_ROC$AUC, CNT_ROC$DIR, CNT_ROC$LEV)
  } else {
    c(CNT_ROC$PPAR, CNT_ROC$AUC, CNT_ROC$DIR, CNT_ROC$LEV)
  }

  join_by <- if (is_grouped) c(CNT_ROC$PPAR, CNT_ROC$GRP) else c(CNT_ROC$PPAR)

  roc_data <- dplyr::select(ds_list[[CNT_ROC$ROC_CURVE]], dplyr::all_of(selected)) |>
    dplyr::distinct() |>
    dplyr::mutate(
      !!CNT_ROC$L_AUC := purrr::map_dbl(.data[["auc"]], ~ .x[[1]]),
      !!CNT_ROC$U_AUC := purrr::map_dbl(.data[["auc"]], ~ .x[[3]]),
      !!CNT_ROC$AUC := purrr::map_dbl(.data[["auc"]], ~ .x[[2]])
    )

  # Several OC with the same title may match the same row on the left related to DVCD-3109 ahyodae
  summary_data <- dplyr::left_join(
    roc_data,
    ds_list[[CNT_ROC$ROC_OC]],
    by = join_by,
    multiple = "all"
  )

  return(summary_data)
}

# Vega and output creation

#' Specification for a set of faceted ROC curves
#'
#' The chart consists of a faceted set of ROC curves plotting the:
#'
#'   - ROC curves
#'
#'   - The confidence intervals
#'
#'   - The set of optimal cuts
#'
#' @details
#'
#' ## Rows and columns:
#'
#'   - By default, predictor parameters are displayed in rows while grouping is displayed in columns.
#'
#'   - If no grouping is selected, then parameters are displayed in cols.
#'
#'   - If `ds_list[[`r CNT_ROC$ROC_CI]]`` is `NULL` then confidence intervals are not presented.
#'
#' @section Input dataframe list:
#'
#' ## `ds_list`
#'
#' `r doc_templates()[["get_roc_data_return"]]`
#'
#' @param ds_list `[list(data.frames())]`
#'
#' A list of dataframes
#'
#' @param param_as_cols `[logical(1)]`
#'
#' Charts are faceted using parameters as columns. This parameter is ignored in the sorted version.
#'
#' @param fig_size `[numeric(1)]`
#'
#' Size in pixels for each of the charts in the facet
#'
#' @name get_roc_spec
#'
#' @return
#'
#' A [vegawidget] specification
#'
#' @keywords internal
#'
get_roc_spec <- function(ds_list, param_as_cols, fig_size) {
  roc_ds <- ds_list[[CNT_ROC$ROC_CURVE]]
  ci_ds <- ds_list[[CNT_ROC$ROC_CI]]
  oc_ds <- ds_list[[CNT_ROC$ROC_OC]]
  is_grouped <- CNT_ROC$GRP %in% names(roc_ds)
  is_multipar <- length(unique(roc_ds[[CNT_ROC$PPAR]])) > 1

  roc_ds <- roc_ds |>
    dplyr::mutate(
      dir_str = purrr::map2_chr(.data[[CNT_ROC$LEV]], .data[[CNT_ROC$DIR]], ~ paste(.x, collapse = .y))
    )

  prev_labels <- purrr::list_modify(get_lbls(ci_ds), !!!get_lbls(roc_ds))
  full_ds <- set_lbls(dplyr::bind_rows(roc_ds, ci_ds, oc_ds), prev_labels)

  spec <- list(
    `$schema` = vegawidget::vega_schema(), # specifies Vega-Lite
    usermeta = list(embedOptions = CNT_VAL$EMBED_OPTIONS),
    data = list(values = full_ds)
  )

  x_encoding <- list(
    datum = list(expr = glue::glue("1-datum.{CNT_ROC$SPEC}")),
    type = "quantitative",
    axis = list(
      title = ROC_PLOT_VAL$ROC$LABELS$X_AXIS
    )
  )

  y_encoding <- list(
    field = CNT_ROC$SENS,
    type = "quantitative",
    axis = list(
      title = ROC_PLOT_VAL$ROC$LABELS$Y_AXIS
    )
  )

  tooltip_encoding <- list(
    list(
      field = CNT_ROC$PPAR, type = "nominal",
      title = ROC_PLOT_VAL$ROC$LABELS$PRED_TOOLTIP
    ),
    list(
      field = CNT_ROC$RPAR, type = "nominal",
      title = ROC_PLOT_VAL$ROC$LABELS$RESP_TOOLTIP
    ),
    if (is_grouped) list(field = CNT_ROC$GRP, type = "nominal", title = get_lbl_robust(roc_ds, CNT_ROC$GRP)) else NULL,
    list(
      field = "auc_str_frt", type = "nominal",
      title = ROC_PLOT_VAL$ROC$LABELS$AUC_TOOLTIP
    ),
    list(
      field = CNT_ROC$SENS, type = "quantitative",
      title = ROC_PLOT_VAL$ROC$LABELS$SENS_TOOLTIP,
      format = ROC_PLOT_VAL$STR_FMT$TWO_DEC
    ),
    list(
      field = CNT_ROC$SPEC, type = "quantitative",
      title = ROC_PLOT_VAL$ROC$LABELS$SPEC_TOOLTIP,
      format = ROC_PLOT_VAL$STR_FMT$TWO_DEC
    ),
    list(
      field = CNT_ROC$THR, type = "quantitative",
      title = ROC_PLOT_VAL$ROC$LABELS$THR_TOOLTIP,
      format = ROC_PLOT_VAL$STR_FMT$TWO_DEC
    ),
    list(
      field = "dir_str", type = "nominal",
      title = ROC_PLOT_VAL$ROC$LABELS$DIR_TOOLTIP
    )
  )

  point_layer <- list(
    transform = list(
      list(
        as = "auc_str_frt",
        calculate = glue::glue(
          "if(isArray(datum.{CNT_ROC$AUC}), ''+format(datum.{CNT_ROC$AUC}[1], '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+' ('+format(datum.{CNT_ROC$AUC}[0], '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+'-'+format(datum.{CNT_ROC$AUC}[2], '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+')', 0)"
        )
      )
    ),
    mark = "point",
    encoding = list(
      x = x_encoding,
      y = y_encoding,
      tooltip = tooltip_encoding
    )
  )

  line_layer <- list(
    mark = "line",
    encoding = list(
      x = x_encoding,
      y = y_encoding,
      tooltip = tooltip_encoding
    )
  )

  ci_rect_layer <- list(
    transform = list(
      list(calculate = glue::glue("'{ROC_PLOT_VAL$ROC$LABELS$TITLE_CI_TOOLTIP}'"), as = "title"),
      list(
        calculate = glue::glue(
          "'('+format(datum.{CNT_ROC$CI_L_SENS}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+'-'+format(datum.{CNT_ROC$CI_U_SENS}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+')'"
        ),
        as = "ci_se_str"
      ),
      list(calculate = glue::glue(
        "'('+format(datum.{CNT_ROC$CI_L_SPEC}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+'-'+format(datum.{CNT_ROC$CI_U_SPEC}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+')'"
      ), as = "ci_sp_str")
    ),
    mark = list(type = "rect"),
    encoding = list(
      x = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_L_SPEC}")), type = "quantitative"),
      x2 = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_U_SPEC}"))),
      y = list(field = CNT_ROC$CI_L_SENS, type = "quantitative"),
      y2 = list(field = CNT_ROC$CI_U_SENS),
      opacity = list(value = 0.2),
      tooltip = list(
        list(field = "title", type = "nominal"),
        list(field = CNT_ROC$PPAR, type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$PRED_TOOLTIP),
        list(field = CNT_ROC$RPAR, type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$RESP_TOOLTIP),
        if (is_grouped) {
          list(
            field = CNT_ROC$GRP,
            type = "nominal",
            title = get_lbl_robust(roc_ds, CNT_ROC$GRP)
          )
        } else {
          NULL
        },
        list(field = "ci_se_str", type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$SENS_TOOLTIP),
        list(field = "ci_sp_str", type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$SPEC_TOOLTIP),
        list(
          field = CNT_ROC$THR, type = "quantitative", title = ROC_PLOT_VAL$ROC$LABELS$THR_TOOLTIP,
          format = ROC_PLOT_VAL$STR_FMT$TWO_DEC
        )
      )
    )
  )

  ref_line_layer <- list(
    data = list(values = list(list(x = 0, y = 0), list(x = 1, y = 1))),
    mark = list(type = "line", strokeDash = c(3, 1)),
    encoding = list(
      x = list(field = "x", type = "quantitative"),
      y = list(field = "y", type = "quantitative"),
      color = list(value = "black")
    )
  )

  se_ci_layer <- list(
    mark = list(type = "rule", strokeDash = c(3, 1)),
    encoding = list(
      y = list(field = CNT_ROC$CI_L_SENS, type = "quantitative"),
      y2 = list(field = CNT_ROC$CI_U_SENS),
      x = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_SPEC}")), type = "quantitative"),
      x2 = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_SPEC}")))
    )
  )

  sp_ci_layer <- list(
    mark = list(type = "rule", strokeDash = c(3, 1)),
    encoding = list(
      y = list(field = CNT_ROC$CI_SENS, type = "quantitative"),
      y2 = list(field = CNT_ROC$CI_SENS),
      x = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_L_SPEC}")), type = "quantitative"),
      x2 = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_U_SPEC}")))
    )
  )

  optimal_cut_layer <- list(
    transform = list(
      list(calculate = glue::glue("datum.{CNT_ROC$OC_TITLE}"), as = "title"),
      list(
        as = "oc_str_sp",
        calculate = glue::glue(
          "''+format(datum.{CNT_ROC$OC_SPEC}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+' ('+format(datum.{CNT_ROC$OC_L_SPEC}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+'-'+format(datum.{CNT_ROC$OC_U_SPEC}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+')'"
        )
      ),
      list(
        as = "oc_str_se",
        calculate = glue::glue(
          "''+format(datum.{CNT_ROC$OC_SENS}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+' ('+format(datum.{CNT_ROC$OC_U_SENS}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+'-'+format(datum.{CNT_ROC$OC_L_SENS}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+')'"
        )
      )
    ),
    mark = "point",
    encoding = list(
      x = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$OC_SPEC}")), type = "quantitative"),
      y = list(field = CNT_ROC$OC_SENS, type = "quantitative"),
      color = list(
        field = CNT_ROC$OC_TITLE, scale = list(scheme = CNT_VAL$COLOR_SCHEME), title = ROC_PLOT_VAL$ROC$LABELS$OC_TITLE
      ),
      tooltip = list(
        list(field = "title", type = "nominal"),
        list(field = CNT_ROC$PPAR, type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$PRED_TOOLTIP),
        list(field = CNT_ROC$RPAR, type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$RESP_TOOLTIP),
        if (is_grouped) {
          list(
            field = CNT_ROC$GRP,
            type = "nominal",
            title = get_lbl_robust(roc_ds, CNT_ROC$GRP)
          )
        } else {
          NULL
        },
        list(field = "oc_str_sp", type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$SENS_TOOLTIP),
        list(field = "oc_str_se", type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$SPEC_TOOLTIP),
        list(
          field = CNT_ROC$OC_THR, type = "quantitative",
          title = ROC_PLOT_VAL$ROC$LABELS$THR_TOOLTIP, format = ROC_PLOT_VAL$STR_FMT$TWO_DEC
        )
      )
    )
  )

  layer <- list(
    ref_line_layer,
    se_ci_layer,
    sp_ci_layer,
    ci_rect_layer,
    line_layer,
    point_layer,
    optimal_cut_layer
  )

  spec[["spec"]] <- list(
    layer = layer,
    width = fig_size,
    height = fig_size
  )

  if (is_grouped) {
    if (is_multipar) {
      facet_par <- list(
        field = CNT_ROC$PPAR,
        title = get_lbl_robust(roc_ds, CNT_ROC$PPAR)
      )
      facet_grp <- list(
        field = CNT_ROC$GRP,
        title = get_lbl_robust(roc_ds, CNT_ROC$GRP)
      )
      if (param_as_cols) {
        spec[["facet"]] <- list(column = facet_par, row = facet_grp)
      } else {
        spec[["facet"]] <- list(column = facet_grp, row = facet_par)
      }
    } else {
      spec[["facet"]] <- list(
        column = list(
          field = CNT_ROC$GRP,
          title = get_lbl_robust(roc_ds, CNT_ROC$GRP)
        )
      )
    }
  } else {
    spec[["facet"]] <- list(
      column = list(field = CNT_ROC$PPAR, title = get_lbl_robust(roc_ds, CNT_ROC$PPAR))
    )
  }

  vegawidget::as_vegaspec(spec)
}

#' @describeIn get_roc_spec Specification for a set of sorted ROC curves
#'
#' @details
#'
#' ## Rows and columns:
#'
#'   - Charts are ordered from left to right and top to bottom from the highest to lowest area under the curve
#'
get_roc_sorted_spec <- function(ds_list, param_as_cols, fig_size) {
  roc_ds <- ds_list[[CNT_ROC$ROC_CURVE]]
  ci_ds <- ds_list[[CNT_ROC$ROC_CI]]
  oc_ds <- ds_list[[CNT_ROC$ROC_OC]]
  is_grouped <- CNT_ROC$GRP %in% names(roc_ds)

  roc_ds <- roc_ds |> dplyr::mutate(
    dir_str = purrr::map2_chr(.data[[CNT_ROC$LEV]], .data[[CNT_ROC$DIR]], ~ paste(.x, collapse = .y))
  )

  prev_labels <- purrr::list_modify(
    get_lbls(dplyr::select(roc_ds, -dplyr::any_of(CNT_ROC$GRP))),
    !!!get_lbls(dplyr::select(oc_ds, -dplyr::any_of(CNT_ROC$GRP)))
  )
  prev_labels <- purrr::discard(prev_labels, is.null)

  roc_ds <- roc_ds |>
    dplyr::mutate(auc_sort = purrr::map_dbl(.data[[CNT_ROC$AUC]], ~ .x[2]))

  if (is_grouped) {
    prev_labels[[CNT_ROC$PPAR]] <- paste0(
      get_lbl_robust(roc_ds, CNT_ROC$PPAR), " - ", get_lbl_robust(roc_ds, CNT_ROC$GRP)
    )
    roc_ds <- roc_ds |>
      dplyr::mutate(!!CNT_ROC$PPAR := paste(.data[[CNT_ROC$PPAR]], " - ", .data[[CNT_ROC$GRP]])) |>
      dplyr::select(-dplyr::all_of(CNT_ROC$GRP))
    ci_ds <- ci_ds |>
      dplyr::mutate(!!CNT_ROC$PPAR := paste(.data[[CNT_ROC$PPAR]], " - ", .data[[CNT_ROC$GRP]])) |>
      dplyr::select(-dplyr::all_of(CNT_ROC$GRP))
    oc_ds <- oc_ds |>
      dplyr::mutate(!!CNT_ROC$PPAR := paste(.data[[CNT_ROC$PPAR]], " - ", .data[[CNT_ROC$GRP]])) |>
      dplyr::select(-dplyr::all_of(CNT_ROC$GRP))
    is_grouped <- FALSE
  }


  full_ds <- set_lbls(dplyr::bind_rows(roc_ds, ci_ds, oc_ds), prev_labels)

  spec <- list(
    `$schema` = vegawidget::vega_schema(), # specifies Vega-Lite
    usermeta = list(embedOptions = CNT_VAL$EMBED_OPTIONS),
    data = list(values = full_ds)
  )

  x_encoding <- list(
    datum = list(expr = glue::glue("1-datum.{CNT_ROC$SPEC}")),
    type = "quantitative",
    axis = list(
      title = ROC_PLOT_VAL$ROC$LABELS$X_AXIS
    )
  )

  y_encoding <- list(
    field = CNT_ROC$SENS,
    type = "quantitative",
    axis = list(
      title = ROC_PLOT_VAL$ROC$LABELS$Y_AXIS
    )
  )

  tooltip_encoding <- list(
    list(
      field = CNT_ROC$PPAR, type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$PRED_TOOLTIP
    ),
    list(
      field = CNT_ROC$RPAR, type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$RESP_TOOLTIP
    ),
    if (is_grouped) list(field = CNT_ROC$GRP, type = "nominal", title = get_lbl_robust(roc_ds, CNT_ROC$GRP)) else NULL,
    list(
      field = "auc_str_frt", type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$AUC_TOOLTIP
    ),
    list(
      field = CNT_ROC$SENS, type = "quantitative", title = ROC_PLOT_VAL$ROC$LABELS$SENS_TOOLTIP,
      format = ROC_PLOT_VAL$STR_FMT$TWO_DEC
    ),
    list(
      field = CNT_ROC$SPEC, type = "quantitative", title = ROC_PLOT_VAL$ROC$LABELS$SPEC_TOOLTIP,
      format = ROC_PLOT_VAL$STR_FMT$TWO_DEC
    ),
    list(
      field = CNT_ROC$THR, type = "quantitative", title = ROC_PLOT_VAL$ROC$LABELS$THR_TOOLTIP,
      format = ROC_PLOT_VAL$STR_FMT$TWO_DEC
    ),
    list(
      field = "dir_str", type = "nominal",
      title = ROC_PLOT_VAL$ROC$LABELS$DIR_TOOLTIP
    )
  )

  point_layer <- list(
    transform = list(
      list(
        as = "auc_str_frt",
        calculate = glue::glue(
          "if(isArray(datum.{CNT_ROC$AUC}), ''+format(datum.{CNT_ROC$AUC}[1], '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+' ('+format(datum.{CNT_ROC$AUC}[0], '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+'-'+format(datum.{CNT_ROC$AUC}[2], '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+')', 0)"
        )
      )
    ),
    mark = "point",
    encoding = list(
      x = x_encoding,
      y = y_encoding,
      tooltip = tooltip_encoding
    )
  )

  line_layer <- list(
    mark = "line",
    encoding = list(
      x = x_encoding,
      y = y_encoding,
      tooltip = tooltip_encoding
    )
  )

  ci_rect_layer <- list(
    transform = list(
      list(calculate = glue::glue("'{ROC_PLOT_VAL$ROC$LABELS$TITLE_CI_TOOLTIP}'"), as = "title"),
      list(
        calculate = glue::glue(
          "'('+format(datum.{CNT_ROC$CI_L_SENS}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+'-'+format(datum.{CNT_ROC$CI_U_SENS}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+')'"
        ),
        as = "ci_se_str"
      ),
      list(
        calculate = glue::glue(
          "'('+format(datum.{CNT_ROC$CI_L_SPEC}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+'-'+format(datum.{CNT_ROC$CI_U_SPEC}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+')'"
        ),
        as = "ci_sp_str"
      )
    ),
    mark = list(type = "rect"),
    encoding = list(
      x = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_L_SPEC}")), type = "quantitative"),
      x2 = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_U_SPEC}"))),
      y = list(field = CNT_ROC$CI_L_SENS, type = "quantitative"),
      y2 = list(field = CNT_ROC$CI_U_SENS),
      opacity = list(value = 0.2),
      tooltip = list(
        list(field = "title", type = "nominal"),
        list(field = CNT_ROC$PPAR, type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$PRED_TOOLTIP),
        list(field = CNT_ROC$RPAR, type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$RESP_TOOLTIP),
        if (is_grouped) {
          list(
            field = CNT_ROC$GRP,
            type = "nominal",
            title = get_lbl_robust(roc_ds, CNT_ROC$GRP)
          )
        } else {
          NULL
        },
        list(field = "ci_se_str", type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$SENS_TOOLTIP),
        list(field = "ci_sp_str", type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$SPEC_TOOLTIP),
        list(
          field = CNT_ROC$THR, type = "quantitative", title = ROC_PLOT_VAL$ROC$LABELS$THR_TOOLTIP,
          format = ROC_PLOT_VAL$STR_FMT$TWO_DEC
        )
      )
    )
  )

  ref_line_layer <- list(
    data = list(values = list(list(x = 0, y = 0), list(x = 1, y = 1))),
    mark = list(type = "line", strokeDash = c(3, 1)),
    encoding = list(
      x = list(field = "x", type = "quantitative"),
      y = list(field = "y", type = "quantitative"),
      color = list(value = "black")
    )
  )

  se_ci_layer <- list(
    mark = list(type = "rule", strokeDash = c(3, 1)),
    encoding = list(
      y = list(field = CNT_ROC$CI_L_SENS, type = "quantitative"),
      y2 = list(field = CNT_ROC$CI_U_SENS),
      x = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_SPEC}")), type = "quantitative"),
      x2 = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_SPEC}")))
    )
  )

  sp_ci_layer <- list(
    mark = list(type = "rule", strokeDash = c(3, 1)),
    encoding = list(
      y = list(field = CNT_ROC$CI_SENS, type = "quantitative"),
      y2 = list(field = CNT_ROC$CI_SENS),
      x = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_L_SPEC}")), type = "quantitative"),
      x2 = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$CI_U_SPEC}")))
    )
  )

  optimal_cut_layer <- list(
    transform = list(
      list(calculate = glue::glue("datum.{CNT_ROC$OC_TITLE}"), as = "title"),
      list(
        as = "oc_str_sp",
        calculate = glue::glue(
          "''+format(datum.{CNT_ROC$OC_SPEC}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+' ('+format(datum.{CNT_ROC$OC_L_SPEC}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+'-'+format(datum.{CNT_ROC$OC_U_SPEC}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+')'"
        )
      ),
      list(
        as = "oc_str_se",
        calculate = glue::glue(
          "''+format(datum.{CNT_ROC$OC_SENS}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+' ('+format(datum.{CNT_ROC$OC_U_SENS}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+'-'+format(datum.{CNT_ROC$OC_L_SENS}, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+')'"
        )
      )
    ),
    mark = "point",
    encoding = list(
      x = list(datum = list(expr = glue::glue("1-datum.{CNT_ROC$OC_SPEC}")), type = "quantitative"),
      y = list(field = CNT_ROC$OC_SENS, type = "quantitative"),
      color = list(
        field = CNT_ROC$OC_TITLE, scale = list(scheme = CNT_VAL$COLOR_SCHEME), title = ROC_PLOT_VAL$ROC$LABELS$OC_TITLE
      ),
      tooltip = list(
        list(field = "title", type = "nominal"),
        list(field = CNT_ROC$PPAR, type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$PRED_TOOLTIP),
        list(field = CNT_ROC$RPAR, type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$RESP_TOOLTIP),
        if (is_grouped) {
          list(
            field = CNT_ROC$GRP,
            type = "nominal",
            title = get_lbl_robust(roc_ds, CNT_ROC$GRP)
          )
        } else {
          NULL
        },
        list(field = "oc_str_sp", type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$SENS_TOOLTIP),
        list(field = "oc_str_se", type = "nominal", title = ROC_PLOT_VAL$ROC$LABELS$SPEC_TOOLTIP),
        list(
          field = CNT_ROC$OC_THR, type = "quantitative", title = ROC_PLOT_VAL$ROC$LABELS$THR_TOOLTIP,
          format = ROC_PLOT_VAL$STR_FMT$TWO_DEC
        )
      )
    )
  )

  layer <- list(
    ref_line_layer,
    se_ci_layer,
    sp_ci_layer,
    ci_rect_layer,
    line_layer,
    point_layer,
    optimal_cut_layer
  )

  spec[["spec"]] <- list(
    layer = layer,
    width = fig_size,
    height = fig_size
  )

  spec[["facet"]] <- list(
    field = CNT_ROC$PPAR,
    sort = list(op = "mean", field = "auc_sort", order = "descending"),
    title = get_lbl_robust(full_ds, CNT_ROC$PPAR)
  )
  spec[["columns"]] <- 4

  vegawidget::as_vegaspec(spec)
}

# here

#' Specification for an ordered AUC value plus CI chart
#'
#' The chart consists of a set of points with confidence intervals representing the AUC and its confidence interval.
#'
#' Parameters, by default, are vertically ordered from highest to lowest AUC curve.
#' When grouped, parameters will be combined with the grouping variable.
#'
#' @section Internal checks:
#'
#' ## Shiny validation errors:
#'
#' - If the number of rows returned is greater than `ROC_VAL$MAX_ROWS_EXPLORE` a validation error is produced.
#' Otherwise the chart is too large, for greater limits than `ROC_VAL$MAX_ROWS_EXPLORE` the session may crash.
#'
#' @section Input dataframe list:
#'
#' ## `ds`
#'
#' `r doc_templates()[["get_roc_data_return_roc_curve"]]`
#'
#' @param ds `[data.frame()]`
#'
#' A data.frame
#'
#' @param fig_size `[numeric(1)]`
#'
#' Size in pixels for the chart
#'
#' @param sort_alph `[logical(1)]`
#'
#' Sort chart by parameter name
#'
#' @return
#'
#' A [vegawidget] specification
#'
#' @keywords internal
#'
get_explore_roc_spec <- function(ds, fig_size, sort_alph) {
  is_grouped <- CNT_ROC$GRP %in% names(ds)

  shiny::validate(
    shiny::need(
      nrow(ds) < ROC_VAL$MAX_ROWS_EXPLORE,
      ROC_MSG$ROC$VALIDATE$TOO_MANY_ROWS_EXPLORE
    )
  )


  if (sort_alph) {
    ds <- ds |>
      dplyr::mutate(
        # relevel required otherwise sort acts on level order and not alphabetically
        !!CNT_ROC$PPAR := factor(.data[[CNT_ROC$PPAR]], levels = sort(levels(.data[[CNT_ROC$PPAR]])))
      ) |>
      dplyr::arrange(.data[[CNT_ROC$PPAR]], dplyr::desc(.data[[CNT_ROC$AUC]]))
  } else {
    ds <- dplyr::arrange(ds, dplyr::desc(.data[[CNT_ROC$AUC]]))
  }

  ds <- dplyr::mutate(
    ds,
    "_sort" := dplyr::row_number()
  )

  ds <- if (is_grouped) {
    dplyr::mutate(
      ds,
      !!CNT_ROC$PPAR := paste(.data[[CNT_ROC$PPAR]], "-", .data[[CNT_ROC$GRP]])
    )
  } else {
    ds
  }

  spec <- list(
    `$schema` = vegawidget::vega_schema(), # specifies Vega-Lite
    usermeta = list(embedOptions = CNT_VAL$EMBED_OPTIONS),
    data = list(values = ds),
    width = fig_size,
    encoding = list(
      x = list(
        field = CNT_ROC$AUC,
        type = "quantitative",
        axis = list(
          title = "AUC"
        ),
        scale = list("domain" = c(0, 1))
      ),
      y = list(
        field = CNT_ROC$PPAR,
        type = "nominal",
        axis = list(
          title = "Parameter"
        ),
        sort = list("field" = "_sort", "order" = "ascending")
      )
    ),
    layer = list(
      list(
        encoding = list(
          color = list(
            field = if (is_grouped) CNT_ROC$GRP else CNT_ROC$PPAR, # If grouped we color by group
            type = "nominal",
            scale = list(scheme = CNT_VAL$COLOR_SCHEME),
            legend = list(
              title = if (is_grouped) get_lbl_robust(ds, CNT_ROC$GRP) else get_lbl_robust(ds, CNT_ROC$PPAR),
              values = if (is_grouped) as.list(unique(ds[[CNT_ROC$GRP]])) else as.list(unique(ds[[CNT_ROC$PPAR]]))
            )
          )
        ),
        mark = "point"
      ),
      list(
        mark = "rule",
        encoding = list(
          color = list(
            field = if (is_grouped) CNT_ROC$GRP else CNT_ROC$PPAR, # If grouped we color by group
            type = "nominal",
            scale = list(scheme = CNT_VAL$COLOR_SCHEME),
            legend = list(
              title = if (is_grouped) get_lbl_robust(ds, CNT_ROC$GRP) else get_lbl_robust(ds, CNT_ROC$PPAR),
              values = if (is_grouped) as.list(unique(ds[[CNT_ROC$GRP]])) else as.list(unique(ds[[CNT_ROC$PPAR]]))
            )
          ),
          x = list(
            field = CNT_ROC$L_AUC,
            type = "quantitative",
            axis = list(
              title = "AUC"
            )
          ),
          x2 = list(field = CNT_ROC$U_AUC)
        )
      )
    )
  )

  vegawidget::as_vegaspec(spec)
}

#' Specification for a set of faceted histograms
#'
#' The chart consists of a faceted set of ROC curves plotting histograms for the values of the different predictor
#' parameters. Each facet will be grouped by the value of the response parameter.
#'
#' @details
#'
#' ## Rows and columns:
#'
#'   - By default, predictor parameters are displayed in rows while grouping is displayed in columns.
#'
#'   - If no grouping is selected, then parameters are displayed in cols.
#'
#'   - All groups corresponding to the same parameters share the same X and Y axis limits.
#'
#' @section Input dataframe:
#'
#' `r doc_templates()[["subset_data_return"]]`
#'
#' @param ds `[data.frames()]`
#'
#' A dataframe
#'
#' @param param_as_cols `[logical(1)]`
#'
#' Charts are faceted using parameters as columns.
#'
#' @param fig_size `[numeric(1)]`
#'
#' Size in pixels for each of the charts in the facet
#'
#'
#' @return
#'
#' A [vegawidget] specification
#'
#' @keywords internal
#'
get_histo_spec <- function(ds, param_as_cols, fig_size) {
  is_grouped <- CNT_ROC$GRP %in% names(ds)
  is_multipar <- length(unique(ds[[CNT_ROC$PPAR]])) > 1

  spec <- list(
    `$schema` = vegawidget::vega_schema(), # specifies Vega-Lite
    usermeta = list(embedOptions = CNT_VAL$EMBED_OPTIONS),
    data = list(values = ds)
  )

  layer <- list(
    list(
      mark = list(type = "rect"),
      encoding = list(
        x = list(
          field = CNT_ROC$BIN_START,
          type = "quantitative",
          axis = list(
            title = "Value"
          ),
          scale = list(zero = FALSE)
        ),
        x2 = list(
          field = CNT_ROC$BIN_END
        ),
        y = list(
          field = CNT_ROC$BIN_COUNT,
          type = "quantitative",
          axis = list(
            title = "Count"
          )
        ),
        y2 = list(
          datum = 0
        ),
        color = list(
          field = CNT_ROC$RVAL,
          type = "nominal",
          scale = list(scheme = CNT_VAL$COLOR_SCHEME),
          legend = list(
            title = "Response"
          )
        ),
        opacity = list(value = 0.7)
      )
    )
  )



  spec[["spec"]] <- list(
    layer = layer,
    width = fig_size,
    height = fig_size
  )

  spec[["resolve"]] <- list(
    scale = list(
      x = "independent",
      y = "independent"
    )
  )

  if (is_grouped) {
    if (is_multipar) {
      facet_par <- list(
        field = CNT_ROC$PPAR,
        title = "Parameter"
      )
      facet_grp <- list(
        field = CNT_ROC$GRP,
        title = get_lbl_robust(ds, CNT_ROC$GRP)
      )
      if (param_as_cols) {
        spec[["facet"]] <- list(column = facet_par, row = facet_grp)
      } else {
        spec[["facet"]] <- list(column = facet_grp, row = facet_par)
      }
    } else {
      spec[["facet"]] <- list(
        column = list(
          field = CNT_ROC$GRP,
          title = get_lbl_robust(ds, CNT_ROC$GRP)
        )
      )
    }
  } else {
    spec[["facet"]] <- list(
      column = list(field = CNT_ROC$PPAR, title = "Parameter")
    )
  }

  vegawidget::as_vegaspec(spec)
}

#' Specification for a set of faceted probability density plots
#'
#' The chart consists of a faceted set of ROC curves plotting probability density curves for the values of
#' the different predictor parameters. Each facet will be grouped by the value of the response parameter.
#'
#' @details
#'
#' ## Rows and columns:
#'
#'   - By default, predictor parameters are displayed in rows while grouping is displayed in columns.
#'
#'   - If no grouping is selected, then parameters are displayed in cols.
#'
#'   - All groups corresponding to the same parameters share the same X and Y axis limits.
#'
#' @section Input dataframe:
#'
#' `r doc_templates()[["get_dens_data_return"]]`
#'
#' @param ds `[data.frames()]`
#'
#' A dataframe
#'
#' @param param_as_cols `[logical(1)]`
#'
#' Charts are faceted using parameters as columns.
#'
#' @param fig_size `[numeric(1)]`
#'
#' Size in pixels for each of the charts in the facet
#'
#'
#' @return
#'
#' A [vegawidget] specification
#'
#' @keywords internal
#'
get_dens_spec <- function(ds, param_as_cols, fig_size) {
  # REFACT: Limits can be included akin to those in histo plots, it makes the dataset bigger but nicer, maybe passing
  # the dataset and joining is an option

  is_grouped <- CNT_ROC$GRP %in% names(ds)
  is_multipar <- length(unique(ds[[CNT_ROC$PPAR]])) > 1

  if (is_grouped) {
    grp_var <- c(CNT_ROC$PPAR, CNT_ROC$GRP, CNT_ROC$RVAL)
    # Add dummy values at the extremes
    max_x <- ds |>
      dplyr::group_by(dplyr::across(dplyr::all_of(grp_var))) |>
      dplyr::summarise(
        !!CNT_ROC$DENS_X := max(.data[[CNT_ROC$DENS_X]])
      ) |>
      dplyr::ungroup(dplyr::all_of(CNT_ROC$GRP)) |>
      dplyr::mutate(
        !!CNT_ROC$DENS_X := max(.data[[CNT_ROC$DENS_X]]),
        !!CNT_ROC$DENS_Y := NA
      )
    min_x <- ds |>
      dplyr::group_by(dplyr::across(dplyr::all_of(grp_var))) |>
      dplyr::summarise(
        !!CNT_ROC$DENS_X := min(.data[[CNT_ROC$DENS_X]])
      ) |>
      dplyr::ungroup(dplyr::all_of(CNT_ROC$GRP)) |>
      dplyr::mutate(
        !!CNT_ROC$DENS_X := min(.data[[CNT_ROC$DENS_X]]),
        !!CNT_ROC$DENS_Y := NA
      )

    max_y <- ds |>
      dplyr::group_by(dplyr::across(dplyr::all_of(grp_var))) |>
      dplyr::summarise(
        !!CNT_ROC$DENS_Y := max(.data[[CNT_ROC$DENS_Y]])
      ) |>
      dplyr::ungroup(dplyr::all_of(CNT_ROC$GRP)) |>
      dplyr::mutate(
        !!CNT_ROC$DENS_Y := max(.data[[CNT_ROC$DENS_Y]]),
        !!CNT_ROC$DENS_X := NA
      )

    min_y <- ds |>
      dplyr::group_by(dplyr::across(dplyr::all_of(grp_var))) |>
      dplyr::summarise(
        !!CNT_ROC$DENS_Y := min(.data[[CNT_ROC$DENS_Y]])
      ) |>
      dplyr::ungroup(dplyr::all_of(CNT_ROC$GRP)) |>
      dplyr::mutate(
        !!CNT_ROC$DENS_Y := min(.data[[CNT_ROC$DENS_Y]]),
        !!CNT_ROC$DENS_X := NA
      )
    # Add a point per parameter and group rval can be any

    # The order of the binding is relevant, vega overwrites points depending on the order in the dataframe, therefore
    # this is the proper way
    ds <- dplyr::bind_rows(min_x, min_y, ds, max_x, max_y) |>
      # Binding rows removes labels. Reassigned from the original dataset
      set_lbl(CNT_ROC$GRP, get_lbl_robust(ds, CNT_ROC$GRP))
  }


  spec <- list(
    `$schema` = vegawidget::vega_schema(), # specifies Vega-Lite
    usermeta = list(embedOptions = CNT_VAL$EMBED_OPTIONS),
    data = list(values = ds)
  )

  encoding <- list(
    x = list(
      field = CNT_ROC$DENS_X,
      type = "quantitative",
      stack = FALSE,
      axis = list(
        title = "Value"
      )
    ),
    y = list(
      field = CNT_ROC$DENS_Y,
      type = "quantitative",
      stack = FALSE,
      axis = list(
        title = "Density"
      )
    ),
    color = list(
      field = CNT_ROC$RVAL,
      type = "nominal",
      stack = FALSE,
      scale = list(scheme = CNT_VAL$COLOR_SCHEME),
      legend = list(
        title = "Response"
      )
    ),
    opacity = list(value = 0.7)
  )

  layer <- list(
    list(mark = list(type = "area"))
  )

  spec[["spec"]] <- list(
    encoding = encoding,
    layer = layer,
    width = fig_size,
    height = fig_size
  )

  spec[["resolve"]] <- list(
    scale = list(
      x = "independent",
      y = "independent"
    )
  )

  if (is_grouped) {
    if (is_multipar) {
      facet_par <- list(
        field = CNT_ROC$PPAR,
        title = "Parameter"
      )
      facet_grp <- list(
        field = CNT_ROC$GRP,
        title = get_lbl_robust(ds, CNT_ROC$GRP)
      )
      if (param_as_cols) {
        spec[["facet"]] <- list(column = facet_par, row = facet_grp)
      } else {
        spec[["facet"]] <- list(column = facet_grp, row = facet_par)
      }
    } else {
      spec[["facet"]] <- list(
        column = list(
          field = CNT_ROC$GRP,
          title = get_lbl_robust(ds, CNT_ROC$GRP)
        )
      )
    }
  } else {
    spec[["facet"]] <- list(
      column = list(field = CNT_ROC$PPAR, title = "Parameter")
    )
  }

  vegawidget::as_vegaspec(spec)
}

#' Specification for a set of raincloud plots
#'
#' The chart consists of a faceted set of raincloud. Each facet will be grouped by the value of the response parameter.
#'
#' @details
#'
#' ## Rows and columns:
#'
#'   - By default, predictor parameters are displayed in rows while grouping is displayed in columns.
#'
#'   - If no grouping is selected, then parameters are displayed in cols.
#'
#' @section Input dataframe list:
#'
#' ## `area_ds`
#'
#' `r doc_templates()[["get_dens_data_return"]]`
#'
#' ## `quantile_ds`
#'
#' `r doc_templates()[["get_quantile_data_return"]]`
#'
#' ## `point_ds`
#'
#' `r doc_templates()[["subset_data_return"]]`
#'
#' @param area_ds,quantile_ds,point_ds `[data.frames()]`
#'
#' A dataframe
#'
#' @param param_as_cols `[logical(1)]`
#'
#' Charts are faceted using parameters as columns.
#'
#' @param fig_size `[numeric(1)]`
#'
#' Size in pixels for each of the charts in the facet
#'
#'
#' @return
#'
#' A [vegawidget] specification
#'
#' @keywords internal
#'
get_raincloud_spec <- function(area_ds, quantile_ds, point_ds, param_as_cols, fig_size) {
  is_grouped <- CNT_ROC$GRP %in% names(area_ds)
  is_multipar <- length(unique(area_ds[[CNT_ROC$PPAR]])) > 1

  r_levels <- levels(area_ds[[CNT_ROC$RVAL]])
  y_offset <- stats::setNames(c(1 / 4, 3 / 4), r_levels)
  bottom_padding <- 1 / 4 * 0.1
  top_padding <- 1 / 4 * 0.05
  area_height <- 1 / 4 - (bottom_padding + top_padding)

  area_ds <- dplyr::group_by(area_ds, dplyr::across(dplyr::all_of(c(CNT_ROC$RVAL, CNT_ROC$PPAR)))) |>
    dplyr::mutate(
      y = ((.data[[CNT_ROC$DENS_Y]] / max(.data[[CNT_ROC$DENS_Y]])) * (area_height)),
      y0 = y_offset[[dplyr::cur_group()[[CNT_ROC$RVAL]]]] + bottom_padding,
      y2 = -.data[["y"]],
      y = .data[["y"]] + y_offset[[dplyr::cur_group()[[CNT_ROC$RVAL]]]] + bottom_padding,
      y2 = .data[["y2"]] + y_offset[[dplyr::cur_group()[[CNT_ROC$RVAL]]]] - bottom_padding
    ) |>
    dplyr::ungroup()

  quantile_ds <- dplyr::group_by(quantile_ds, dplyr::across(CNT_ROC$RVAL)) |>
    dplyr::mutate(
      q_y = y_offset[[dplyr::cur_group()[[CNT_ROC$RVAL]]]]
    ) |>
    dplyr::ungroup()

  point_ds <- dplyr::group_by(point_ds, dplyr::across(dplyr::any_of(c(CNT_ROC$RVAL, CNT_ROC$PPAR, CNT_ROC$GRP)))) |>
    dplyr::mutate(
      p_y = {
        # Find the closest in the group
        dsf <- area_ds[
          area_ds[[CNT_ROC$RVAL]] == dplyr::cur_group()[[CNT_ROC$RVAL]] &
            area_ds[[CNT_ROC$PPAR]] == dplyr::cur_group()[[CNT_ROC$PPAR]] &
            if (is_grouped) (area_ds[[CNT_ROC$GRP]] == dplyr::cur_group()[[CNT_ROC$GRP]]) else TRUE,
        ]
        purrr::map_dbl(.data[[CNT_ROC$PVAL]], function(x) {
          wm <- which.min(abs(dsf[[CNT_ROC$DENS_X]] - x))
          y <- y_offset[[dplyr::cur_group()[[CNT_ROC$RVAL]]]] - bottom_padding
          y2 <- dsf[["y2"]][[wm]]
          stats::runif(1, min = y2, max = y)
        })
      }
    ) |>
    dplyr::ungroup()

  max_x <- dplyr::group_by(area_ds, dplyr::across(dplyr::any_of(c(CNT_ROC$RVAL, CNT_ROC$PPAR, CNT_ROC$GRP)))) |>
    dplyr::summarise(
      lim_x = max(.data[[CNT_ROC$DENS_X]])
    ) |>
    (function(x) {
      if (is_grouped) dplyr::mutate(x, lim_x = max(.data[["lim_x"]])) else x
    })()

  min_x <- dplyr::group_by(area_ds, dplyr::across(dplyr::any_of(c(CNT_ROC$RVAL, CNT_ROC$PPAR, CNT_ROC$GRP)))) |>
    dplyr::summarise(
      lim_x = min(.data[[CNT_ROC$DENS_X]])
    ) |>
    (function(x) {
      if (is_grouped) dplyr::mutate(x, lim_x = max(.data[["lim_x"]])) else x
    })()

  joint_data <- dplyr::bind_rows(area_ds, point_ds, max_x, min_x, quantile_ds)
  joint_data <- dplyr::select(joint_data, -dplyr::all_of(c(CNT_ROC$RPAR)))

  spec <- list(
    `$schema` = vegawidget::vega_schema(), # specifies Vega-Lite
    usermeta = list(embedOptions = CNT_VAL$EMBED_OPTIONS),
    data = list(values = joint_data)
  )

  encoding <- list(
    color = list(
      field = CNT_ROC$RVAL,
      type = "nominal",
      scale = list(scheme = CNT_VAL$COLOR_SCHEME),
      legend = list(
        title = get_lbl_robust(point_ds, CNT_ROC$RPAR)
      ),
      sort = list(value = r_levels)
    ),
    opacity = list(value = 0.4)
  )

  real_layer <- list(
    list(
      mark = list(type = "area"),
      encoding = list(
        x = list(
          field = CNT_ROC$DENS_X,
          type = "quantitative",
          axis = list(
            title = "Value"
          )
        ),
        y = list(
          field = "y",
          type = "quantitative",
          "scale" = list("domain" = c(0, 1)),
          axis = NULL
        ),
        y2 = list(
          field = "y0"
        ),
        opacity = list(value = 0.4)
      )
    ),
    list(
      mark = list(type = "line"),
      encoding = list(
        strokeWidth = list(value = .5),
        x = list(
          field = "x",
          type = "quantitative"
        ),
        y = list(
          field = "y",
          type = "quantitative",
          "scale" = list("domain" = c(0, 1)),
          axis = NULL
        )
      )
    ),
    list(
      mark = list(type = "line"),
      encoding = list(
        strokeWidth = list(value = .5),
        x = list(
          field = "x",
          type = "quantitative"
        ),
        y = list(
          field = "y0",
          type = "quantitative",
          "scale" = list("domain" = c(0, 1)),
          axis = NULL
        )
      )
    ),
    list(
      mark = list(type = "point", tooltip = list(content = "data"), filled = TRUE),
      encoding = list(
        x = list(
          field = CNT_ROC$PVAL,
          type = "quantitative"
        ),
        y = list(
          field = "p_y",
          type = "quantitative",
          "scale" = list("domain" = c(0, 1)),
          axis = NULL
        ),
        tooltip = list(
          list(field = CNT_ROC$SBJ, type = "nominal", title = ROC_PLOT_VAL$RAINCLOUD$LABELS$SBJ_TOOLTIP),
          list(field = CNT_ROC$PPAR, type = "nominal", title = ROC_PLOT_VAL$RAINCLOUD$LABELS$PPAR_TOOLTIP),
          list(
            field = CNT_ROC$PVAL, type = "quantitative", title = ROC_PLOT_VAL$RAINCLOUD$LABELS$PVAL_TOOLTIP,
            format = ROC_PLOT_VAL$STR_FMT$TWO_DEC
          ),
          list(field = CNT_ROC$RVAL, type = "nominal", title = ROC_PLOT_VAL$RAINCLOUD$LABELS$RVAL_TOOLTIP)
        )
      )
    ),
    list(
      transform = list(
        list(
          as = "q25_75",
          calculate = glue::glue(
            "'['+format(datum.q25, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+', '+format(datum.q75, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+']'"
          )
        ),
        list(
          as = "q05_95",
          calculate = glue::glue(
            "'['+format(datum.q05, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+', '+format(datum.q95, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+']'"
          )
        )
      ),
      mark = list(type = "rule", tooltip = list(content = "data")),
      encoding = list(
        x = list(
          field = "q05",
          type = "quantitative"
        ),
        x2 = list(
          field = "q95"
        ),
        y = list(
          field = "q_y",
          type = "quantitative",
          "scale" = list("domain" = c(0, 1)),
          axis = NULL
        ),
        opacity = list(value = 1),
        size = list(value = 2),
        tooltip = list(
          list(field = "mean", type = "nominal", title = "Mean", format = ROC_PLOT_VAL$STR_FMT$TWO_DEC),
          list(field = "q50", type = "nominal", title = "Median", format = ROC_PLOT_VAL$STR_FMT$TWO_DEC),
          list(field = "q25_75", type = "nominal", title = "[25%, 75%]"),
          list(field = "q05_95", type = "nominal", title = "[ 5%, 95%]")
        )
      )
    ),
    list(
      transform = list(
        list(
          as = "q25_75",
          calculate = glue::glue(
            "'['+format(datum.q25, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+', '+format(datum.q75, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+']'"
          )
        ),
        list(
          as = "q05_95",
          calculate = glue::glue(
            "'['+format(datum.q05, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+', '+format(datum.q95, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+']'"
          )
        )
      ),
      mark = list(type = "rule", tooltip = list(content = "data")),
      encoding = list(
        x = list(
          field = "q25",
          type = "quantitative"
        ),
        x2 = list(
          field = "q75"
        ),
        y = list(
          field = "q_y",
          type = "quantitative",
          "scale" = list("domain" = c(0, 1)),
          axis = NULL
        ),
        opacity = list(value = 1),
        size = list(value = 4),
        tooltip = list(
          list(field = "mean", type = "nominal", title = "Mean", format = ROC_PLOT_VAL$STR_FMT$TWO_DEC),
          list(field = "q50", type = "nominal", title = "Median", format = ROC_PLOT_VAL$STR_FMT$TWO_DEC),
          list(field = "q25_75", type = "nominal", title = "[25%, 75%]"),
          list(field = "q05_95", type = "nominal", title = "[5%, 95%]")
        )
      )
    ),
    list(
      transform = list(
        list(
          as = "q25_75",
          calculate = glue::glue(
            "'['+format(datum.q25, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+', '+format(datum.q75, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+']'"
          )
        ),
        list(
          as = "q05_95",
          calculate = glue::glue(
            "'['+format(datum.q05, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+', '+format(datum.q95, '{ROC_PLOT_VAL$STR_FMT$TWO_DEC}')+']'"
          )
        )
      ),
      mark = list(type = "point", tooltip = list(content = "data")),
      encoding = list(
        x = list(
          field = "q50",
          type = "quantitative"
        ),
        y = list(
          field = "q_y",
          type = "quantitative",
          "scale" = list("domain" = c(0, 1)),
          axis = NULL
        ),
        opacity = list(value = 1),
        tooltip = list(
          list(field = "mean", type = "nominal", title = "Mean", format = ROC_PLOT_VAL$STR_FMT$TWO_DEC),
          list(field = "q50", type = "nominal", title = "Median", format = ROC_PLOT_VAL$STR_FMT$TWO_DEC),
          list(field = "q25_75", type = "nominal", title = "[25%, 75%]"),
          list(field = "q05_95", type = "nominal", title = "[5%, 95%]")
        )
      )
    )
  )

  dummy_layer <- list(
    list(
      mark = list(type = "point"),
      encoding = list(
        x = list(
          field = "lim_x",
          type = "quantitative"
        ),
        y = list(
          field = CNT_ROC$RVAL,
          type = "nominal",
          axis = list(title = NULL)
        ),
        opacity = list(value = 0)
      )
    )
  )

  spec[["spec"]] <- list(
    encoding = encoding,
    layer = c(real_layer, dummy_layer),
    width = fig_size,
    height = fig_size
  )

  spec[["resolve"]] <- list(
    scale = list(
      x = if (!is_multipar && is_grouped) "shared" else "independent",
      y = "independent"
    )
  )

  if (is_grouped) {
    if (is_multipar) {
      facet_par <- list(
        field = CNT_ROC$PPAR,
        title = get_lbl_robust(area_ds, CNT_ROC$PPAR)
      )
      facet_grp <- list(
        field = CNT_ROC$GRP,
        title = get_lbl_robust(area_ds, CNT_ROC$GRP)
      )
      if (param_as_cols) {
        spec[["facet"]] <- list(column = facet_par, row = facet_grp)
      } else {
        spec[["facet"]] <- list(column = facet_grp, row = facet_par)
      }
    } else {
      spec[["facet"]] <- list(
        column = list(
          field = CNT_ROC$GRP,
          title = get_lbl_robust(area_ds, CNT_ROC$GRP)
        )
      )
    }
  } else {
    spec[["facet"]] <- list(
      column = list(field = CNT_ROC$PPAR, title = get_lbl_robust(point_ds, CNT_ROC$PPAR))
    )
  }

  spec |> vegawidget::as_vegaspec(spec)
}

#' Specification for a set of line plots for classification metrics
#'
#' The chart consists of a faceted set of line and point charts.
#'
#' @details
#'
#' ## Rows and columns:
#'
#'   - By default, predictor parameters are displayed in rows while metrics are displayed in columns.
#'
#' @section Input:
#'
#' ## `ds`
#'
#' `r doc_templates()[["get_metric_data_return_ds"]]`
#'
#' ## `limits`
#'
#' `r doc_templates()[["get_metric_data_return_limits"]]`
#'
#' @param ds `[data.frames()]`
#'
#' A dataframe
#'
#' @param param_as_cols `[logical(1)]`
#'
#' Charts are faceted using parameters as columns.
#'
#' @param fig_size `[numeric(1)]`
#'
#' Size in pixels for each of the charts in the facet
#'
#' @param limits `[list()]`
#'
#' A vector as specified in the input section
#'
#' @param x_col `[character(1)]`
#'
#' Column for the x axis of the graph
#'
#' @return
#'
#' A [vegawidget] specification
#'
#' @keywords internal
#'
get_metric_spec <- function(ds, param_as_cols, fig_size, limits, x_col) {
  is_grouped <- CNT_ROC$GRP %in% names(ds)
  is_multipar <- length(unique(ds[[CNT_ROC$PPAR]])) > 1

  shiny::validate(
    shiny::need(
      x_col %in% names(ds),
      ROC_MSG$ROC$VALIDATE$X_COL_METRICS_NOT_IN_DS
    )
  )

  limits_to_df <- function(d, l, l_x) {
    lhs <- purrr::imap_dfr(l, function(v, n) {
      data.frame(type = n, lim_y = v, lim_x = l_x)
    })
    rhs <- dplyr::distinct(
      d,
      dplyr::across(dplyr::any_of(
        c(
          CNT_ROC$PPAR,
          CNT_ROC$GRP,
          CNT_ROC$RPAR,
          "type"
        )
      ))
    )
    dplyr::left_join(lhs, rhs, by = "type", multiple = "all", relationship = "many-to-many")
  }

  limits_df <- limits_to_df(ds, limits, min(ds[[x_col]]))
  lbls <- get_lbls(ds)
  ds <- dplyr::bind_rows(ds, limits_df) |>
    possibly_set_lbls(lbls)


  encoding <- list(
    x = list(
      field = x_col,
      type = "quantitative",
      title = get_lbl_robust(ds, x_col)
    ),
    y = list(
      field = "y",
      title = NA,
      type = "quantitative"
    ),
    color = list(
      field = if (is_grouped) CNT_ROC$GRP else CNT_ROC$RPAR,
      type = "nominal",
      scale = list(scheme = "magma"),
      legend = list(
        title = if (is_grouped) get_lbl_robust(ds, CNT_ROC$GRP) else get_lbl_robust(ds, CNT_ROC$RPAR)
      )
    )
  )

  layer <- list(
    list(mark = list(type = "line")),
    list(mark = list(type = "point", tooltip = list(content = "data"))),
    # dummy layer
    list(
      mark = list(type = "point"),
      encoding = list(
        x = list(field = "lim_x", type = "quantitative"),
        y = list(field = "lim_y", type = "quantitative"),
        opacity = list(value = 0)
      )
    )
  )

  spec <- list(
    `$schema` = vegawidget::vega_schema(), # specifies Vega-Lite
    usermeta = list(embedOptions = CNT_VAL$EMBED_OPTIONS),
    data = list(values = ds)
  )

  spec[["spec"]] <- list(
    encoding = encoding,
    layer = layer,
    width = fig_size,
    height = fig_size
  )

  facet_par <- list(
    field = CNT_ROC$PPAR,
    title = NA
  )
  facet_met <- list(field = "type", title = NA)

  if (is_multipar) {
    if (param_as_cols) {
      spec[["facet"]] <- list(column = facet_par, row = facet_met)
    } else {
      spec[["facet"]] <- list(
        column = facet_met, row = facet_par,
        header = list("labelFontWeight" = "bold")
      )
    }
  } else {
    spec[["facet"]] <- list(column = facet_met, row = facet_par)
  }

  spec[["resolve"]] <- list(scale = list("x" = "shared", "y" = "independent"))

  spec[["config"]] <- list(header = list("labelFontWeight" = "bold"))

  vegawidget::as_vegaspec(spec)
}

#' GT Summary table for the area under the curve, optimal cut data and their confidence intervals
#'
#' The table summarizes the AUC, the optimal cut data, for each parameter and grouping combination
#'
#' Numerical values are rounded to two decimals
#'
#' @section Input:
#'
#' `r doc_templates()[["get_summary_data_return"]]`
#'
#' @param ds `[data.frames()]`
#'
#' A dataframe
#'
#' @param rounder `[function()]`
#'
#' Single parameter function that rounds a numeric vector for rendendering
#'
#' @param sort_alph `[logical(1)]`
#'
#' Sort summary table by parameter name
#'
#' @return
#'
#' A [vegawidget] specification
#'
#' @keywords internal
#'
get_gt_summary_table <- function(ds, rounder = function(x) round(x, digits = 2), sort_alph) {
  response_param <- unique(ds[[CNT_ROC$RPAR]])
  oc_titles <- unique(ds[[CNT_ROC$OC_TITLE]])
  rounded_colums <- c(
    CNT_ROC$AUC, CNT_ROC$L_AUC, CNT_ROC$U_AUC,
    CNT_ROC$OC_SENS, CNT_ROC$OC_SPEC, CNT_ROC$OC_THR,
    CNT_ROC$OC_U_SPEC, CNT_ROC$OC_L_SPEC, CNT_ROC$OC_U_SENS, CNT_ROC$OC_L_SENS
  )

  ci_formatter <- function(l, u) paste0("[", l, ", ", u, "]")

  ds <- dplyr::mutate(
    ds,
    dplyr::across(dplyr::all_of(rounded_colums), rounder),
    dplyr::across(dplyr::all_of(rounded_colums), function(x) {
      sprintf("%.02f", x)
    }),
    dir_str = purrr::map2_chr(.data[[CNT_ROC$LEV]], .data[[CNT_ROC$DIR]], ~ paste(.x, collapse = .y))
  )

  ds <- dplyr::mutate(
    ds,
    AUC = as.numeric(.data[[CNT_ROC$AUC]]),
    AUC_95 = ci_formatter(.data[[CNT_ROC$L_AUC]], .data[[CNT_ROC$U_AUC]]),
    Sensitivity = .data[[CNT_ROC$OC_SENS]],
    Sensitivity_95 = ci_formatter(.data[[CNT_ROC$OC_L_SENS]], .data[[CNT_ROC$OC_U_SENS]]),
    Specificity = .data[[CNT_ROC$OC_SPEC]],
    Specificity_95 = ci_formatter(.data[[CNT_ROC$OC_L_SPEC]], .data[[CNT_ROC$OC_U_SPEC]]),
    Threshold = .data[[CNT_ROC$OC_THR]],
    Direction = .data[["dir_str"]]
  )

  ds <- dplyr::select(
    ds,
    dplyr::any_of(
      c(
        CNT_ROC$PPAR, CNT_ROC$GRP, "AUC", "AUC_95", "Sensitivity", "Sensitivity_95",
        "Specificity", "Specificity_95", "Threshold", CNT_ROC$OC_TITLE, "Direction"
      )
    )
  )

  # CNT_VAL$ASCII_DELIM Non standard ASCII character, unlikely to have
  # a collision but controlled below in case it appears.

  if (any(grepl(CNT_VAL$ASCII_DELIM, ds[[CNT_ROC$OC_TITLE]]))) {
    rlang::abort(
      glue::glue(
        "Optimal cut title contains the ASCII character with code \\{utf8ToInt(CNT_VAL$ASCII_DELIM)}. This character is used as a delimitator. Please remove this character from the optimal cut title."
      )
    )
  }

  wide_ds <- tidyr::pivot_wider(ds,
    names_glue = glue::glue("{{{CNT_ROC$OC_TITLE}}}{CNT_VAL$ASCII_DELIM}{{.value}}"),
    names_from = CNT_ROC$OC_TITLE,
    values_from = c("Sensitivity", "Sensitivity_95", "Specificity", "Specificity_95", "Threshold"),
    values_fn = list
  )

  if (sort_alph) {
    wide_ds <- dplyr::arrange(wide_ds, .data[["predictor_parameter"]], dplyr::desc(as.numeric(.data[["AUC"]])))
  } else {
    wide_ds <- dplyr::arrange(wide_ds, dplyr::desc(as.numeric(.data[["AUC"]])))
  }

  wide_ds <- dplyr::mutate(
    wide_ds,
    dplyr::across(
      dplyr::where(is.list),
      function(col) {
        purrr::map_chr(col, ~ if (!is.null(.x)) paste(.x, collapse = ", ") else "")
      }
    )
  )

  # Columns must be sorted otherwise column grouping in gt does not work well
  wide_ds_col <- names(wide_ds)
  non_oc_col <- c(CNT_ROC$PPAR, CNT_ROC$GRP, "AUC", "AUC_95")
  oc_col <- sort(wide_ds_col[!wide_ds_col %in% non_oc_col])
  sort_wide_ds_col <- c(non_oc_col, oc_col)
  wide_ds <- dplyr::select(wide_ds, dplyr::any_of(sort_wide_ds_col))

  wide_ds <- dplyr::group_by(wide_ds, dplyr::across(c(CNT_ROC$PPAR)))
  t <- gt::gt(wide_ds, groupname_col = CNT_ROC$PPAR, rowname_col = CNT_ROC$GRP)
  t <- gt::tab_header(t, title = gt::md(paste0("**", response_param, "**")))
  t <- gt::tab_spanner_delim(t, delim = CNT_VAL$ASCII_DELIM)
  t <- purrr::reduce(
    oc_titles,
    .init = t,
    function(t, title) {
      sens_col <- paste0(title, CNT_VAL$ASCII_DELIM, "Sensitivity")
      sens_95_col <- paste0(sens_col, "_95")
      spec_col <- paste0(title, CNT_VAL$ASCII_DELIM, "Specificity")
      spec_95_col <- paste0(spec_col, "_95")

      t <- gt::cols_merge(
        t,
        columns = dplyr::all_of(c(sens_col, sens_95_col)),
        pattern = "{1}<br><span style = 'font-size: x-small'><em>{2}</em></span>"
      )

      t <- gt::cols_merge(
        t,
        columns = dplyr::all_of(c(spec_col, spec_95_col)),
        pattern = "{1}<br><span style = 'font-size: x-small'><em>{2}</em></span>"
      )

      sens_label <- stats::setNames(
        list(gt::html("Sensitivity<br><span style = 'font-size: x-small'><em>[95%C.I.]</em></span>")),
        sens_col
      )
      spec_label <- stats::setNames(
        list(gt::html("Specificity<br><span style = 'font-size: x-small'><em>[95%C.I.]</em></span>")),
        spec_col
      )
      t <- gt::cols_label(t, .list = sens_label)
      t <- gt::cols_label(t, .list = spec_label)
      t
    }
  )

  t <- gt::cols_align(t, align = "center")
  t <- gt::tab_style(
    t,
    style = list(gt::cell_text(align = "left")),
    locations = gt::cells_stub(rows = TRUE)
  )
  t <- gt::tab_style(
    t,
    style = list(gt::cell_text(v_align = "top")),
    locations = list(
      gt::cells_column_labels(columns = -c("AUC", "Direction")),
      gt::cells_body(),
      gt::cells_stub(rows = TRUE)
    )
  )
  t <- gt::tab_style(
    t,
    style = list(gt::cell_text(weight = "bold")),
    locations = list(
      gt::cells_row_groups()
    )
  )

  t <- gt::data_color(
    t,
    columns = .data[["AUC"]],
    fn = scales::col_numeric(
      palette = c("white", "#3fc1c9"),
      domain = NULL
    )
  )
  t <- gt::cols_merge(
    t,
    columns = c("AUC", "AUC_95"), pattern = "{1}<br><span style = 'font-size: x-small'><em>{2}</em></span>"
  )
  # non blank space below is included to align the title with the rest of headers
  t <- gt::cols_label(t, Direction = gt::html("Direction<br><span style = 'font-size: x-small'><em>&nbsp</em></span>"))
  t <- gt::cols_label(t, AUC = gt::html("AUC<br><span style = 'font-size: x-small'><em>[95%C.I.]</em></span>"))
  t <- gt::tab_source_note(t, source_note = gt::md("Numerical values are rounded to 2 decimal places"))
  t <- gt::tab_source_note(
    t,
    source_note = gt::md("Color scale domain ranges from the maximum to the minimum AUC value in the table")
  )
  t <- gt::opt_table_lines(t, extent = c("none"))
  t <- gt::tab_options(t,
    row_group.as_column = TRUE,
    column_labels.border.bottom.style = "solid",
    column_labels.border.bottom.width = gt::px(1),
    column_labels.border.bottom.color = "#E0E0E0",
    table_body.border.bottom.style = "solid"
  )

  t <- gt::tab_style(t,
    style = list(gt::cell_text(font = c("Garamond", gt::default_fonts()), style = "italic")),
    locations = list(
      locations = gt::cells_stub(rows = TRUE)
    )
  )

  # Lines
  t <- gt::tab_style(t,
    style = list(gt::cell_borders(sides = "bottom", color = "#E0E0E0")),
    locations = list(
      gt::cells_column_labels()
    )
  )

  t <- gt::opt_css(
    t,
    css = ".gt_row_group_first ~ .gt_row_group_first{border-top-style: dotted;border-width: 1px;border-color: #E0E0E0}"
  )

  t
}

# here

# Composed functions for outputs

#' Composed functions
#'
#' Functions that creates and output to be displayed in the app, usually, by composing data and plotting calls.
#'
#' @name composed
#'
#' @keywords composed internal
#'
NULL

#' @describeIn composed ROC plot
get_roc_plot_output <- function(ds_list, param_as_cols, fig_size, is_sorted) {
  f <- if (is_sorted) get_roc_sorted_spec else get_roc_spec
  f(ds_list, param_as_cols, fig_size)
}

#' @describeIn composed Density plot
get_dens_plot_output <- function(ds, param_as_cols, fig_size) {
  ds |>
    get_dens_data() |>
    get_dens_spec(
      param_as_cols,
      fig_size
    )
}

#' @describeIn composed Density plot
get_histo_plot_output <- function(ds, param_as_cols, fig_size) {
  ds |>
    get_histo_data() |>
    get_histo_spec(
      param_as_cols,
      fig_size
    )
}

#' @describeIn composed Raincloud plot
get_raincloud_output <- function(ds, param_as_cols, fig_size) {
  get_raincloud_spec(
    area_ds = get_dens_data(ds),
    quantile_ds = get_quantile_data(ds),
    point_ds = ds,
    param_as_cols = param_as_cols,
    fig_size = fig_size
  )
}

#' @describeIn composed Metrics plot
get_metrics_output <- function(ds, param_as_cols, fig_size, x_metrics_col, compute_metric_fn) {
  metric_data <- get_metric_data(ds, compute_metric_fn)
  spec <- get_metric_spec(
    ds = metric_data[["ds"]],
    param_as_cols = param_as_cols,
    fig_size = fig_size,
    limits = metric_data[["limits"]],
    x_col = x_metrics_col
  )
  spec
}

#' @describeIn composed GT Summary
get_gt_summary_output <- function(ds_list, sort_alph) {
  ds_list |>
    get_summary_data() |>
    get_gt_summary_table(sort_alph = sort_alph)
}

#' @describeIn composed Info Panel
get_info_panel_output <- function(ds) {
  info_content <- if (is_validation_error(ds)) {
    "Incomplete or incorrect selection"
  } else {
    # Because of the upper is_validation_error the promise is interrupted and throws a warning. Seems to be irrelevant.
    response_levels <- sort(levels(suppressWarnings(ds[[CNT_ROC$RVAL]])))
    shiny::tags[["table"]](
      shiny::tags[["tr"]](
        shiny::tags[["th"]]("Response"),
      ),
      shiny::tags[["tr"]](
        shiny::tags[["td"]](paste(response_levels, collapse = " vs. ")),
      ),
      class = "table table-condensed roc_info_table"
    )
  }
  info_content
}

# Computing helpers

# nocov start

# No testing required for this functions as they are not really part of the module this calculations are
# supposed to be confirmed and provided by the user

#' Helpers for computing ROC data from the subset dataset
#'
#'
#' @details
#'
#'   - Computing CIs for sensitivity and specifity usually implies using bootstrap which can be too expensive,
#'   therefore the option of not running calculating them when the function is invoked is included.
#'
#'   - Response levels are selected alphabetically being `case` the first one alphabetically the comparison direction
#'   is selected automatically by [pROC::roc()] and related functions.
#'
#'   - CIs are expected to be 95% CIs
#'
#' @param r `[list(data.frame())]`
#'
#' dataframe resulting from compute_roc_data
#' @param with_ci `[logical(1)]`
#'
#' Indicates if CI is included in the result
#'
#' @param predictor `[numeric(n)]`
#'
#' The scores of the predictor
#'
#' @param response `[factor(n)]`
#'
#' The response value
#'
#' @param ci_points `[list(spec = numeric(), thr = numeric())]`
#' Points at which 95% confidence intervals for sensitivity and specificity will be calculated. Depending on the entry
#' CI will be calculated at defined specificity points or threshold points.
#'
#' @param do_bootstrap `[logical(1)]`
#' Calculate confidence intervals for sensitivity and specificity
#'
#' @name compute_roc
#'
#' @keywords compute
#'
NULL

#' @describeIn compute_roc Assert compute_roc result data.frame types are correct
assert_compute_roc_data <- function(r, with_ci) {
  min_names <- if (with_ci) {
    c(CNT_ROC$ROC_CURVE, CNT_ROC$ROC_OC, CNT_ROC$ROC_CI)
  } else {
    c(CNT_ROC$ROC_CURVE, CNT_ROC$ROC_OC)
  }
  checkmate::assert_subset(min_names, names(r), .var.name = "names(r)")

  # roc data.frame
  checkmate::assert_data_frame(r[[CNT_ROC$ROC_CURVE]])
  roc_min_names <- c(CNT_ROC$SENS, CNT_ROC$SPEC, CNT_ROC$THR, CNT_ROC$AUC)
  checkmate::assert_subset(roc_min_names, names(r[[CNT_ROC$ROC_CURVE]]),
    .var.name = glue::glue("names(r[[\"{CNT_ROC$ROC_CURVE}\"]])")
  )
  checkmate::assert_numeric(r[[CNT_ROC$ROC_CURVE]][[CNT_ROC$SENS]])
  checkmate::assert_numeric(r[[CNT_ROC$ROC_CURVE]][[CNT_ROC$SPEC]])
  checkmate::assert_numeric(r[[CNT_ROC$ROC_CURVE]][[CNT_ROC$THR]])
  checkmate::assert_character(r[[CNT_ROC$ROC_CURVE]][[CNT_ROC$DIR]])
  checkmate::assert_list(r[[CNT_ROC$ROC_CURVE]][[CNT_ROC$LEVELS]], types = "character")
  checkmate::assert_list(r[[CNT_ROC$ROC_CURVE]][[CNT_ROC$AUC]], types = "numeric")

  # optimal_cut
  checkmate::assert_data_frame(r[[CNT_ROC$ROC_OC]])
  oc_min_names <- c(
    CNT_ROC$OC_TITLE, CNT_ROC$OC_SENS, CNT_ROC$OC_SPEC, CNT_ROC$OC_THR,
    CNT_ROC$OC_U_SPEC, CNT_ROC$OC_L_SPEC, CNT_ROC$OC_U_SENS, CNT_ROC$OC_L_SENS
  )
  checkmate::assert_subset(oc_min_names, names(r[[CNT_ROC$ROC_OC]]),
    .var.name = glue::glue("names(r[[\"{CNT_ROC$ROC_OC}\"]])")
  )
  checkmate::assert_numeric(r[[CNT_ROC$ROC_OC]][[CNT_ROC$OC_SENS]])
  checkmate::assert_numeric(r[[CNT_ROC$ROC_OC]][[CNT_ROC$OC_SPEC]])
  checkmate::assert_numeric(r[[CNT_ROC$ROC_OC]][[CNT_ROC$OC_THR]])
  checkmate::assert_numeric(r[[CNT_ROC$ROC_OC]][[CNT_ROC$OC_U_SPEC]])
  checkmate::assert_numeric(r[[CNT_ROC$ROC_OC]][[CNT_ROC$OC_L_SPEC]])
  checkmate::assert_numeric(r[[CNT_ROC$ROC_OC]][[CNT_ROC$OC_U_SENS]])
  checkmate::assert_numeric(r[[CNT_ROC$ROC_OC]][[CNT_ROC$OC_L_SENS]])
  checkmate::assert_character(r[[CNT_ROC$ROC_OC]][[CNT_ROC$OC_TITLE]])

  if (with_ci) {
    checkmate::assert_data_frame(r[[CNT_ROC$ROC_CI]])
    ci_min_names <- c(
      CNT_ROC$CI_SENS, CNT_ROC$CI_SPEC, CNT_ROC$CI_L_SPEC,
      CNT_ROC$CI_U_SPEC, CNT_ROC$CI_L_SENS, CNT_ROC$CI_U_SENS, CNT_ROC$THR
    )
    checkmate::assert_subset(ci_min_names, names(r[["ci_se_sp"]]),
      .var.name = glue::glue("names(r[[\"{CNT_ROC$ROC_CI}\"]])")
    )
    checkmate::assert_numeric(r[[CNT_ROC$ROC_CI]][[CNT_ROC$CI_SENS]])
    checkmate::assert_numeric(r[[CNT_ROC$ROC_CI]][[CNT_ROC$CI_SPEC]])
    checkmate::assert_numeric(r[[CNT_ROC$ROC_CI]][[CNT_ROC$CI_U_SPEC]])
    checkmate::assert_numeric(r[[CNT_ROC$ROC_CI]][[CNT_ROC$CI_L_SPEC]])
    checkmate::assert_numeric(r[[CNT_ROC$ROC_CI]][[CNT_ROC$CI_U_SENS]])
    checkmate::assert_numeric(r[[CNT_ROC$ROC_CI]][[CNT_ROC$CI_L_SENS]])
    checkmate::assert_numeric(r[[CNT_ROC$ROC_CI]][[CNT_ROC$THR]])
  } else {
    checkmate::assert_null(r[[CNT_ROC$ROC_CI]])
  }
}

#' @describeIn compute_roc Compute ROC analysis
#'
#' @return
#'
#' `[list(data.frame())]`
#'
#' A list with entries:
#'
#' ## ``r CNT_ROC$ROC_CURVE``
#'
#'   `r doc_templates()[["compute_roc_data_return_roc_curve"]]`
#'
#' ## ``r CNT_ROC$ROC_CI``
#'
#'   `r doc_templates()[["compute_roc_data_return_roc_ci"]]`
#'
#' ## ``r CNT_ROC$ROC_OC``
#'
#'   `r doc_templates()[["compute_roc_data_return_roc_oc"]]`
#'
compute_roc_data <- function(predictor,
                             response,
                             do_bootstrap,
                             ci_points) {
  conf_level <- .95
  this_levels <- sort(levels(response)) # Alphabetical order

  r <- list()
  roc <- pROC::roc(
    response = response,
    predictor = predictor,
    ci = TRUE,
    conf.level = conf_level,
    direction = "auto",
    levels = this_levels
  )

  direction <- roc[["direction"]]

  r[["roc_curve"]] <- tibble::tibble(
    sensitivity = roc[["sensitivities"]],
    specificity = roc[["specificities"]],
    threshold = roc[["thresholds"]],
    auc = list(as.numeric(roc[["ci"]])),
    levels = list(roc[["levels"]]),
    direction = roc[["direction"]]
  )

  # Youden Index
  # Note: When AUC <.5 then youden <- pROC::coords(...) returns both extremes
  # Inf and -Inf unsure how to fix this and user's must clarify
  youden <- pROC::coords(roc, x = "best", best.method = "youden")
  if (do_bootstrap) {
    youden_bts_ci_se_sp <- pROC::ci.thresholds(
      roc,
      thresholds = youden[["threshold"]],
      conf.level = conf_level,
      direction = direction,
      levels = this_levels,
      progress = "none"
    )
    youden_ci_se_sp <- list(
      l_sp = youden_bts_ci_se_sp[["specificity"]][, 1],
      u_sp = youden_bts_ci_se_sp[["specificity"]][, 3],
      l_se = youden_bts_ci_se_sp[["sensitivity"]][, 1],
      u_se = youden_bts_ci_se_sp[["sensitivity"]][, 3]
    )
  } else {
    youden_ci_se_sp <- list(l_sp = NA, u_sp = NA, l_se = NA, u_se = NA)
  }

  optimal_cut <-
    tibble::tibble(
      optimal_cut_title = "Youden Index",
      optimal_cut_sensitivity = youden[["sensitivity"]],
      optimal_cut_specificity = youden[["specificity"]],
      optimal_cut_threshold = youden[["threshold"]],
      optimal_cut_upper_specificity = youden_ci_se_sp[["u_sp"]],
      optimal_cut_lower_specificity = youden_ci_se_sp[["l_sp"]],
      optimal_cut_upper_sensitivity = youden_ci_se_sp[["u_se"]],
      optimal_cut_lower_sensitivity = youden_ci_se_sp[["l_se"]]
    )

  # TODO: When AUC <.5 then youden <- pROC::coords(...) returns both extremes
  # Inf and -Inf unsure how to fix this and user's must clarify
  # It seems that once the direction is correctly set returning two bests is no problem as infinity does not appear
  # In fact the documentation of coords explicitely indicates that several best points may be returned
  # For now the code will be retained until this has run for a while
  if (FALSE) { # ahyodae
    if (nrow(optimal_cut) == 2) stop("FIX DIRECTION ISSUE!")
  }

  r[["roc_optimal_cut"]] <- optimal_cut

  # CI

  thr_ci_points <- c(
    purrr::map_dbl(ci_points[["spec"]], function(q) {
      roc[["thresholds"]][[which.min(abs(roc$specificities - q))]]
    }),
    ci_points[["thr"]]
  ) |>
    purrr::keep(~ !is.na(.x))

  if (do_bootstrap && length(thr_ci_points) > 0) { # Check that there is at least one point

    roc_ci_se_sp <- pROC::ci.thresholds(roc,
      thresholds = thr_ci_points,
      conf.level = conf_level,
      direction = direction,
      levels = this_levels,
      progress = "none"
    )

    ci_se_sp <- tibble::tibble(
      ci_specificity = roc_ci_se_sp$specificity[, 2],
      ci_lower_specificity = roc_ci_se_sp$specificity[, 1],
      ci_upper_specificity = roc_ci_se_sp$specificity[, 3],
      ci_sensitivity = roc_ci_se_sp$sensitivity[, 2],
      ci_lower_sensitivity = roc_ci_se_sp$sensitivity[, 1],
      ci_upper_sensitivity = roc_ci_se_sp$sensitivity[, 3],
      threshold = attr(roc_ci_se_sp, "thresholds")
    )
    r[["roc_ci"]] <- ci_se_sp
  }

  r
}

#' Helpers for computing metric data from the subset dataset
#'
#' @param r `[data.frame()]`
#'
#' dataframe resulting from compute_metric_data
#'
#' @param predictor `[numeric()]`
#'
#' The scores of the predictor
#'
#' @param response `[factor()]`
#'
#' The response value
#'
#' @name compute_metric
#'
NULL

#' @describeIn compute_metric Assert compute_metric result data.frame types are correct
#'
#'
assert_compute_metric_data <- function(r) {
  #  - score, norm_score and normalized_score_rank
  #  - type: the metric name as it will be plotted in the graph
  #  - y: the value of the metric

  checkmate::assert_data_frame(r)
  min_names <- c("score", "norm_score", "normalized_rank_score", "type", "y")
  checkmate::assert_subset(min_names, names(r), .var.name = "names(r)")

  checkmate::assert_numeric(r[["score"]])
  checkmate::assert_numeric(r[["norm_score"]])
  checkmate::assert_numeric(r[["normalized_rank_score"]])
  checkmate::assert_numeric(r[["y"]])
  checkmate::assert_character(r[["type"]])

  checkmate::assert_set_equal(names(attr(r, "limits")), unique(r[["types"]]))
  checkmate::assert_list(attr(r, "limits"))
  purrr::iwalk(attr(r, "limits"), ~ checkmate::assert_numeric(.x, len = 2))
}

# Specs:
# Output: A dataframe with columns:
#  - score, norm_score and normalized_score_rank
#  - type: the metric name as it will be plotted in the graph
#  - y: the value of the metric
# The dataset has an attribute limits that sets the limits for each of the metrics

#' @describeIn compute_metric Compute metric analysis
#'
#' @return
#'
#' `r doc_templates()[["compute_metric_data_return"]]`
#'
#'
compute_metric_data <- function(predictor, response) {
  cds <- as.data.frame(
    precrec::evalmod(
      scores = as.numeric(predictor),
      labels = as.character(response),
      mode = "basic"
    )
  ) |>
    dplyr::select(-.data[["dsid"]], -.data[["modname"]]) |>
    dplyr::rename(norm_rank = .data[["x"]]) |>
    tidyr::pivot_wider(values_from = "y", names_from = "type") |>
    dplyr::mutate(
      norm_score = {
        val <- .data[["score"]]
        min_val <- min(val, na.rm = TRUE)
        max_val <- max(val, na.rm = TRUE)
        (val - min_val) / (max_val - min_val)
      }
    ) |>
    tidyr::pivot_longer(
      cols = -dplyr::all_of(c("norm_rank", "score", "norm_score")),
      names_to = "type",
      values_to = "y"
    ) |>
    dplyr::ungroup()

  limits <- list(
    accuracy = c(0, 1),
    label = c(-1, 1),
    error = c(0, 1),
    specificity = c(0, 1),
    sensitivity = c(0, 1),
    precision = c(0, 1),
    mcc = c(-1, 1),
    fscore = c(0, 1)
  )

  structure(
    cds,
    limits = limits
  )
}

# nocov end

# Input helpers

#' Split string with ; delimiters and transform to numeric
#'
#' @param str `[character(1)]`
#'
#' String to be split
#'
#' @keywords internal
parse_ci <- function(str) {
  sort(unique(as.numeric(strsplit(str, ";", fixed = TRUE)[[1]])))
}

# https://github.com/vegawidget/vegawidget/issues/217
# https://github.com/vegawidget/vegawidget/issues/218
# To fix this issue we will wrap the elements in a renderUI that will solve this problem
# until vegawidget fix those
# The overhead of an extra div should be neglible compared to the size of sending data and plotting it
# Two helpers will be used

vegawidget_hack_output <- shiny::uiOutput
render_vegawidget_hack <- shiny::renderUI
ns_vegawidget_hack <- function(container_id) {
  paste0(container_id, "-", "chart")
}

# Doc templates

doc_templates <- function() {
  # nocov start
  # nolint start

  # Subset Data
  subset_data_return <-
    "
`[data.frame()]`

 With columns:

  - `{CNT_ROC$SBJ}` `[factor()]`: Subject ID

  - `{CNT_ROC$PPAR}` `[factor()]`: Predictor parameter name.

  - `{CNT_ROC$RPAR}` `[factor()]`: Response parameter value.

  - `{CNT_ROC$GRP}` `[factor()]`: An optional column for the grouping value (if group is specified).

  - `{CNT_ROC$PVAL}` `[numeric()]`: Predictor parameter Value

  - `{CNT_ROC$RVAL}` `[factor()]`: Response parameter Value.
"


  # Get roc data

  get_roc_data_return <-
    "
`[list(data.frame())]`
 A list with entries:

## {CNT_ROC$ROC_CURVE}
{get_roc_data_return_roc_curve |> glue::glue()}

## {CNT_ROC$ROC_CI}
{get_roc_data_return_roc_ci |> glue::glue()}

CIs are only calculated when `do_bootstrap` is `TRUE`

## {CNT_ROC$ROC_OC}
{get_roc_data_return_roc_optimal_cut |> glue::glue()}

CIs are only calculated when `do_bootstrap` is `TRUE`
"

  get_roc_data_return_roc_curve <-
    "
`[data.frame()]`

With columns:
  - `{CNT_ROC$PPAR}` `[factor()]`: Predictor parameter name.

  - `{CNT_ROC$RPAR}` `[factor()]`: Response parameter name.

  - `{CNT_ROC$GRP}` `[factor()]`: An optional column for the grouping value (if group is specified).

  - `{CNT_ROC$SPEC}` `[numeric()]`: Sensitivity

  - `{CNT_ROC$SENS}` `[numeric()]`: Specificity

  - `{CNT_ROC$THR}` `[numeric()]`: Threshold

  - `{CNT_ROC$AUC}` `[numeric(3)]`: A numeric vector of length 3 c(LOWER AUC CI, AUC, UPPER AUC CI)
"
  get_roc_data_return_roc_ci <-
    "
`[data.frame()]`

With columns:

  - `{CNT_ROC$PPAR}` `[factor()]`: Predictor parameter name.

  - `{CNT_ROC$RPAR}` `[factor()]`: Response parameter name.

  - `{CNT_ROC$GRP}` `[factor()]`: An optional column for the grouping value (if group is specified).

  - `{CNT_ROC$CI_SPEC}` `[numeric()]`: Specificity value

  - `{CNT_ROC$CI_L_SPEC}` `[numeric()]`: Specificity lower confidence interval

  - `{CNT_ROC$CI_U_SPEC}` `[numeric()]`: Specificity upper confidence interval

  - `{CNT_ROC$CI_SENS}` `[numeric()]`: Sensitivity value

  - `{CNT_ROC$CI_L_SENS}` `[numeric()]`: Sensitivity lower confidence interval

  - `{CNT_ROC$CI_U_SENS}` `[numeric()]`: Sensitivity upper confidence interval
"
  get_roc_data_return_roc_optimal_cut <-
    "
`[data.frame()]`

With columns:
  - `{CNT_ROC$PPAR}` `[factor()]`: Predictor parameter name.

  - `{CNT_ROC$RPAR}` `[factor()]`: Response parameter name.

  - `{CNT_ROC$GRP}` `[factor()]`: An optional column for the grouping value (if group is specified).

  - `{CNT_ROC$OC_TITLE}` `[character()]`: Name of the optimal cut

  - `{CNT_ROC$OC_SPEC}` `[numeric()]`: Sensitivity at the optimal cut point

  - `{CNT_ROC$OC_L_SPEC}` `[numeric()]`: Lower Confidence interval of sensitivity

  - `{CNT_ROC$OC_U_SPEC}` `[numeric()]`: Upper Confidence interval of sensitivity

  - `{CNT_ROC$OC_SENS}` `[numeric()]`: Specificity at the optimal cut point

  - `{CNT_ROC$OC_L_SENS}` `[numeric()]`: Lower Confidence interval of sensitivity

  - `{CNT_ROC$OC_U_SENS}` `[numeric()]`: Upper Confidence interval of sensitivity

  - `{CNT_ROC$OC_THR}` `[numeric()]`: Threshold of the optimal cut
"

  # Get metric data

  get_metric_data_return <-
    "
`[list()]`
 A list with entries:

## `ds`
{get_metric_data_return_ds |> glue::glue()}

## `limits`
{get_metric_data_return_limits |> glue::glue()}
"

  get_metric_data_return_ds <-
    "
`[data.frame()]`

With columns:

  - `{CNT_ROC$PPAR}` `[factor()]`: Predictor parameter name.

  - `{CNT_ROC$RPAR}` `[factor()]`: Response parameter name.

  - `{CNT_ROC$GRP}` `[factor()]`: An optional column for the grouping value (if group is specified).

  - `type` `[character()]`: Metric name

  - `y` `[numeric()]`: Metric value

  - `score`, `norm_score`, `norm_rank` `[numeric()]`: Raw, normalized, and normalized rank predictor value per group.
"

  get_metric_data_return_limits <-
    "
`[list()]`

With one entry per metric type. Each entry is a `numeric(2)` that contains the plotting limits for the metric.
"

  # Get density data

  get_dens_data_return <-
    "
`[data.frame()]`

With columns:

  - `{CNT_ROC$PPAR}` `[factor()]`: Predictor parameter name.

  - `{CNT_ROC$RVAL}` `[factor()]`: Response parameter value.

  - `{CNT_ROC$GRP}` `[factor()]`: An optional column for the grouping value (if group is specified).

  - `{CNT_ROC$DENS_X}` `[numeric()]`: Predictor parameter value.

  - `{CNT_ROC$DENS_Y}` `[numeric()]`: Predictor parameter probability density.
"

  # Get histo Data

  get_histo_data_return <-
    "
`[data.frame()]`

With columns:

  - `{CNT_ROC$PPAR}` `[factor()]`: Predictor parameter name.

  - `{CNT_ROC$RVAL}` `[factor()]`: Response parameter value.

  - `{CNT_ROC$GRP}` `[factor()]`: An optional column for the grouping value (if group is specified).

  - `{CNT_ROC$BIN_START}` `[numeric()]`: Predictor parameter bin start.

  - `{CNT_ROC$BIN_END}` `[numeric()]`: Predictor parameter bin end.

  - `{CNT_ROC$BIN_COUNT}` `[numeric()]`: Predictor parameter bin count.
"

  # Get Explore Roc Data

  get_explore_roc_data_return <-
    "
`[data.frame()]`

With columns:
  - `{CNT_ROC$PPAR}` `[factor()]`: Predictor parameter name.

  - `{CNT_ROC$RPAR}` `[factor()]`: Response parameter name.

  - `{CNT_ROC$GRP}` `[factor()]`: An optional column for the grouping value (if group is specified).

  - `{CNT_ROC$AUC}` `[numeric()]`: Area under the curve

  - `{CNT_ROC$L_AUC}` `[numeric()]`: AUC lower confidence interval

  - `{CNT_ROC$U_AUC}` `[numeric()]`: AUC upper confidence interval
"

  # Quantile data return ---
  get_quantile_data_return <-
    "
`[data.frame()]`

With columns:

  - `{CNT_ROC$PPAR}` `[factor()]`: Predictor parameter name.

  - `{CNT_ROC$RVAL}` `[factor()]`: Response parameter value.

  - `{CNT_ROC$GRP}` `[factor()]`: An optional column for the grouping value (if group is specified).

  - `mean` `[numeric()]`: Mean of the predictor parameter value

  - `q05`, `q25`, `q50`, `q75`, `q95` `[numeric()]`: Quantiles of the predictor parameter value
"

  get_summary_data_return <-
    "
`[data.frame()]`

With columns:
  - `{CNT_ROC$PPAR}` `[factor()]`: Predictor parameter name.

  - `{CNT_ROC$RPAR}` `[factor()]`: Response parameter name.

  - `{CNT_ROC$GRP}` `[factor()]`: An optional column for the grouping value (if group is specified).

  - `{CNT_ROC$AUC}` `[numeric()]`: Area under the curve

  - `{CNT_ROC$L_AUC}` `[numeric()]`: AUC lower confidence interval

  - `{CNT_ROC$U_AUC}` `[numeric()]`: AUC upper confidence interval

  - `{CNT_ROC$OC_TITLE}` `[character()]`: Name of the optimal cut

  - `{CNT_ROC$OC_SPEC}` `[numeric()]`: Sensitivity at the optimal cut point

  - `{CNT_ROC$OC_L_SPEC}` `[numeric()]`: Lower Confidence interval of sensitivity

  - `{CNT_ROC$OC_U_SPEC}` `[numeric()]`: Upper Confidence interval of sensitivity

  - `{CNT_ROC$OC_SENS}` `[numeric()]`: Specificity at the optimal cut point

  - `{CNT_ROC$OC_L_SENS}` `[numeric()]`: Lower Confidence interval of sensitivity

  - `{CNT_ROC$OC_U_SENS}` `[numeric()]`: Upper Confidence interval of sensitivity
"

  compute_roc_data_return_roc_curve <-
    "
`[data.frame()]`

With columns:

  - `{CNT_ROC$SPEC}` `[numeric()]`: Sensitivity

  - `{CNT_ROC$SENS}` `[numeric()]`: Specificity

  - `{CNT_ROC$THR}` `[numeric()]`: Threshold

  - `{CNT_ROC$AUC}` `[numeric(3)]`: A numeric vector of length 3 c(LOWER AUC CI, AUC, UPPER AUC CI)

  - `{CNT_ROC$DIR}` `[character(1)]`: The direction of the comparisons `<` or `>` according to `{CNT_ROC$LEV}`

  - `{CNT_ROC$LEV}` `[character(2)]`: The sorted levels of the response variable according to `{CNT_ROC$DIR}`
"

  compute_roc_data_return_roc_ci <-
    "
`[data.frame()]`

With columns:

  - `{CNT_ROC$CI_SPEC}` `[numeric()]`: Specificity value

  - `{CNT_ROC$CI_L_SPEC}` `[numeric()]`: Specificity lower confidence interval

  - `{CNT_ROC$CI_U_SPEC}` `[numeric()]`: Specificity upper confidence interval

  - `{CNT_ROC$CI_SENS}` `[numeric()]`: Sensitivity value

  - `{CNT_ROC$CI_L_SENS}` `[numeric()]`: Sensitivity lower confidence interval

  - `{CNT_ROC$CI_U_SENS}` `[numeric()]`: Sensitivity upper confidence interval

  - `{CNT_ROC$THR}` `[numeric()]`: Threshold

"

  compute_roc_data_return_roc_oc <-
    "
`[data.frame()]`

With columns:

  - `{CNT_ROC$OC_TITLE}` `[character()]`: Name of the optimal cut

  - `{CNT_ROC$OC_SPEC}` `[numeric()]`: Sensitivity at the optimal cut point

  - `{CNT_ROC$OC_L_SPEC}` `[numeric()]`: Lower Confidence interval of sensitivity

  - `{CNT_ROC$OC_U_SPEC}` `[numeric()]`: Upper Confidence interval of sensitivity

  - `{CNT_ROC$OC_SENS}` `[numeric()]`: Specificity at the optimal cut point

  - `{CNT_ROC$OC_L_SENS}` `[numeric()]`: Lower Confidence interval of sensitivity

  - `{CNT_ROC$OC_U_SENS}` `[numeric()]`: Upper Confidence interval of sensitivity

  - `{CNT_ROC$OC_THR}` `[numeric()]`: Threshold of optimal cut
"

  compute_metric_data_return <-
    "
`[data.frame()]`

With columns:

  - `type` `[character()]`: Metric name

  - `y` `[numeric()]`: Metric value

  - `score`, `norm_score`, `norm_rank` `[numeric()]`: Raw, normalized, and normalized rank predictor value per group.

With an attribute:

  - `limits` `[list()]`: With one entry per metric type. Each entry is a `numeric(2)` that contains the plotting limits for the metric.
"
  doc_list <- as.list(environment())
  purrr::map_chr(doc_list, ~ glue::glue(.x))

  # nolint end
  # nocov end
}

# mock apps

#' Mock functions
#' @name mock_roc
#'
#' @keywords mock
#'
NULL


#' @describeIn mock_roc Mock app running the module inside dv.manager
#'
#' @param adbm,adbin,group Datasets for the mock app
#' @export
mock_roc_mm_app <- function(adbm = test_roc_data()[["adbm"]],
                            adbin = test_roc_data()[["adbin"]],
                            group = test_roc_data()[["adsl"]]) {
  if (requireNamespace("dv.manager")) {
    dv.manager::run_app(
      data = list(
        "Sample Data" = list(
          adbm = adbm,
          adbin = adbin,
          adsl = group
        )
      ),
      module_list = list(
        "ROC" = dv.explorer.parameter::mod_roc(
          module_id = "mod_roc",
          pred_dataset_name = "adbm",
          resp_dataset_name = "adbin",
          group_dataset_name = "adsl"
        )
      ),
      filter_data = "adsl",
      filter_key = "USUBJID",
      enableBookmarking = "url"
    )
  } else {
    rlang::abort("dv.manager is required to run this mock")
  }
}

#' @describeIn mock_roc Mock app running the module standalone
#'
#' @export
mock_roc_app <- function() {
  ui <- function(request) {
    shiny::fluidPage(
      dv.explorer.parameter::roc_UI("roc")
    )
  }

  server <- function(input, output, session) {
    dv.explorer.parameter::roc_server(
      id = "roc",
      pred_dataset = shiny::reactive(test_roc_data()[["adbm"]]),
      resp_dataset = shiny::reactive(test_roc_data()[["adbin"]]),
      group_dataset = shiny::reactive(test_roc_data()[["adsl"]])
    )
    shiny::observe({
      shiny::reactiveValuesToList(input)
      session$doBookmark()
    })
    # Update the query string
    shiny::onBookmarked(shiny::updateQueryString)
  }

  shiny::shinyApp(
    ui = ui,
    server = server,
    enableBookmarking = "url"
  )
}

roc_test_app <- function(dataset) {
  ui <- function(request) {
    shiny::fluidPage(
      roc_UI("roc"),
      shiny::bookmarkButton()
    )
  }

  server <- function(input, output, session) {
    roc_server(
      id = "roc",
      pred_dataset = shiny::reactive(test_roc_data()[["adbm"]]),
      resp_dataset = shiny::reactive(test_roc_data()[["adbin"]]),
      group_dataset = shiny::reactive(test_roc_data()[["adsl"]])
    )
  }

  structure(
    shiny::shinyApp(
      ui = ui,
      server = server,
      enableBookmarking = "url"
    ),
    version = "Shiny Day"
  )
}

# Synthetic data

test_roc_data <- function() {
  set.seed(1)

  n_subj <- 100
  country_list <- c("DE", "US", "ES")
  arm_list <- c("ARM A", "ARM B", "PLACEBO")
  sex_list <- c("F", "M", "U")
  visit_list <- c("V1", "V2", "V3")

  adsl <- tibble::tibble(
    USUBJID = factor(1:n_subj)
  ) |>
    dplyr::mutate(
      AGE = sample(50:100, size = n_subj, replace = TRUE),
      COUNTRY = factor(sample(country_list, size = n_subj, replace = TRUE)),
      ARM = factor(sample(arm_list, size = n_subj, replace = TRUE)),
      SEX = factor(sample(sex_list, size = n_subj, replace = TRUE))
    )

  adbm <- expand.grid(
    USUBJID = factor(1:n_subj),
    PARCAT = factor(c("A", "B")),
    PARAM = factor(c("1", "2", "3")),
    AVISIT = visit_list
  ) |>
    tibble::as_tibble() |>
    dplyr::mutate(
      PARAM = factor(paste0(.data[["PARCAT"]], .data[["PARAM"]]))
    ) |>
    dplyr::filter(!.data[["PARAM"]] %in% c("B2", "B3")) |>
    dplyr::group_by(.data[["PARAM"]]) |>
    dplyr::mutate(
      AVAL = {
        stats::rnorm(dplyr::n(), dplyr::cur_group_id())
      }
    ) |>
    dplyr::ungroup()

  adbin <- adbm |>
    dplyr::mutate(
      PARCAT = factor(paste0("Bin", .data[["PARCAT"]])),
      PARAM = factor(paste0("Bin", .data[["PARAM"]])),
      CHG1 = factor(sample(c("POS", "NEG"), nrow(adbm), replace = TRUE)),
      CHG2 = factor(sample(c("POS", "NEG", ""), nrow(adbm), replace = TRUE)),
      # Predict somes values better than others,
      CHG1 = dplyr::if_else(
        .data[["PARAM"]] == "BinA1",
        dplyr::if_else(
          .data[["AVAL"]] > stats::median(adbm[adbm[["PARAM"]] == "A1", ][["AVAL"]]),
          factor("POS", levels = c("POS", "NEG")),
          factor("NEG", levels = c("POS", "NEG"))
        ),
        .data[["CHG1"]]
      ),
      CHG2 = dplyr::if_else(
        .data[["PARAM"]] == "BinB1",
        dplyr::if_else(
          .data[["AVAL"]] > stats::median(adbm[adbm[["PARAM"]] == "B1", ][["AVAL"]]),
          sample(factor(c("POS", "NEG"), levels = c("POS", "NEG")), 1, prob = c(2, 8)),
          sample(factor(c("POS", "NEG"), levels = c("POS", "NEG")), 1, prob = c(8, 2))
        ),
        .data[["CHG2"]]
      )
    )

  attr(adbm[["AVAL"]], "label") <- "Analysis Value"

  list(
    adbin = adbin,
    adbm = adbm,
    adsl = adsl
  )
}
