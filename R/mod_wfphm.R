# First level entries in WFPHM point to different modules so name repetition is not an issue
# nolint start
WFPHM_ID <- pack_of_constants( # nolint
  WF = pack_of_constants(
    CONT = "cont",
    GROUP = "group",
    CHECK = "check",
    PAR = "par",
    LOG = "log",
    VALUE = "value",
    VISIT = "visit",
    OUTLIER = "outlier",
    CHART = "chart"
  ),
  HMCAT = pack_of_constants(
    CAT = "cat",
    CONTAINER = "container",
    CHART = "chart",
    LEGEND = "legend"
  ),
  HMCONT = pack_of_constants(
    CONT = "cont",
    CONTAINER = "container",
    CHART = "chart"
  ),
  HMPAR = pack_of_constants(
    PAR = "par",
    LOG = "log",
    VALUE = "value",
    VISIT = "visit",
    TRANSFORM = "transform",
    OUTLIER = "outlier",
    CHART = "chart"
  ),
  WFPHM = pack_of_constants(
    WF = "wf",
    HMCAT = "hmcat",
    HMCONT = "hmcont",
    HMPAR = "hmpar",
    NON_GXP_TAG = "non_gxp_tag",
    CHART_CONTAINER = "chart_container",
    WF_MENU = "wf_menu",
    CC_MENU = "cc_menu",
    PAR_MENU = "par_menu",
    OUTLIER_MENU = "outlier_menu",
    DOWNLOAD_MENU = "download_menu",
    FILENAME = "filename",
    SAVE_PNG = "save_png",
    SAVE_SVG = "save_svg",
    CHART_WIDTH = "chart_width"
  )
)

WFPHM_VAL <- pack_of_constants( # nolint
  WF = pack_of_constants(
    HEIGHT = "200px",
    OUTLIER_LABEL = "outlier",
    OUTLIER_COLOR = "gray"
  ),
  HMCAT = pack_of_constants(
    HEIGHT = 50
  ),
  HMCONT = pack_of_constants(
    HEIGHT = 50
  ),
  HMPAR = pack_of_constants(
    HEIGHT = "400px",
    OUTLIER_LABEL = "x",
    OUTLIER_STYLE = "fill: white; font-weight: bold;"
  ),
  WFPHM = poc(
    DOWNLOAD = poc(
      CHART_WIDTH = 3000
    )
  )
)

WFPHM_MSG <- pack_of_constants( # nolint
  BASE = pack_of_constants(
    NO_ROWS = "Dataset has 0 rows",
    COL_DOES_NOT_EXIST = "is not a column in the dataset. Please make sure that your dataset contains the adequate columns and this module is correctly parametrized."
  ),
  WF = pack_of_constants(
    MENU = "Waterfall",
    GROUP = "Grouping",
    PAR_COL = "Display demographic baseline information",
    CONT = "Value",
    PAR = c("Category", "Parameter"),
    VISIT = "Visit",
    VALUE = "Value",
    VALIDATE = pack_of_constants(
      NO_CONT_SEL = "(Waterfall) Select a continuous variable",
      NO_GROUP_SEL = "(Waterfall) Select a grouping variable",
      NO_CAT_SEL = "(Waterfall) Select a category",
      NO_PAR_SEL = "(Waterfall) Select a parameter",
      NO_VISIT_SEL = "(Waterfall) Select a visit",
      NO_VALUE_SEL = "(Waterfall) Select a value",
      TOO_MANY_ROWS_VALUE = "(Waterfall) Selected value cannot be plotted. The selection returns more than 1 row per subject.",
      TOO_MANY_ROWS_GROUP = "(Waterfall) Selected group cannot be plotted. The selection returns more than 1 row per subject."
    )
  ),
  HMCAT = pack_of_constants(
    MENU = "Con/Cat",
    SEL = "Discrete heatmap",
    VALIDATE = pack_of_constants(
      NO_CAT_SEL = "(Cat. Heatmap) Select a categorical variable",
      TOO_MANY_ROWS = "(Cat. Heatmap) Selected variable cannot be plotted. The selection returns more than 1 row per subject."
    )
  ),
  HMCONT = pack_of_constants(
    # MENU_TITLE = USES HMCAT,
    SEL = "Continuous heatmap",
    VALIDATE = pack_of_constants(
      NO_CONT_SEL = "(Cont. Heatmap) Select a continuous variable",
      TOO_MANY_ROWS = "(Cont. Heatmap) Selected variable cannot be plotted. The selection returns more than 1 row per subject."
    )
  ),
  HMPAR = pack_of_constants(
    BASE_MENU = "Param. Heatmap",
    OUTLIER_MENU = "Outlier",
    PAR = c("Parameter Category", "Parameter"),
    VALUE = "Select Value",
    VISIT = "Visit",
    TRANSFORMATION = "Transformation",
    OUTLIER = "Select a parameter",
    VALIDATE = pack_of_constants(
      NO_PAR_SEL = "(Par. Heatmap) Select a parameter",
      NO_CAT_SEL = "(Par. Heatmap) Select a category",
      NO_VISIT_SEL = "(Par. Heatmap) Select a visit",
      NO_VALUE_SEL = "(Par. Heatmap) Select a value",
      NO_TRANSFORMATION_SEL = "(Par. Heatmap) Select a transformation",
      TOO_MANY_ROWS =
        "(Par. Heatmap) Selected parameter cannot be plotted. The selection returns more than 1 row per subject.",
      NO_ROWS = "(Par. Heatmap) The menu selection returns a dataset with 0 rows."
    )
  ),
  WFPHM = poc(
    DOWNLOAD = poc(
      MENU = "Download chart",
      FILENAME = poc(
        LABEL = "Save as",
        PLACEHOLDER = "Chart filename"
      ),
      SAVE_PNG = "Save as PNG",
      SAVE_SVG = "Save as SVG",
      CHART_WIDTH = "Chart width in pixels"
    )
  )
)

# nolint end

# WF Component

#' Waterfall component of WFPHM
#'
#' @param id Shiny ID `[character(1)]`
#'
#' @param dataset `[shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`
#'
#' It expects the following format:
#'
#'  - it contains, at least, the columns specified in the parameters: `cat_var`, `par_var`, `value_vars`, `visit_var`
#' and `subjid_var`
#'  - `cat_var`, `par_var`, `visit_var` and `subjid_var` columns are factors
#'
#' @param cat_var,par_var,visit_var,subjid_var `[character(1)]`
#'
#' columns used as indicated in the details section
#'
#' @param value_vars `[character(1+)]`
#'
#' possible colum values. If column is labelled, label will be displayed in the value menu
#'
#' @param bar_group_palette `[list(palettes)]`
#'
#' list of custom palettes to apply to bar_grouping. It receives the values used for grouping and must return a DaVinci
#' palette. Each palette is applied when the name of the entry in the list matches the name of the column used for
#' grouping
#'
#' @param margin `[numeric(4) | shiny::reactive(numeric(4)) | shinymeta::metaReactive(numeric(4))]`
#'
#'  margin to be used on each of the sides. It must contain four entries named `top`, `bottom`, `left` and `right`
#'
#' @return
#'
#' ## UI
#' A bar plot
#'
#' ## Server
#' A list with two entries:
#'  - `margin`: similar to the `margin` parameter with the minimum margins for the current plot
#'  - `sorted_x`: From the subsetted data the `x` levels sorted from high to low by `y`
#'
#'
#' @details
#'
#' Data subsetting:
#'    - Allows selecting a column from all factor or character columns, from now on **grouping_selection**.
#'      - Menu labelled: `r WFPHM_MSG$WF$GROUP`
#'    - Data selection for plotting can be done in two modes switched by:
#'      - Menu labelled: `r WFPHM_MSG$WF$PAR_COL`
#'
#' ## Mode 1:
#'
#'    - Allows selecting a column from the set of all numerical columns, from now on **value_selection**.
#'      - Menu labelled: `r WFPHM_MSG$WF$CONT`
#'    - Subsets the dataset to the columns **grouping_selection**, `subj_var` and **value_selection**.
#'    - Removes all repeated rows from the dataset
#'    - If more than one row have the same `subj_var` an informative error indicating the plot cannot be created
#'  is shown.
#'
#' ## Mode 2:
#'    - Allows selecting a value from the `cat_var` column, from now on **cat_selection** and a value from the `par_var`
#'  column from the subset of rows where `par_cat` is equal to **cat_selection** from now on **par_selection**.
#'      - Menu labelled: `r WFPHM_MSG$WF$PAR[1]` and `r WFPHM_MSG$WF$PAR[2]`
#'    - Allows selecting between the columns defined in `val_var` from now on **value_selection**.
#'      - Menu labelled: `r WFPHM_MSG$WF$VALUE`
#'    - Allows selecting a value from `visit_var` column, from now on **visit_selection**.
#'      - Menu labelled: `r WFPHM_MSG$WF$VISIT`
#'    - Subsets the dataset rows where:
#'      - `visit_var` equal to **visit_selection**
#'      - `par_var` equal to **par_selection**
#'    - Subsets the dataset to the **grouping_selection**, the `subj_var` and the **value_selection**.
#'    - If more than one row have the same `subj_var` an informative error indicating the plot cannot be created
#'  is shown.
#'
#' Then the dataset is prepared to be passed to [bar_D3]:
#'  - `subj_var` becomes `x` column
#'  - `val_selection` becomes `y` column
#'  -  the label attribute of `y` column is either `value_selection` in *Mode 1* or `par_selection` in *Mode 2*
#'  - `grouping_selection` becomes `z` column
#'  - `grouping_selection` becomes `label` column
#'
#' ## Completing the dataset:
#'  - Subset dataset will be completed in the following way. If any level in `x` is not present in the subset
#' dataset, but it was present in the `subj_var` column in the original dataset, a row is added where `x` is equal to
#' the missing value `y` is NA and `z` is NA.
#'
#' ## Data outliers:
#'  - Allows setting two limits upper and lower, values above or below in the subsetted dataset will be considered
#'  outliers. Rows considered outliers will have the column:
#'    - `label` replaced by "`r WFPHM_VAL$WF$OUTLIER_LABEL`"
#'    - `color` equal to "`r WFPHM_VAL$WF$OUTLIER_COLOR`"
#'  - Rows not considered outliers will have the column:
#'    - `color` equal to NA
#'
#' ## X axis sorting
#' - `x` levels are sorted from greater to lower value in `y`
#'
#' Then a call to [bar_D3] is done with the following arguments:
#'  - `data` = `subset dataset` (as described above)
#'  - `x_axis` = `NULL`
#'  - `y_axis` = `W`
#'  - `z_axis` = NULL
#'  - `margin` is the parameter passed to this same function
#'  - `palette` is hardcoded with 8 colors. After 8 categories colors are repeated
#'  - `msg_func` = NULL
#'  - `quiet` = TRUE
#'
#' @keywords internal
#'
#' @name wfphm_wf
#'
NULL

