# SCATTER PLOT MATRIX ----

SPM <- poc( # nolint
  ID = poc( # nolint
    PAR_BUTTON = "par_button",
    PAR = "par",
    PAR_VALUE = "par_value",
    PAR_VISIT = "par_visit",
    GRP_BUTTON = "grp_button",
    MAIN_GRP = "main_grp",
    OTHER_BUTTON = "other_button",
    CHART = "chart",
    TAB_TABLES = "tab_tables",
    TABLE_LISTING = "table_listing",
    TABLE_COUNT = "table_count",
    TABLE_SUMMARY = "table_summary",
    TABLE_SIGNIFICANCE = "table_significance",
    CHART_CLICK = "click"
  ),
  VAL = poc(
    ALPHA = .7
  ), # nolint
  MSG = poc( # nolint
    LABEL = poc(
      PAR_BUTTON = "Parameter",
      PAR = "Parameter",
      CAT = "Category",
      PAR_VALUE = "Value",
      PAR_VISIT = "Visit",
      PAR_TRANSFORM = "Transform",
      GRP_BUTTON = "Grouping",
      MAIN_GRP = "Group",
      SUB_GRP = "Subgroup",
      PAGE_GRP = "Page Group",
      OTHER_BUTTON = "Other",
      TABLE_LISTING = "Data Listing",
      TABLE_COUNT = "Data Count",
      TABLE_SUMMARY = "Data Summary",
      TABLE_SIGNIFICANCE = "Data Significance"
    ),
    VALIDATE = poc(
      NO_CAT_SEL = "Select a category",
      NO_PAR_SEL = "Select a parameter",
      NO_VALUE_SEL = "Value selection does not exist",
      UKNOWN_VALUE_SEL = "Select a value",
      NO_VISIT_SEL = "Select a visit",
      NO_MAIN_GROUP_SEL = "Select a group",
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
      LESS_THAN_2_PARAMETER = "Please select at least 2 parameters"
    )
  )
)

#' Matrix of scatterplots module
#'
#' @description
#'
#' `mod_scatterplotmatrix` is a Shiny module prepared to display data in a matrix of scatterplots with different levels
#'  of grouping. It also includes correlation stats.
#'
#' @name mod_scatterplotmatrix
#' @inheritParams scatterplotmatrix_server
#'
#' @keywords main
#'
NULL

#' Scatter plot matrix UI function
#' @keywords developers
#' @param id Shiny ID `[character(1)]`
#' @export
scatterplotmatrix_UI <- function(id) { # nolint
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  # argument asserts ----

  # UI ----
  ns <- shiny::NS(id)

  parameter_menu <- drop_menu_helper(
    ns(SPM$ID$PAR_BUTTON), SPM$MSG$LABEL$PAR_BUTTON,
    parameter_UI(id = ns(SPM$ID$PAR)),
    col_menu_UI(ns(SPM$ID$PAR_VALUE)),
    val_menu_UI(id = ns(SPM$ID$PAR_VISIT))
  )

  group_menu <- drop_menu_helper(
    ns(SPM$ID$GRP_BUTTON), SPM$MSG$LABEL$GRP_BUTTON,
    col_menu_UI(id = ns(SPM$ID$MAIN_GRP))
  )

  other_menu <- drop_menu_helper(
    ns(SPM$ID$OTHER_BUTTON), SPM$MSG$LABEL$OTHER_BUTTON
  )


  top_menu <- shiny::tagList(
    add_top_menu_dependency(),
    parameter_menu,
    group_menu,
    other_menu
  )

  # Charts and tables ----

  chart <- shiny::column(
    width = 12, align = "center",
    shiny::div(
      shiny::plotOutput(outputId = ns(SPM$ID$CHART), click = ns(SPM$ID$CHART_CLICK), height = "100%", width = "100%"),
      style = "height:70vh; width:70vh"
    )
  )

  #   # main_ui ----

  main_ui <- shiny::tagList(
    add_warning_mark_dependency(),
    shiny::div(top_menu, class = "bm_top_menu_bar"),
    chart
  )

  if (..__is_db()) {
    ..__db_UI(ns("debug"), main_ui, stacked = TRUE) # Debugging
  } else {
    main_ui
  }
}

