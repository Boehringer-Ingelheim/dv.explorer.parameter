# IDs
# BOXPLOT
BP <- poc( # nolint
  ID = poc( # nolint
    PAR_BUTTON = "par_button",
    PAR = "par",
    PAR_VALUE = "par_value",
    PAR_VISIT = "par_visit",

    ###############################
    ANLFL_FILTER = "anlfl_filter",


    PAR_TRANSFORM = "par_transform",
    GRP_BUTTON = "grp_button",
    MAIN_GRP = "main_grp",
    SUB_GRP = "sub_grp",
    PAGE_GRP = "page_grp",
    OTHER_BUTTON = "other_button",
    VIOLIN_CHECK = "violin_check",
    SHOW_POINTS_CHECK = "show_points_check",
    Y_PROJECTION_CHECK = "y_projection_check",
    CHART = "chart",
    TAB_TABLES = "tab_tables",
    TABLE_SINGLE_LISTING = "table_single_listing",
    TABLE_LISTING = "table_listing",
    TABLE_COUNT = "table_count",
    TABLE_SUMMARY = "table_summary",
    TABLE_SIGNIFICANCE = "table_significance",
    CHART_CLICK = "click",
    CHART_DCLICK = "dclick",
    STORE = "store"
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

      ###############################
      ANLFL_FILTER = "Analysis Flag Filter",


      PAR_TRANSFORM = "Transform",
      GRP_BUTTON = "Grouping",
      MAIN_GRP = "Group",
      SUB_GRP = "Subgroup",
      PAGE_GRP = "Page Group",
      OTHER_BUTTON = "Other",
      VIOLIN_CHECK = "Violin plot",
      SHOW_POINTS_CHECK = "Show individual points",
      Y_PROJECTION_CHECK = "Y-axis logarithmic projection",
      TABLE_LISTING = "Data Listing",
      TABLE_SINGLE_LISTING = "Single Listing",
      TABLE_COUNT = "Data Count",
      TABLE_SUMMARY = "Data Summary",
      TABLE_SIGNIFICANCE = "Data Significance",
      STORE = "State"
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
      NOT_INVARIANT_N_SBJ = "The number of subjects differ between datasets",
      NON_POS_SIZE = "Figure size must be positive",
      X_COL_METRICS_NOT_IN_DS = "The selected column for the metrics X axis does not exist in the metrics dataset",
      N_SUBJECT_EMPTY_RESPONSES = function(x) {
        paste(x, "subjects with empty responses!")
      },
      CLICK_LISTING = "Click on a boxplot to see listing",
      CLICK_DLISTING = "Double click on a point"
    )
  )
)
# UI and server functions

#' Boxplot module
#'
#' @description
#'
#' `mod_boxplot` is a Shiny module prepared to display data with boxplot charts with different levels of grouping.
#' It also includes a set of listings with information about the population, distribution and statistical comparisons.
#'
#' @name mod_boxplot
#' @inheritParams boxplot_server
#'
#' @keywords main
#'
NULL

#' Boxplot UI function
#' @param id Shiny ID `[character(1)]`
#' @keywords developers
#' @export
boxplot_UI <- function(id) { # nolint
  # UI ----
  ns <- shiny::NS(id)


  parameter_menu <- drop_menu_helper(
    ns(BP$ID$PAR_BUTTON), BP$MSG$LABEL$PAR_BUTTON,
    parameter_UI(id = ns(BP$ID$PAR)),
    col_menu_UI(ns(BP$ID$ANLFL_FILTER)),
    col_menu_UI(ns(BP$ID$PAR_VALUE)),
    val_menu_UI(id = ns(BP$ID$PAR_VISIT))
  )



  group_menu <- drop_menu_helper(
    ns(BP$ID$GRP_BUTTON), BP$MSG$LABEL$GRP_BUTTON,
    col_menu_UI(id = ns(BP$ID$MAIN_GRP)),
    col_menu_UI(id = ns(BP$ID$SUB_GRP)),
    col_menu_UI(id = ns(BP$ID$PAGE_GRP))
  )

  other_menu <- drop_menu_helper(
    ns(BP$ID$OTHER_BUTTON), BP$MSG$LABEL$OTHER_BUTTON,
    shiny::checkboxInput(inputId = ns(BP$ID$VIOLIN_CHECK), BP$MSG$LABEL$VIOLIN_CHECK),
    shiny::checkboxInput(inputId = ns(BP$ID$SHOW_POINTS_CHECK), BP$MSG$LABEL$SHOW_POINTS_CHECK),
    shiny::checkboxInput(inputId = ns(BP$ID$Y_PROJECTION_CHECK), BP$MSG$LABEL$Y_PROJECTION_CHECK)
  )

  state_menu <- drop_menu_helper(
    ns(BP$ID$STORE), BP$MSG$LABEL$STORE,
    store_ui(ns("store"))
  )

  top_menu <- shiny::tagList(
    add_top_menu_dependency(),
    fontawesome::fa_html_dependency(),
    parameter_menu,
    group_menu,
    state_menu,
    other_menu
  )

  # Charts and tables ----

  chart <- shiny::div(
    shiny::plotOutput(
      outputId = ns(BP$ID$CHART), click = ns(BP$ID$CHART_CLICK),
      dblclick = ns(BP$ID$CHART_DCLICK), height = "100%"
    ),
    style = "height:70vh"
  )

  tables <- shiny::tabsetPanel(
    id = ns(BP$ID$TAB_TABLES),
    shiny::tabPanel(
      BP$MSG$LABEL$TABLE_LISTING,
      shiny::h3(BP$MSG$LABEL$TABLE_SINGLE_LISTING),
      DT::DTOutput(ns(BP$ID$TABLE_SINGLE_LISTING)),
      shiny::h3(BP$MSG$LABEL$TABLE_LISTING),
      DT::DTOutput(ns(BP$ID$TABLE_LISTING))
    ),
    shiny::tabPanel(
      BP$MSG$LABEL$TABLE_COUNT,
      DT::DTOutput(ns(BP$ID$TABLE_COUNT))
    ),
    shiny::tabPanel(
      BP$MSG$LABEL$TABLE_SUMMARY,
      DT::DTOutput(ns(BP$ID$TABLE_SUMMARY))
    ),
    shiny::tabPanel(
      BP$MSG$LABEL$TABLE_SIGNIFICANCE,
      DT::DTOutput(ns(BP$ID$TABLE_SIGNIFICANCE))
    )
  )

  #   # main_ui ----

  main_ui <- shiny::tagList(
    add_warning_mark_dependency(),
    shiny::div(top_menu, class = "bp_top_menu_bar"),
    chart,
    tables
  )

  if (..__is_db()) {
    ..__db_UI(ns("debug"), main_ui, stacked = TRUE) # Debugging
  } else {
    main_ui
  }

}

