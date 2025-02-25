# IDs
# SCATTER PLOT ----

SP <- poc( # nolint
  ID = poc( # nolint
    PAR_BUTTON = "par_button",
    X = poc(
      PAR = "x_par",
      PAR_VALUE = "x_par_value",
      PAR_VISIT = "x_par_visit"
    ),
    Y = poc(
      PAR = "y_par",
      PAR_VALUE = "y_par_value",
      PAR_VISIT = "y_par_visit"
    ),
    GRP_BUTTON = "grp_button",
    GRP = "group",
    COLOR = "color",
    OTHER_BUTTON = "other_button",
    X_LIM_MAX = "x_lim_max",
    X_LIM_MIN = "x_lim_min",
    Y_LIM_MAX = "y_lim_max",
    Y_LIM_MIN = "y_lim_min",
    CHART = "chart",
    TAB_TABLES = "tab_tables",
    TABLE_LISTING = "table_listing",
    TABLE_REGRESSION = "table_regression",
    TABLE_CORRELATION = "table_correlation",
    CHART_CLICK = "click",
    CHART_BRUSH = "brush"
  ),
  VAL = poc( # nolint
    SUBSET_DEBOUNCE_TIME = 500
  ),
  MSG = poc( # nolint
    LABEL = poc(
      PAR_BUTTON = "Parameter",
      PAR = "Parameter",
      CAT = "Category",
      PAR_VALUE = "Value",
      PAR_VISIT = "Visit",
      PAR_TRANSFORM = "Transform",
      GRP_BUTTON = "Grouping",
      GRP = "Group by",
      COLOR = "Color by",
      OTHER_BUTTON = "Other",
      X_LIM = "X limit",
      Y_LIM = "Y limit",
      TABLE_LISTING = "Data Listing",
      TABLE_REGRESSION = "Linear Regression"
    ),
    VALIDATE = poc(
      NO_CAT_SEL = "Select a category",
      NO_PAR_SEL = "Select a parameter",
      NO_VALUE_SEL = "Value selection does not exist",
      UKNOWN_VALUE_SEL = "Select a value",
      NO_VISIT_SEL = "Select a visit",
      NO_MAIN_GROUP_SEL = "Select a group",
      NO_SUB_GROUP_SEL = "(Subgroup) Select a group",
      NO_PAGE_GROUP_SEL = "(Page group) Select a group",
      BM_TOO_MANY_ROWS = "(Biomarker) The selection returns more than 1 row per subject and cannot be plotted",
      GROUP_TOO_MANY_ROWS = "(Group) The selection returns more than 1 row per subject and cannot be plotted",
      GROUP_COL_REPEATED = "(Group) Selected group is already a column in resp or pred datasets",
      NOT_INVARIANT_N_SBJ = "The number of subjects differ between datasets",
      NO_ROWS = "Current selection returns 0 rows",
      NON_POS_SIZE = "Figure size must be positive",
      X_COL_METRICS_NOT_IN_DS = "The selected column for the metrics X axis does not exist in the metrics dataset",
      N_SUBJECT_EMPTY_RESPONSES = function(x) {
        paste(x, "subjects with empty responses!")
      },
      CLICK_LISTING = "Click on a boxplot to see listing",
      NO_GROUP_SEL = "Select a group",
      NO_COLOR_SEL = "Select a color"
    )
  )
)
# UI and server functions ----

#' Scatterplot module
#'
#' @description
#'
#' `mod_scatterplot` is a Shiny module prepared to display a scatterplot of two biomarkers with different levels of
#' grouping.
#' It also includes a set of listings with information about the population and the regression and correlation
#' estimates.
#'
#' @inheritParams scatterplot_server
#'
#' @name mod_scatterplot
#'
#' @keywords main
#'
NULL