#' Scatter plot matrix server function
#' @keywords developers
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
#' `visit_var` and `value_var`. The values of these variables are as described
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
#' @param default_cat,default_par,default_visit,default_value,default_main_group `[character(1)|NULL]`
#'
#' Default values for the selectors
#'
#' @export
#'
scatterplotmatrix_server <- function(id,
                                     bm_dataset,
                                     group_dataset,
                                     dataset_name = shiny::reactive(character(0)),
                                     cat_var = "PARCAT",
                                     par_var = "PARAM",
                                     value_vars = "AVAL",
                                     visit_var = "AVISIT",
                                     subjid_var = "USUBJID",
                                     default_cat = NULL,
                                     default_par = NULL,
                                     default_visit = NULL,
                                     default_value = NULL,
                                     default_main_group = NULL) {
  ac <- checkmate::makeAssertCollection()
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1, add = ac)
  # non reactive asserts
  ###### Check types of reactive variables, pred_dataset, ...
  checkmate::assert_character(default_cat, min.chars = 1, add = ac, null.ok = TRUE)
  checkmate::assert_character(default_par, min.chars = 1, add = ac, null.ok = TRUE)
  checkmate::assert_string(default_visit, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_value, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(default_main_group, min.chars = 1, null.ok = TRUE, add = ac)
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
    sv_not_empty <- function(input, msg) {
      function(x) if (test_not_empty(input())) NULL else msg
    }

    sv_not_empty_and_at_least_2 <- function(input, msg) {
      function(x) if (test_not_empty(input()) && length(input()) > 1) NULL else msg
    }

    inputs <- list()
    inputs[[SPM$ID$PAR]] <- parameter_server(
      id = SPM$ID$PAR,
      data = v_bm_dataset, cat_var = VAR$CAT, par_var = VAR$PAR, default_cat = default_cat, default_par = default_par
    )
    inputs[[SPM$ID$PAR_VISIT]] <- val_menu_server(
      id = SPM$ID$PAR_VISIT,
      label = SPM$MSG$LABEL$PAR_VISIT,
      data = v_bm_dataset,
      var = VAR$VIS,
      default = default_visit
    )
    inputs[[SPM$ID$PAR_VALUE]] <- col_menu_server(
      id = SPM$ID$PAR_VALUE,
      data = v_bm_dataset,
      label = SPM$MSG$LABEL$PAR_VALUE, include_func = function(val, name) {
        name %in% VAR$VAL
      },
      include_none = FALSE,
      default = default_value
    )
    inputs[[SPM$ID$MAIN_GRP]] <- col_menu_server(
      id = SPM$ID$MAIN_GRP,
      data = v_group_dataset,
      label = "Select a grouping variable",
      include_func = function(x) {
        is.factor(x) || is.character(x)
      },
      default = default_main_group
    )

    param_iv <- shinyvalidate::InputValidator$new()
    param_iv$add_rule(
      get_id(inputs[[SPM$ID$PAR]])[["cat"]],
      sv_not_empty(
        inputs[[SPM$ID$PAR]][["cat"]],
        SPM$MSG$VALIDATE$NO_CAT_SEL
      )
    )
    param_iv$add_rule(
      get_id(inputs[[SPM$ID$PAR]])[["par"]],
      sv_not_empty_and_at_least_2(
        inputs[[SPM$ID$PAR]][["par"]],
        SPM$MSG$VALIDATE$LESS_THAN_2_PARAMETER
      )
    )
    param_iv$add_rule(
      get_id(inputs[[SPM$ID$PAR_VISIT]]),
      sv_not_empty(
        inputs[[SPM$ID$PAR_VISIT]],
        SPM$MSG$VALIDATE$NO_VISIT_SEL
      )
    )
    param_iv$add_rule(
      get_id(inputs[[SPM$ID$PAR_VALUE]]),
      sv_not_empty(
        inputs[[SPM$ID$PAR_VALUE]],
        SPM$MSG$VALIDATE$NO_VALUE_SEL
      )
    )
    param_iv$enable()

    group_iv <- shinyvalidate::InputValidator$new()
    group_iv$add_rule(
      get_id(inputs[[SPM$ID$MAIN_GRP]]),
      sv_not_empty(
        inputs[[SPM$ID$MAIN_GRP]],
        SPM$MSG$VALIDATE$NO_MAIN_GROUP_SEL
      )
    )
    group_iv$enable()

    shiny::observeEvent(param_iv$is_valid(), {
      session$sendCustomMessage(
        "dv_bm_toggle_warning_mark",
        list(
          id = ns(SPM$ID$PAR_BUTTON),
          add_mark = !param_iv$is_valid()
        )
      )
    })

    shiny::observeEvent(group_iv$is_valid(), {
      session$sendCustomMessage(
        "dv_bm_toggle_warning_mark",
        list(
          id = ns(SPM$ID$GRP_BUTTON),
          add_mark = !group_iv$is_valid()
        )
      )
    })

    # input validation ----

    v_input_subset <- shiny::reactive(
      {
        shiny::validate(shiny::need(
          param_iv$is_valid() && group_iv$is_valid(),
          "Current selection cannot produce an output,
 please review menu feedback"
        ))
        subset_inputs <- c(SPM$ID$PAR, SPM$ID$PAR_VISIT, SPM$ID$PAR_VALUE, SPM$ID$MAIN_GRP)
        resolve_reactives <- function(x) {
          if (is.list(x)) {
            return(purrr::map(x, resolve_reactives))
          }
          x()
        }
        resolve_reactives(inputs[subset_inputs])
      },
      label = ns("input_roc")
    )


    # data reactives ----

    data_subset <- shiny::reactive({
      # Reactive is resolved first as nested reactives do no "react"
      # (pun intented) properly when used inside dplyr::filter
      # The suspect is NSE, but further testing is needed.
      l_input_roc <- v_input_subset()

      group_vect <- drop_nones(
        stats::setNames(
          c(l_input_roc[[SPM$ID$MAIN_GRP]]),
          CNT$MAIN_GROUP
        )
      )

      spm_subset_data(
        cat = l_input_roc[[SPM$ID$PAR]][["cat"]],
        par = l_input_roc[[SPM$ID$PAR]][["par"]],
        val_col = l_input_roc[[SPM$ID$PAR_VALUE]],
        vis = l_input_roc[[SPM$ID$PAR_VISIT]],
        group_vect = group_vect,
        bm_ds = v_bm_dataset(),
        group_ds = v_group_dataset(),
        subj_col = VAR$SBJ,
        cat_col = VAR$CAT,
        par_col = VAR$PAR,
        vis_col = VAR$VIS
      )
    })

    # List of output arguments
    output_arguments <- list()

    # scatter plot matrix ----
    output_arguments[[SPM$ID$CHART]] <- shiny::reactive(
      list(
        ds = data_subset()
      )
    )
    output[[SPM$ID$CHART]] <- shiny::renderPlot({
      do.call(get_scatterplotmatrix_output, output_arguments[[SPM$ID$CHART]]())
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

#' Invoke scatterplotmatrix module
#'
#' @param module_id `[character(1)]`
#'
#' Module Shiny id
#'
#' @param bm_dataset_name,group_dataset_name `[character(1)]`
#'
#' Name of the dataset
#'
#'
#' @keywords main
#'
#'
#' @export
mod_scatterplotmatrix <- function(module_id,
                                  bm_dataset_name,
                                  group_dataset_name,
                                  cat_var = "PARCAT",
                                  par_var = "PARAM",
                                  value_vars = "AVAL",
                                  visit_var = "AVISIT",
                                  subjid_var = "USUBJID",
                                  default_cat = NULL,
                                  default_par = NULL,
                                  default_visit = NULL,
                                  default_value = NULL,
                                  default_main_group = NULL) {
  mod <- list(
    ui = scatterplotmatrix_UI,
    server = function(afmm) {
      scatterplotmatrix_server(
        id = module_id,
        bm_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[bm_dataset_name]]),
        group_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[group_dataset_name]]),
        dataset_name = afmm[["dataset_name"]],
        cat_var = cat_var,
        par_var = par_var,
        value_vars = value_vars,
        visit_var = visit_var,
        subjid_var = subjid_var,
        default_cat = default_cat,
        default_par = default_par,
        default_visit = default_visit,
        default_value = default_value,
        default_main_group = default_main_group
      )
    },
    module_id = module_id
  )
  mod
}