#' Waterfall UI function
#' @keywords developers
wfphm_wf_UI <- function(id) { # nolintr

  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  # paste ctxt ----
  paste_ctxt <- paste_ctxt_factory(id) # nolint

  # argument asserts ----

  # UI ----
  ns <- shiny::NS(id)

  # menu ----
  menu <- shiny::tagList(
    shiny::checkboxInput(ns(WFPHM_ID$WF$CHECK), label = WFPHM_MSG$WF$PAR_COL, value = FALSE),
    shiny::conditionalPanel(
      paste0("input['", ns(WFPHM_ID$WF$CHECK), "']===true"),
      col_menu_UI(id = ns(WFPHM_ID$WF$CONT))
    ),
    shiny::conditionalPanel(
      paste0("input['", ns(WFPHM_ID$WF$CHECK), "']===false"),
      parameter_UI(id = ns(WFPHM_ID$WF$PAR)),
      col_menu_UI(ns(WFPHM_ID$WF$VALUE)),
      val_menu_UI(id = ns(WFPHM_ID$WF$VISIT))
    ),
    col_menu_UI(id = ns(WFPHM_ID$WF$GROUP)),
    shiny::conditionalPanel(
      paste0("true"), # "input['", attr(group_selector, "ns_gen_id", exact = TRUE), "']!==''"),
      outlier_container_single_UI(ns(WFPHM_ID$WF$OUTLIER))
    )
  )

  # chart ----

  chart <- bar_d3_UI(ns(WFPHM_ID$WF$CHART), height = WFPHM_VAL$WF$HEIGHT)

  # return ----

  list(
    menu = menu,
    chart = chart
  )
}

# nolint start cyclocomp_linter
#' Waterfall server function
#' @keywords developers
wfphm_wf_server <- function(id,
                            bm_dataset,
                            group_dataset,
                            cat_var, par_var,
                            visit_var,
                            subjid_var,
                            value_vars,
                            .default_group_palette = function(x) {
                              pal_get_cat_palette(x, viridisLite::viridis(length(unique(x))))
                            },
                            bar_group_palette = list(),
                            margin) {
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)



  module <- function(input, output, session) {
    # sessions ----
    ns <- session[["ns"]]

    # paste ctxt ----
    paste_ctxt <- paste_ctxt_factory(ns(""))

    # argument asserts ----

    ac <- checkmate::makeAssertCollection()
    checkmate::assert_string(cat_var, add = ac, .var.name = paste_ctxt(cat_var))
    checkmate::assert_string(par_var, add = ac, .var.name = paste_ctxt(par_var))
    checkmate::assert_string(visit_var, add = ac, .var.name = paste_ctxt(visit_var))
    checkmate::assert_string(subjid_var, add = ac, .var.name = paste_ctxt(subjid_var))
    checkmate::assert_character(value_vars,
      any.missing = FALSE, unique = TRUE,
      add = ac, .var.name = paste_ctxt(value_vars)
    )
    checkmate::assert_multi_class(bm_dataset, c("reactive", "shinymeta_reactive"),
      add = ac,
      .var.name = paste_ctxt(bm_dataset)
    )
    checkmate::assert_multi_class(group_dataset, c("reactive", "shinymeta_reactive"),
      add = ac,
      .var.name = paste_ctxt(group_dataset)
    )

    # assert for all entries
    purrr::walk(bar_group_palette, ~ assert_palette(.x(letters), ac))
    # margin is only forwarded so asserting is done in [barplot_d3_server]
    checkmate::reportAssertions(ac)

    # dataset validation ----

    # input ----
    inputs <- list()
    inputs[["cont"]] <- col_menu_server(
      id = WFPHM_ID$WF$CONT,
      data = group_dataset,
      include_func = is.numeric,
      label = "Select a continuous variable",
      include_none = FALSE
    )
    inputs[["group"]] <- col_menu_server(
      id = WFPHM_ID$WF$GROUP,
      data = group_dataset,
      include_func = function(x) {
        is.factor(x) || is.character(x)
      },
      label = WFPHM_MSG$WF$GROUP,
      include_none = FALSE
    )

    inputs[["par"]] <- parameter_server(
      id = WFPHM_ID$WF$PAR,
      data = bm_dataset,
      cat_var = cat_var,
      par_var = par_var,
      multi_cat = FALSE,
      multi_par = FALSE
    )

    inputs[["visit"]] <- val_menu_server(
      id = WFPHM_ID$WF$VISIT,
      label = WFPHM_MSG$WF$VISIT,
      data = bm_dataset,
      var = visit_var
    )

    inputs[["value"]] <- col_menu_server(
      id = WFPHM_ID$WF$VALUE,
      data = bm_dataset,
      include_func = function(val, name) {
        name %in% value_vars
      },
      include_none = FALSE,
      label = WFPHM_MSG$WF$VALUE
    )

    inputs[["check"]] <- shiny::reactive({
      input[[WFPHM_ID$WF$CHECK]]
    })

    inputs[["outlier"]] <- outlier_con_single_server(
      id = WFPHM_ID$WF$OUTLIER,
      selection = shiny::reactive({
        l_inputs <- v_input_subset()
        if (!l_inputs[["check"]]) l_inputs[["par"]][["par"]] else l_inputs[["cont"]]
      })
    )

    sv_not_empty <- function(input, ..., msg) {
      function(x) {
        if (test_not_empty(input())) NULL else msg
      }
    }

    # TODO: Validator does not applu properly to single menus. It only appears in the button.
    # They properly applied in other modules but fail in this one.
    # Likely suspects are shinyOutput and several passes until data is loaded
    # Maybe moving the validator inside the selectors is the correct way of addressing this.

    par_iv <- shinyvalidate::InputValidator$new()

    par_iv$add_rule(
      get_id(inputs[["par"]])[["par"]],
      sv_not_empty(inputs[["par"]][["par"]],
        msg = WFPHM_MSG$WF$VALIDATE$NO_PAR_SEL
      )
    )

    par_iv$add_rule(
      get_id(inputs[["par"]])[["cat"]],
      sv_not_empty(inputs[["par"]][["cat"]],
        msg = WFPHM_MSG$WF$VALIDATE$NO_CAT_SEL
      )
    )

    par_iv$add_rule(
      get_id(inputs[["visit"]]),
      sv_not_empty(inputs[["visit"]],
        msg = WFPHM_MSG$WF$VALIDATE$NO_VISIT_SEL
      )
    )
    par_iv$enable()

    cont_iv <- shinyvalidate::InputValidator$new()
    cont_iv$add_rule(
      get_id(inputs[["cont"]]),
      sv_not_empty(inputs[["cont"]],
        msg = WFPHM_MSG$WF$VALIDATE$NO_CONT_SEL
      )
    )
    cont_iv$enable()

    group_iv <- shinyvalidate::InputValidator$new()
    group_iv$add_rule(
      get_id(inputs[["group"]]),
      sv_not_empty(inputs[["group"]],
        msg = WFPHM_MSG$WF$VALIDATE$NO_GROUP_SEL
      )
    )
    group_iv$enable()

    v_input_subset <- shiny::reactive(
      {
        shiny::req(!is.null(inputs[["check"]]()))
        valid <- ((!inputs[["check"]]() && par_iv$is_valid()) || (inputs[["check"]]() && cont_iv$is_valid())) &&
          group_iv$is_valid()

        shiny::validate(
          shiny::need(
            valid,
            "Current selection cannot produce an output, please review menu feedback"
          )
        )

        subset_inputs <- c("cont", "group", "par", "visit", "value", "check")
        resolve_reactives <- function(x) {
          if (is.list(x)) {
            return(purrr::map(x, resolve_reactives))
          }
          x()
        }
        resolve_reactives(inputs[subset_inputs])
      },
      label = ns("inputs")
    )
    # TODO: |> shiny::debounce(BP$VAL$SUBSET_DEBOUNCE_TIME)

    data <- shiny::reactive(
      {
        # The original dataset in the app has subjects A B C and D. After globally filtering only participants A B and C
        # survive the filtering. Now the levels in the subjid_var factor are incorrect as they include participant D.
        # Therefore we drop the unused levels.

        l_inputs <- v_input_subset()

        df <- if (l_inputs[["check"]]) {
          wfphm_wf_subset_data_cont(
            val_col = l_inputs[["cont"]],
            color_col = l_inputs[["group"]],
            group_ds = group_dataset(),
            subj_col = subjid_var
          )
        } else {
          wfphm_wf_subset_data_par(
            cat = l_inputs[["par"]][["cat"]],
            par = l_inputs[["par"]][["par"]],
            val_col = l_inputs[["value"]],
            vis = l_inputs[["visit"]],
            color_col = l_inputs[["group"]],
            bm_ds = bm_dataset(),
            group_ds = group_dataset(),
            subj_col = subjid_var,
            cat_col = cat_var,
            par_col = par_var,
            vis_col = visit_var
          )
        }
        df |>
          wfphm_wf_apply_outliers(ll = inputs[["outlier"]]()[["ll"]], ul = inputs[["outlier"]]()[["ul"]]) |>
          wfphm_wf_rename_cols()
      },
      label = ns(" data")
    )

    sorted_x <- shiny::reactive(
      levels(data()[["x"]]),
      label = ns(" sorted_x")
    )

    # chart helpers ----

    palette <- shiny::reactive(
      {
        if (v_input_subset()[["group"]] %in% names(bar_group_palette)) {
          pal_fun <- bar_group_palette[[v_input_subset()[["group"]]]]
        } else {
          pal_fun <- .default_group_palette
        }

        pal_fun(data()[["z"]])
      },
      label = ns(" palette")
    )

    msg_func <- shiny::reactive(
      {
        val_label <- if (v_input_subset()[["check"]]) v_input_subset()[["cont"]] else v_input_subset()[["par"]][["par"]]
        group <- v_input_subset()[["group"]]
        paste0(
          "(d)=>`", subjid_var, ": ${d.x}<br>", val_label, ": ${d.y}<br>", group, ":${d.z}`"
        )
      },
      label = ns(" msg_func")
    )

    # chart ----
    chart_args <- list(
      id = WFPHM_ID$WF$CHART,
      data = data,
      x_axis = NULL,
      y_axis = "W",
      z_axis = NULL,
      margin = margin,
      palette = palette,
      msg_func = msg_func
    )

    chart_info <- do.call(bar_d3_server, chart_args)

    # return ----

    r <- list(
      sorted_x = sorted_x,
      margin = chart_info[["margin"]],
      valid = shiny::reactive({
        shiny::req(!is.null(inputs[["check"]]()))
        ((!inputs[["check"]]() && par_iv$is_valid()) || (inputs[["check"]]() && cont_iv$is_valid())) &&
          group_iv$is_valid()
      })
    )

    if (isTRUE(getOption("shiny.testmode"))) do.call(shiny::exportTestValues, as.list(environment()))

    r
  }

  shiny::moduleServer(id, module)
}
# nolint end cyclocomp_linter