#' Scatter plot UI function
#' @keywords developers
#' @param id Shiny ID `[character(1)]`
#' @export
scatterplot_UI <- function(id) { # nolint
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  # argument asserts ----

  # UI ----
  ns <- shiny::NS(id)

  parameter_menu <- drop_menu_helper(
    ns(SP$ID$PAR_BUTTON), SP$MSG$LABEL$PAR_BUTTON,
    # X axis
    shiny::h2("X axis"),
    parameter_UI(id = ns(SP$ID$X$PAR)),
    col_menu_UI(ns(SP$ID$X$PAR_VALUE)),
    val_menu_UI(id = ns(SP$ID$X$PAR_VISIT)),
    # Y axis
    shiny::h2("Y axis"),
    parameter_UI(id = ns(SP$ID$Y$PAR)),
    col_menu_UI(ns(SP$ID$Y$PAR_VALUE)),
    val_menu_UI(id = ns(SP$ID$Y$PAR_VISIT)),
  )

  group_menu <- drop_menu_helper(
    ns(SP$ID$GRP_BUTTON), SP$MSG$LABEL$GRP_BUTTON,
    col_menu_UI(
      id = ns(SP$ID$GRP)
    ),
    col_menu_UI(
      id = ns(SP$ID$COLOR)
    ),
  )

  other_menu <- drop_menu_helper(
    ns(SP$ID$OTHER_BUTTON), SP$MSG$LABEL$OTHER_BUTTON,
    shiny::tags[["label"]](SP$MSG$LABEL$X_LIM, class = "control-label"),
    shiny::splitLayout(
      shiny::numericInput(ns(SP$ID$X_LIM_MAX), NULL, NULL, width = 75),
      shiny::numericInput(ns(SP$ID$X_LIM_MIN), NULL, NULL, width = 75)
    ),
    shiny::tags[["label"]](SP$MSG$LABEL$Y_LIM, class = "control-label"),
    shiny::splitLayout(
      shiny::numericInput(ns(SP$ID$Y_LIM_MAX), NULL, NULL, width = 75),
      shiny::numericInput(ns(SP$ID$Y_LIM_MIN), NULL, NULL, width = 75)
    )
  )


  top_menu <- shiny::tagList(
    add_top_menu_dependency(),
    add_warning_mark_dependency(),
    parameter_menu,
    group_menu,
    other_menu
  )



  # Charts and tables ----

  chart <- shiny::div(
    shiny::plotOutput(
      outputId = ns(SP$ID$CHART),
      click = ns(SP$ID$CHART_CLICK),
      brush = ns(SP$ID$CHART_BRUSH),
      height = "100%"
    ),
    style = "height:70vh;position:relative"
  )
  tables <- shiny::tabsetPanel(
    id = ns(SP$ID$TAB_TABLES),
    shiny::tabPanel(
      SP$MSG$LABEL$TABLE_LISTING,
      DT::DTOutput(ns(SP$ID$TABLE_LISTING))
    ),
    shiny::tabPanel(
      SP$MSG$LABEL$TABLE_REGRESSION,
      shiny::h3("Linear Regression"),
      DT::DTOutput(ns(SP$ID$TABLE_REGRESSION)),
      shiny::h3("Correlation measures"),
      DT::DTOutput(ns(SP$ID$TABLE_CORRELATION))
    )
  )

  #   # main_ui ----

  main_ui <- shiny::tagList(
    shiny::div(top_menu, class = "bm_top_menu_bar"),
    chart,
    tables
  )

  if (..__is_db()) {
    ..__db_UI(ns("debug"), main_ui, stacked = TRUE) # Debugging
  } else {
    main_ui
  }
}