#' Boxplot server function
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
#' 1 record per subject per parameter per analysis visit.
#'
#' It must contain, at least, the columns passed in the parameters, `subjid_var`, `cat_var`, `par_var`,
#' `visit_var` and `value_vars`. The values of these variables are as described
#' in the CDISC standard for the variables USUBJID, PARCAT, PARAM, AVISIT and AVAL.
#'
#' ### group_dataset
#'
#' It expects a dataset with an structure similar to
#' https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806 ,
#' one record per subject.
#'
#' It must contain, at least, the column passed in the parameter, `subjid_var`.
#'
#' @param bm_dataset,group_dataset `[data.frame()]`
#'
#' Dataframes as described in the `Input dataframes` section
#'
#' @param dataset_name `[shiny::reactive(*)]`
#'
#' a reactive indicating when the dataset has possibly changed its columns
#'
#' @param cat_var,par_var,visit_var, `[character(1)]`
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
#' @param on_sbj_click `[function()]`
#'
#' Function to invoke when a subject is clicked in the single subject listing
#'
#' @param default_cat,default_par,default_visit,default_value,default_main_group,default_sub_group,default_page_group
#' `[character(1)|NULL]`
#'
#' Default values for the selectors
#'
#' @export
#'
boxplot_server <- function(id,
                           bm_dataset,
                           group_dataset,
                           dataset_name = shiny::reactive(character(0)),
                           cat_var = "PARCAT",
                           par_var = "PARAM",

                           ###################################
                           anlfl_vars = NULL,


                           value_vars = "AVAL",
                           visit_var = "AVISIT",
                           subjid_var = "USUBJID",
                           default_cat = NULL,
                           default_par = NULL,
                           default_visit = NULL,
                           default_value = NULL,
                           default_main_group = NULL,
                           default_sub_group = NULL,
                           default_page_group = NULL,
                           on_sbj_click = function(x) {
                           }) {
  #anlfl_vars

  # All these are covered by check_mod_boxplot_auto
  ac <- checkmate::makeAssertCollection()
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1, add = ac)
  # non reactive asserts
  ###### Check types of reactive variables, pred_dataset, ...
  checkmate::assert_string(cat_var, min.chars = 1, add = ac)
  checkmate::assert_string(par_var, min.chars = 1, add = ac)

  message("Type of anlfl_vars: ", typeof(anlfl_vars))
  message("Is null? ", is.null(anlfl_vars))
  message("Is character? ", is.character(anlfl_vars))

  ###############################################
  checkmate::assert_character(anlfl_vars, min.chars = 1, null.ok = TRUE, any.missing = FALSE, add = ac)

  checkmate::assert_character(default_cat, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_character(default_par, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_visit, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_value, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_main_group, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_sub_group, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_page_group, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_character(
    value_vars,
    min.chars = 1, any.missing = FALSE,
    all.missing = FALSE, unique = TRUE, min.len = 1, add = ac
  )
  checkmate::assert_string(visit_var, min.chars = 1, add = ac)
  checkmate::assert_string(subjid_var, min.chars = 1, add = ac)

  checkmate::reportAssertions(ac)
  # module constants ----
  VAR <- poc( # nolint Parameters from the function that will be considered constant across the function
    CAT = cat_var,
    PAR = par_var,
    VAL = value_vars,
    VIS = visit_var,
    SBJ = subjid_var
  )

  module <- function(input, output, session) {
    # sessions ----
    ns <- session[["ns"]]

    # dataset validation ----

    v_group_dataset <- shiny::reactive(
      {
        # Covered by check_mod_boxplot_auto (except for min.rows, which is filter-dependent)
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
        # Covered by check_mod_boxplot_auto (except for unique_par_names, which is _mostly_ covered by #ahwopu)
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_data_frame(bm_dataset(), min.rows = 1, .var.name = ns("group_dataset"))
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

    # input

    inputs <- list()
    inputs[[BP$ID$MAIN_GRP]] <- col_menu_server(
      id = BP$ID$MAIN_GRP, data = v_group_dataset,
      label = "Select a grouping variable",
      include_func = function(x) {
        is.factor(x) || is.character(x)
      }, default = default_main_group
    )
    inputs[[BP$ID$SUB_GRP]] <- col_menu_server(
      id = BP$ID$SUB_GRP, data = v_group_dataset,
      label = "Select a sub grouping variable",
      include_func = function(x) {
        is.factor(x) || is.character(x)
      }, default = default_sub_group
    )
    inputs[[BP$ID$PAGE_GRP]] <- col_menu_server(
      id = BP$ID$PAGE_GRP, data = v_group_dataset,
      label = "Select a page grouping variable",
      include_func = function(x) {
        is.factor(x) || is.character(x)
      }, default = default_page_group
    )
    inputs[[BP$ID$PAR]] <- parameter_server(
      id = BP$ID$PAR,
      data = v_bm_dataset,
      cat_var = VAR$CAT,
      par_var = VAR$PAR,
      default_cat = default_cat,
      default_par = default_par
    )
    inputs[[BP$ID$PAR_VISIT]] <- val_menu_server(
      id = BP$ID$PAR_VISIT,
      label = BP$MSG$LABEL$PAR_VISIT,
      data = v_bm_dataset,
      var = VAR$VIS,
      default = default_visit
    )
    inputs[[BP$ID$PAR_VALUE]] <- col_menu_server(
      id = BP$ID$PAR_VALUE,
      data = v_bm_dataset,
      label = BP$MSG$LABEL$PAR_VALUE,
      include_func = function(val, name) {
        name %in% VAR$VAL
      }, include_none = FALSE, default = default_value
    )


    #####################################################
    # analysis flag filter input
    if (!is.null(anlfl_vars) && length(anlfl_vars) > 0) {
      inputs[[BP$ID$ANLFL_FILTER]] <- col_menu_server(
        id = BP$ID$ANLFL_FILTER,
        data = v_bm_dataset,
        label = BP$MSG$LABEL$ANLFL_FILTER,
        include_func = function(x, name) name %in% anlfl_vars,
        include_none = FALSE, default = anlfl_vars[1]
      )
    }


    inputs[[BP$ID$VIOLIN_CHECK]] <- shiny::reactive({
      input[[BP$ID$VIOLIN_CHECK]]
    })
    inputs[[BP$ID$SHOW_POINTS_CHECK]] <- shiny::reactive({
      input[[BP$ID$SHOW_POINTS_CHECK]]
    })
    inputs[[BP$ID$Y_PROJECTION_CHECK]] <- shiny::reactive({
      input[[BP$ID$Y_PROJECTION_CHECK]]
    })
    inputs[[BP$ID$CHART_CLICK]] <- shiny::reactive({
      input[[BP$ID$CHART_CLICK]]
    })
    inputs[[BP$ID$CHART_DCLICK]] <- shiny::reactive({
      input[[BP$ID$CHART_DCLICK]]
    })

    # Reactivity must be solved inside otherwise the function does not depend on the value
    sv_not_empty <- function(input, ..., msg) {
      function(x) {
        if (test_not_empty(input())) NULL else msg
      }
    }

    # We listen to button presses shiny::reactive(input[[BP$ID$PAR_BUTTON]]) because when the app starts the element\
    # inside the dropdown menu are not present
    # Therefore on the first pass the styles are not applied because they are not present until the first click on the
    # menus happen
    # We also listen to dataset changes, as the par selector elements are drawn using shinyoutput it may be the case
    # that the following happens
    # A dataset loads, the invalidation rules are applied, dataset changes, the selector is redrawn but with no
    # invalidation decoration
    # but because there is no change in the output the rules are not reapplied and invalidation decoration is not
    # applied.

    param_iv <- shinyvalidate::InputValidator$new()
    param_iv$add_rule(
      get_id(inputs[[BP$ID$PAR]])[["cat"]],
      sv_not_empty(inputs[[BP$ID$PAR]][["cat"]],
        msg = BP$MSG$VALIDATE$NO_CAT_SEL
      )
    )

    param_iv$add_rule(
      get_id(inputs[[BP$ID$PAR]])[["par"]],
      sv_not_empty(inputs[[BP$ID$PAR]][["par"]],
        msg = BP$MSG$VALIDATE$NO_PAR_SEL
      )
    )
    param_iv$add_rule(
      get_id(inputs[[BP$ID$PAR_VISIT]]),
      sv_not_empty(inputs[[BP$ID$PAR_VISIT]],
        msg = BP$MSG$VALIDATE$NO_VISIT_SEL
      )
    )
    param_iv$add_rule(
      get_id(inputs[[BP$ID$PAR_VALUE]]),
      sv_not_empty(inputs[[BP$ID$PAR_VALUE]],
        msg = BP$MSG$VALIDATE$NO_VALUE_SEL
      )
    )
    param_iv$enable()

    group_iv <- shinyvalidate::InputValidator$new()
    group_iv$add_rule(
      get_id(inputs[[BP$ID$MAIN_GRP]]),
      sv_not_empty(inputs[[BP$ID$MAIN_GRP]],
        msg = BP$MSG$VALIDATE$NO_MAIN_GROUP_SEL
      )
    )
    group_iv$add_rule(
      get_id(inputs[[BP$ID$SUB_GRP]]),
      sv_not_empty(inputs[[BP$ID$SUB_GRP]],
        msg = BP$MSG$VALIDATE$NO_SUB_GROUP_SEL
      )
    )
    group_iv$add_rule(
      get_id(inputs[[BP$ID$PAGE_GRP]]),
      sv_not_empty(inputs[[BP$ID$PAGE_GRP]],
        msg = BP$MSG$VALIDATE$NO_PAGE_GROUP_SEL
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

    # input validation

    v_input_subset <- shiny::reactive(
      {
        shiny::validate(
          shiny::need(
            param_iv$is_valid() && group_iv$is_valid(),
            "Current selection cannot produce an output, please review menu feedback"
          )
        )

        subset_inputs <- c(BP$ID$PAR, BP$ID$PAR_VISIT, BP$ID$PAR_VALUE, BP$ID$MAIN_GRP, BP$ID$SUB_GRP, BP$ID$PAGE_GRP)
        resolve_reactives <- function(x) {
          if (is.list(x)) {
            return(purrr::map(x, resolve_reactives))
          }
          x()
        }
        resolve_reactives(inputs[subset_inputs])
      },
      label = ns("inputs")
    ) |> shiny::debounce(BP$VAL$SUBSET_DEBOUNCE_TIME)

    v_input_closest_to_click <- shiny::reactive({
      bp_get_closest_single_click(data_subset(), inputs[[BP$ID$CHART_CLICK]]())
    })

    v_input_closest_to_dclick <- shiny::reactive({
      bp_get_closest_double_click(data_subset(), inputs[[BP$ID$CHART_DCLICK]]())
    })

    # data reactives
    data_subset <- shiny::reactive({
      # Reactive is resolved first as nested reactives do no "react"
      # (pun intented) properly when used inside dplyr::filter
      # The suspect is NSE, but further testing is needed.
      l_inputs <- v_input_subset()
      group_vect <- drop_nones(
        stats::setNames(
          c(l_inputs[[BP$ID$MAIN_GRP]], l_inputs[[BP$ID$SUB_GRP]], l_inputs[[BP$ID$PAGE_GRP]]),
          c(CNT$MAIN_GROUP, CNT$SUB_GROUP, CNT$PAGE_GROUP)
        )
      )


      bp_subset_data(
        cat = l_inputs[[BP$ID$PAR]][["cat"]],
        par = l_inputs[[BP$ID$PAR]][["par"]],
        val_col = l_inputs[[BP$ID$PAR_VALUE]],
        vis = l_inputs[[BP$ID$PAR_VISIT]],
        group_vect = group_vect,
        bm_ds = v_bm_dataset(),
        group_ds = v_group_dataset(),
        subj_col = VAR$SBJ,
        cat_col = VAR$CAT,
        par_col = VAR$PAR,
        vis_col = VAR$VIS,

        ##########################################
        selected_flag = if (!is.null(inputs[[BP$ID$ANLFL_FILTER]])) inputs[[BP$ID$ANLFL_FILTER]]() else NULL
      )
    })


    bp_title_data <- shiny::reactive({
      l_inputs <- v_input_subset()
      list(
        par = l_inputs[[BP$ID$PAR]][["par"]],
        par_value = l_inputs[[BP$ID$PAR_VALUE]],
        vis = l_inputs[[BP$ID$PAR_VISIT]],
        main_grp = l_inputs[[BP$ID$MAIN_GRP]],
        sub_grp = l_inputs[[BP$ID$SUB_GRP]],
        page_grp = l_inputs[[BP$ID$PAGE_GRP]]
      )
    })

    # List of output arguments
    output_arguments <- list()

    # box plot ----
    output_arguments[[BP$ID$CHART]] <- shiny::reactive(
      list(
        ds = data_subset(),
        violin = inputs[[BP$ID$VIOLIN_CHECK]](),
        show_points = inputs[[BP$ID$SHOW_POINTS_CHECK]](),
        log_project_y = inputs[[BP$ID$Y_PROJECTION_CHECK]](),
        title_data = bp_title_data()
      )
    )
    output[[BP$ID$CHART]] <- shiny::renderPlot({
      do.call(bp_get_boxplot_output, output_arguments[[BP$ID$CHART]]())
    })

    # listings table ----
    output_arguments[[BP$ID$TABLE_LISTING]] <- shiny::reactive(
      list(
        closest_point = v_input_closest_to_click(),
        ds = data_subset()
      )
    )
    output[[BP$ID$TABLE_LISTING]] <- DT::renderDT({
      do.call(bp_get_listings_output, output_arguments[[BP$ID$TABLE_LISTING]]())
    })

    # single listings table ----
    output_arguments[[BP$ID$TABLE_SINGLE_LISTING]] <- shiny::reactive(
      list(
        closest_point = v_input_closest_to_dclick(),
        ds = data_subset(),
        input_id = session[["ns"]]("BOTON")
      )
    )
    output[[BP$ID$TABLE_SINGLE_LISTING]] <- DT::renderDT({
      do.call(bp_get_single_listings_output, output_arguments[[BP$ID$TABLE_SINGLE_LISTING]]())
    })

    # count table
    output_arguments[[BP$ID$TABLE_COUNT]] <- shiny::reactive(
      list(
        ds = data_subset()
      )
    )
    output[[BP$ID$TABLE_COUNT]] <- DT::renderDT({
      do.call(bp_get_count_output, output_arguments[[BP$ID$TABLE_COUNT]]())
    })

    # summary table
    output_arguments[[BP$ID$TABLE_SUMMARY]] <- shiny::reactive(
      list(
        ds = data_subset()
      )
    )
    output[[BP$ID$TABLE_SUMMARY]] <- DT::renderDT({
      do.call(bp_get_summary_output, output_arguments[[BP$ID$TABLE_SUMMARY]]())
    })

    # significance table
    output_arguments[[BP$ID$TABLE_SIGNIFICANCE]] <- shiny::reactive(
      list(
        ds = data_subset()
      )
    )
    output[[BP$ID$TABLE_SIGNIFICANCE]] <- DT::renderDT({
      do.call(bp_get_significance_output, output_arguments[[BP$ID$TABLE_SIGNIFICANCE]]())
    })

    # state store

    loaded_state <- store_server("store", shiny::reactive({
      resolve_reactives <- function(x) {
        if (is.list(x)) {
          return(purrr::map(x, resolve_reactives))
        }
        x()
      }
      purrr::possibly(resolve_reactives, otherwise = NULL)(inputs)
    }))

    shiny::observeEvent(loaded_state(), {
      get_update(inputs[[BP$ID$MAIN_GRP]])[["val"]](selected = loaded_state()[[BP$ID$MAIN_GRP]])
      get_update(inputs[[BP$ID$SUB_GRP]])[["val"]](selected = loaded_state()[[BP$ID$SUB_GRP]])
      get_update(inputs[[BP$ID$PAGE_GRP]])[["val"]](selected = loaded_state()[[BP$ID$PAGE_GRP]])
      get_update(inputs[[BP$ID$PAR]])[["val"]](
        cat_selected = loaded_state()[[BP$ID$PAR]][["cat"]],
        par_selected = loaded_state()[[BP$ID$PAR]][["par"]]
      )
      get_update(inputs[[BP$ID$PAR_VISIT]])[["val"]](selected = loaded_state()[[BP$ID$PAR_VISIT]])
      get_update(inputs[[BP$ID$PAR_VALUE]])[["val"]](selected = loaded_state()[[BP$ID$PAR_VALUE]])
      shiny::updateCheckboxInput(inputId = BP$ID$VIOLIN_CHECK, value = loaded_state()[[BP$ID$VIOLIN_CHECK]])
      shiny::updateCheckboxInput(inputId = BP$ID$SHOW_POINTS_CHECK, value = loaded_state()[[BP$ID$SHOW_POINTS_CHECK]])
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
          )
        )
      )
    }

    # test values
    shiny::exportTestValues(
      data_subset = data_subset()
    )

    # return

    shiny::observe({
      shiny::req(!is.null(input[["BOTON"]]))
      on_sbj_click()
    })

    res <- shiny::reactive({
      shiny::req(!is.null(input[["BOTON"]]))
      input[["BOTON"]]
    })

    return(res)
  }


  shiny::moduleServer(id, module)
}

#' Invoke boxplot module
#'
#' @details `mod_boxplot_papo` is a deprecated function that was required to use the jumping feature in combination
#' with `dv.papo` but is no longer required. The function is still available for compatibility reasons.
#'
#' @param module_id `[character(1)]`
#'
#' Module Shiny id
#'
#' @param bm_dataset_name,group_dataset_name `[character(1)]`
#'
#' Name of the dataset
#'
#' @param server_wrapper_func `[function()]`
#'
#' A function that will be applied to the server returned value. Its default value will work for the current cases.
#'
#' @param receiver_id `[character(1)]`
#'
#' Shiny ID of the module receiving the selected subject ID in the data listing. This ID must
#' be present in the app or be NULL.
#'
#' inheritParams boxplot_server
#'
#' @name mod_boxplot
#'
#' @keywords main
#'
#' @export

mod_boxplot <- function(module_id,
                        bm_dataset_name,
                        group_dataset_name,
                        receiver_id = NULL,
                        cat_var = "PARCAT",
                        par_var = "PARAM",

                        #################################
                        anlfl_vars = NULL,


                        value_vars = "AVAL",
                        visit_var = "AVISIT",
                        subjid_var = "SUBJID",
                        default_cat = NULL,
                        default_par = NULL,
                        default_visit = NULL,
                        default_value = NULL,
                        default_main_group = NULL,
                        default_sub_group = NULL,
                        default_page_group = NULL,
                        server_wrapper_func = function(x) list(subj_id = x)) {
  #anlfl_vars


  mod <- list(
    ui = boxplot_UI,
    server = function(afmm) {
      if (is.null(receiver_id)) {
        on_sbj_click_fun <- function() NULL
      } else {
        on_sbj_click_fun <- function() {
          afmm[["utils"]][["switch2mod"]](receiver_id)
        }
      }

      server_wrapper_func(
        boxplot_server(
          id = module_id,
          bm_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[bm_dataset_name]]),
          group_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[group_dataset_name]]),
          dataset_name = afmm[["dataset_name"]],

          ########################################
          anlfl_vars = anlfl_vars,

          on_sbj_click = on_sbj_click_fun,
          cat_var = cat_var, par_var = par_var, value_vars = value_vars, visit_var = visit_var, subjid_var = subjid_var,
          default_cat = default_cat, default_par = default_par, default_visit = default_visit,
          default_value = default_value, default_main_group = default_main_group, default_sub_group = default_sub_group,
          default_page_group = default_page_group
        )
      )
    },
    module_id = module_id
  )
  mod
}