#' Subset datasets for waterfall in waterfall plus heatmap
#'
#' @description
#'
#' Prepares the basic input for the rest of waterfall heatmap functions
#'   - `bm_dataset` is subset according to category, parameter and visit selection
#'   - `group_dataset` is subset according to group_selection
#'   - both are joined using `subject_col` as a common key
#'   - it uses a full join to include the subjects that has no parameter value for that parameter visit combination
#'
#' It is based on [subset_bds_param()] and [subset_adsl()] with additional error checking.
#'
#' @details
#'
#' - columns are renamed to `x`, `y`, `z` and `color`
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
#' @param color_col the column used to color the bars
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
#' | `x` | `y` | `z` |`color` |
#' | -- | -- | -- | -- |
#' |xx|xx|xx|xx|
#'
#' @keywords internal
#'
wfphm_wf_subset_data_par <- function(cat,
                                     cat_col,
                                     par,
                                     par_col,
                                     val_col,
                                     vis,
                                     vis_col,
                                     color_col,
                                     bm_ds,
                                     group_ds,
                                     subj_col) {
  bm_fragment <- subset_bds_param(
    ds = bm_ds, par = par, par_col = par_col,
    cat = cat, cat_col = cat_col, val_col = val_col,
    vis = vis, vis_col = vis_col, subj_col = subj_col
  )

  shiny::validate(
    need_one_row_per_sbj(bm_fragment, CNT$SBJ, CNT$PAR, CNT$VIS, msg = CMN$MSG$VALIDATE$BM_TOO_MANY_ROWS)
  )

  group_vect <- stats::setNames(color_col, CNT$MAIN_GROUP)

  checkmate::assert_subset(names(group_vect), c(CNT$MAIN_GROUP, CNT$SUB_GROUP, CNT$PAGE_GROUP))

  grp_fragment <- subset_adsl(
    ds = group_ds, group_vect = group_vect, subj_col = subj_col
  )

  shiny::validate(
    need_one_row_per_sbj(grp_fragment, CNT$SBJ, msg = CMN$MSG$VALIDATE$GROUP_TOO_MANY_ROWS),
    need_disjunct_cols(bm_fragment, grp_fragment, ignore = CNT$SBJ, msg = CMN$MSG$VALIDATE$GROUP_COL_REPEATED)
  )

  joint_data <- dplyr::full_join(
    bm_fragment,
    grp_fragment,
    by = c(CNT$SBJ)
  ) |>
    set_lbls(get_lbls(bm_fragment)) |>
    set_lbls(get_lbls(grp_fragment))

  shiny::validate(
    need_rows(joint_data)
  )

  labels <- get_lbls(joint_data)

  # Relevel biomarker factors but groups remain untouched
  if (!isTRUE(attr(bm_fragment, "parameter_renamed"))) {
    joint_data[[CNT$PAR]] <- factor(par, levels = par)
  }
  joint_data[[CNT$CAT]] <- factor(cat, levels = cat)
  joint_data[[CNT$VIS]] <- factor(vis, levels = vis)

  sorted_subjects <- dplyr::arrange(joint_data, -(.data[[CNT$VAL]]))[[CNT$SBJ]]
  joint_data[[CNT$SBJ]] <- factor(joint_data[[CNT$SBJ]], levels = sorted_subjects)
  joint_data[["label"]] <- as.character(joint_data[[CNT$MAIN_GROUP]])

  # Relabel with labels before releveling
  set_lbls(joint_data, labels)
}

#' Subsets a subject level dataset for the waterfall heatmap
#'
#' Levels in subject column are ordered with respect to value column higher to lower
#'
#' @param val_col the column from the group_dataset to be used
#'
#' @param color_col the column to be used for coloring/grouping
#'
#' @param group_ds the subject level dataset
#'
#' @param subj_col the subject id column
#'
#' @keywords internal

wfphm_wf_subset_data_cont <- function(val_col,
                                      color_col,
                                      group_ds,
                                      subj_col) {
  group_vect <- stats::setNames(c(color_col, val_col), c(CNT$MAIN_GROUP, CNT$VAL))

  grp_fragment <- subset_adsl(
    ds = group_ds, group_vect = group_vect, subj_col = subj_col
  )

  lbls <- get_lbls_robust(grp_fragment)

  shiny::validate(
    need_one_row_per_sbj(grp_fragment, CNT$SBJ, msg = CMN$MSG$VALIDATE$GROUP_TOO_MANY_ROWS)
  )

  df <-
    grp_fragment |>
    set_lbls(get_lbls(grp_fragment))

  shiny::validate(
    need_rows(df)
  )

  sorted_subjects <- dplyr::arrange(df, -(.data[[CNT$VAL]]))[[CNT$SBJ]]
  df[[CNT$PAR]] <- val_col
  df[[CNT$SBJ]] <- factor(df[[CNT$SBJ]], levels = sorted_subjects)
  df[["label"]] <- as.character(df[[CNT$MAIN_GROUP]])

  df <- set_lbls(df, lbls)


  df
}

#' Color bars and changes labels to outliers
#'
#' `label` is replaced by ``r  WFPHM_VAL$WF$OUTLIER_LABEL``
#'
#' `color` is replaced by ``r WFPHM_VAL$WF$OUTLIER_COLOR``
#'
#' @param df the dataframe where we will apply the outliers
#'
#' @param ll,ul the lower/upper value limit to consider an entry an outlier
#'
#' @keywords internal

wfphm_wf_apply_outliers <- function(df, ll, ul) {
  df <- force(df)
  ll <- force(ll)
  ul <- force(ul)



  shiny::maskReactiveContext({
    ll <- if (is.na(ll)) {
      min(df[[CNT$VAL]], na.rm = TRUE)
    } else {
      ll
    }

    ul <- if (is.na(ul)) {
      max(df[[CNT$VAL]], na.rm = TRUE)
    } else {
      ul
    }

    is_outlier <- !dplyr::between(as.numeric(df[[CNT$VAL]]), ll, ul)
    is_outlier[is.na(is_outlier)] <- FALSE

    # Apply outliers only when there is at least one outlier
    if (!is.null(is_outlier) && any(is_outlier)) {
      df[["label"]][is_outlier] <- WFPHM_VAL$WF$OUTLIER_LABEL
      df[["color"]] <- dplyr::if_else(is_outlier, WFPHM_VAL$WF$OUTLIER_COLOR, NA_character_)
    }
    df
  })
}

#' Renames wf subset columns
#'
#' column names are replaced by x y z
#'
#' y column label is set
#'
#' @param df the dataframe
#'
#' @keywords internal
wfphm_wf_rename_cols <- function(df) {
  contain_visit <- CNT$VIS %in% names(df)
  visit <- levels(df[[CNT$VIS]])
  param <- levels(df[[CNT$PAR]])
  val_lbl <- get_lbl_robust(df, CNT$VAL)

  df[["x"]] <- df[[CNT$SBJ]]
  df[["y"]] <- df[[CNT$VAL]]
  df[["z"]] <- df[[CNT$MAIN_GROUP]]
  df <- df[, c("x", "y", "z", "label", if ("color" %in% names(df)) "color")]

  if (!contain_visit) {
    df <- set_lbl(df, "y", sprintf("%s (%s)", param, val_lbl))
  } else {
    df <- set_lbl(df, "y", sprintf("%s (%s) at %s", param, val_lbl, visit))
  }
  df
}


# HM Cat Component