#' Scatter plot server function
#'
#' @keywords developers
#'
#' @description
#'
#' ## Input dataframes:
#'
#' ### bm_dataset
#'
#' It expects a dataset similar to
#' https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192 ,
#' 1 record per subject per parameter per analysis visit
#'
#' It expects, at least, the columns passed in the parameters, `subjid_var`, `cat_var`, `par_var`,
#' `visit_var` and `value_var`. The values of these variables are as described
#' in the CDISC standard for the variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.
#'
#' ### group_dataset
#'
#' It expects a dataset with an structure similar to
#' https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806 ,
#' one record per subject
#'
#' It expects to contain, at least, `subjid_var`
#'
#' @param bm_dataset,group_dataset `[data.frame()]`
#'
#' Dataframes as described in the `Input dataframes` section
#'
#' @param dataset_name `[shiny::reactive(*)]`
#'
#' a reactive indicating when the dataset has possibly changed its columns
#'
#' @param cat_var,par_var,visit_var `[character(1)]`
#'
#' Columns from `bm_dataset` that correspond to the parameter category, parameter and visit
#'
#' @param value_vars `[character(n)]`
#'
#' Columns from `bm_dataset` that correspond to values of the parameters
#'
#' @param subjid_var `[character(1)]`
#'
#' Column corresponding to subject ID
#'
#' @param compute_lm_cor_fn `[function()]`
#'
#' Function used to compute the linear regression model and correlation statistics,
#' please view the corresponding vignette for more details.
#'
#' @param default_x_cat,default_x_par,default_x_visit,default_x_value,default_y_cat,default_y_par `[character(1)|NULL]`
#'
#' Default values for the selectors
#'
#' @param default_y_visit,default_y_value,default_group,default_color `[character(1)|NULL]`
#'
#' Default values for the selectors
#'
#' @export
#'
scatterplot_server <- function(id,
                               bm_dataset,
                               group_dataset,
                               dataset_name = shiny::reactive(character(0)),
                               cat_var = "PARCAT",
                               par_var = "PARAM",
                               value_vars = "AVAL",
                               visit_var = "AVISIT",
                               subjid_var = "SUBJID",
                               default_x_cat = NULL,
                               default_x_par = NULL,
                               default_x_value = NULL,
                               default_x_visit = NULL,
                               default_y_cat = NULL,
                               default_y_par = NULL,
                               default_y_value = NULL,
                               default_y_visit = NULL,
                               default_group = NULL,
                               default_color = NULL,
                               compute_lm_cor_fn = sp_compute_lm_cor_default) {
  ac <- checkmate::makeAssertCollection()
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1, add = ac)

  # non reactive asserts ----
  ###### Check types of reactive variables, pred_dataset, ...
  checkmate::assert_string(cat_var, min.chars = 1, add = ac)
  checkmate::assert_string(par_var, min.chars = 1, add = ac)
  checkmate::assert_string(default_x_cat, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_x_par, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_x_visit, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_x_value, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_y_cat, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_y_par, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_y_visit, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_y_value, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_group, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_color, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_character(
    value_vars,
    min.chars = 1, any.missing = FALSE,
    all.missing = FALSE, unique = TRUE, min.len = 1, add = ac
  )
  checkmate::assert_string(visit_var, min.chars = 1, add = ac)
  checkmate::assert_string(subjid_var, min.chars = 1, add = ac)
  checkmate::assert_function(compute_lm_cor_fn, nargs = 1, add = ac)
  checkmate::reportAssertions(ac)

  # module constants ----
  VAR <- poc( # nolint Parameters from the function that will be considered constant across the function
    CAT = cat_var,
    PAR = par_var,
    VAL = value_vars,
    VIS = visit_var,
    SBJ = subjid_var
  )

  # module ----
  module <- function(input, output, session) {
    ns <- session[["ns"]]

    # dataset validation ----
    v_group_dataset <- shiny::reactive(
      {
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_data_frame(group_dataset(), min.rows = 1, .var.name = ns("group_dataset"))
        checkmate::assert_names(
          names(group_dataset()),
          type = "unique",
          must.include = c(VAR$SBJ), .var.name = ns("group_dataset")
        )
        checkmate::assert_factor(group_dataset()[[VAR$SBJ]], add = ac, .var.name = ns("group_dataset"))
        checkmate::reportAssertions(ac)
        group_dataset()
      },
      label = ns(" v_group_dataset")
    )

    v_bm_dataset <- shiny::reactive(
      {
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_data_frame(bm_dataset(), min.rows = 1, .var.name = ns("bm_dataset"))
        checkmate::assert_names(
          names(bm_dataset()),
          type = "unique",
          must.include = c(
            VAR$CAT, VAR$PAR, VAR$SBJ, VAR$VIS, VAR$VAL
          ),
          .var.name = ns("bm_dataset")
        )
        unique_par_names <- bm_dataset() |>
          dplyr::distinct(dplyr::across(c(VAR$CAT, VAR$PAR))) |>
          dplyr::group_by(dplyr::across(c(VAR$PAR))) |>
          dplyr::tally() |>
          dplyr::pull(.data[["n"]]) |>
          max()

        unique_par_names <- unique_par_names == 1
        checkmate::assert_true(unique_par_names, .var.name = ns("bm_dataset"))
        checkmate::assert_factor(bm_dataset()[[VAR$SBJ]], .var.name = ns("bm_dataset"))
        checkmate::reportAssertions(ac)
        bm_dataset()
      },
      label = ns("v_bm_dataset")
    )

    # input ----
    inputs <- list()
    inputs[[SP$ID$GRP]] <- col_menu_server(
      id = SP$ID$GRP,
      data = v_group_dataset,
      label = SP$MSG$LABEL$GRP,
      include_func = function(x) {
        is.factor(x) || is.character(x)
      },
      default = default_group
    )
    inputs[[SP$ID$COLOR]] <- col_menu_server(
      id = SP$ID$COLOR,
      data = v_group_dataset,
      label = SP$MSG$LABEL$COLOR,
      include_func = function(x) {
        is.factor(x) || is.character(x)
      },
      default = default_color
    )
    inputs[[SP$ID$X$PAR]] <- parameter_server(
      id = SP$ID$X$PAR,
      data = v_bm_dataset,
      cat_var = VAR$CAT,
      par_var = VAR$PAR,
      multi_cat = FALSE,
      multi_par = FALSE,
      default_cat = default_x_cat,
      default_par = default_x_par
    )
    inputs[[SP$ID$X$PAR_VISIT]] <- val_menu_server(
      id = SP$ID$X$PAR_VISIT,
      label = SP$MSG$LABEL$PAR_VISIT,
      data = v_bm_dataset,
      var = VAR$VIS,
      default = default_x_visit
    )
    inputs[[SP$ID$X$PAR_VALUE]] <- col_menu_server(
      id = SP$ID$X$PAR_VALUE,
      data = v_bm_dataset,
      label = SP$MSG$LABEL$PAR_VALUE,
      include_func = function(val, name) {
        name %in% VAR$VAL
      },
      include_none = FALSE,
      default = default_x_value
    )
    inputs[[SP$ID$Y$PAR]] <- parameter_server(
      id = SP$ID$Y$PAR,
      data = v_bm_dataset,
      cat_var = VAR$CAT,
      par_var = VAR$PAR,
      multi_cat = FALSE,
      multi_par = FALSE,
      default_cat = default_y_cat,
      default_par = default_y_par
    )
    inputs[[SP$ID$Y$PAR_VISIT]] <- val_menu_server(
      id = SP$ID$Y$PAR_VISIT,
      label = SP$MSG$LABEL$PAR_VISIT,
      data = v_bm_dataset,
      var = VAR$VIS,
      default = default_y_visit
    )
    inputs[[SP$ID$Y$PAR_VALUE]] <- col_menu_server(
      id = SP$ID$Y$PAR_VALUE,
      data = v_bm_dataset,
      label = SP$MSG$LABEL$PAR_VALUE,
      include_func = function(val, name) {
        name %in% VAR$VAL
      },
      include_none = FALSE,
      default = default_y_value
    )
    inputs[[SP$ID$CHART_BRUSH]] <- shiny::reactive({
      shiny::req(!is.null(input[[SP$ID$CHART_BRUSH]]))
      input[[SP$ID$CHART_BRUSH]]
    })
    inputs[["x_lim"]] <- shiny::reactive({
      as.numeric(c(input[[SP$ID$X_LIM_MAX]], input[[SP$ID$X_LIM_MIN]]))
    })
    inputs[["y_lim"]] <- shiny::reactive({
      as.numeric(c(input[[SP$ID$Y_LIM_MAX]], input[[SP$ID$Y_LIM_MIN]]))
    })

    # input validation ----

    sv_not_empty <- function(input, msg) {
      function(x) if (test_not_empty(input())) NULL else msg
    }

    param_iv <- shinyvalidate::InputValidator$new()
    param_iv$add_rule(
      get_id(inputs[[SP$ID$X$PAR]])[["cat"]],
      sv_not_empty(
        inputs[[SP$ID$X$PAR]][["cat"]],
        SP$MSG$VALIDATE$NO_CAT_SEL
      )
    )
    param_iv$add_rule(
      get_id(inputs[[SP$ID$X$PAR]])[["par"]],
      sv_not_empty(
        inputs[[SP$ID$X$PAR]][["par"]],
        SP$MSG$VALIDATE$NO_PAR_SEL
      )
    )
    param_iv$add_rule(
      get_id(inputs[[SP$ID$X$PAR_VISIT]]),
      sv_not_empty(
        inputs[[SP$ID$X$PAR_VISIT]],
        SP$MSG$VALIDATE$NO_VISIT_SEL
      )
    )
    param_iv$add_rule(
      get_id(inputs[[SP$ID$X$PAR_VALUE]]),
      sv_not_empty(
        inputs[[SP$ID$X$PAR_VALUE]],
        SP$MSG$VALIDATE$NO_VALUE_SEL
      )
    )
    param_iv$add_rule(
      get_id(inputs[[SP$ID$Y$PAR]])[["cat"]],
      sv_not_empty(
        inputs[[SP$ID$Y$PAR]][["cat"]],
        SP$MSG$VALIDATE$NO_CAT_SEL
      )
    )
    param_iv$add_rule(
      get_id(inputs[[SP$ID$Y$PAR]])[["par"]],
      sv_not_empty(
        inputs[[SP$ID$Y$PAR]][["par"]],
        SP$MSG$VALIDATE$NO_PAR_SEL
      )
    )
    param_iv$add_rule(
      get_id(inputs[[SP$ID$Y$PAR_VISIT]]),
      sv_not_empty(
        inputs[[SP$ID$Y$PAR_VISIT]],
        SP$MSG$VALIDATE$NO_VISIT_SEL
      )
    )
    param_iv$add_rule(
      get_id(inputs[[SP$ID$Y$PAR_VALUE]]),
      sv_not_empty(
        inputs[[SP$ID$Y$PAR_VALUE]],
        SP$MSG$VALIDATE$NO_VALUE_SEL
      )
    )
    param_iv$enable()

    group_iv <- shinyvalidate::InputValidator$new()
    group_iv$add_rule(
      get_id(inputs[[SP$ID$GRP]]),
      sv_not_empty(
        inputs[[SP$ID$GRP]],
        SP$MSG$VALIDATE$NO_MAIN_GROUP_SEL
      )
    )
    group_iv$add_rule(
      get_id(inputs[[SP$ID$COLOR]]),
      sv_not_empty(
        inputs[[SP$ID$COLOR]],
        SP$MSG$VALIDATE$NO_SUB_GROUP_SEL
      )
    )
    group_iv$enable()

    shiny::observeEvent(param_iv$is_valid(), {
      session$sendCustomMessage(
        "dv_bm_toggle_warning_mark",
        list(
          id = ns(BP$ID$PAR_BUTTON),
          add_mark = !param_iv$is_valid()
        )
      )
    })

    shiny::observeEvent(group_iv$is_valid(), {
      session$sendCustomMessage(
        "dv_bm_toggle_warning_mark",
        list(
          id = ns(BP$ID$GRP_BUTTON),
          add_mark = !group_iv$is_valid()
        )
      )
    })

    v_input_subset <- shiny::reactive(
      {
        shiny::validate(shiny::need(
          param_iv$is_valid() && group_iv$is_valid(),
          "Current selection cannot produce an output, please review menu feedback"
        ))

        subset_inputs <- c(
          SP$ID$X$PAR, SP$ID$X$PAR_VISIT, SP$ID$X$PAR_VALUE,
          SP$ID$Y$PAR, SP$ID$Y$PAR_VISIT, SP$ID$Y$PAR_VALUE,
          SP$ID$GRP, SP$ID$COLOR
        )
        resolve_reactives <- function(x) {
          if (is.list(x)) {
            return(purrr::map(x, resolve_reactives))
          }
          x()
        }
        resolve_reactives(inputs[subset_inputs])
      },
      label = ns("inputs")
    ) |> shiny::debounce(SP$VAL$SUBSET_DEBOUNCE_TIME)

    # data reactives ----

    data_subset <- shiny::reactive({
      # Reactive is resolved first as nested reactives do no "react"
      # (pun intented) properly when used inside dplyr::filter
      # The suspect is NSE, but further testing is needed.
      l_input <- v_input_subset()

      group_vect <- drop_nones(
        stats::setNames(
          c(l_input[[SP$ID$GRP]], l_input[[SP$ID$COLOR]]),
          c(CNT$MAIN_GROUP, CNT$COLOR_GROUP)
        )
      )

      sp_subset_data(
        x_cat = l_input[[SP$ID$X$PAR]][["cat"]],
        y_cat = l_input[[SP$ID$Y$PAR]][["cat"]],
        x_par = l_input[[SP$ID$X$PAR]][["par"]],
        y_par = l_input[[SP$ID$Y$PAR]][["par"]],
        x_val_col = l_input[[SP$ID$X$PAR_VALUE]],
        y_val_col = l_input[[SP$ID$Y$PAR_VALUE]],
        x_vis = l_input[[SP$ID$X$PAR_VISIT]],
        y_vis = l_input[[SP$ID$Y$PAR_VISIT]],
        group_vect = group_vect,
        bm_ds = v_bm_dataset(),
        group_ds = v_group_dataset(),
        subj_col = VAR$SBJ,
        cat_col = VAR$CAT,
        par_col = VAR$PAR,
        vis_col = VAR$VIS
      )
    })

    lm_cor <- shiny::reactive({
      sp_apply_lm_cor(data_subset(), lm_cor_fn = compute_lm_cor_fn)
    })


    # List of output arguments
    output_arguments <- list()

    # scatter plot ----
    output_arguments[[SP$ID$CHART]] <- shiny::reactive(
      list(
        ds = data_subset(),
        xlim = inputs[["x_lim"]](),
        ylim = inputs[["y_lim"]]()
      )
    )
    output[[SP$ID$CHART]] <- shiny::renderPlot({
      do.call(sp_get_scatterplot_output, output_arguments[[SP$ID$CHART]]())
    })

    # listings table ----
    output_arguments[[SP$ID$TABLE_LISTING]] <- shiny::reactive(
      list(
        ds = data_subset(),
        brush = inputs[[SP$ID$CHART_BRUSH]]()
      )
    )
    output[[SP$ID$TABLE_LISTING]] <- DT::renderDT({
      do.call(sp_get_listings_output, output_arguments[[SP$ID$TABLE_LISTING]]())
    })

    # regression table ----
    output_arguments[[SP$ID$TABLE_REGRESSION]] <- shiny::reactive(
      list(
        lm_ds = lm_cor()[["lm"]]
      )
    )
    output[[SP$ID$TABLE_REGRESSION]] <- DT::renderDT({
      do.call(sp_get_regression_output, output_arguments[[SP$ID$TABLE_REGRESSION]]())
    })

    # correlation table ----
    output_arguments[[SP$ID$TABLE_CORRELATION]] <- shiny::reactive(
      list(
        cor_ds = lm_cor()[["cor"]]
      )
    )
    output[[SP$ID$TABLE_CORRELATION]] <- DT::renderDT({
      do.call(sp_get_correlation_output, output_arguments[[SP$ID$TABLE_CORRELATION]]())
    })

    # debug tab ----
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
          )
        )
      )
    }

    # test values ----
    shiny::exportTestValues(
      data_subset = data_subset()
    )

    # return ----
    NULL
  }

  shiny::moduleServer(id, module)
}