# scatterplotmatrix module interface description ----
# TODO: Fill in
mod_scatterplotmatrix_API_docs <- list(
  "Scatter plot matrix",
  module_id = "",
  bm_dataset_name = "",
  group_dataset_name = "",
  cat_var = "",
  par_var = "",
  value_vars = "",
  visit_var = "",
  subjid_var = "",
  default_cat = "",
  default_par = "",
  default_visit = "",
  default_value = "",
  default_main_group = ""
)

mod_scatterplotmatrix_API_spec <- TC$group(
  module_id = TC$mod_ID(),
  bm_dataset_name = TC$dataset_name(),
  group_dataset_name = TC$dataset_name() |> TC$flag("subject_level_dataset_name"),
  cat_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("map_character_to_factor"),
  par_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("map_character_to_factor"),
  value_vars = TC$col("bm_dataset_name", TC$numeric()) |> TC$flag("one_or_more"),
  visit_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor(), TC$numeric())) |> TC$flag("map_character_to_factor"),
  subjid_var = TC$col("group_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("subjid_var", "map_character_to_factor"),
  default_cat = TC$choice_from_col_contents("cat_var") |> TC$flag("zero_or_more", "optional"),
  default_par = TC$choice_from_col_contents("par_var") |> TC$flag("zero_or_more", "optional"),
  default_visit = TC$choice_from_col_contents("visit_var") |> TC$flag("optional"),
  default_value = TC$choice("value_vars") |> TC$flag("optional"), # FIXME(miguel): ? Should be called default_value_var
  default_main_group = TC$col("group_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("optional")
) |> TC$attach_docs(mod_scatterplotmatrix_API_docs)

check_mod_scatterplotmatrix <- function(
    afmm, datasets, module_id, bm_dataset_name, group_dataset_name, cat_var, par_var, value_vars, visit_var,
    subjid_var, default_cat, default_par, default_visit, default_value, default_main_group) {
  warn <- CM$container()
  err <- CM$container()

  # TODO: Replace this function with a generic one that performs the checks based on mod_boxplot_API_spec.
  # Something along the lines of OK <- CM$check_API(mod_corr_hm_API_spec, args = match.call(), warn, err)
  OK <- check_mod_scatterplotmatrix_auto(
    afmm, datasets, module_id, bm_dataset_name, group_dataset_name, cat_var, par_var, value_vars, visit_var,
    subjid_var, default_cat, default_par, default_visit, default_value, default_main_group, warn, err
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

dataset_info_scatterplotmatrix <- function(bm_dataset_name, group_dataset_name, ...) {
  # TODO: Replace this function with a generic one that builds the list based on mod_boxplot_API_spec.
  # Something along the lines of CM$dataset_info(mod_scatterplotmatrix_API_spec, args = match.call())
  return(list(all = unique(c(bm_dataset_name, group_dataset_name)), subject_level = group_dataset_name))
}

mod_scatterplotmatrix <- CM$module(
  mod_scatterplotmatrix, check_mod_scatterplotmatrix,
  dataset_info_scatterplotmatrix, map_afmm_mod_scatterplotmatrix_auto
)

# Logic functions ----

# Data manipulation ----

#' Subset datasets for scatterplot matrix
#'
#' @description
#'
#' Prepares the basic input for the rest of the scatterplot matrix functions.
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
#' - `group_vect` names are a subset of `r CNT$MAIN_GROUP` or empty,
#' otherwise a regular error is produced.
#' - `label` attributes from `group_ds` and `bm_ds` are retained when available
#'
#' ## Shiny validation errors:
#'
#' - The bm_dataset fragments from bm contains more than row per subject, category, parameter and visit combination
#' - The fragment from group contains more than row per subject
#' - If `bm_ds` and `grp_ds` share column names, apart from `subj_col`, after internal renaming has occured
#' - If the returned dataset has 0 rows
#' - If the returned dataset has a single parameter column
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
#' | ``PAR1`` | ``PAR2`` | ``PAR3`` |``r CNT$MAIN_GROUP``
#' | -- | -- | -- | -- |
#' |xx|xx|xx|xx
#'
#' @keywords internal
#'
#' @export
#'
spm_subset_data <- function(cat,
                            cat_col,
                            par,
                            par_col,
                            val_col,
                            vis,
                            vis_col,
                            group_vect,
                            bm_ds,
                            group_ds,
                            subj_col) {
  is_grouped <- length(group_vect) > 0

  bm_fragment <- subset_bds_param(
    ds = bm_ds, par = par, par_col = par_col,
    cat = cat, cat_col = cat_col, val_col = val_col,
    vis = vis, vis_col = vis_col, subj_col = subj_col
  )

  shiny::validate(
    need_one_row_per_sbj(bm_fragment, CNT$SBJ, CNT$PAR, CNT$VIS, CNT$CAT, msg = CMN$MSG$VALIDATE$BM_TOO_MANY_ROWS),
    need_rows(bm_fragment),
    shiny::need(length(unique(bm_fragment[[CNT$PAR]])) > 1, SPM$MSG$VALIDATE$LESS_THAN_2_PARAMETER)
  )

  # Group data ----


  if (is_grouped) {
    checkmate::assert_subset(names(group_vect), c(CNT$MAIN_GROUP))
    grp_fragment <- subset_adsl(
      ds = group_ds, group_vect = group_vect, subj_col = subj_col
    )

    shiny::validate(
      need_one_row_per_sbj(grp_fragment, CNT$SBJ, msg = CMN$MSG$VALIDATE$GROUP_TOO_MANY_ROWS),
      need_no_rep_names_but_sbj(bm_fragment, grp_fragment, SPM$MSG$VALIDATE$GROUP_COL_REPEATED),
      need_rows(grp_fragment)
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

  # Drop levels for all non present levels in the factors, should we do this, or relevel to selection
  # Relabel incase the joint breaks something or droplevels breaks something
  shiny::validate(
    need_rows(joint_data)
  )

  joint_data <- joint_data |>
    dplyr::mutate(dplyr::across(dplyr::where(is.factor), droplevels)) |>
    dplyr::select(-dplyr::all_of(CNT$CAT)) |>
    possibly_set_lbls(get_lbls(joint_data)) |>
    tidyr::pivot_wider(names_from = CNT$PAR, values_from = CNT$VAL) |>
    dplyr::select(-dplyr::all_of(c(CNT$SBJ)))

  joint_data
}

# Chart functions ----

scatterplotmatrix_chart <- function(ds) {
  is_main_grouped <- CNT$MAIN_GROUP %in% names(ds)
  val_cols <- setdiff(names(ds), c(CNT$MAIN_GROUP, CNT$VIS))

  if (is_main_grouped) {
    mapping <- ggplot2::aes(color = .data[[CNT$MAIN_GROUP]], fill = .data[[CNT$MAIN_GROUP]])
  } else {
    mapping <- ggplot2::aes(fill = "1")
  }

  # Grab the first one as they are all the same
  val_col <- get_lbl_robust(ds, val_cols[[1]])

  # TODO?: Pass the errors to the consumer and deal with those there
  GGally::ggpairs(
    data = ds,
    columns = val_cols,
    mapping = mapping,
    progress = FALSE,
    upper = list(
      continuous = function(data, mapping, ...) {
        tryCatch(
          GGally::ggally_cor(data, mapping, ...),
          error = function(e) {
            ggplot2::ggplot(
              data.frame(text = "Error", x = 0, y = 0),
              mapping = ggplot2::aes(x = .data[["x"]], y = .data[["y"]], label = .data[["text"]])
            ) +
              ggplot2::geom_text() +
              ggplot2::theme_void()
          }
        )
      }
    ),
    diag = list(
      continuous = function(data, mapping, ...) {
        ggplot2::ggplot(data = data, mapping = mapping) +
          ggplot2::geom_density(..., alpha = SPM$VAL$ALPHA, color = NA)
      }
    ),
    lower = list(
      continuous = function(data, mapping, ...) {
        ggplot2::ggplot(data) +
          ggplot2::geom_point(mapping = mapping) +
          ggplot2::geom_smooth(mapping = mapping[c("x", "y")], method = "lm", formula = y ~ x)
      }
    )
  ) +
    ggplot2::theme(
      axis.title = ggplot2::element_text(size = STYLE$AXIS_TITLE_SIZE),
      axis.text.x = ggplot2::element_text(angle = 45, size = STYLE$AXIS_TEXT_SIZE, hjust = 1),
      axis.text.y = ggplot2::element_text(size = STYLE$AXIS_TEXT_SIZE),
      strip.text.x = ggplot2::element_text(angle = 90, hjust = 0),
      strip.text.y = ggplot2::element_text(angle = 0, hjust = 0)
    ) +
    ggplot2::labs(
      y = val_col,
      x = val_col
    )
}

# Composed functions ----

get_scatterplotmatrix_output <- function(ds) {
  scatterplotmatrix_chart(ds)
}