#' Categorical heatmap component of WFPHM
#'
#' Presents a heatmap plot for categorical variables
#'
#' @param id Shiny ID `[character(1)]`
#'
#' @param dataset `[shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`
#'
#' It expects the following format:
#'
#'  - it contains, at least, the columns specified in the parameters: `subjid_var`
#'  - `subjid_var` columns is a factor
#'
#' @param subjid_var `[character(1)]`
#'
#' column used as indicated in the details section
#'
#' @param sorted_x `[factor(*) | shiny::reactive(factor(*)) | shinymeta::metaReactive(factor(*))]`
#'
#' indicates how the levels of `subjid_var` should be ordered in the X axis.
#'
#' @param cat_palette `[list(functions)]`
#'
#' list of functions that receive the values of the variable and returns a vector with the colors for each of the values
#' Each palette is applied when the name of the entry in the list matches the name of the selected categorical
#' variable
#'
#' @param margin `[numeric(4) | shiny::reactive(numeric(4)) | shinymeta::metaReactive(numeric(4))]`
#'
#'  margin to be used on each of the sides. It must contain four entries named `top`, `bottom`, `left` and `right`
#'
#' @return
#'
#' ## UI
#' A heatmap plot
#'
#' ## Server
#' A list with one entry:
#'  - `margin`: similar to the `margin` parameter with the minimum margins for the current plot
#'
#' @details
#'
#' # Data subsetting:
#'    - Allows selecting several columns from all factor or character columns, from now on **category_selection**.
#'      - Menu labelled: `r WFPHM_MSG$HMCAT$SEL`
#'
#'    - Subsets the dataset to the columns **category_selection**, and `subj_var`.
#'    - Pivot the dataset to a longer format such that each row have:
#'      - column `x`: the value of `subjid_var`
#'      - column `y`: the value of a **category_selection**
#'      - column `z`: the value of the **category_selection** in `y` for the value in `x`
#'    - If more than one row have the same `x` and `y` an informative error indicating the plot cannot be created
#'  is shown.
#'
#' ## X axis ordering
#' - `x` levels are ordered according to `sorted_x`
#'
#' Then a call to [heatmap_D3] is done with the following arguments:
#'  - `data` = `subset dataset` (as described above)
#'  - `x_axis` = `NULL`
#'  - `y_axis` = `W`
#'  - `z_axis` = `E`
#'  - `margin` is the parameter passed to this same function
#'  - `palette` is hardcoded with 8 colors. After 8 categories colors are repeated
#'  - `msg_func` = NULL
#'  - `quiet` = TRUE
#'
#' @keywords internal
#'
#' @name wfphm_hmcat
#'
NULL

#' Waterfall plus heatmap categorical heatmap UI function
#' @keywords developers
wfphm_hmcat_UI <- function(id) { # nolint

  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1) # nolint

  # paste ctxt ----
  paste_ctxt <- paste_ctxt_factory(id) # nolint

  # argument asserts ----

  # UI ----
  ns <- shiny::NS(id)

  # menu ----

  menu <- col_menu_UI(id = ns(WFPHM_ID$HMCAT$CAT))

  # chart ----

  chart <- shiny::uiOutput(ns(WFPHM_ID$HMCAT$CONTAINER))

  # legend ----
  legend <- shiny::uiOutput(
    ns(WFPHM_ID$HMCAT$LEGEND)
  )
  # return ----

  list(
    menu = menu,
    chart = chart,
    legend = legend
  )
}

#' Waterfall plus heatmap categorical heatmap server function
#' @keywords developers
wfphm_hmcat_server <- function(id,
                               dataset,
                               subjid_var,
                               sorted_x,
                               cat_palette = list(),
                               margin) {
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  module <- function(input, output, session) {
    # sessions ----
    ns <- session[["ns"]]

    # paste ctxt ----
    paste_ctxt <- paste_ctxt_factory(ns(""))

    # argument asserts ----

    ac <- checkmate::makeAssertCollection()
    checkmate::assert_string(subjid_var, add = ac, .var.name = paste_ctxt(subjid_var))
    checkmate::assert_multi_class(dataset, c("reactive", "shinymeta_reactive"),
      add = ac,
      .var.name = paste_ctxt(dataset)
    )
    checkmate::assert_multi_class(sorted_x, c("reactive", "shinymeta_reactive"),
      add = ac,
      .var.name = paste_ctxt(sorted_x)
    )
    # margin is only forwarded so asserting is done in [barplot_d3_server]
    checkmate::reportAssertions(ac)

    # dataset validation ----
    # validated first as it is needed for creating the menus

    v_dataset <- shiny::reactive(
      {
        checkmate::assert_data_frame(dataset(), min.rows = 1, .var.name = paste_ctxt(dataset))
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_factor(dataset()[[subjid_var]], add = ac, .var.name = paste_ctxt(dataset))
        checkmate::reportAssertions(ac)
        dataset()
      },
      label = ns(" v_dataset")
    )

    # input ----
    cat_selection <- col_menu_server(
      id = WFPHM_ID$HMCAT$CAT,
      data = v_dataset,
      include_func = function(x, y) {
        is.character(x) || is.factor(x) && !(y %in% subjid_var)
      },
      multiple = TRUE,
      include_none = FALSE,
      label = WFPHM_MSG$HMCAT$SEL,
      options = list(plugins = list("remove_button", "drag_drop"))
    )

    # input validation ----

    v_cat_selection <- shiny::reactive(
      {
        cat <- cat_selection()
        shiny::validate(
          shiny::need(
            checkmate::test_character(
              cat,
              min.len = 1,
              min.chars = 1,
              any.missing = FALSE
            ),
            WFPHM_MSG$HMCAT$VALIDATE$NO_CAT_SEL
          )
        )
        cat
      },
      label = ns(" v_cat_selection")
    )

    v_sorted_x <- shiny::reactive(
      {
        sorted_x()
      },
      label = ns(" v_sorted_x")
    )

    # data ----
    data <- shiny::reactive(
      {
        wfphm_hmcat_subset(
          data = v_dataset(),
          selection = v_cat_selection(),
          palette = cat_palette,
          subjid_var = subjid_var,
          sorted_x = v_sorted_x()
        )
      },
      label = ns(" data")
    )

    # chart helpers ----

    palette <- shiny::reactive(
      {
        pal_get_cat_palette(
          data()[["z"]],
          RColorBrewer::brewer.pal(n = 8, name = "Accent")
        )
      },
      label = ns(" palette")
    )

    msg_func <- shiny::reactive(
      {
        paste0(
          "(d)=>`", subjid_var, ": ${d.x}<br>${d.y}: ${d.z}`"
        )
      },
      label = ns(" msg_func")
    )

    # legend ----
    output[[WFPHM_ID$HMCAT$LEGEND]] <- shiny::renderUI({
      shiny::req(palette())
      shiny::req(data())
      apply_cat_palette_legend(palette(), data()) |> create_cat_legend()
    })

    # chart ----

    output[[WFPHM_ID$HMCAT$CONTAINER]] <- shiny::renderUI({
      heatmap_d3_UI(ns(WFPHM_ID$HMCAT$CHART), height = nlevels(data()[["y"]]) * WFPHM_VAL$HMCAT$HEIGHT)
    })

    chart_args <- list(
      WFPHM_ID$HMCAT$CHART,
      data = data,
      x_axis = NULL,
      y_axis = "W",
      z_axis = NULL,
      margin = margin,
      palette = palette,
      msg_func = msg_func
    )

    chart_info <- do.call(heatmap_d3_server, chart_args)

    # return ----

    r <- list(
      margin = chart_info[["margin"]]
    )

    # testValues ----
    if (isTRUE(getOption("shiny.testmode"))) do.call(shiny::exportTestValues, as.list(environment()))

    r
  }

  shiny::moduleServer(id, module)
}

#' Prepares the data for the categorical heatmap
#'
#' @param data the dataframe to be subset, commonly a subject level dataset
#'
#' @param selection the categorical columns to be selected
#'
#' @param palette a palette to be applied
#'
#' @param subjid_var the column that corresponde to the subject id
#'
#' @param sorted_x the ordered subject ids
#'
#' @keywords internal
wfphm_hmcat_subset <- function(data, selection, palette, subjid_var, sorted_x) {
  lbls <- get_lbls_robust(data)

  df <- data[, c(subjid_var, selection), drop = FALSE]
  df[] <- lapply(df, function(x) {
    factor(x, ordered = FALSE)
  })
  df <- tidyr::pivot_longer(df, -dplyr::all_of(subjid_var), names_to = "y", values_to = "z")
  df[["x"]] <- factor(df[[subjid_var]], levels = sorted_x)
  df[[subjid_var]] <- NULL
  df <- df[, c("x", "y", "z"), drop = FALSE]

  is_single_value_per_subject <- !any(duplicated(df[, c("x", "y"), drop = FALSE]))

  shiny::validate(
    shiny::need(
      is_single_value_per_subject,
      WFPHM_MSG$HMCAT$VALIDATE$TOO_MANY_ROWS
    )
  )

  df[["y"]] <- factor(as.character(lbls[df[["y"]]]), levels = lbls[selection])

  if (length(palette) > 0) {
    df <- pal_colorize_custom_cat_df(df, palette)
  }

  df[["label"]] <- as.character(df[["z"]])

  df
}


# HM Cont Component

#' Continuous heatmap component of WFPHM
#'
#' Presents a heatmap plot for continuous variables
#'
#' @param id Shiny ID `[character(1)]`
#'
#' @param dataset `[shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`
#'
#' It expects the following format:
#'
#'  - it contains, at least, the columns specified in the parameters: `subjid_var`
#'  - `subjid_var` columns is a factor
#'
#' @param subjid_var `[character(1)]`
#'
#' column used as indicated in the details section
#'
#' @param sorted_x `[factor(*) | shiny::reactive(factor(*)) | shinymeta::metaReactive(factor(*))]`
#'
#' indicates how the levels of `subjid_var` should be ordered in the X axis.
#'
#' @param margin `[numeric(4) | shiny::reactive(numeric(4)) | shinymeta::metaReactive(numeric(4))]`
#'
#'  margin to be used on each of the sides. It must contain four entries named `top`, `bottom`, `left` and `right`
#'
#' @return
#'
#' ## UI
#' A heatmap plot
#'
#' ## Server
#' A list with one entry:
#'  - `margin`: similar to the `margin` parameter with the minimum margins for the current plot
#'
#' @details
#'
#' # Data subsetting:
#'    - Allows selecting several columns from all numerical columns, from now on **numerical_selection**.
#'      - Menu labelled: `r WFPHM_MSG$HMCONT$SEL`
#'
#'    - Subsets the dataset to the columns **numerical_selection**, and `subj_var`.
#'    - Pivot the dataset to a longer format such that each row have:
#'      - column `x`: the value of `subjid_var`
#'      - column `y`: the value of a **numerical_selection**
#'      - column `z`: the value of the **numerical_selection** in `y` for the value in `x`
#'    - If more than one row have the same `x` and `y` an informative error indicating the plot cannot be created
#'  is shown.
#'
#' ## X axis ordering
#' - `x` levels are ordered according to `sorted_x`
#'
#' Then a call to [heatmap_D3] is done with the following arguments:
#'  - `data` = `subset dataset` (as described above)
#'  - `x_axis` = `NULL`
#'  - `y_axis` = `W`
#'  - `z_axis` = `E`
#'  - `margin` is the parameter passed to this same function
#'  - `palette` is hardcoded to `RColorBrewer::brewer.pal(n = 8, name = "Accent")` after 8 categories
#' colors are repeated
#'  - `msg_func` = NULL
#'  - `quiet` = TRUE
#'
#' @keywords internal
#'
#' @name wfphm_hmcont
#'
NULL