# Boxplot module interface description ----
# TODO: Fill in
mod_boxplot_API_docs <- list(
  "Boxplot",
  module_id = "",
  bm_dataset_name = "",
  group_dataset_name = "",
  receiver_id = "",
  cat_var = "",
  par_var = "",

  ##################################
  anlfl_vars = "",

  value_vars = "",
  visit_var = "",
  subjid_var = "",
  default_cat = "",
  default_par = "",
  default_visit = "",
  default_value = "",
  default_main_group = "",
  default_sub_group = "",
  default_page_group = "",
  server_wrapper_func = ""
)

mod_boxplot_API_spec <- TC$group(
  module_id = TC$mod_ID(),
  bm_dataset_name = TC$dataset_name(),
  group_dataset_name = TC$dataset_name() |> TC$flag("subject_level_dataset_name"),
  receiver_id = TC$character() |> TC$flag("optional", "ignore"),
  cat_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("map_character_to_factor"),
  par_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("map_character_to_factor"),

  ################################################ "zero_or_more", "optional",
  anlfl_vars = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("zero_or_more", "optional"),

  value_vars = TC$col("bm_dataset_name", TC$numeric()) |> TC$flag("one_or_more"),
  visit_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor(), TC$numeric())) |> TC$flag("map_character_to_factor"),
  subjid_var = TC$col("group_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("subjid_var", "map_character_to_factor"),
  default_cat = TC$choice_from_col_contents("cat_var") |> TC$flag("zero_or_more", "optional"),
  default_par = TC$choice_from_col_contents("par_var") |> TC$flag("zero_or_more", "optional"),
  default_visit = TC$choice_from_col_contents("visit_var") |> TC$flag("optional"),
  default_value = TC$choice("value_vars") |> TC$flag("optional"), # FIXME(miguel): ? Should be called default_value_var
  default_main_group = TC$col("group_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("optional"),
  default_sub_group = TC$col("group_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("optional"),
  default_page_group = TC$col("group_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("optional"),
  server_wrapper_func = TC$fn(arg_count = 1) |> TC$flag("optional", "ignore")
) |> TC$attach_docs(mod_boxplot_API_docs)


check_mod_boxplot <- function(
    afmm, datasets, module_id, bm_dataset_name, group_dataset_name, receiver_id, cat_var, par_var,

    ################
    anlfl_vars,

    value_vars,
    visit_var, subjid_var, default_cat, default_par, default_visit, default_value, default_main_group,
    default_sub_group, default_page_group, server_wrapper_func) {
  warn <- CM$container()
  err <- CM$container()

  # TODO: Replace this function with a generic one that performs the checks based on mod_boxplot_API_spec.
  # Something along the lines of OK <- CM$check_API(mod_corr_hm_API_spec, args = match.call(), warn, err)
  OK <- check_mod_boxplot_auto(
    afmm, datasets, module_id, bm_dataset_name, group_dataset_name, receiver_id, cat_var, par_var,


    ################
    anlfl_vars,


    value_vars,
    visit_var, subjid_var, default_cat, default_par, default_visit, default_value, default_main_group,
    default_sub_group, default_page_group, server_wrapper_func, warn, err
  )

  # Checks that API spec does not (yet?) capture
  #ahwopu
  if (OK[["subjid_var"]] && OK[["cat_var"]] && OK[["par_var"]] && OK[["visit_var"]] && OK[["anlfl_vars"]]) {

    for (anlfl_var in anlfl_vars) {
      CM$check_unique_sub_cat_par_vis(
        datasets, "bm_dataset_name", bm_dataset_name,
        subjid_var, cat_var, par_var, visit_var,

        #########################################
        anlfl = anlfl_var,


        warn, err
      )
    }

  } else if (OK[["subjid_var"]] && OK[["cat_var"]] && OK[["par_var"]] && OK[["visit_var"]]) {
    CM$check_unique_sub_cat_par_vis(
      datasets, "bm_dataset_name", bm_dataset_name,
      subjid_var, cat_var, par_var, visit_var,
      anlfl = NULL,
      warn, err
    )
  }


  res <- list(warnings = warn[["messages"]], errors = err[["messages"]])
  return(res)
}

dataset_info_boxplot <- function(bm_dataset_name, group_dataset_name, ...) {
  # TODO: Replace this function with a generic one that builds the list based on mod_boxplot_API_spec.
  # Something along the lines of CM$dataset_info(mod_boxplot_API_spec, args = match.call())
  return(list(all = unique(c(bm_dataset_name, group_dataset_name)), subject_level = group_dataset_name))
}

mod_boxplot <- CM$module(mod_boxplot, check_mod_boxplot, dataset_info_boxplot, map_afmm_mod_boxplot_auto)

#' Boxplot wrapper when its output is fed into the papo module
#' @keywords main
#' @export
mod_boxplot_papo <- function(...) {
  .Deprecated("mod_boxplot_papo", msg = "'mod_boxplot_papo' is no longer required and should be replaced by 'mod_boxplot'. It is still available for compatibility purposes") # nolint
  mod_boxplot(...)
}

# Data manipulation

#' Subset datasets for boxplot
#'
#' @description
#'
#' Prepares the basic input for the rest of the boxplot functions.
#'   - `bm_dataset` is subset according to category, parameter and visit selection
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
#' - `group_vect` names are a subset of `r CNT$MAIN_GROUP`, `r CNT$SUB_GROUP` and `r CNT$PAGE_GROUP` or empty,
#' otherwise a regular error is produced.
#' - `label` attributes from `group_ds` and `bm_ds` are retained when available
#'
#' ## Shiny validation errors:
#'
#' - The fragment from bm contains more than row per subject, category, parameter and visit combination
#' - The fragment from group contains more than row per subject
#' - If `bm_ds` and `grp_ds` share column names, apart from `subj_col`, after internal renaming has occured
#' - If the returned dataset has 0 rows
#'
#' @param bm_ds,group_ds `data.frame`
#'
#' data frames to be used as inputs in [subset_bds_param] and [subset_adsl]
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
#' | ``r CNT$SBJ`` | ``r CNT$PAR`` | ``r CNT$VAL`` |``r CNT$MAIN_GROUP`` |``r CNT$SUB_GROUP`` | ``r CNT$PAGE_GROUP`` |
#' | -- | -- | -- | -- | -- | -- |
#' |xx|xx|xx|xx|xx|xx|
#'
#' @keywords internal
#'
bp_subset_data <- function(cat,
                           cat_col,
                           par,
                           par_col,
                           val_col,
                           vis,
                           vis_col,
                           group_vect,
                           bm_ds,
                           group_ds,
                           subj_col,
                           selected_flag = NULL) {

  bm_fragment <- subset_bds_param(
    ds = bm_ds, par = par, par_col = par_col,
    cat = cat, cat_col = cat_col, val_col = val_col,
    vis = vis, vis_col = vis_col, subj_col = subj_col,
    anlfl_col = selected_flag
  )

  # Covered by #ahwopu
  shiny::validate(
    need_one_row_per_sbj(bm_fragment, CNT$SBJ, CNT$PAR, CNT$VIS, msg = CMN$MSG$VALIDATE$BM_TOO_MANY_ROWS)
  )

  # Group data ----
  is_grouped <- length(group_vect) > 0

  if (is_grouped) {
    checkmate::assert_subset(names(group_vect), c(CNT$MAIN_GROUP, CNT$SUB_GROUP, CNT$PAGE_GROUP))

    grp_fragment <- subset_adsl(
      ds = group_ds, group_vect = group_vect, subj_col = subj_col
    )

    shiny::validate(
      need_one_row_per_sbj(grp_fragment, CNT$SBJ, msg = CMN$MSG$VALIDATE$GROUP_TOO_MANY_ROWS),
      need_disjunct_cols(bm_fragment, grp_fragment, ignore = CNT$SBJ, msg = CMN$MSG$VALIDATE$GROUP_COL_REPEATED)
    )

    joint_data <- dplyr::left_join(
      bm_fragment,
      grp_fragment,
      by = c(CNT$SBJ)
    ) |>
      set_lbls(get_lbls(bm_fragment)) |>
      set_lbls(get_lbls(grp_fragment))
  } else {
    joint_data <- bm_fragment
  }

  shiny::validate(
    need_rows(joint_data)
  )

  labels <- get_lbls(joint_data)

  # Relevel biomarker factors but groups remain untouched
  if (!isTRUE(attr(bm_fragment, "parameter_renamed"))) {
    joint_data[[CNT$PAR]] <- factor(joint_data[[CNT$PAR]], levels = par)
  }
  joint_data[[CNT$CAT]] <- factor(joint_data[[CNT$CAT]], levels = cat)
  if (!is.null(selected_flag) && CNT$ANLFL %in% names(joint_data)) {
    joint_data[[CNT$ANLFL]] <- factor(joint_data[[CNT$ANLFL]], levels = "Y")
  }
  joint_data[[CNT$VIS]] <- factor(joint_data[[CNT$VIS]], levels = vis)
  joint_data[[CNT$SBJ]] <- droplevels(joint_data[[CNT$SBJ]])

  # Relabel with labels before releveling
  set_lbls(joint_data, labels)
}

# Chart functions

#' ggplot for a set of faceted boxplots
#'
#' The chart consists of a faceted set of boxplots for biomarker data
#'
#' @details
#'
#' ## Labels:
#'   - X axis and color aesthetic are labelled using the label atttribute from ``r CNT$MAIN_GROUP`` column from `ds`
#'   - Y axis is labelled using the label atttribute from ``r CNT$VAL`` column from `ds`
#'
#' ## Aesthetics:
#'   - ``r CNT$PAR`` is coded as 1st level row facets
#'   - ``r CNT$MAIN_GROUP`` is coded as colors and x axis
#'   - ``r CNT$SUB_GROUP`` is coded as 1st level column facets
#'   - ``r CNT$PAGE_GROUP`` is coded as 2nd level row facets
#'
#' ## Hack:
#'
#' [shiny::nearPoints] do not manage well charts with no x aesthetic. Therefore when no ``r CNT$MAIN_GROUP`` is present
#' in `ds` a dummy one is added.
#'
#' @param ds `data.frame()`
#'
#' A dataframe as output by [bp_subset_data]
#'
#' @param violin `logical(1)`
#'
#' Shows a violin plot instead of a boxplot
#'
#' @param show_points `logical(1)`
#'
#' Shows individual points in the boxplot chart
#'
#' @param title_data `list()`
#'
#' Shows a title summarising parameter values.
#'
#' @name boxplot_chart
#'
#' @return
#'
#' A ggplot chart
#'
#' @keywords internal
#'
boxplot_chart <- function(ds, violin, show_points, log_project_y, title_data = NULL) {
  is_main_grouped <- CNT$MAIN_GROUP %in% names(ds)
  is_sub_grouped <- CNT$SUB_GROUP %in% names(ds)
  is_page_grouped <- CNT$PAGE_GROUP %in% names(ds)

  # Define aes

  if (is_main_grouped) {
    aes <- ggplot2::aes(
      x = .data[[CNT$MAIN_GROUP]],
      y = .data[[CNT$VAL]],
      color = .data[[CNT$MAIN_GROUP]]
    )

    labs <- ggplot2::labs(
      x = get_lbl_robust(ds, CNT$MAIN_GROUP),
      y = get_lbl_robust(ds, CNT$VAL),
      color = get_lbl_robust(ds, CNT$MAIN_GROUP)
    )
  } else {
    # Nearpoints cannot manage plots with no x aesthetic, therefore,
    # no main group implies no x aesthetic in the plot.
    # To solve this boxplot_chart inputs a dummy main grouping
    # we have to patch the dataset to include this dummy grouping

    ds[[CNT$MAIN_GROUP]] <- ""

    aes <- ggplot2::aes(
      x = .data[[CNT$MAIN_GROUP]],
      y = .data[[CNT$VAL]]
    )

    labs <- ggplot2::labs(
      x = "",
      y = get_lbl_robust(ds, CNT$VAL)
    )
  }

  # Define grid

  cols <- c(
    if (is_sub_grouped) ggplot2::vars(.data[[CNT$SUB_GROUP]])
  )

  rows <- if (is_page_grouped) {
    ggplot2::vars(.data[[CNT$PAGE_GROUP]], .data[[CNT$PAR]])
  } else {
    ggplot2::vars(c(.data[[CNT$PAR]]))
  }

  p <- ggplot2::ggplot(
    data = ds,
    mapping = aes
  )

  if (violin) {
    p <- p +
      ggplot2::geom_violin(trim = FALSE) +
      ggplot2::geom_boxplot(width = 0.1, outlier.shape = if (show_points) NA else 19)
  } else {
    p <- p + ggplot2::geom_boxplot(outlier.shape = if (show_points) NA else 19)
  }

  if (show_points) {
    p <- p + ggplot2::geom_jitter(width = .2, height = 0)
  }

  title_text <- sprintf(
    "Parameter = %s\nValue = %s\nVisit = %s\n",
    title_data$par, title_data$par_value, title_data$vis
  )

  group_text <- sprintf(
    "Main group = %s\nSub group = %s\nPage group = %s",
    title_data$main_grp, title_data$sub_grp, title_data$page_grp
  )

  p <- p +
    ggplot2::facet_grid(
      rows = rows,
      cols = cols,
      scales = "free_y"
    ) +
    labs +
    ggplot2::ggtitle(paste0(title_text, group_text)) +
    ggplot2::theme(
      aspect.ratio = 1,
      legend.position = "None",
      axis.title = ggplot2::element_text(size = STYLE$AXIS_TITLE_SIZE),
      axis.text.x = ggplot2::element_text(angle = 45, size = STYLE$AXIS_TEXT_SIZE, hjust = 1),
      axis.text.y = ggplot2::element_text(size = STYLE$AXIS_TEXT_SIZE),
      strip.text.x = ggplot2::element_text(size = STYLE$STRIP_TEXT_SIZE),
      strip.text.y = ggplot2::element_text(size = STYLE$STRIP_TEXT_SIZE)
    )

  if (isTRUE(log_project_y)) {
    p <- p + ggplot2::scale_y_continuous(trans = pseudo_log_projection(base = 10))
  }

  return(p)
}

#' Subsets a data.frame based on the values of a one-rowed data.frame
#'
#' It subsets `ds` based on the values of `f_ds`.
#'
#' @param ds `data.frame()`
#'
#' data.frame to be subset
#'
#' @param f_ds `data.frame()`
#'
#' one-rowed data.frame
#'
#' @return `data.frame()`
#'
#' The subset dataset
#'
#' @details
#'
#' No check no names of data.frames is performed (e.g.: names in `f_ds` are names in `ds`)
#'
#'
#' @keywords boxplot, internal
bp_listings_table <- function(ds, f_ds) {
  # Control the trivial case in which f_ds has no rows
  # Otherwise the map_chr throws an error as entries are character(0)
  if (nrow(f_ds) == 0) {
    mask <- rep(FALSE, nrow(ds))
  } else {
    click_list <- purrr::map_chr(f_ds, ~ as.character(.x))
    click_list <- click_list[!names(f_ds) %in% (c(CNT$SBJ, CNT$VAL))]
    mask <- equal_and_mask_from_vec(ds, click_list)
  }
  ds[mask, ]
}

#' Counts the number of rows grouped by all variables except ``r CNT$SBJ`` and ``r CNT$VAL``
#'
#' - Counts the number of rows grouped by all variables except ``r CNT$SBJ`` and ``r CNT$VAL``.
#' - Throws an error if the Count column is present
#' - The function returns a data frame with the counts for each group.
#'
#' @param ds `data.frame()`
#'   A data frame to count the rows over.
#'
#' @return `data.frame()`
#'   A data frame with the counts for each group.
#'
#' @keywords boxplot, internal
#'
#'
bp_count_table <- function(ds) {
  count_by <- setdiff(names(ds), c(CNT$SBJ, CNT$VAL))
  # If a variable in the original dataset has the name Count a conflict may appear
  # This should not be a problem as tibble can support that and this ds is displayed and not further processed
  # Nonetheless a conservative approach is taken and error is raised in that case
  checkmate::assert_disjunct(names(ds), "Count")

  dplyr::count(ds, dplyr::across(dplyr::all_of(count_by)), .drop = FALSE, name = "Count")
}

#' Calculates a set of summary statistics grouped by all variables except ``r CNT$SBJ`` and ``r CNT$VAL``
#'
#' - Calculates a set of summary statistics grouped by all variables except ``r CNT$SBJ`` and ``r CNT$VAL``.
#' - The summary statistics include `N`, `Mean`, `Median`, `SD`, `Min`, `Q1`, `Median`, `Q3`, `Max` and `NA Values`.
#' - `NA` values are ignored when calculating stats
#'
#' @param ds `data.frame()`
#'   A data frame to perform the summary over.
#'
#' @return `data.frame()`
#'   A data frame with the summary statistics.
#'
#' @keywords internal
bp_summary_table <- function(ds) {
  group_by <- setdiff(names(ds), c(CNT$SBJ, CNT$VAL))

  ds |>
    dplyr::group_by(dplyr::across(dplyr::all_of(group_by))) |>
    dplyr::summarise(
      N = dplyr::n(),
      Mean = mean(.data[[CNT$VAL]], na.rm = TRUE),
      SD = stats::sd(.data[[CNT$VAL]], na.rm = TRUE),
      Min = min(.data[[CNT$VAL]], na.rm = TRUE),
      Q1 = stats::quantile(.data[[CNT$VAL]], probs = .25, na.rm = TRUE),
      Median = stats::median(.data[[CNT$VAL]], na.rm = TRUE),
      Q3 = stats::quantile(.data[[CNT$VAL]], probs = .75, na.rm = TRUE),
      Max = max(.data[[CNT$VAL]], na.rm = TRUE),
      "NA Values" = sum(is.na(.data[[CNT$VAL]]))
    ) |>
    dplyr::ungroup() |>
    tidyr::complete(!!!rlang::syms(group_by), fill = list(N = 0))
}

#' Create a table of t-test results for pairwise comparisons for ``r CNT$MAIN_GROUP`` in a data frame
#'
#' @description
#'
#' Creates a table of t-test results for pairwise comparisons for the groups defined by ``r CNT$MAIN_GROUP``
#' groups in a data frame and values in ``r CNT$VAL``
#'
#' Each of the pairwise comparison is performed for each of groups defined by the columns that are not
#' ``r CNT$MAIN_GROUP``, ``r CNT$VAL`` and ``r CNT$SBJ``.
#'
#' If no or a single data point for a group is present for a given group `NA` values are returned
#'
#' @param ds  `data.frame()`
#'   A data frame to be analyzed.
#'
#' @return  `data.frame()`
#'   A data frame with the test results.
#' The returned data frame will have one row for each pairwise comparison and group, and three additional columns
#' `Test`, `Comparison`, and `P Value`.
#' @keywords internal

bp_significance_table <- function(ds) {
  checkmate::assert_subset(CNT$MAIN_GROUP, names(ds))

  # If a variable in the original dataset has the name Count a conflict may appear
  # This should not be a problem as tibble can support that and this ds is displayed and not further processed
  # If further processed distinguising the two columns would not be trivial
  group_by <- setdiff(names(ds), c(CNT$SBJ, CNT$VAL, CNT$MAIN_GROUP))

  comb <- utils::combn(unique(ds[[CNT$MAIN_GROUP]]), 2)
  t_test <- function(x) {
    d <- tidyr::pivot_wider(x,
      id_cols = -dplyr::all_of(CNT$SBJ),
      names_from = CNT$MAIN_GROUP,
      values_from = CNT$VAL,
      values_fn = list
    )
    purrr::map(seq_len(ncol(comb)), function(ci) {
      g1 <- comb[1, ci]
      g2 <- comb[2, ci]
      d1 <- d[[g1]][[1]]
      d2 <- d[[g2]][[1]]

      # Check data is available for both groups. Careful as t.test(1:3, NULL) calculates a one sample t.test.
      # That is why an specific if is required.
      if (is.null(d1) || is.null(d2) || length(d1) == 1 || length(d2) == 1) {
        p <- NA
      } else {
        p <- stats::t.test(d1, d2)$p.value
      }
      tibble::tibble(
        Test = "t.test",
        Comparison = paste(g1, "vs.", g2),
        "P Value" = p
      )
    }) |>
      dplyr::bind_rows() |>
      list()
  }

  ds |>
    dplyr::nest_by(dplyr::across(dplyr::all_of(group_by))) |>
    dplyr::mutate(data = t_test(.data[["data"]])) |>
    tidyr::unnest(dplyr::all_of("data")) |>
    dplyr::ungroup()
}

# ComposedPlot functions

#' Composes data selection and charting for boxplot
#'
#' This is a set of *glue* functions that in most cases follow the pattern
#' of receiving data, calculating data in an independent/several independent functions
#'
#' In some cases aesthetic or simple error validations can occur
#'
#' This set of functions is not directly tested as they are indirectly tested in the running app
#'
#'
#' @name boxplot_composed
#' @keywords internal
#'
NULL

#' @rdname boxplot_composed
#' @inheritParams boxplot_chart
bp_get_boxplot_output <- function(ds, violin, show_points, log_project_y, title_data) {
  boxplot_chart(ds, violin, show_points, log_project_y, title_data)
}

#' @rdname boxplot_composed
#' @inheritParams bp_listings_table
#'
bp_get_listings_output <- function(ds, closest_point) {
  bp_listings_table(ds, closest_point) |>
    DT::datatable(colnames = as.character(get_lbls_robust(ds)))
}

#' @rdname boxplot_composed
#' @inheritParams bp_listings_table
#' @param input_id Shiny ID for the single listing button
bp_get_single_listings_output <- function(ds, closest_point, input_id) {
  buttons <- purrr::map(closest_point[[CNT$SBJ]], function(sbj) {
    as.character(shiny::tags[["button"]](
      class = "",
      shiny::icon("address-card"),
      onclick = sprintf(
        "Shiny.setInputValue('%s', '%s', {priority:'event'});", input_id, sbj
      )
    ))
  })

  closest_point[["View Details"]] <- buttons
  closest_point <- possibly_set_lbls(closest_point, get_lbls_robust(ds))
  closest_point <- DT::datatable(
    closest_point,
    colnames = as.character(get_lbls_robust(closest_point)),
    escape = TRUE
  )
}

#' @rdname boxplot_composed
#' @inheritParams bp_count_table
#'
bp_get_count_output <- function(ds) {
  labels <- c(get_lbls_robust(ds))
  count_table <- bp_count_table(ds) |>
    possibly_set_lbls(labels)
  DT::datatable(count_table, colnames = as.character(get_lbls_robust(count_table)))
}

#' @rdname boxplot_composed
#' @inheritParams bp_summary_table
bp_get_summary_output <- function(ds) {
  summary <- bp_summary_table(ds)
  summary <- possibly_set_lbls(summary, get_lbls_robust(ds))
  summary <- DT::datatable(summary, colnames = as.character(get_lbls_robust(summary)))
  summary <- DT::formatRound(summary, c("Mean", "SD", "Min", "Q1", "Median", "Q3", "Max"), digits = 2)
}

#' @rdname boxplot_composed
#' @inheritParams bp_significance_table
bp_get_significance_output <- function(ds) {
  # Where does this validation belong to the output or to the bp_significance table
  shiny::validate(
    shiny::need(
      CNT$MAIN_GROUP %in% names(ds),
      BP$MSG$VALIDATE$NO_MAIN_GROUP_SEL
    )
  )

  significance <- bp_significance_table(ds)
  significance <- possibly_set_lbls(significance, get_lbls_robust(ds))
  significance <- DT::datatable(significance, colnames = as.character(get_lbls_robust(significance)))
  significance <- DT::formatRound(significance, c("P Value"), digits = 2)
}

# Clicking helpers

#' Clicking helpers
#'
#' @description
#'
#' The boxplot requires several helpers to manage the clicks. The main function is `bp_get_closest_gen_click`, and the
#' other two are specific calls for `click` and `double_click` events.
#'
#' ## bp_get_closest_gen_click
#'
#' This function takes a dataset and a general click and returns the closest row to the click. It uses the
#' [shiny::nearPoints]. [shiny::nearpoints] function is not particularly well-behaved in two cases:
#'
#' - The ggplot does contain several facet levels
#' Solved by:
#' Prefiltering `ds` manually so it only contains the rows corresponding to the clicked facet
#'
#' - The ggplot lacks an `x` or `y` aesthetic
#' Solved by:
#' In this particular case the `x` aesthetic correspond to the `CNT$MAIN_GROUP` column. If no grouping
#' is specified during the selection this function assumes that a dummy `x` aesthetic was used in [boxplot_chart].
#' Therefore, this dummy variable is introduced as a column in `ds`, and [shiny::nearPoints] can be used.
#'
#' - The aesthetic has been defined using the `.data` pronoun to overcome NSE used in [ggplot2::ggplot]
#' Solved by:
#' Stripping `.data` pronouns before passing them into [shiny::nearPoints]
#'
#' ## Specific calls:
#'
#' After a click is made and a table shown, when the dataset changes, the app reaches this function in an invalid state
#' where `ds` contains the new dataset and `click` contains the click from the previous dataset. This usually provokes
#' that a 0-row dataset is returned.
#'
#' @param ds `data.frame()`
#'
#' A data frame containing the data to be filtered.
#'
#' @param click `list()`
#'
#' A list containing the click information as received from the `Shiny` input
#'
#' @return `data.frame`
#'
#' A data frame containing the closest row in `ds` to the click.
#' @keywords internal
bp_get_closest_gen_click <- function(ds, click) {
  is_main_grouped <- CNT$MAIN_GROUP %in% names(ds)

  # Prefilter ds using panelvars
  var <- click[["mapping"]][startsWith(names(click[["mapping"]]), "panelvar")]
  val <- click[names(var)]
  names(val) <- strip_data_pronoun(var)

  mask <- equal_and_mask_from_vec(ds = ds, fl = val)
  ds <- ds[mask, ]

  # Nearpoints cannot manage plots with no x aesthetic, therefore,
  # no main group implies no x aesthetic in the plot.
  # To solve boxplot_chart imputs a dummy main grouping
  # we have to patch the dataset to include this dummy grouping

  if (!is_main_grouped) {
    ds[[CNT$MAIN_GROUP]] <- click[["domain"]][["discrete_limits"]][["x"]]
  }

  cp <- shiny::nearPoints(
    ds,
    coordinfo = click,
    maxpoints = 1,
    threshold = Inf,
    xvar = strip_data_pronoun(click[["mapping"]][["x"]]),
    yvar = strip_data_pronoun(click[["mapping"]][["y"]]),
    panelvar1 = strip_data_pronoun(click[["mapping"]][["panelvar1"]]),
    panelvar2 = strip_data_pronoun(click[["mapping"]][["panelvar2"]])
  )

  if (!is_main_grouped) {
    cp <- dplyr::select(cp, -dplyr::any_of(CNT$MAIN_GROUP))
  }

  cp
}

#' @rdname bp_get_closest_gen_click
bp_get_closest_single_click <- function(ds, click) {
  shiny::validate(
    shiny::need(
      !is.null(click),
      BP$MSG$VALIDATE$CLICK_LISTING
    )
  )
  bp_get_closest_gen_click(ds, click)
}

#' @rdname bp_get_closest_gen_click
bp_get_closest_double_click <- function(ds, click) {
  shiny::validate(
    shiny::need(
      !is.null(click),
      BP$MSG$VALIDATE$CLICK_DLISTING
    )
  )
  bp_get_closest_gen_click(ds, click)
}