#' Invoke scatterplot module
#'
#' @param module_id `[character(1)]`
#'
#' Module Shiny id
#'
#' @param bm_dataset_name,group_dataset_name `[character(1)]`
#'
#' Name of the dataset
#'
#' @keywords main
#'
#'
#' @export

mod_scatterplot <- function(module_id,
                            bm_dataset_name,
                            group_dataset_name,
                            cat_var = "PARCAT",
                            par_var = "PARAM",
                            value_vars = "AVAL",
                            visit_var = "AVISIT",
                            subjid_var = "SUBJID",
                            default_x_cat = NULL,
                            default_x_par = NULL,
                            default_x_value = NULL,
                            default_x_visit = NULL,
                            default_y_cat = NULL,
                            default_y_par = NULL,
                            default_y_value = NULL,
                            default_y_visit = NULL,
                            default_group = NULL,
                            default_color = NULL,
                            compute_lm_cor_fn = sp_compute_lm_cor_default) {
  mod <- list(
    ui = scatterplot_UI,
    server = function(afmm) {
      scatterplot_server(
        id = module_id,
        bm_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[bm_dataset_name]]),
        group_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[group_dataset_name]]),
        dataset_name = afmm[["dataset_name"]],
        cat_var = cat_var,
        par_var = par_var,
        value_vars = value_vars,
        visit_var = visit_var,
        subjid_var = subjid_var,
        default_x_cat = default_x_cat,
        default_x_par = default_x_par,
        default_x_value = default_x_value,
        default_x_visit = default_x_visit,
        default_y_cat = default_y_cat,
        default_y_par = default_y_par,
        default_y_value = default_y_value,
        default_y_visit = default_y_visit,
        default_group = default_group,
        default_color = default_color,
        compute_lm_cor_fn = compute_lm_cor_fn
      )
    },
    module_id = module_id
  )
  mod
}