#' @describeIn wfphm_hmcont UI
wfphm_hmcont_UI <- function(id) { # nolintr

  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  # paste ctxt ----
  paste_ctxt <- paste_ctxt_factory(id) # nolint

  # argument asserts ----

  # UI ----
  ns <- shiny::NS(id)

  # menu ----

  menu <- col_menu_UI(
    id = ns(WFPHM_ID$HMCONT$CONT)
  )

  # chart ----

  chart <- shiny::uiOutput(ns(WFPHM_ID$HMCONT$CONTAINER))

  # return ----

  list(
    menu = menu,
    chart = chart
  )
}

#' @describeIn wfphm_hmcont server
wfphm_hmcont_server <- function(id,
                                dataset,
                                subjid_var,
                                sorted_x,
                                margin) {
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  module <- function(input, output, session) {
    # sessions ----
    ns <- session[["ns"]]

    # paste ctxt ----
    paste_ctxt <- paste_ctxt_factory(ns(""))

    # argument asserts ----
    ac <- checkmate::makeAssertCollection()
    checkmate::assert_string(subjid_var, add = ac, .var.name = paste_ctxt(subjid_var))
    checkmate::assert_multi_class(dataset, c("reactive", "shinymeta_reactive"),
      add = ac,
      .var.name = paste_ctxt(dataset)
    )
    checkmate::assert_multi_class(sorted_x, c("reactive", "shinymeta_reactive"),
      add = ac,
      .var.name = paste_ctxt(sorted_x)
    )
    # margin is only forwarded so asserting is done in [barplot_d3_server]
    checkmate::reportAssertions(ac)

    # dataset validation ----
    # validated first as it is needed for creating the menus

    v_dataset <- shiny::reactive(
      {
        checkmate::assert_data_frame(dataset(), min.rows = 1, .var.name = paste_ctxt(dataset))
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_factor(dataset()[[subjid_var]], add = ac, .var.name = paste_ctxt(dataset))
        checkmate::reportAssertions(ac)
        dataset()
      },
      label = ns(" v_dataset")
    )

    # input ----
    cont_selection <- col_menu_server(
      id = WFPHM_ID$HMCONT$CONT,
      data = v_dataset,
      include_func = function(x) {
        is.numeric(x)
      },
      multiple = TRUE,
      include_none = FALSE,
      label = WFPHM_MSG$HMCONT$SEL,
      options = list(plugins = list("remove_button", "drag_drop"))
    )

    # input validation ----

    v_cont_selection <- shiny::reactive(
      {
        cont <- cont_selection()
        shiny::validate(
          shiny::need(
            checkmate::test_character(
              cont,
              min.len = 1,
              min.chars = 1,
              any.missing = FALSE
            ),
            WFPHM_MSG$HMCONT$VALIDATE$NO_CONT_SEL
          )
        )
        cont
      },
      label = ns(" v_cont_selection")
    )

    v_sorted_x <- shiny::reactive(
      {
        sorted_x()
      },
      label = ns(" v_sorted_x")
    )

    # data ----
    data <- shiny::reactive(
      {
        wfphm_hmcont_subset(
          data = v_dataset(),
          selection = v_cont_selection(),
          subjid_var = subjid_var,
          sorted_x = v_sorted_x()
        )
      },
      label = ns(" data")
    )


    # chart helpers ----

    palette <- shiny::reactive(
      pal_get_cont_palette(data()[["z"]]),
      label = ns(" palette")
    )

    msg_func <- shiny::reactive(
      {
        paste0(
          "(d)=>`", subjid_var, ": ${d.x}<br>${d.y}: ${d.z}`"
        )
      },
      label = ns(" msg_func")
    )

    # chart ----

    output[[WFPHM_ID$HMCONT$CONTAINER]] <- shiny::renderUI({
      heatmap_d3_UI(ns(WFPHM_ID$HMCONT$CHART), height = nlevels(data()[["y"]]) * WFPHM_VAL$HMCONT$HEIGHT)
    })

    chart_args <- list(
      WFPHM_ID$HMCONT$CHART,
      data = data,
      x_axis = NULL,
      y_axis = "W",
      z_axis = NULL,
      margin = margin,
      palette = palette,
      msg_func = msg_func
    )

    chart_info <- do.call(heatmap_d3_server, chart_args)

    # return ----

    r <- list(
      margin = chart_info[["margin"]]
    )

    # testValues ----
    if (isTRUE(getOption("shiny.testmode"))) do.call(shiny::exportTestValues, as.list(environment()))

    r
  }

  shiny::moduleServer(id, module)
}

#' Prepares the data for the continuous heatmap
#'
#' @param data the dataframe to be subset, commonly a subject level dataset
#'
#' @param selection the categorical columns to be selected
#'
#' @param subjid_var the column that corresponde to the subject id
#'
#' @param sorted_x the ordered subject ids
#' @keywords internal
wfphm_hmcont_subset <- function(data, selection, subjid_var, sorted_x) {
  lbls <- get_lbls_robust(data)

  df <- data[, c(subjid_var, selection), drop = FALSE]

  df <- tidyr::pivot_longer(df, -dplyr::all_of(subjid_var), names_to = "y", values_to = "z")
  df[["x"]] <- factor(df[[subjid_var]], levels = sorted_x)
  df[[subjid_var]] <- NULL
  df <- df[, c("x", "y", "z"), drop = FALSE]

  is_single_value_per_subject <- !any(duplicated(df[, c("x", "y"), drop = FALSE]))

  shiny::validate(
    shiny::need(
      is_single_value_per_subject,
      WFPHM_MSG$HMCAT$VALIDATE$TOO_MANY_ROWS
    )
  )

  df[["y"]] <- factor(as.character(lbls[df[["y"]]]), levels = lbls[selection])

  df[["label"]] <- as.character(df[["z"]])

  df
}


# HM Par Component

#' Parameter heatmap component of WFPHM
#'
#' @param id Shiny ID `[character(1)]`
#'
#' @param dataset `[shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`
#'
#' It expects the following format:
#'
#'  - it contains, at least, the columns specified in the parameters: `cat_var`, `par_var`, `value_vars`, `visit_var`
#' and `subjid_var`
#'  - `cat_var`, `par_var`, `visit_var` and `subjid_var` columns are factors
#'  - `value_vars` must be numeric
#'
#' @param margin `[numeric(4) | shiny::reactive(numeric(4)) | shinymeta::metaReactive(numeric(4))]`
#'
#'  margin to be used on each of the sides. It must contain four entries named `top`, `bottom`, `left` and `right`
#'
#' @param cat_var,par_var,visit_var,subjid_var `[character(1)]`
#'
#' @param value_vars `[character(1+)]`
#'
#' possible colum values. If column is labelled, label will be displayed in the value menu
#'
#' @param tr_mapper `[function(1+)]`
#'
#' named list containing a set of unary functions to transform the data. The name is the string shown in a selector and
#' the value is the function to be applied according to details section.
#'
#' @param show_x_ticks `[logical(1)]`
#'
#' show x ticks in the parameter heatmap
#'
#'
#' @return
#'
#' ## UI
#' A heatmap plot
#'
#' ## Server
#' A list with one entry:
#'  - `margin`: similar to the `margin` parameter with the minimum margins for the current plot
#'
#' @details
#'
#' ## Data subsetting:
#'
#'    - Allows selecting several values from the `cat_var` column, from now on **cat_selection** and several values
#'  from the `par_var` column from the subset of rows where `par_cat` is equal to **cat_selection**
#'  from now on **par_selection**.
#'      - Menu labelled: `r WFPHM_MSG$WF$PAR[1]` and `r WFPHM_MSG$WF$PAR[2]`
#'    - Allows selecting between the columns defined in `value_vars` from now on **value_selection**.
#'      - Menu labelled: `r WFPHM_MSG$WF$VALUE`
#'    - Allows selecting a value from `visit_var` column, from now on **visit_selection**.
#'      - Menu labelled: `r WFPHM_MSG$WF$VISIT`
#'    - Subsets the dataset rows where:
#'      - `visit_var` equal to **visit_selection**
#'      - `par_var` equal to **par_selection**
#'    - Subsets the dataset to `par_var`, `subj_var` and the **value_selection**.
#'    - If more than one row have the same combination `subj_var` and `par_var` an informative error indicating the plot
#'  cannot be created is shown.
#'
#' Then the dataset is prepared to be passed to [heatmap_D3]:
#'  - `subj_var` becomes `x` column
#'  -  the label attribute of `x` column is `Subject ID`
#'  - `par_var` becomes `y` column
#'  - `value_selection` becomes `z` column
#'  - `z` becomes `label` column
#'
#' ## Completing the dataset:
#'  - Subset dataset will be completed in the following way. All non-present combination of the original levels of `x`
#'  and 'y' is are added with rows where:
#'  - `x` and `y` are equal to the missing combination
#'  - `z` is NA
#'
#' ## Data outliers:
#'  - Allows setting two limits upper and lower for `y` value, values above or below in the subsetted dataset will be
#'   considered outliers. Rows considered outliers will have the column:
#'    - `label` replaced by "`r WFPHM_VAL$HMPAR$OUTLIER_LABEL`"
#'    - `color` equal to "`r WFPHM_VAL$HMPAR$OUTLIER_STYLE`"
#'  - Rows not considered outliers will have the column:
#'    - `color` equal to NA
#'
#' ## Data transformation:
#' - Allows selecting between a set of functions as defined in `tr_mapper` from now on **transformation_function**.
#'      - Menu labelled: `r WFPHM_MSG$HMPAR$TRANSFORMATION`
#' - This transformation is applied to the subset dataset grouped by the `y` column. i.e. each row of the heatmap is
#' transformed independently.
#' - The function must be unary, and the unique argument will be the numerical values of a given row of the hetamap.
#'
#' ## X axis ordering
#' - `x` levels are ordered according to `sorted_x`
#'
#' Then a call to [heatmap_D3] is done with the following arguments:
#'  - `data` = `subset dataset` (as described above)
#'  - `x_axis` = `S`
#'  - `y_axis` = `W`
#'  - `z_axis` = `E`
#'  - `margin` is the parameter passed to this same function
#'  - `palette` is hardcoded to `RColorBrewer::brewer.pal(n = 8, name = "Set2")` after 8 categories colors are repeated
#'  - `msg_func` = NULL
#'  - `quiet` = TRUE
#'
#' @keywords internal
#'
#' @name wfphm_hmpar
#'
NULL

#' @describeIn wfphm_hmpar UI
wfphm_hmpar_UI <- function(id, tr_choices) { # nolintr

  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  # paste ctxt ----
  paste_ctxt <- paste_ctxt_factory(id) # nolint

  # argument asserts ----

  # UI ----
  ns <- shiny::NS(id)

  # UI ----

  main <- shiny::tagList(
    shiny::div(
      id = ns(WFPHM_ID$HMPAR$PAR),
      parameter_UI(id = ns(WFPHM_ID$HMPAR$PAR))
    ),
    col_menu_UI(ns(WFPHM_ID$HMPAR$VALUE)),
    val_menu_UI(
      id = ns(WFPHM_ID$HMPAR$VISIT)
    ),
    shiny::selectizeInput(
      inputId = ns(WFPHM_ID$HMPAR$TRANSFORM),
      label = WFPHM_MSG$HMPAR$TRANSFORMATION,
      choices = tr_choices,
      multiple = FALSE
    )
  )

  outlier <- shiny::div(
    shiny::tags[["p"]](WFPHM_MSG$HMPAR$OUTLIER),
    outlier_container_UI(id = ns(WFPHM_ID$HMPAR$OUTLIER))
  )

  # chart ----

  chart <- heatmap_d3_UI(ns(WFPHM_ID$HMPAR$CHART), height = WFPHM_VAL$HMPAR$HEIGHT)

  # return ----

  list(
    menu = list(
      main = main,
      outlier = outlier
    ),
    chart = chart
  )
}

#' @describeIn wfphm_hmpar server
wfphm_hmpar_server <- function(id,
                               dataset,
                               cat_var, par_var,
                               visit_var,
                               subjid_var,
                               value_vars,
                               sorted_x,
                               tr_mapper,
                               margin,
                               show_x_ticks) {
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  module <- function(input, output, session) {
    # sessions ----
    ns <- session[["ns"]]

    # paste ctxt ----
    paste_ctxt <- paste_ctxt_factory(ns(""))

    # argument asserts ----

    ac <- checkmate::makeAssertCollection()
    checkmate::assert_string(cat_var, add = ac, .var.name = paste_ctxt(cat_var))
    checkmate::assert_string(par_var, add = ac, .var.name = paste_ctxt(par_var))
    checkmate::assert_string(visit_var, add = ac, .var.name = paste_ctxt(visit_var))
    checkmate::assert_string(subjid_var, add = ac, .var.name = paste_ctxt(subjid_var))
    checkmate::assert_character(value_vars,
      any.missing = FALSE, unique = TRUE, add = ac,
      .var.name = paste_ctxt(value_vars)
    )
    checkmate::assert_list(tr_mapper,
      types = "function", any.missing = FALSE,
      names = "named", add = ac,
      .var.name = paste_ctxt(tr_mapper)
    )
    checkmate::assert_multi_class(dataset, c("reactive", "shinymeta_reactive"),
      add = ac,
      .var.name = paste_ctxt(dataset)
    )

    # margin is only forwarded so asserting is done in [barplot_d3_server]
    checkmate::reportAssertions(ac)

    # dataset validation ----
    # validated first as it is needed for creating the menus

    v_dataset <- shiny::reactive(
      {
        checkmate::assert_data_frame(dataset(), min.rows = 1, .var.name = paste_ctxt(dataset))
        checkmate::assert_names(
          names(dataset()),
          type = "unique",
          must.include = c(visit_var, subjid_var, cat_var, par_var), .var.name = paste_ctxt(dataset)
        )
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_factor(dataset()[[subjid_var]], add = ac, .var.name = paste_ctxt(dataset))
        checkmate::assert_factor(dataset()[[visit_var]], add = ac, .var.name = paste_ctxt(dataset))
        checkmate::assert_factor(dataset()[[cat_var]], add = ac, .var.name = paste_ctxt(dataset))
        checkmate::assert_factor(dataset()[[par_var]], add = ac, .var.name = paste_ctxt(dataset))
        checkmate::reportAssertions(ac)
        dataset()
      },
      label = ns(" v_dataset")
    )

    # input ----
    input_menu <- list(
      par = parameter_server(
        id = WFPHM_ID$HMPAR$PAR,
        data = v_dataset,
        cat_var = cat_var,
        par_var = par_var,
        multi_cat = TRUE,
        multi_par = TRUE,
        options_cat = list(plugins = list("remove_button", "drag_drop")),
        options_par = list(plugins = list("remove_button", "drag_drop"))
      ),
      value = col_menu_server(
        id = WFPHM_ID$HMPAR$VALUE,
        data = v_dataset,
        include_func = function(val, name) {
          name %in% value_vars
        },
        include_none = FALSE,
        label = WFPHM_MSG$HMPAR$VALUE
      ),
      visit = val_menu_server(
        id = WFPHM_ID$HMPAR$VISIT,
        data = v_dataset,
        var = visit_var,
        label = WFPHM_MSG$HMPAR$VISIT
      ),
      transform = shiny::reactive(input[[WFPHM_ID$HMPAR$TRANSFORM]])
    )

    # Added after because we need the returned value from l[["par"]][["par"]][[par_var]]
    input_menu[["outlier"]] <- outlier_container_server(WFPHM_ID$HMPAR$OUTLIER, shiny::reactive({
      if (is.null(input_menu[["par"]][["par"]]())) character(0) else input_menu[["par"]][["par"]]()
    }))

    # input validation ----

    v_input <- shiny::reactive(
      {
        v_i <- list(
          cat = input_menu[["par"]][["cat"]](),
          par = input_menu[["par"]][["par"]](),
          visit = input_menu[["visit"]](),
          value = input_menu[["value"]](),
          transform = input_menu[["transform"]]()
        )
        shiny::validate(
          shiny::need(
            checkmate::test_character(v_i[["cat"]], min.len = 1, any.missing = FALSE, unique = TRUE, min.chars = 1),
            WFPHM_MSG$HMPAR$VALIDATE$NO_CAT_SEL
          ),
          shiny::need(
            checkmate::test_character(v_i[["par"]], min.len = 1, any.missing = FALSE, unique = TRUE, min.chars = 1) &&
              !identical(v_i[["par"]], "None"),
            WFPHM_MSG$HMPAR$VALIDATE$NO_PAR_SEL
          ),
          shiny::need(
            checkmate::test_string(v_i[["value"]], min.chars = 1),
            WFPHM_MSG$HMPAR$VALIDATE$NO_VALUE_SEL
          ),
          shiny::need(
            identical(v_i[["value"]], "") ||
              isTRUE(v_i[["value"]] %in% names(v_dataset())),
            paste(
              "Par. Heatmap", v_i[["value"]],
              WFPHM_MSG$BASE$COL_DOES_NOT_EXIST
            )
          ),
          shiny::need(
            checkmate::test_string(v_i[["visit"]], min.chars = 1),
            WFPHM_MSG$HMPAR$VALIDATE$NO_VISIT_SEL
          ),
          shiny::need(
            checkmate::test_string(v_i[["transform"]], min.chars = 1),
            WFPHM_MSG$HMPAR$VALIDATE$NO_TRANSFORMATION_SEL
          )
        )
        v_i
      },
      label = ns(" v_input")
    )

    v_sorted_x <- shiny::reactive(
      {
        sorted_x()
      },
      label = ns(" v_sorted_x")
    )

    # data ----
    data <- shiny::reactive(
      {
        wfphm_hmpar_subset(
          v_dataset(),
          v_input()[["cat"]],
          cat_var,
          v_input()[["par"]],
          par_var,
          v_input()[["visit"]],
          visit_var,
          v_input()[["value"]],
          subjid_var,
          v_sorted_x(),
          input_menu[["outlier"]](),
          get_tr_apply(tr_mapper[[v_input()[["transform"]]]])
        )
      },
      label = ns(" data")
    )

    # chart helpers ----

    palette <- shiny::reactive(
      {
        pal_get_cont_palette(data()[["z"]])
      },
      label = ns(" palette")
    )
    msg_func <- shiny::reactive(
      {
        paste0(
          "(d)=>`", subjid_var, ": ${d.x}<br>${d.y}: ${d.z}`"
        )
      },
      label = ns(" msg_func")
    )

    # chart ----
    chart_args <- list(
      WFPHM_ID$HMPAR$CHART,
      data = data,
      x_axis = if (show_x_ticks) "S" else NULL,
      y_axis = "W",
      z_axis = "E",
      margin = margin,
      palette = palette,
      msg_func = msg_func
    )

    chart_info <- do.call(heatmap_d3_server, chart_args)

    # return ----

    r <- list(
      margin = chart_info[["margin"]]
    )

    # testValues ----
    if (isTRUE(getOption("shiny.testmode"))) do.call(shiny::exportTestValues, as.list(environment()))

    r
  }

  shiny::moduleServer(id, module)
}