# Scatterplot module interface description ----
# TODO: Fill in
mod_scatterplot_API_docs <- list(
  "Scatter plot",
  module_id = "",
  bm_dataset_name = "",
  group_dataset_name = "",
  cat_var = "",
  par_var = "",
  value_vars = "",
  visit_var = "",
  subjid_var = "",
  default_x_cat = "",
  default_x_par = "",
  default_x_value = "",
  default_x_visit = "",
  default_y_cat = "",
  default_y_par = "",
  default_y_value = "",
  default_y_visit = "",
  default_group = "",
  default_color = "",
  compute_lm_cor_fn = ""
)

mod_scatterplot_API_spec <- TC$group(
  module_id = TC$mod_ID(),
  bm_dataset_name = TC$dataset_name(),
  group_dataset_name = TC$dataset_name() |> TC$flag("subject_level_dataset_name"),
  cat_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor())),
  par_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor())),
  value_vars = TC$col("bm_dataset_name", TC$numeric()) |> TC$flag("one_or_more"),
  visit_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor(), TC$numeric())),
  subjid_var = TC$col("group_dataset_name", TC$factor()) |> TC$flag("subjid_var"),
  default_x_cat = TC$choice_from_col_contents("cat_var") |> TC$flag("optional"),
  default_x_par = TC$choice_from_col_contents("par_var") |> TC$flag("optional"),
  default_x_value = TC$choice("value_vars") |> TC$flag("optional"), # FIXME(miguel): ? Should be called default_value_var
  default_x_visit = TC$choice_from_col_contents("visit_var") |> TC$flag("optional"),
  default_y_cat = TC$choice_from_col_contents("cat_var") |> TC$flag("optional"),
  default_y_par = TC$choice_from_col_contents("par_var") |> TC$flag("optional"),
  default_y_value = TC$choice("value_vars") |> TC$flag("optional"), # FIXME(miguel): ? Should be called default_value_var
  default_y_visit = TC$choice_from_col_contents("visit_var") |> TC$flag("optional"),
  default_group = TC$col("group_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("optional"),
  default_color = TC$col("group_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("optional"),
  compute_lm_cor_fn = TC$fn(arg_count = 1) |> TC$flag("optional")
) |> TC$attach_docs(mod_scatterplot_API_docs)

check_mod_scatterplot <- function(
    afmm, datasets, module_id, bm_dataset_name, group_dataset_name, cat_var, par_var, value_vars, visit_var, subjid_var,
    default_x_cat, default_x_par, default_x_value, default_x_visit, default_y_cat, default_y_par, default_y_value,
    default_y_visit, default_group, default_color, compute_lm_cor_fn) {
  warn <- CM$container()
  err <- CM$container()

  # TODO: Replace this function with a generic one that performs the checks based on mod_boxplot_API_spec.
  # Something along the lines of OK <- CM$check_API(mod_corr_hm_API_spec, args = match.call(), warn, err)
  OK <- check_mod_scatterplot_auto(
    afmm, datasets, module_id, bm_dataset_name, group_dataset_name, cat_var, par_var, value_vars, visit_var, subjid_var,
    default_x_cat, default_x_par, default_x_value, default_x_visit, default_y_cat, default_y_par, default_y_value,
    default_y_visit, default_group, default_color, compute_lm_cor_fn, warn, err
  )

  # Checks that API spec does not (yet?) capture
  if (OK[["subjid_var"]] && OK[["cat_var"]] && OK[["par_var"]] && OK[["visit_var"]]) {
    CM$check_unique_sub_cat_par_vis(
      datasets, "bm_dataset_name", bm_dataset_name, subjid_var, cat_var, par_var, visit_var, warn, err
    )
  }

  res <- list(warnings = warn[["messages"]], errors = err[["messages"]])
  return(res)
}

dataset_info_scatterplot <- function(bm_dataset_name, group_dataset_name, ...) {
  # TODO: Replace this function with a generic one that builds the list based on mod_boxplot_API_spec.
  # Something along the lines of CM$dataset_info(mod_scatterplot_API_spec, args = match.call())
  return(list(all = unique(c(bm_dataset_name, group_dataset_name)), subject_level = group_dataset_name))
}

mod_scatterplot <- CM$module(mod_scatterplot, check_mod_scatterplot, dataset_info_scatterplot)

# Logic functions ----

# Data manipulation ----

#' Subset datasets for scatterplot
#'
#' @description
#'
#' Prepares the basic input for the rest of the scatterplot functions.
#'   - `bm_dataset` is subset according to category, parameter and visit selection for x and y val
#'   - `group_dataset` is subset according to group_selection
#'   - both are joined using `subject_col` as a common key
#'   - it uses a left join
#'
#' It is based on [subset_bds_param()] and [subset_adsl()] with additional error checking.
#'
#' @details
#'
#' - factors from `bm_ds` are releveled so all extra levels not present after subsetting are dropped and are sorted
#' according to `par` and `cat`. Unless parameters are renamed in [subset_bds_param()] then no releveling occurs.
#' - `group_vect` names are a subset of `r CNT$MAIN_GROUP` and `r CNT$SUB_GROUP` or empty,
#' otherwise a regular error is produced.
#' - `label` attributes from `group_ds` and `bm_ds` are retained when available
#'
#' ## Shiny validation errors:
#'
#' - The x or y fragments from bm contains more than row per subject, category, parameter and visit combination
#' - The fragment from group contains more than row per subject
#' - If `bm_ds` and `grp_ds` share column names, apart from `subj_col`, after internal renaming has occured
#' - If the returned dataset has 0 rows
#'
#' @param bm_ds,group_ds `data.frame`
#'
#' data frames to be used as inputs in [subset_bds_param] and [subset_adsl]
#'
#' @param x_cat,y_cat,x_par,y_par,x_val_col,y_val_col,x_vis,y_vis
#'
#' Are similar to those without prefix in [subset_bds_param()].
#'
#' @inheritParams subset_bds_param
#'
#' @inheritParams subset_adsl
#'
#' @returns
#'
#' `[data.frame()]`
#'
#' The `_group` columns depend on the names in `group_vect`
#'
#' | ``r CNT$SBJ`` | ``r CNT$X_VAL`` | ``r CNT$Y_VAL`` |``r CNT$MAIN_GROUP`` |``r CNT$SUB_GROUP`` |
#' | -- | -- | -- | -- | -- |
#' |xx|xx|xx|xx|xx|
#'
#' @keywords internal
#'
#'

sp_subset_data <- function(x_cat,
                           y_cat,
                           cat_col,
                           x_par,
                           y_par,
                           par_col,
                           x_val_col,
                           y_val_col,
                           x_vis,
                           y_vis,
                           vis_col,
                           group_vect,
                           bm_ds,
                           group_ds,
                           subj_col) {
  x_bm_fragment <- subset_bds_param(
    ds = bm_ds, par = x_par, par_col = par_col,
    cat = x_cat, cat_col = cat_col, val_col = x_val_col,
    vis = x_vis, vis_col = vis_col, subj_col = subj_col
  ) |>
    dplyr::select(
      CNT$SBJ,
      !!CNT$X_VAL := CNT$VAL # nolint
    )



  y_bm_fragment <- subset_bds_param(
    ds = bm_ds, par = y_par, par_col = par_col,
    cat = y_cat, cat_col = cat_col, val_col = y_val_col,
    vis = y_vis, vis_col = vis_col, subj_col = subj_col
  ) |>
    dplyr::select(
      CNT$SBJ,
      !!CNT$Y_VAL := CNT$VAL # nolint
    )

  # Group data ----

  is_grouped <- length(group_vect) > 0

  if (is_grouped) {
    checkmate::assert_subset(names(group_vect), c(CNT$MAIN_GROUP, CNT$COLOR_GROUP))
  }

  grp_fragment <- subset_adsl(
    ds = group_ds, group_vect = group_vect, subj_col = subj_col
  )

  shiny::validate(
    need_one_row_per_sbj(x_bm_fragment, CNT$SBJ, msg = CMN$MSG$VALIDATE$BM_TOO_MANY_ROWS),
    need_one_row_per_sbj(y_bm_fragment, CNT$SBJ, msg = CMN$MSG$VALIDATE$BM_TOO_MANY_ROWS),
    need_one_row_per_sbj(grp_fragment, CNT$SBJ, msg = CMN$MSG$VALIDATE$GROUP_TOO_MANY_ROWS),
    need_rows(x_bm_fragment),
    need_rows(y_bm_fragment),
    if (is_grouped) need_rows(grp_fragment) else NULL,
    need_disjunct_cols(x_bm_fragment, grp_fragment, ignore = CNT$SBJ, msg = CMN$MSG$VALIDATE$GROUP_COL_REPEATED),
    need_disjunct_cols(y_bm_fragment, grp_fragment, ignore = CNT$SBJ, msg = CMN$MSG$VALIDATE$GROUP_COL_REPEATED)
  )

  xy_dataset <- dplyr::full_join(
    x_bm_fragment,
    y_bm_fragment,
    by = CNT$SBJ
  )

  xy_dataset <- dplyr::left_join(xy_dataset, grp_fragment, by = CNT$SBJ)

  # Drop levels for all non present levels in the factors, should we do this, or relevel to selection
  # Relabel incase the joint breaks something or droplevels breaks something

  shiny::validate(
    need_rows(xy_dataset)
  )

  xy_dataset |>
    dplyr::mutate(dplyr::across(dplyr::where(is.factor), droplevels)) |>
    set_lbls(get_lbls(x_bm_fragment)) |>
    set_lbls(get_lbls(grp_fragment)) |>
    set_lbl(CNT$X_VAL, paste0(x_par, " [", get_lbl_robust(bm_ds, x_val_col), "]")) |> # par names as labels in plot
    set_lbl(CNT$Y_VAL, paste0(y_par, " [", get_lbl_robust(bm_ds, y_val_col), "]"))
}

# Chart functions ----

scatterplot_chart <- function(ds) {
  is_grouped <- CNT$MAIN_GROUP %in% names(ds)
  is_colored <- CNT$COLOR_GROUP %in% names(ds)

  common_aes <- ggplot2::aes(
    x = .data[[CNT$X_VAL]],
    y = .data[[CNT$Y_VAL]]
  )

  if (is_grouped) {
    if (is_colored) {
      point_aes <- ggplot2::aes(
        color = .data[[CNT$COLOR_GROUP]],
        shape = .data[[CNT$MAIN_GROUP]]
      )
    } else {
      point_aes <- ggplot2::aes(
        shape = .data[[CNT$MAIN_GROUP]]
      )
    }
  } else {
    if (is_colored) {
      point_aes <- ggplot2::aes(
        color = .data[[CNT$COLOR_GROUP]]
      )
    } else {
      point_aes <- ggplot2::aes()
    }
  }

  lab_args <- list(
    x = get_lbl_robust(ds, CNT$X_VAL),
    y = get_lbl_robust(ds, CNT$Y_VAL),
    color = if (is_colored) get_lbl_robust(ds, CNT$COLOR_GROUP) else NULL,
    shape = if (is_grouped) get_lbl_robust(ds, CNT$MAIN_GROUP) else NULL
  )

  labs <- do.call(
    ggplot2::labs,
    lab_args
  )

  p <- ggplot2::ggplot(
    data = ds,
    mapping = common_aes
  ) +
    ggplot2::geom_point(mapping = point_aes) +
    labs +
    ggplot2::theme(aspect.ratio = 1) +
    ggplot2::geom_smooth(method = "lm", formula = y ~ x) +
    ggplot2::theme(
      aspect.ratio = 1,
      axis.title = ggplot2::element_text(size = STYLE$AXIS_TITLE_SIZE),
      axis.text.x = ggplot2::element_text(size = STYLE$AXIS_TEXT_SIZE),
      axis.text.y = ggplot2::element_text(size = STYLE$AXIS_TEXT_SIZE)
    )

  p
}

# Stat functions ----

sp_apply_lm_cor <- function(ds, lm_cor_fn) {
  lm_cor_fn(ds)
}

sp_compute_lm_cor_default <- function(ds) {
  # This function receives a ds with columns CNT$SBJ CNT$X_VALUE, CNT$Y_VALUE
  # May contain NA values
  tidy_linear_model <- broom::tidy(stats::lm(y_value ~ x_value, data = ds))

  tidy_correlation <- purrr::map(c("pearson", "kendall", "spearman"), function(x) {
    t <- stats::cor.test(ds[["x_value"]], ds[["y_value"]], method = x, use = "complete.obs", exact = FALSE)
    t <- broom::tidy(t)
    t
  }) |>
    dplyr::bind_rows()

  return(
    list(
      lm = tidy_linear_model,
      cor = tidy_correlation
    )
  )
}

# Composed functions ----

sp_get_scatterplot_output <- function(ds, xlim = c(NA_real_, NA_real_), ylim = c(NA_real_, NA_real_)) {
  # Complete cases
  complete_lgl_mask <- stats::complete.cases(ds[c(CNT$X_VAL, CNT$Y_VAL)])

  if (sum(!complete_lgl_mask) > 0) {
    shiny::showNotification(paste(sum(!complete_lgl_mask), "incomplete cases are dropped"), type = "warn")
  }

  # Elements inside the limits
  inbounds_mask <- dplyr::between(
    ds[[CNT$X_VAL]],
    if (is.na(xlim[[1]])) -Inf else xlim[[1]],
    if (is.na(xlim[[2]])) Inf else xlim[[2]]
  ) & dplyr::between(
    ds[[CNT$Y_VAL]],
    if (is.na(ylim[[1]])) -Inf else ylim[[1]],
    if (is.na(ylim[[2]])) Inf else ylim[[2]]
  )

  # nolint start
  # In this boolean operations there is some quirky logic dealing with:
  # NA & FALSE = FALSE; NA & TRUE = NA; NA | TRUE = TRUE; NA & TRUE = NA
  # Treat with care
  # nolint end

  outbounds_n <- sum(complete_lgl_mask & !inbounds_mask)

  if (outbounds_n > 0) {
    shiny::showNotification(paste(outbounds_n, "complete cases are outside chart limits"), type = "warn")
  }

  # Filter dataset for complete and selected cases

  lbls <- get_lbls_robust(ds)
  ds <- ds[complete_lgl_mask & inbounds_mask, ]
  ds <- possibly_set_lbls(ds, lbls)

  scatterplot_chart(ds)
}

sp_get_listings_output <- function(ds, brush) {
  p <- shiny::brushedPoints(
    ds,
    brush,
    xvar = strip_data_pronoun(brush$mapping$x),
    yvar = strip_data_pronoun(brush$mapping$y)
  )

  rename_list <- get_lbls_robust(ds)
  rename_list <- stats::setNames(names(rename_list), rename_list)

  DT::datatable(p, colnames = rename_list)
}

sp_get_regression_output <- function(lm_ds) {
  DT::datatable(lm_ds) |>
    DT::formatRound(c("estimate", "statistic", "std.error", "p.value"), digits = 2)
}

sp_get_correlation_output <- function(cor_ds) {
  dplyr::relocate(
    cor_ds,
    dplyr::all_of("method")
  ) |>
    DT::datatable() |>
    DT::formatRound(c("estimate", "statistic", "parameter", "conf.low", "conf.high", "p.value"), digits = 2)
}