#' Subsets data for hmpar module
#'
#' @param data the bsd param dataset
#'
#' @param cat_selection,par_selection,visit_selection the selected category, parameter and visit selections
#'
#' @param cat_var,par_var,visit_var,value_var,subjid_var the corresponding columns
#'
#' @param sorted_x the ordered subject ids
#'
#' @param out_criteria the outlier criteria
#'
#' @param scale a scaling function that will rescale the values in the heatmap
#'
#' @keywords internal
wfphm_hmpar_subset <- function(
    data,
    cat_selection, cat_var,
    par_selection, par_var,
    visit_selection, visit_var,
    value_var,
    subjid_var,
    sorted_x,
    out_criteria,
    scale) {
  df <- subset_bds_param(
    ds = data,
    par = par_selection,
    par_col = par_var,
    cat = cat_selection,
    cat_col = cat_var,
    vis = visit_selection,
    vis_col = visit_var,
    val_col = value_var,
    subj_col = subjid_var
  )

  shiny::validate(
    need_one_row_per_sbj(df, CNT$SBJ, CNT$PAR, msg = WFPHM_MSG$HMPAR$VALIDATE$TOO_MANY_ROWS)
  )

  df <- df[, c(CNT$SBJ, CNT$PAR, CNT$VAL), drop = FALSE]
  names(df) <- c("x", "y", "z")

  df[["y"]] <- droplevels(df[["y"]])
  df[["y"]] <- factor(df[["y"]], levels = par_selection)

  # Not all values in sorted_x are present in the df subjid_var
  # There maybe subjects with no measures at all

  df[["x"]] <- factor(df[["x"]], levels = sorted_x)

  df <- scale(df, "y", "z")

  df <- tidyr::complete(df, !!!rlang::syms(c("x", "y")))

  df[["label"]] <- dplyr::if_else(
    is_outlier(df, out_criteria), WFPHM_VAL$HMPAR$OUTLIER_LABEL, NA_character_
  )

  df[["z"]] <- dplyr::if_else(is_outlier(df, out_criteria), NA_real_, df[["z"]])
  df <- set_lbl(df, "x", get_lbl_robust(data, subjid_var))
  df <- set_lbl(df, "y", value_var)

  df
}


# WFPHM Component

#' Waterfall heatmap shiny module
#'
#' A module that creates the following plots with its corresponding menus:
#'  - A waterfall [wfphm_wf]
#'  - A heatmap for categorical variables [wfphm_hmcat]
#'  - A heatmap for continuous variables [wfphm_hmcont]
#'  - A heatmap that displays a set of parameters [wfphm_hmpar]
#'
#' See the subsections for each of plots particularities
#'
#' @param module_id Shiny ID `[character(1)]`
#'
#' It expects the following format:
#'
#'  - it contains, at least, the columns specified in the parameters: `cat_var`, `par_var`, `value_vars`, `visit_var`
#' and `subjid_var`
#'  - `cat_var`, `par_var`, `visit_var` and `subjid_var` columns are factors
#'  - It contains at least 1 row
#'
#' It expects the following format:
#'
#'  - it contains, at least, the columns specified in the parameters: `subjid_var`
#'  - `subjid_var` columns is a factors
#'  - It contains at least 1 row
#'
#'
#' @param cat_var,par_var,visit_var,subjid_var `[character(1)]`
#'
#' columns used as indicated in each of the subplots
#'
#' @param value_vars `[character(1+)]`
#'
#' possible colum values. If column is labelled, label will be displayed in the value menu
#'
#' @param tr_mapper `[function(1+)]`
#'
#' named vector containing a set of transformation where the name is the string shown in the selector and the value is
#' function to be applied according to details section.
#'
#' @param bar_group_palette `[list(palettes)]`
#'
#' list of custom palettes to apply to bar_grouping. It receives the values used for grouping and must return a DaVinci
#' palette. Each palette is applied when the name of the entry in the list matches the name of the column used for
#' grouping
#'
#' @param cat_palette `[list(functions)]`
#'
#' list of functions that receive the values of the variable and returns a vector with the colors for each of the values.
#' Each palette is applied when the name of the entry in the list matches the name of the selected categorical
#' variable
#'
#' @param show_x_ticks `[logical(1)]`
#'
#' show x ticks in the parameter heatmap
#'
#' @return
#'
#' ## UI
#' The menus and plots
#'
#' ## Server
#' NULL
#'
#' @details
#' ## X axis
#' All charts share the same x-axis order as defined by the value `sorted_x` returned by the [wfphm_wf].
#'
#' ## Margins
#' All four plots are aligned on their left and right sides so their x axis are also aligned. Each plot returns
#' their required margins and we calculate the maximum for each side and return it in the `margin` argument of each
#' plot.
#'
#' @name wfphm
#'
#' @keywords main
#'
NULL

#' Waterfall plus heatmap UI function
#'
#' @param id Shiny ID `[character(1)]`
#' @param tr_choices the names of the entries in tr_mapper
#'
#' @keywords developers
#' @export

wfphm_UI <- function(id, tr_choices = names(tr_mapper_def())) { # nolint

  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  # paste ctxt ----
  paste_ctxt <- paste_ctxt_factory(id) # nolint

  # argument asserts ----


  # UI ----
  ns <- shiny::NS(id)

  # UI ----
  wf_ui <- wfphm_wf_UI(ns(WFPHM_ID$WFPHM$WF))
  hmcat_ui <- wfphm_hmcat_UI(ns(WFPHM_ID$WFPHM$HMCAT))
  hmcont_ui <- wfphm_hmcont_UI(ns(WFPHM_ID$WFPHM$HMCONT))
  hmpar_ui <- wfphm_hmpar_UI(ns(WFPHM_ID$WFPHM$HMPAR), tr_choices)

  wfphm_menu <- shiny::tagList(
    drop_menu_helper(ns(WFPHM_ID$WFPHM$WF_MENU), WFPHM_MSG$WF$MENU, wf_ui[["menu"]]),
    drop_menu_helper(ns(WFPHM_ID$WFPHM$CC_MENU), WFPHM_MSG$HMCAT$MENU, shiny::tagList(
      hmcat_ui[["menu"]],
      hmcont_ui[["menu"]]
    )),
    drop_menu_helper(ns(WFPHM_ID$WFPHM$PAR_MENU), WFPHM_MSG$HMPAR$BASE_MENU, hmpar_ui[["menu"]][["main"]]),
    drop_menu_helper(ns(WFPHM_ID$WFPHM$OUTLIER_MENU), WFPHM_MSG$HMPAR$OUTLIER_MENU, hmpar_ui[["menu"]][["outlier"]]),
    drop_menu_helper(
      ns(WFPHM_ID$WFPHM$DOWNLOAD_MENU),
      icon = shiny::icon("download"),
      WFPHM_MSG$WFPHM$DOWNLOAD$MENU,
      shiny::textInput(
        ns(WFPHM_ID$WFPHM$FILENAME),
        label = WFPHM_MSG$WFPHM$DOWNLOAD$FILENAME$LABEL,
        placeholder = WFPHM_MSG$WFPHM$DOWNLOAD$FILENAME$PLACEHOLDER
      ),
      shiny::numericInput(
        ns(WFPHM_ID$WFPHM$CHART_WIDTH),
        label = WFPHM_MSG$WFPHM$DOWNLOAD$CHART_WIDTH,
        value = WFPHM_VAL$WFPHM$DOWNLOAD$CHART_WIDTH
      ),
      shiny::actionButton(inputId = ns(WFPHM_ID$WFPHM$SAVE_PNG), label = WFPHM_MSG$WFPHM$DOWNLOAD$SAVE_PNG),
      shiny::actionButton(inputId = ns(WFPHM_ID$WFPHM$SAVE_SVG), label = WFPHM_MSG$WFPHM$DOWNLOAD$SAVE_SVG)
    )
  )

  wfphm_mainpanel <- shiny::div(
    shiny::tagList(
      add_warning_mark_dependency(),
      screenshot_deps(),
      non_gxp_tag(ns(WFPHM_ID$WFPHM$NON_GXP_TAG)),
      shiny::div(wfphm_menu),
      shiny::div(
        id = ns(WFPHM_ID$WFPHM$CHART_CONTAINER),
        wf_ui[["chart"]],
        # nolint start
        shiny::conditionalPanel(condition = "input['hmcat-cat-val']!== undefined && Object.hasOwn(input['hmcat-cat-val'], \"length\") ? input['hmcat-cat-val'].length>0 : false", hmcat_ui[["chart"]], ns = ns),
        shiny::conditionalPanel(condition = "input['hmcont-cont-val']!== undefined &&Object.hasOwn(input['hmcont-cont-val'], \"length\") ? input['hmcont-cont-val'].length>0 : false", hmcont_ui[["chart"]], ns = ns),
        shiny::conditionalPanel(condition = "
          (input['hmpar-par-par_val']!== undefined && Object.hasOwn(input['hmpar-par-par_val'], \"length\") ? input['hmpar-par-par_val'].length>0 : false) &&
          (input['hmpar-value-val']!== undefined && Object.hasOwn(input['hmpar-value-val'], \"length\") ? input['hmpar-value-val'].length>0 : false) &&
          (input['hmpar-visit-val']!== undefined && Object.hasOwn(input['hmpar-visit-val'], \"length\") ? input['hmpar-visit-val'].length>0 : false) &&
          (input['hmpar-transform']!== undefined && Object.hasOwn(input['hmpar-transform'], \"length\") ? input['hmpar-transform'].length>0 : false)
          ", hmpar_ui[["chart"]], ns = ns), # nolint
        shiny::conditionalPanel(
          condition = "input['hmcat-cat-val']!== undefined && Object.hasOwn(input['hmcat-cat-val'], \"length\") ? input['hmcat-cat-val'].length>0 : false",
          shiny::div(
            shiny::h5("Categorical legend"),
            hmcat_ui[["legend"]]
          ),
          ns = ns
        )
        # nolint end
      )
    ),
    style = "position:relative"
  )

  wfphm_mainpanel
}

#' Waterfall plus heatmap server function
#' @keywords developers
#' @param bm_dataset `[shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`
#' @param group_dataset `[shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`
#'
#' @keywords developers
#' @inheritParams wfphm_UI
#' @inheritParams mod_wfphm
#' @export
wfphm_server <- function(id,
                         bm_dataset,
                         group_dataset,
                         cat_var = "PARCAT1", par_var = "PARAM",
                         visit_var = "AVISIT",
                         subjid_var = "SUBJID",
                         value_vars = "AVAL",
                         bar_group_palette = list(),
                         cat_palette = list(),
                         tr_mapper = tr_mapper_def(),
                         show_x_ticks = TRUE) {
  module <- function(input, output, session) {
    ns <- session[["ns"]]

    v_group_dataset <- shiny::reactive({
      shiny::validate(
        shiny::need(
          checkmate::test_data_frame(group_dataset(), min.rows = 1),
          sprintf("group_dataset: %s", WFPHM_MSG$BASE$NO_ROWS)
        )
      )
      group_dataset()
    })

    v_bm_dataset <- shiny::reactive({
      shiny::validate(
        shiny::need(
          checkmate::test_data_frame(bm_dataset(), min.rows = 1),
          sprintf("bm_dataset: %s", WFPHM_MSG$BASE$NO_ROWS)
        )
      )
      bm_dataset()
    })

    shiny::observe({
      shiny::req(input[[WFPHM_ID$WFPHM$SAVE_PNG]] > 0)
      shiny::req(input[[WFPHM_ID$WFPHM$CHART_WIDTH]])
      session$sendCustomMessage("get-screenshot", list(
        filename = shiny::isolate(input[[WFPHM_ID$WFPHM$FILENAME]]),
        container = ns(WFPHM_ID$WFPHM$CHART_CONTAINER),
        chart_width = input[[WFPHM_ID$WFPHM$CHART_WIDTH]],
        as_png = TRUE
      ))
    })

    shiny::observe({
      shiny::req(input[[WFPHM_ID$WFPHM$SAVE_SVG]] > 0)
      session$sendCustomMessage("get-screenshot", list(
        id = ns(WFPHM_ID$WFPHM$CHART_CONTAINER),
        filename = shiny::isolate(input[[WFPHM_ID$WFPHM$FILENAME]]),
        container = ns(WFPHM_ID$WFPHM$CHART_CONTAINER),
        chart_width = -1,
        as_png = FALSE
      ))
    })

    shiny::setBookmarkExclude(c(WFPHM_ID$WFPHM$SAVE_PNG, WFPHM_ID$WFPHM$SAVE_SVG))

    # data ----

    wf_margin <- shiny::reactive(
      {
        c(top = 10, bottom = 10, right = max_margin()[["right"]], left = max_margin()[["left"]])
      },
      label = ns(" df_margin")
    )

    hmcat_margin <- wf_margin
    hmcont_margin <- wf_margin

    hmpar_margin <- shiny::reactive(
      {
        c(
          top = 10, bottom = max_margin()[["bottom"]],
          right = max_margin()[["right"]], left = max_margin()[["left"]]
        )
      },
      label = ns(" hmpar_margin")
    )

    # charts ----
    wf_args <- list(
      id = WFPHM_ID$WFPHM$WF,
      bm_dataset = v_bm_dataset, group_dataset = v_group_dataset,
      cat_var = cat_var, par_var = par_var,
      visit_var = visit_var, subjid_var = subjid_var,
      value_vars = value_vars, margin = wf_margin,
      bar_group_palette = bar_group_palette
    )
    wf <- do.call(wfphm_wf_server, wf_args)

    hmcat_args <- list(
      id = WFPHM_ID$WFPHM$HMCAT, dataset = v_group_dataset,
      subjid_var = subjid_var, sorted_x = wf[["sorted_x"]],
      margin = hmcat_margin, cat_palette = cat_palette
    )
    hmcat <- do.call(wfphm_hmcat_server, hmcat_args)

    hmcont_args <- list(
      id = WFPHM_ID$WFPHM$HMCONT, dataset = v_group_dataset,
      subjid_var = subjid_var, sorted_x = wf[["sorted_x"]],
      margin = hmcont_margin
    )
    hmcont <- do.call(wfphm_hmcont_server, hmcont_args)

    hmpar_args <- list(
      id = WFPHM_ID$WFPHM$HMPAR, dataset = v_bm_dataset,
      cat_var = cat_var, par_var = par_var, visit_var = visit_var,
      subjid_var = subjid_var, sorted_x = wf[["sorted_x"]], value_vars = value_vars,
      tr_mapper = tr_mapper, margin = hmpar_margin,
      show_x_ticks = show_x_ticks
    )
    hmpar <- do.call(wfphm_hmpar_server, hmpar_args)

    # margin ----

    max_margin <- shiny::debounce(
      shiny::reactive(
        {
          dm_list <- c(
            top = 0,
            bottom = 0,
            right = 0,
            left = 0
          )
          l <- list(
            if_not_null(wf[["margin"]](), wf[["margin"]](), dm_list),
            if_not_null(hmcat[["margin"]](), hmcat[["margin"]](), dm_list),
            if_not_null(hmcont[["margin"]](), hmcont[["margin"]](), dm_list),
            if_not_null(hmpar[["margin"]](), hmpar[["margin"]](), dm_list)
          )
          rlang::inform(paste(purrr::pmap(l, max)), class = "debug")
          purrr::pmap_dbl(l, max)
        },
        label = ns(" max_margin")
      ),
      millis = 200
    )

    shiny::observeEvent(wf$valid(), {
      session$sendCustomMessage(
        "dv_bm_toggle_warning_mark",
        list(
          id = ns(WFPHM_ID$WFPHM$WF_MENU),
          add_mark = !wf$valid()
        )
      )
    })

    if (isTRUE(getOption("shiny.testmode"))) do.call(shiny::exportTestValues, as.list(environment()))

    # return ----

    return(NULL)
  }

  shiny::moduleServer(
    id = id,
    module = module
  )
}

tr_mapper_def <- function() {
  list(
    "Original" = tr_identity,
    "Scale by (result-mean)/SD of each parameter" = tr_z_score,
    "Scale by result/Gini's Mean Difference of each parameter" = tr_gini,
    "Scale by parameter with truncation" = tr_trunc_z_score_3_3,
    "Normalize (result-min)/max" = tr_min_max,
    "Percentize (rank of result/maximal rank)" = tr_percentize
  )
}

#' @describeIn wfphm dv.manager wrapper for the module
#'
#' @param bm_dataset_name,group_dataset_name
#'
#' The name of the dataset
#'
#' @export
mod_wfphm <- function(
    module_id, bm_dataset_name, group_dataset_name,
    cat_var = "PARCAT1", par_var = "PARAM",
    visit_var = "AVISIT",
    subjid_var = "SUBJID",
    value_vars = "AVAL",
    bar_group_palette = list(),
    cat_palette = list(),
    tr_mapper = tr_mapper_def(),
    show_x_ticks = TRUE) {
  mod <- list(
    ui = function(id) wfphm_UI(id, names(tr_mapper)),
    server = function(afmm) {
      wfphm_server(
        id = module_id,
        bm_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[bm_dataset_name]]),
        group_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[group_dataset_name]]),
        cat_var = cat_var,
        visit_var = visit_var,
        subjid_var = subjid_var,
        value_vars = value_vars,
        bar_group_palette = bar_group_palette,
        cat_palette = cat_palette,
        tr_mapper = tr_mapper,
        show_x_ticks = show_x_ticks
      )
    },
    module_id = module_id
  )
  mod
}

# wfphm module interface description ----
# TODO: Fill in
mod_wfphm_API_docs <- list(
  "Waterfall Plus Heatmap",
  module_id = "",
  bm_dataset_name = "",
  group_dataset_name = "",
  cat_var = "",
  par_var = "",
  visit_var = "",
  subjid_var = "",
  value_vars = "",
  bar_group_palette = "",
  cat_palette = "",
  tr_mapper = "",
  show_x_ticks = ""
)

mod_wfphm_API_spec <- TC$group(
  module_id = TC$mod_ID(),
  bm_dataset_name = TC$dataset_name(),
  group_dataset_name = TC$dataset_name() |> TC$flag("subject_level_dataset_name"),
  cat_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor())),
  par_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor())),
  visit_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor(), TC$numeric())),
  subjid_var = TC$col("group_dataset_name", TC$factor()) |> TC$flag("subjid_var"),
  value_vars = TC$col("bm_dataset_name", TC$numeric()) |> TC$flag("one_or_more"),
  bar_group_palette = TC$fn(arg_count = 1) |> TC$flag("optional", "zero_or_more", "named", "ignore"),
  cat_palette = TC$fn(arg_count = 1) |> TC$flag("optional", "zero_or_more", "named", "ignore"),
  tr_mapper = TC$fn(arg_count = 1) |> TC$flag("optional", "zero_or_more", "named", "ignore"),
  show_x_ticks = TC$logical()
) |> TC$attach_docs(mod_wfphm_API_docs)


check_mod_wfphm <- function(
    afmm, datasets, module_id, bm_dataset_name, group_dataset_name, cat_var, par_var, visit_var, subjid_var,
    value_vars, bar_group_palette, cat_palette, tr_mapper, show_x_ticks) {
  warn <- CM$container()
  err <- CM$container()

  # TODO: Replace this function with a generic one that performs the checks based on mod_boxplot_API_spec.
  # Something along the lines of OK <- CM$check_API(mod_corr_hm_API_spec, args = match.call(), warn, err)
  OK <- check_mod_wfphm_auto(
    afmm, datasets, module_id, bm_dataset_name, group_dataset_name, cat_var, par_var, visit_var, subjid_var,
    value_vars, bar_group_palette, cat_palette, tr_mapper, show_x_ticks, warn, err
  )

  # Checks that API spec does not (yet?) capture

  # #ahwopu
  if (OK[["subjid_var"]] && OK[["cat_var"]] && OK[["par_var"]] && OK[["visit_var"]]) {
    CM$check_unique_sub_cat_par_vis(
      datasets, "bm_dataset_name", bm_dataset_name,
      subjid_var, cat_var, par_var, visit_var, warn, err
    )
  }

  res <- list(warnings = warn[["messages"]], errors = err[["messages"]])
  return(res)
}

dataset_info_wfphm <- function(bm_dataset_name, group_dataset_name, ...) {
  # TODO: Replace this function with a generic one that builds the list based on mod_boxplot_API_spec.
  # Something along the lines of CM$dataset_info(mod_wfphm_API_spec, args = match.call())
  return(list(all = unique(c(bm_dataset_name, group_dataset_name)), subject_level = group_dataset_name))
}

mod_wfphm <- CM$module(mod_wfphm, check_mod_wfphm, dataset_info_wfphm)
