# Changes from the original (should ask users about them):
# - Group filtering through global filter
# - Transform/val should be specified through columns on the dataset

# The following problems are byproducts of working with reactives. They can be addressed within a
# reactive framework, but I lean towards bundling them into a composite input (inside a shiny
# module) that updates atomically. That would solve these issues and simplify the selector logic
# instead of creating a reactive rat's nest.
# FIXME: Selecting a category triggers multiple spurious updates
#        I think that has to do with:
#        - v_input_subset bundles several inputs: downstream reactives trigger on inputs they don't care
#        - interdependent inputs treated separately (e.g. CATEGORICAL_VAL_{A,B} triggering one invalidates
#        the choices for the other one)
# FIXME: Faulty bookmarking: The right-most grouping selector is not restored properly, probably
#        because of the "exclude_cols" reactive expression (see #etoozi in tests)
# FIXME: Setting some menus reset other menus. One example is the grouping menu, that gets reset
#        when switching between statistic methods.
# TODO: Generalize forest plot display ranges
#       It is set from -1 to 1 in the case of numeric_numeric_functions, expecting a correlation
#       function and from 0 to 5 in the case of numeric_factor_functions, expecting an odds ratio
#       calculation. Related to the next TODO.
# TODO: It has been suggested by other devs that the option of a logarithmic scale for the odds ratio
#       plot would be welcomed. That function is defined external to the module, which means that the
#       log scale should be offered as part of the app creator interface, which makes it a non-trivial
#       feature. We will wait for a user requirement.
# TODO: Remove the function_names from the UI signature and use a renderUI instead?

# FOREST PLOT

FP_ID <- poc(
  PAR_BUTTON = "par_button",
  GRP_BUTTON = "grp_button",
  CATEGORICAL_VAR_BUTTON = "categorical_var_button",
  PLOT_BUTTON = "plot_button",
  PAR = "par",
  PAR_VALUE_TRANSFORM = "par_value",
  PAR_VISIT = "par_visit",
  FOREST_KIND = "forest_kind",
  FOREST_KIND_PEARSON = "pearson",
  FOREST_KIND_SPEARMAN = "spearman",
  FOREST_KIND_ODDS_RATIO = "odds_ratio",
  MAIN_GRP = "main_grp",
  TABLE_LISTING = "table_listing",
  CONT_VAR = "cont_var",
  CATEGORICAL_VAR = "categorical_var",
  CATEGORICAL_VAL_A = "categorical_val_a",
  CATEGORICAL_VAL_B = "categorical_val_b",
  PLOT_TITLE = "plot_title",
  CONT_CAT_VAR_BUTTON = "cont_cat_var_button",
  FOREST_SVG = "forest_svg"
)

FP_MSG <- poc(
  LABEL = poc(
    PAR_BUTTON = "Parameter", # inline selector "these parameters",
    CATEGORICAL_VAR_BUTTON = "these groups",
    PAR = "Parameter",
    CAT = "Category",
    VISIT = "Visit",
    TRANSFORM = "Transform",
    PAR_VALUE_TRANSFORM = "Value and transform",
    PAR_VISIT = "Visit",
    GRP_BUTTON = "Grouping",
    MAIN_GRP = "Group",
    CAT_VAL1 = "First value",
    CAT_VAL2 = "Second value",
    CORR_BUTTON = "Correlation",
    P_VALUE = "p-value (2-sided)",
    CI_MIN = "95% CI (min)",
    CI_MAX = "95% CI (max)",
    PLOT_BUTTON = "Plot",
    CONT_CAT_VAR_BUTTON = "Target variable" # label does not fit both use cases
  ),
  VALIDATE = poc(
    NO_CAT_SEL = "Select a category",
    NO_PAR_SEL = " Select a parameter",
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
    }
  )
)



# UI and server functions

#' Forest plot module
#'
#' @param id Shiny ID `[character(1)]`
#'
#' @name mod_forest
#'
#' @keywords main
#'
NULL

#' @describeIn mod_forest UI
#'
#' @param id `[character(1)]`
#'
#' Shiny ID
#'
#' @param numeric_numeric_function_names,numeric_factor_function_names `[character(1)]`
#'
#' Vectors of names of functions passed as `numeric_numeric_functions` and `numeric_factor_functions`
#' to `forest_server`
#'
#' @param default_function `[character(1)]`
#'
#' Default function
#'
#' @export
forest_UI <- function(id, numeric_numeric_function_names = character(0), numeric_factor_function_names = character(0),
                      default_function = NULL) {
  # FIXME? Asking the caller to pass the names of the functions handed to the server is error-prone
  #        but saves us some renderUI trouble
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)
  checkmate::assert_character(numeric_numeric_function_names)
  checkmate::assert_character(numeric_factor_function_names)
  # TODO: More descriptive messages
  checkmate::assert_true(length(numeric_numeric_function_names) + length(numeric_factor_function_names) > 0)

  # argument asserts ----

  # UI ----
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

  visit_selector <- val_menu_UI(id = ns(FP_ID$PAR_VISIT))

  parameter_menu_inline <- drop_menu_helper(
    ns(FP_ID$PAR_BUTTON), FP_MSG$LABEL$PAR_BUTTON,
    parameter_UI(id = ns(FP_ID$PAR)),
    col_menu_UI(id = ns(FP_ID$PAR_VALUE_TRANSFORM))
  )
  group_selector <- col_menu_UI(id = ns(FP_ID$MAIN_GRP))


  forest_kind_selector <-
    shiny::selectInput(
      ns(FP_ID$FOREST_KIND), NULL,
      choices = c(numeric_numeric_function_names, numeric_factor_function_names),
      selected = default_function %||% c(numeric_numeric_function_names, numeric_factor_function_names)[[1]]
    )

  cont_var_selector <- shiny::conditionalPanel(
    condition = ssub(
      '[NUM_NUM_IDS].includes(input["FOREST_KIND_ID"])',
      NUM_NUM_IDS = paste0('"', numeric_numeric_function_names, '"', collapse = ","),
      FOREST_KIND_ID = ns(FP_ID$FOREST_KIND)
    ),
    # TODO: POC
    col_menu_UI(id = ns(FP_ID$CONT_VAR))
  )

  categorical_var_selector <- shiny::conditionalPanel(
    condition = ssub(
      '[NUM_FAC_IDS].includes(input["FOREST_KIND_ID"])',
      NUM_FAC_IDS = paste0('"', numeric_factor_function_names, '"', collapse = ","),
      FOREST_KIND_ID = ns(FP_ID$FOREST_KIND)
    ),
    col_menu_UI(id = ns(FP_ID$CATEGORICAL_VAR)),
    shiny::selectizeInput(inputId = ns(FP_ID$CATEGORICAL_VAL_A), label = FP_MSG$LABEL$CAT_VAL1, choices = NULL),
    shiny::selectizeInput(inputId = ns(FP_ID$CATEGORICAL_VAL_B), label = FP_MSG$LABEL$CAT_VAL2, choices = NULL)
  )

  cont_cat_menu <- drop_menu_helper( # for traditional menus
    ns(FP_ID$CONT_CAT_VAR_BUTTON), FP_MSG$LABEL$CONT_CAT_VAR_BUTTON,
    cont_var_selector, categorical_var_selector,
  )

  # Charts and tables ----

  table_heading <- it_interactive_title(
    "Forest plot of ", forest_kind_selector, "between ", parameter_menu_inline,
    "and", cont_cat_menu, "on visit", visit_selector,
    "grouped by", group_selector
  )

  table <- shiny::tagList(
    table_heading,
    DT::DTOutput(ns(FP_ID$TABLE_LISTING))
  )

  js_resize <- shiny::tags[["script"]]('
    MOVE_RESIZE_DIV = function() {
    let forest_col = document.getElementById("ID_FOREST_COLUMN");
    if(forest_col == null) return;

    let table_forest_div = document.getElementById("TABLE_FOREST_DIV");
    let forest_div = document.getElementById("FOREST_DIV");
    let table = document.getElementById("TABLE_LISTING");

    let tbody = table.getElementsByTagName("tbody")[0];
    let tbody_rect = tbody.getBoundingClientRect();
    let table_forest_rect = table_forest_div.getBoundingClientRect();
    let forest_col_rect = forest_col.getBoundingClientRect();

    // position (table_forest_rect offsetting because the forest_div is nested into a position:relative div)
    forest_div.style.left = (forest_col_rect.x - table_forest_rect.x) + "px";
    forest_div.style.top = (tbody_rect.y - table_forest_rect.y) + "px";
    forest_div.style.width = forest_col_rect.width + "px";
    forest_div.style.height = tbody_rect.height + "px";

    // size
    var w = forest_col_rect.width;
    var h = tbody_rect.height;
    var obj = {width: w, height: h};
    Shiny.setInputValue("FOREST_DIV_SIZE", {w: w, h: h});
  }

  const RESIZE_OBSERVER = new ResizeObserver(MOVE_RESIZE_DIV);
  ' |> ssub(
    # FIXME: #iephan namespace; left intentionally until I write the test that fails
    ID_FOREST_COLUMN = "id_forest_column",
    TABLE_FOREST_DIV = ns("table_forest_div"), # POC
    FOREST_DIV = ns("forest_div"), # POC
    TABLE_LISTING = ns(FP_ID$TABLE_LISTING),
    FOREST_DIV_SIZE = ns("forest_div_size"),
    RESIZE_OBSERVER = underscore_ns(ns, "resize_observer"), # TODO: POC
    MOVE_RESIZE_DIV = underscore_ns(ns, "move_resize_div")
  )
  )

  forest_div <- shiny::tags[["div"]](
    id = ns("forest_div"), # POC
    style = "position: absolute; top: 0px; left: 0px; width: 0px; height: 0px; <!-- background-color: #ffff4155; --> ",
    shiny::uiOutput(ns(FP_ID$FOREST_SVG))
  )

  table_absolute_div <- shiny::tags[["div"]](
    id = ns("table_absolute_div"),
    style = "position: absolute; top:0px; bottom:0px; width:100%",
    table
  )

  table_forest_div <- shiny::tags[["div"]](
    id = ns("table_forest_div"), # TODO: POC
    style = "position: relative",
    shiny::tagList(table_absolute_div, forest_div)
  )


  # main_ui ----

  main_ui <- shiny::tagList(js_resize, table_forest_div)

  if (..__is_db()) {
    ..__db_UI(ns("debug"), main_ui, stacked = TRUE) # Debugging
  } else {
    main_ui
  }
}

gen_svg_ <- function(output_size, df, table_row_order, axis_config) {
  check_type(output_size, "size")
  check_type(df, "result_table")
  check_type(table_row_order, "sequence_permutation")
  check_type(axis_config, "axis_config")
  checkmate::assert_true(length(table_row_order) == nrow(df))

  width <- output_size[["w"]]
  height <- output_size[["h"]]
  ratio <- height / width

  row_count <- nrow(df)

  x_min <- axis_config[["x_min"]]
  x_max <- axis_config[["x_max"]]
  ref_line_x <- axis_config[["ref_line_x"]]
  tick_count <- axis_config[["tick_count"]]

  x_range <- x_max - x_min

  cell_height <- x_range * ratio / row_count
  viewbox_height <- cell_height * (row_count + 1)

  header <- ssub(
    '<svg version="1.1" viewBox="X_MIN 0 RANGE VIEWBOX_HEIGHT" height="100%" width="100%" style="overflow: visible">',
    X_MIN = x_min, RANGE = x_range, VIEWBOX_HEIGHT = viewbox_height
  )
  ref_line <- ssub(
    '<line x1="REF_LINE_X" y1="0" x2="REF_LINE_X" y2="AXIS_Y" style="stroke:rgb(0,0,0);stroke-opacity:0.3;stroke-width:REF_LINE_STROKE_WIDTH"/>',
    REF_LINE_X = ref_line_x
  )
  axis <- ssub(
    '<line x1="X_MIN" y1="AXIS_Y" x2="X_MAX" y2="AXIS_Y" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:AXIS_STROKE_WIDTH"/>',
    X_MIN = x_min, X_MAX = x_max
  )

  ticks <- local({
    l <- list()
    font_size <- cell_height / 3
    for (x in seq(from = x_min, to = x_max, length.out = tick_count)) {
      tick <- ssub(
        '<line x1="X" y1="AXIS_Y" x2="X" y2="TICK_Y2" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:AXIS_STROKE_WIDTH" stroke-linecap="round"/>
       <text x="X" y="TICK_Y2" dy=DY text-anchor="middle" dominant-baseline="hanging" font-size=FONT_SIZE>TEXT</text>',
        TICK_Y2 = x_range * ratio + font_size / 2,
        X = x, TEXT = x, FONT_SIZE = font_size, DY = font_size / 2
      )
      l <- append(l, tick)
    }
    paste(l, collapse = "\n")
  })

  trees <- local({
    l <- list()

    whisker_height <- cell_height / 5
    square_side <- 0.85 * whisker_height

    shiny::req(table_row_order, max(table_row_order) == row_count)

    for (i_row in seq_len(row_count)) {
      row <- df[table_row_order[[i_row]], ]

      x2 <- row[["CI_upper_limit"]]
      x2_ends <- x2
      if (!is.na(x2) && ((is.infinite(x2) & x2 > 0) || (x2 > x_max))) {
        x2 <- x_max
        x2_ends <- x2 - x_range / 50
      }

      y <- i_row * cell_height - cell_height / 2

      tree <- ssub(
        '<line x1="X1" y1="Y" x2="X2" y2="Y" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:TREE_STROKE_WIDTH"/>
         <line x1="X1" y1="Y1" x2="X1" y2="Y2" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:TREE_STROKE_WIDTH"/>
         <!-- right marker -->
         <line x1="X2_ENDS" y1="Y1" x2="X2" y2="Y"  style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:TREE_STROKE_WIDTH"/>
         <line x1="X2" y1="Y" x2="X2_ENDS" y2="Y2" style="stroke:rgb(0,0,0);stroke-opacity:0.8;stroke-width:TREE_STROKE_WIDTH"/>
         <rect x="SQUARE_X" y="SQUARE_Y" width="SQUARE_SIDE" height="SQUARE_SIDE" style="fill:rgb(65,105,225)" />
         ',
        Y = y,
        Y1 = y - whisker_height / 2,
        Y2 = y + whisker_height / 2,
        X1 = row[["CI_lower_limit"]],
        X2_ENDS = x2_ends,
        X2 = x2,
        SQUARE_X = row[["result"]] - square_side / 2,
        SQUARE_Y = y - square_side / 2,
        SQUARE_SIDE = square_side
      )
      l <- append(l, tree)
    }

    paste(l, collapse = "\n")
  })

  footer <- "</svg>"

  svg <- ssub(
    paste(header, ref_line, axis, ticks, trees, footer),
    AXIS_Y = x_range * ratio,
    AXIS_STROKE_WIDTH = 0.04 * cell_height,
    REF_LINE_STROKE_WIDTH = 0.02 * cell_height,
    TREE_STROKE_WIDTH = 0.03 * cell_height
  )

  res <- shiny::HTML(svg) |> type("svg")
  res
}
gen_svg <- strict(gen_svg_)

gen_result_table_fun_ <- function(ds, sl, fun, label) {
  check_type(ds, "data_subset")
  check_type(sl, "sl_df")
  check_type(fun, "fun")
  check_type(label, "S")

  group_cols <- intersect(c(CNT$CAT, CNT$PAR, CNT$MAIN_GROUP), names(ds))

  df <- as.data.frame(table(ds[, group_cols]), responseName = "N", stringsAsFactors = FALSE) |>
    possibly_set_lbls(get_lbls(ds))
  df[["result"]] <- NA
  df[["CI_lower_limit"]] <- NA
  df[["CI_upper_limit"]] <- NA
  df[["p_value"]] <- NA
  df[["warning"]] <- NA

  names(ds)[names(ds) == CNT$VAL] <- "var1" # TODO: POC

  b <- sl[c(CNT$SBJ, "var2")]

  for (i in seq_len(nrow(df))) {
    par <- df[[CNT$PAR]][[i]]

    a <- ds[ds[[CNT$PAR]] == par, ]
    par_mask <- df[[CNT$PAR]] == par
    if (CNT$MAIN_GROUP %in% names(a)) {
      group <- df[[CNT$MAIN_GROUP]][[i]]
      a <- a[a[[CNT$MAIN_GROUP]] == group, ]
      par_mask <- par_mask & (df[[CNT$MAIN_GROUP]] == group)
    }

    a <- a[c(CNT$SBJ, "var1")] # TODO: POC
    ab <- merge(a, b, by.x = CNT$SBJ, by.y = CNT$SBJ) # TODO: Could drop the SBJ column after

    fun_res <- local({ # run function and stuff warnings and errors on a separate column
      warning_message <- NULL

      muffle_handler <- function(cond) {
        warning_message <<- cond[["message"]]
        invokeRestart("muffle")
      }

      res <- withCallingHandlers( # Adapted from https://mschubert.github.io/2017/07/04/r-calling-handlers/
        expr = withRestarts(
          expr = {
            res <- fun(a = ab[["var1"]], b = ab[["var2"]])
            res[unlist(lapply(res, is.null))] <- NA
            res
          },
          muffle = function() NULL
        ),
        warning = muffle_handler,
        error = muffle_handler
      )

      if (!is.null(warning_message)) {
        res[["warning"]] <- warning_message # TODO? POC
      }
      res
    })

    df[par_mask, names(fun_res)] <- fun_res
  }

  attr(df[["result"]], "label") <- label
  attr(df[["CI_lower_limit"]], "label") <- "95% CI lower limit"
  attr(df[["CI_upper_limit"]], "label") <- "95% CI upper limit"
  attr(df[["p_value"]], "label") <- "P-value"
  attr(df[["warning"]], "label") <- "Warning"

  df |> type("result_table")
}
gen_result_table_fun <- strict(gen_result_table_fun_)


#' @describeIn mod_forest Server
#'
#' @param id `[character(1)]`
#'
#' Shiny ID
#'
#' @param bm_dataset `[data.frame()]`
#'
#' An ADBM-like dataset similar in structure to the one in
#' [this example](https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192),
#' with one record per subject per parameter per analysis visit.
#'
#' It should have, at least, the columns specified by the parameters `subjid_var`, `cat_var`,
#' `par_var`, `visit_var` and `value_vars`.
#' The semantics of these columns are as described in the CDISC standard for variables
#' USUBJID, PARCAT, PARAM, AVISIT and AVAL, respectively.
#'
#' @param group_dataset `[data.frame()]`
#'
#' An ADSL-like dataset similar in structure to the one in
#' [this example](https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806),
#' with one record per subject.
#'
#' It should contain, at least, the column specified by the parameter `subjid_var`.
#'
#' @param dataset_name `[shiny::reactive(*)]`
#'
#' A reactive that indicates a possible change in the column structure of any of the two datasets
#'
#' @param numeric_numeric_functions,numeric_factor_functions `[function(n)]`
#'
#' Named lists of functions. Each function needs to take two parameters and produce a list of four numbers
#' with the following names:
#' - result, CI_lower_limit, CI_upper_limit and p_value
#'
#' The module will offer the functions as part of its interface and will run each function if selected.
#'
#' The values returned by the functions are be captured on the output table and are also displayed
#' as part of the forest plot.
#'
#' `numeric_numeric_functions` take two numeric parameters (e.g. `dv.explorer.parameter::pearson_correlation`)
#' and `numeric_factor_functions` should accept a numeric first parameter and a categorical (factor) second parameter
#' (e.g. `dv.explorer.parameter::odds_ratio`).
#'
#' @param subjid_var `[character(1)]`
#'
#' Column corresponding to the subject ID
#'
#' @param cat_var,par_var,visit_var `[character(1)]`
#'
#' Columns from `bm_dataset` that correspond to the parameter category, parameter and visit
#'
#' @param value_vars `[character(n)]`
#'
#' Columns from `bm_dataset` that correspond to values of the parameters
#'
#' @param default_cat,default_par,default_visit,default_value `[character(1)|NULL]`
#'
#' Default values for the selectors
#'
#' @param default_var,default_group,default_categorical_A,default_categorical_B `[character(1)|NULL]`
#'
#' Default values for the selectors
#'
#' @export
#'
forest_server <- function(id,
                          bm_dataset,
                          group_dataset,
                          dataset_name = shiny::reactive(character(0)),
                          numeric_numeric_functions = list(),
                          numeric_factor_functions = list(),
                          subjid_var = "SUBJID",
                          cat_var = "PARCAT",
                          par_var = "PARAM",
                          visit_var = "AVISIT",
                          value_vars = c("AVAL", "PCHG"),
                          default_cat = NULL,
                          default_par = NULL,
                          default_visit = NULL,
                          default_value = NULL,
                          default_var = NULL,
                          default_group = NULL,
                          default_categorical_A = NULL,
                          default_categorical_B = NULL) {
  numeric_numeric_functions <- numeric_numeric_functions |> type("named_function_list")
  numeric_factor_functions <- numeric_factor_functions |> type("named_function_list")
  is_continuous_forest <- function(kind) kind %in% names(numeric_numeric_functions)
  is_categorical_forest <- function(kind) kind %in% names(numeric_factor_functions)

  # module constants ----
  VAR <- poc( # Parameters from the function that will be considered constant across the function
    CAT = cat_var,
    PAR = par_var,
    VAL = value_vars,
    VIS = visit_var,
    SBJ = subjid_var
  )

  module <- function(input, output, session) {
    # sessions ----
    ns <- session[["ns"]]

    # argument asserts ----

    # bookmark ---
    default_a <- default_categorical_A
    default_b <- default_categorical_B

    shiny::onRestore(function(state) {
      default_a <<- if (FP_ID$CATEGORICAL_VAL_A %in% names(state$input)) {
        state[["input"]][[FP_ID$CATEGORICAL_VAL_A]]
      } else {
        default_a
      }
      default_b <<- if (FP_ID$CATEGORICAL_VAL_B %in% names(state$input)) {
        state[["input"]][[FP_ID$CATEGORICAL_VAL_B]]
      } else {
        default_b
      }
    })

    # dataset validation ----
    v_sl_dataset <- shiny::reactive(
      {
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_data_frame(group_dataset(), .var.name = ns("group_dataset"))
        checkmate::assert_names(
          names(group_dataset()),
          type = "unique",
          must.include = c(VAR$SBJ), .var.name = ns("group_dataset")
        )
        checkmate::assert_factor(group_dataset()[[VAR$SBJ]], add = ac, .var.name = ns("group_dataset"))
        checkmate::reportAssertions(ac)
        group_dataset()
      },
      label = ns("v_sl_dataset")
    )

    v_bm_dataset <- shiny::reactive(
      {
        df <- bm_dataset()
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_data_frame(df, .var.name = ns("bm_dataset"), add = ac)
        checkmate::assert_names(
          names(df),
          type = "unique",
          must.include = c(
            VAR$CAT, VAR$PAR, VAR$SBJ, VAR$VIS, VAR$VAL
          ),
          .var.name = ns("bm_dataset"),
          add = ac
        )
        unique_par_names <- sum(duplicated(unique(df[c(VAR$CAT, VAR$PAR)])[["PARAM"]])) == 0
        checkmate::assert_true(unique_par_names, .var.name = ns("bm_dataset"), add = ac)
        checkmate::assert_factor(df[[VAR$SBJ]], .var.name = ns("bm_dataset"), add = ac)
        checkmate::reportAssertions(ac)
        df
      },
      label = ns("v_bm_dataset")
    )

    input_fp <- list()
    input_fp[[FP_ID$PAR]] <- parameter_server(
      id = FP_ID$PAR, data = v_bm_dataset,
      cat_var = VAR$CAT,
      par_var = VAR$PAR,
      default_cat = default_cat,
      default_par = default_par,
      multi_cat = TRUE,
      multi_par = TRUE
    )
    input_fp[[FP_ID$PAR_VALUE_TRANSFORM]] <- col_menu_server(
      id = FP_ID$PAR_VALUE_TRANSFORM,
      data = v_bm_dataset,
      label = FP_MSG$LABEL$PAR_VALUE_TRANSFORM,
      include_func = function(val, name) {
        name %in% VAR$VAL
      }, include_none = FALSE, default = default_value
    )
    input_fp[[FP_ID$MAIN_GRP]] <- col_menu_server(
      id = FP_ID$MAIN_GRP,
      data = v_sl_dataset,
      label = "Select a grouping variable",
      include_func = function(x) {
        is.character(x) || is.factor(x)
      },
      default = default_group
    )
    input_fp[[FP_ID$PAR_VISIT]] <- val_menu_server(
      id = FP_ID$PAR_VISIT,
      label = FP_MSG$LABEL$VISIT,
      data = v_bm_dataset,
      var = VAR$VIS,
      default = default_visit
    )
    input_fp[[FP_ID$FOREST_KIND]] <- shiny::reactive({
      shiny::req(input[[FP_ID$FOREST_KIND]])
      input[[FP_ID$FOREST_KIND]] |> type("forest_kind")
    })
    input_fp[[FP_ID$CONT_VAR]] <- col_menu_server(
      id = FP_ID$CONT_VAR,
      data = v_sl_dataset,
      label = "Continuous parameter",
      include_func = function(val, name) {
        is.numeric(val)
      }, include_none = FALSE, default = default_var
    )
    input_fp[[FP_ID$CATEGORICAL_VAR]] <- col_menu_server(
      id = FP_ID$CATEGORICAL_VAR,
      data = v_sl_dataset,
      label = "Categorical parameter",
      include_func = function(val, name) {
        is.factor(val) || is.character(val)
      }, include_none = FALSE, default = default_var
    )
    input_fp[[FP_ID$CATEGORICAL_VAL_A]] <- shiny::reactive({
      input[[FP_ID$CATEGORICAL_VAL_A]]
    })
    input_fp[[FP_ID$CATEGORICAL_VAL_B]] <- shiny::reactive({
      input[[FP_ID$CATEGORICAL_VAL_B]]
    })

    # Input validators

    # Reactivity must be solved inside otherwise the function does not depend on the value
    sv_not_empty <- function(input, ..., msg) {
      function(x) {
        if (test_not_empty(input())) NULL else msg
      }
    }

    sv_test_string <- function(input, ..., msg) {
      function(x) {
        if (checkmate::test_string(input(), min.chars = 1)) NULL else msg
      }
    }

    sv_test_string_different <- function(input1, input2, ..., msg) {
      function(x) {
        is_string1 <- checkmate::test_string(input1(), min.chars = 1)
        is_string2 <- checkmate::test_string(input2(), min.chars = 1)
        if (!(is_string1 && is_string2)) {
          return(NULL)
        }
        different <- if (is_string1 && is_string2) input1() != input2() else NULL
        if (different) {
          return(NULL)
        } else {
          return(msg)
        }
      }
    }

    # Input validator for parameters
    param_iv <- shinyvalidate::InputValidator$new()
    param_iv$add_rule(
      get_id(input_fp[[FP_ID$PAR]])[["cat"]],
      sv_not_empty(input_fp[[FP_ID$PAR]][["cat"]],
        msg = "Select at least one category"
      )
    )
    param_iv$add_rule(
      get_id(input_fp[[FP_ID$PAR]])[["par"]],
      sv_not_empty(input_fp[[FP_ID$PAR]][["par"]],
        msg = "Select at least one parameter"
      )
    )
    param_iv$add_rule(
      get_id(input_fp[[FP_ID$PAR_VALUE_TRANSFORM]]),
      sv_not_empty(input_fp[[FP_ID$PAR_VALUE_TRANSFORM]],
        msg = "Select one value transform"
      )
    )
    param_iv$enable()

    it_relabel_button(
      id = FP_ID$PAR_BUTTON,
      is_valid = shiny::reactive({
        param_iv$is_valid()
      }),
      label_if_valid = shiny::reactive({
        it_selection_to_label(input_fp[[FP_ID$PAR]][["par"]]())
      }),
      label_if_not_valid = shiny::reactive({
        "[select parameters]"
      })
    )

    # Input validator for categorical values
    categorical_var_iv <- shinyvalidate::InputValidator$new()
    categorical_var_iv$add_rule(
      get_id(input_fp[[FP_ID$CATEGORICAL_VAR]]),
      sv_not_empty(input_fp[[FP_ID$CATEGORICAL_VAR]],
        msg = "Select one categorical variable"
      )
    )
    categorical_var_iv$add_rule(
      FP_ID$CATEGORICAL_VAL_A,
      sv_test_string(input_fp[[FP_ID$CATEGORICAL_VAL_A]],
        msg = "Select one categorical value"
      )
    )
    categorical_var_iv$add_rule(
      FP_ID$CATEGORICAL_VAL_B,
      sv_test_string(input_fp[[FP_ID$CATEGORICAL_VAL_B]],
        msg = "Select one categorical value"
      )
    )
    categorical_var_iv$add_rule(
      FP_ID$CATEGORICAL_VAL_A,
      sv_test_string_different(input_fp[[FP_ID$CATEGORICAL_VAL_A]],
        input_fp[[FP_ID$CATEGORICAL_VAL_B]],
        msg = "Categorical values must be different"
      )
    )
    categorical_var_iv$add_rule(
      FP_ID$CATEGORICAL_VAL_B,
      sv_test_string_different(input_fp[[FP_ID$CATEGORICAL_VAL_B]],
        input_fp[[FP_ID$CATEGORICAL_VAL_A]],
        msg = "Categorical values must be different"
      )
    )
    categorical_var_iv$enable()

    # Visits
    visit_iv <- shinyvalidate::InputValidator$new()
    visit_iv$add_rule(
      get_id(input_fp[[FP_ID$PAR_VISIT]]),
      sv_not_empty(input_fp[[FP_ID$PAR_VISIT]],
        msg = "Select at least one visit value"
      )
    )
    visit_iv$enable()

    # Grouping
    group_iv <- shinyvalidate::InputValidator$new()
    group_iv$add_rule(
      get_id(input_fp[[FP_ID$MAIN_GRP]]),
      sv_not_empty(input_fp[[FP_ID$MAIN_GRP]],
        msg = "Select a group"
      )
    )
    group_iv$enable()

    it_relabel_button(
      id = FP_ID$CONT_CAT_VAR_BUTTON,
      is_valid = shiny::reactive({
        res <- TRUE
        forest_kind <- input_fp[[FP_ID$FOREST_KIND]]()
        if (is_categorical_forest(forest_kind)) res <- categorical_var_iv$is_valid()
        res
      }),
      label_if_valid = shiny::reactive({
        res <- input_fp[[FP_ID$CONT_VAR]]()
        forest_kind <- input_fp[[FP_ID$FOREST_KIND]]()
        if (is_categorical_forest(forest_kind)) {
          res <- paste0(input_fp[[FP_ID$CATEGORICAL_VAL_A]](), ", ", input_fp[[FP_ID$CATEGORICAL_VAL_B]]())
        }
        res
      }),
      label_if_not_valid = shiny::reactive({
        "[select values]"
      })
    )


    # input validation ----
    v_input_subset <- shiny::reactive(
      {
        shiny::validate(
          shiny::need(
            param_iv$is_valid() && visit_iv$is_valid() && group_iv$is_valid(),
            "Selection cannot produce an output. Please, review menu feedback."
          )
        )
        input_fp
      },
      label = ns("input_fp")
    )

    shiny::observeEvent(input_fp[[FP_ID$CATEGORICAL_VAR]](), {
      shiny::req(checkmate::test_subset(input_fp[[FP_ID$CATEGORICAL_VAR]](), names(v_sl_dataset()), empty.ok = FALSE))
      choices <- unique(v_sl_dataset()[[input_fp[[FP_ID$CATEGORICAL_VAR]]()]])
      shiny::updateSelectizeInput(
        inputId = FP_ID$CATEGORICAL_VAL_A,
        choices = choices,
        selected = default_a %||% input_fp[[FP_ID$CATEGORICAL_VAL_A]]()
      )
      shiny::updateSelectizeInput(
        inputId = FP_ID$CATEGORICAL_VAL_B,
        choices = choices,
        selected = default_b %||% input_fp[[FP_ID$CATEGORICAL_VAL_B]]()
      )
      default_a <<- NULL
      default_b <<- NULL
    })

    # data reactives ----

    data_subset <- shiny::reactive({
      # Reactive is resolved first as nested reactives do no "react"
      # (pun intented) properly when used inside dplyr::filter
      # The suspect is NSE, but further testing is needed.
      l_input_fp <- v_input_subset()
      # subgroup FP_ID$MAIN_GRP,

      group_vect <- c()
      group_vect[[CNT$MAIN_GROUP]] <- input_fp[[FP_ID$MAIN_GRP]]()
      group_vect <- drop_nones(unlist(group_vect))

      fp_subset_data(
        cat = l_input_fp[[FP_ID$PAR]][["cat"]](),
        par = l_input_fp[[FP_ID$PAR]][["par"]](),
        val_col = l_input_fp[[FP_ID$PAR_VALUE_TRANSFORM]](),
        vis = l_input_fp[[FP_ID$PAR_VISIT]](),
        bm_ds = v_bm_dataset(),
        group_ds = v_sl_dataset(),
        group_vect = group_vect,
        subj_col = VAR$SBJ,
        cat_col = VAR$CAT,
        par_col = VAR$PAR,
        vis_col = VAR$VIS
      )
    })

    result_table <- shiny::reactive(
      {
        ds <- data_subset() |> type("data_subset")

        v_input_subset <- v_input_subset()
        forest_kind <- v_input_subset[[FP_ID$FOREST_KIND]]() |> type("forest_kind")

        var <- NULL

        shiny::validate(
          shiny::need(
            (is_categorical_forest(forest_kind) && categorical_var_iv$is_valid()) || is_continuous_forest(forest_kind),
            "Selection cannot produce an output. Please, review menu feedback."
          )
        )

        if (is_continuous_forest(forest_kind)) {
          var <- v_input_subset[[FP_ID$CONT_VAR]]() |> type("S")
        } else {
          stopifnot(is_categorical_forest(forest_kind))
          var <- v_input_subset[[FP_ID$CATEGORICAL_VAR]]() |> type("S")
        }

        sl <- local({ # use internal column names to avoid variable parameterization
          sl <- v_sl_dataset()
          names(sl)[names(sl) == VAR$SBJ] <- CNT$SBJ
          names(sl)[names(sl) == var] <- "var2" # TODO: POC
          # TODO? Filter sl to only have these two columns
          sl
        }) |> type("sl_df")

        res <- NULL
        if (is_continuous_forest(forest_kind)) {
          label <- forest_kind |> type("S") # TODO: POC
          fun <- numeric_numeric_functions[[forest_kind]] |> type("fun")
        } else {
          stopifnot(is_categorical_forest(forest_kind))

          categorical_value_a <- v_input_subset[[FP_ID$CATEGORICAL_VAL_A]]() |> type("S")
          categorical_value_b <- v_input_subset[[FP_ID$CATEGORICAL_VAL_B]]() |> type("S")

          # TODO? Force the caller to use a proper factor
          if (is.character(sl[["var2"]])) {
            sl["var2"] <- as.factor(sl[["var2"]])
          }

          shiny::req(
            categorical_value_a, categorical_value_b, categorical_value_a != categorical_value_b,
            categorical_value_a %in% levels(sl[["var2"]]),
            categorical_value_b %in% levels(sl[["var2"]])
          )

          if (is.factor(sl[["var2"]])) { # FIXME: should be
            indices <- sl[["var2"]] %in% c(categorical_value_a, categorical_value_b)
            sl <- sl[indices, ]
            sl[["var2"]] <- stats::relevel(sl[["var2"]], ref = categorical_value_a)
            sl
          }

          label <- forest_kind |> type("S")
          fun <- numeric_factor_functions[[forest_kind]] |> type("fun")
        }

        res <- gen_result_table_fun(
          ds, sl, fun, label
        )

        res
      },
      label = "result_table"
    )

    # listings table ----
    output[[FP_ID$TABLE_LISTING]] <- DT::renderDT({
      # FIXME: Assumes parameter names are not repeated across categories

      df <- result_table()

      df[["result-order"]] <- df[["result"]]
      df[["CI_lower_limit-order"]] <- df[["CI_lower_limit"]]
      df[["CI_upper_limit-order"]] <- df[["CI_upper_limit"]]
      df[["p_value-order"]] <- df[["p_value"]]

      labels <- unname(unlist(get_lbls_robust(df)))

      th_list <- lapply(labels, htmltools::tags[["th"]])

      df[["forest"]] <- ""
      # TODO: namespace and POC #iephan
      th_list <- append(th_list, list(htmltools::tags[["th"]](id = "id_forest_column", "")))

      # TODO? Simplify custom headers with https://premium.shinyapps.io/CustomDataTableHeaders/
      container <- htmltools::tags[["table"]](
        class = "display", style = "white-space:nowrap",
        htmltools::tags[["thead"]](
          do.call(htmltools::tags[["tr"]], th_list)
        )
      )

      format_number <- function(x, decimal_count) {
        fmt <- rep(paste0("%.", decimal_count, "f"), length(x))
        fmt[x > 1e6] <- "%g"
        sprintf(fmt, x)
      }

      # TODO? Specify decimal count centrally
      df[["result"]][] <- format_number(df[["result"]], 2)
      df[["CI_lower_limit"]][] <- format_number(df[["CI_lower_limit"]], 2)
      df[["CI_upper_limit"]][] <- format_number(df[["CI_upper_limit"]], 2)
      df[["p_value"]][] <- format_number(df[["p_value"]], 4)

      warning_rows <- !is.na(df[["warning"]])
      df[["result"]][warning_rows] <- paste0(df[["result"]][warning_rows], " *")

      warning_col_index <- which(names(df) == "warning") - 1

      format_na_and_warnings <- c("function(row, data){
                         for(var i=0; i<data.length; i++){
                           if(data[i] == 'NA' || data[i] == 'Inf'){
                             $('td:eq('+i+')', row).html(data[i])
                               .css({'color': 'rgb(151,151,151)', 'font-style': 'italic'});
                           }
                           else if(typeof data[i] === 'string' && data[i].endsWith('*')){
                             $('td:eq('+i+')', row).html(data[i])
                               .css({'color': 'rgb(255,50,50)'})
                               .attr('title', data[WARNING_COL_INDEX]);
                           }
                         }
                       }" |> ssub(WARNING_COL_INDEX = as.character(warning_col_index)))

      colnum <- function(name) which(names(df) == name) - 1

      res <- DT::datatable(
        data = df, escape = FALSE,
        container = container,
        rownames = FALSE,
        options = list(
          # targets can be expressed as either 0-based indices or strings (https://github.com/rstudio/DT/pull/948)
          # for the rest of indices, we need to provide 0-based indices
          columnDefs = list(
            list(width = "25%", targets = "forest"),
            list(orderData = colnum("result-order"), targets = "result"),
            list(orderData = colnum("CI_lower_limit-order"), targets = "CI_lower_limit"),
            list(orderData = colnum("CI_upper_limit-order"), targets = "CI_upper_limit"),
            list(orderData = colnum("p_value-order"), targets = "p_value"),
            list(
              visible = FALSE, searchable = FALSE,
              targets = list(
                "result-order", "CI_lower_limit-order",
                "CI_upper_limit-order", "p_value-order",
                "warning"
              )
            )
          ),
          dom = "t",
          paging = FALSE,
          initComplete = DT::JS('function(setting, json){
                                  RESIZE_OBSERVER.disconnect();
                                  let table = document.getElementById("TABLE_LISTING");
                                  let tbody = table.getElementsByTagName("tbody")[0];
                                  RESIZE_OBSERVER.observe(tbody);
                                }' |> ssub(
            TABLE_LISTING = ns(FP_ID$TABLE_LISTING),
            RESIZE_OBSERVER = underscore_ns(ns, "resize_observer") # TODO: POC
          )),
          rowCallback = DT::JS(format_na_and_warnings)
        )
      )
      res
    })

    forest_div_size <- shiny::reactive({
      res <- input[["forest_div_size"]]
      shiny::req(res)
      unlist(res) |> type("size")
    }) |>
      shiny::debounce(millis = 100)

    output[[FP_ID$FOREST_SVG]] <- shiny::renderUI({
      forest_div_size <- forest_div_size()
      shiny::req(forest_div_size)

      df <- result_table()
      forest_kind <- v_input_subset()[[FP_ID$FOREST_KIND]]()

      axis_config <- NULL
      if (is_continuous_forest(forest_kind)) {
        axis_config <- c(x_min = -1, x_max = 1, ref_line_x = 0, tick_count = 5) |> type("axis_config")
      } else {
        stopifnot(is_categorical_forest(forest_kind))
        axis_config <- c(x_min = 0, x_max = 5, ref_line_x = 1, tick_count = 6) |> type("axis_config")
      }

      table_row_order <- input[[paste0(FP_ID$TABLE_LISTING, "_rows_current")]] |> type("sequence_permutation",
        allow_NULL = TRUE
      )
      shiny::req(
        table_row_order, length(table_row_order) == nrow(df),
        all(sort(table_row_order) == seq_len(nrow(df)))
      )

      res <- gen_svg(forest_div_size, df, table_row_order, axis_config)
      res
    })

    # debug tab ----
    if (..__is_db()) {
      ..__db_server(
        id = "debug",
        debug_list = list(
          list(
            name = "Data subset",
            ui = DT::dataTableOutput,
            server = DT::renderDataTable({
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


# Data manipulation

#' Subset datasets for correlation heatmap
#'
#' @inheritParams bp_subset_data
#'
#' @description
#'
#' TODO: Update this roxygen description to match the function
#'
#' @keywords internal

fp_subset_data <- function(cat, cat_col, par, par_col, val_col, vis, vis_col, group_vect,
                           bm_ds, group_ds, subj_col) {
  bm_fragment <- subset_bds_param(
    ds = bm_ds, par = par, par_col = par_col,
    cat = cat, cat_col = cat_col, val_col = val_col,
    vis = vis, vis_col = vis_col, subj_col = subj_col
  )

  is_grouped <- length(group_vect) > 0

  if (is_grouped) {
    # Decorate function instead of catching error prefix
    grp_fragment <- subset_adsl(
      ds = group_ds, group_vect = group_vect, subj_col = subj_col
    )

    shiny::validate(
      shiny::need(
        {
          bm_names <- names(bm_fragment)
          grp_names <- names(grp_fragment)
          bm_names <- bm_names[bm_names != c(CNT$SBJ)]
          grp_names <- grp_names[grp_names != c(CNT$SBJ)]
          checkmate::test_disjunct(bm_names, grp_names)
        },
        FP_MSG$VALIDATE$GROUP_COL_REPEATED # TODO: FP
      )
    )

    res <- merge(bm_fragment, grp_fragment, by = CNT$SBJ, all.x = TRUE) |>
      set_lbls(get_lbls(bm_fragment)) |>
      set_lbls(get_lbls(grp_fragment))
  } else {
    res <- bm_fragment
  }

  shiny::validate(need_rows(res))

  # Drop non-present factor levels and restored lost labels
  labels <- get_lbls(res)
  res <- droplevels(res)
  res <- set_lbls(res, labels)
  res
}

#' Forest plot module
#'
#' Display a hybrid table/forest plot of arbitrary statistics (correlations, odds ratios, ...)
#' computed on dataset parameters over a single visit.
#'
#' @param module_id Shiny ID `[character(1)]`
#'
#' Module identifier
#'
#' @param bm_dataset_name,group_dataset_name `[character(1)]`
#'
#' Dataset names
#'
#' @name mod_forest
#'
#' @keywords main
#'
#' @export
#'
mod_forest_ <- function(module_id,
                        bm_dataset_name,
                        group_dataset_name,
                        numeric_numeric_functions = list(),
                        numeric_factor_functions = list(),
                        subjid_var = "SUBJID",
                        cat_var = "PARCAT",
                        par_var = "PARAM",
                        visit_var = "AVISIT",
                        value_vars = c("AVAL", "PCHG"),
                        default_cat = NULL,
                        default_par = NULL,
                        default_visit = NULL,
                        default_value = NULL,
                        default_var = NULL,
                        default_group = NULL,
                        default_categorical_A = NULL,
                        default_categorical_B = NULL) {
  numeric_numeric_function_names <- names(numeric_numeric_functions) %||% character(0)
  numeric_factor_function_names <- names(numeric_factor_functions) %||% character(0)

  mod <- list(
    ui = function(mod_id) {
      forest_UI(
        id = mod_id,
        numeric_numeric_function_names = numeric_numeric_function_names,
        numeric_factor_function_names = numeric_factor_function_names
      )
    },
    server = function(afmm) {
      forest_server(
        id = module_id,
        bm_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[bm_dataset_name]]),
        group_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[group_dataset_name]]),
        numeric_numeric_functions = numeric_numeric_functions,
        numeric_factor_functions = numeric_factor_functions,
        subjid_var = subjid_var,
        cat_var = cat_var,
        par_var = par_var,
        visit_var = visit_var,
        value_vars = value_vars,
        default_cat = default_cat,
        default_par = default_par,
        default_visit = default_visit,
        default_var = default_var,
        default_group = default_group,
        default_categorical_A = default_categorical_A,
        default_categorical_B = default_categorical_B
      )
    },
    module_id = module_id
  )
  return(mod)
}

# Forest plot module interface description ----
# TODO: Fill in
mod_forest_API_docs <- list(
  "Forest plot",
  module_id = "",
  bm_dataset_name = "",
  group_dataset_name = "",
  numeric_numeric_functions = "",
  numeric_factor_functions = "",
  subjid_var = "",
  cat_var = "",
  par_var = "",
  visit_var = "",
  value_vars = "",
  default_cat = "",
  default_par = "",
  default_visit = "",
  default_value = "", # FIXME(miguel): ? Should be called default_value_var
  default_var = "", # TODO: Check FIXME: ? Should it communicate "default categorical var"
  default_group = "", # TODO: Check FIXME: ? Should it communicate "default grouping var"
  default_categorical_A = "", # TODO: Check
  default_categorical_B = "" # TODO: Check
)

mod_forest_API_spec <- T_group(
  module_id = T_mod_ID(),
  bm_dataset_name = T_dataset_name(),
  group_dataset_name = T_dataset_name(),
  numeric_numeric_functions = T_function(arg_count = 2) |> T_flag("optional", "zero_or_more", "named"),
  numeric_factor_functions = T_function(arg_count = 2) |> T_flag("optional", "zero_or_more", "named"),
  subjid_var = T_col("group_dataset_name", T_factor()) |> T_flag("subjid_var"),
  cat_var = T_col("bm_dataset_name", T_or(T_character(), T_factor())),
  par_var = T_col("bm_dataset_name", T_or(T_character(), T_factor())),
  visit_var = T_col("bm_dataset_name", T_or(T_character(), T_factor(), T_numeric())),
  value_vars = T_col("bm_dataset_name", T_numeric()) |> T_flag("one_or_more"),
  default_cat = T_choice_from_col_contents("cat_var") |> T_flag("zero_or_more", "optional"),
  default_par = T_choice_from_col_contents("par_var") |> T_flag("zero_or_more", "optional"),
  default_visit = T_choice_from_col_contents("visit_var") |> T_flag("zero_or_more", "optional"),
  default_value = T_choice("value_vars") |> T_flag("optional"), # FIXME(miguel): ? Should be called default_value_var
  default_var = T_col("group_dataset_name", T_or(T_character(), T_factor())) |> T_flag("optional"), # TODO: Check FIXME: ? Should it communicate "default categorical var"
  default_group = T_col("group_dataset_name", T_or(T_character(), T_factor())) |> T_flag("optional"), # TODO: Check FIXME: ? Should it communicate "default grouping var"
  default_categorical_A = T_choice_from_col_contents("default_var") |> T_flag("optional"), # TODO: Check
  default_categorical_B = T_choice_from_col_contents("default_var") |> T_flag("optional") # TODO: Check
) |> T_attach_docs(mod_forest_API_docs)

check_mod_forest <- function(
    afmm, datasets, module_id, bm_dataset_name, group_dataset_name, numeric_numeric_functions,
    numeric_factor_functions, subjid_var, cat_var, par_var, visit_var, value_vars,
    default_cat, default_par, default_visit, default_value, default_var, default_group,
    default_categorical_A, default_categorical_B) {
  warn <- C_container()
  err <- C_container()

  # TODO: Replace this function with a generic one that performs the checks based on mod_forest_API_spec.
  # Something along the lines of OK <- C_check_API(mod_corr_hm_API_spec, args = match.call(), warn, err)

  OK <- check_mod_forest_auto(
    afmm, datasets, module_id, bm_dataset_name, group_dataset_name, numeric_numeric_functions,
    numeric_factor_functions, subjid_var, cat_var, par_var, visit_var, value_vars,
    default_cat, default_par, default_visit, default_value, default_var, default_group,
    default_categorical_A, default_categorical_B, warn, err
  )

  # Checks that API spec does not (yet?) capture
  if (OK[["numeric_numeric_functions"]] && OK[["numeric_factor_functions"]]) {
    C_assert(
      err, length(numeric_numeric_functions) + length(numeric_factor_functions) > 0,
      paste(
        "Provide at least one function through `numeric_numeric_functions` or `numeric_numeric_functions`,",
        "otherwise this module is useless."
      )
    )
  }

  res <- list(warnings = warn[["messages"]], errors = err[["messages"]])
  return(res)
}

mod_forest <- C_module(mod_forest_, check_mod_forest)

# TODO: Move pearson_correlation and spearman_correlation to their own file
# TODO: Maybe odds_ratio too

#' Forest plot comnputing functions
#'
#' Helpers used in the forest plot to calculate statistics
#'
#' @name fp_stats
#'
NULL

#' @describeIn fp_stats Pearson correlation function
#'
#' Forest plot helper
#'
#' @param a,b vectors to be tested
#'
#' @export
pearson_correlation <- function(a, b) {
  test <- stats::cor.test(a, b)
  res <- list(
    result = test[["estimate"]][["cor"]],
    CI_lower_limit = test[["conf.int"]][[1]],
    CI_upper_limit = test[["conf.int"]][[2]],
    p_value = test[["p.value"]]
  )
  res
}


#' @describeIn fp_stats Spearman correlation function
#'
#' Forest plot helper
#'
#' @param a,b vectors to be tested
#'
#' @export
spearman_correlation <- function(a, b) {
  # Adapted from https://stats.stackexchange.com/a/506367
  spearman_CI <- function(x, y, rho, alpha = 0.05) {
    n <- sum(stats::complete.cases(x, y))
    if (n <= 3) {
      res <- c(NA, NA)
    } else {
      res <- sort(
        tanh(atanh(rho) + c(-1, 1) * sqrt((1 + rho^2 / 2) / (n - 3)) * stats::qnorm(p = alpha / 2)),
        na.last = TRUE
      )
    }
    res
  }

  test <- stats::cor.test(a, b, method = "spearman", exact = FALSE)
  rho <- test[["estimate"]][["rho"]]
  if (is.na(rho)) {
    test[["conf.int"]] <- c(NA, NA)
  } else {
    test[["conf.int"]] <- spearman_CI(a, b, rho)
  }

  res <- list(
    result = rho,
    CI_lower_limit = test[["conf.int"]][[1]],
    CI_upper_limit = test[["conf.int"]][[2]],
    p_value = test[["p.value"]]
  )
  res
}

#' @describeIn fp_stats Odds ratio function
#'
#' Forest plot helper
#'
#' @export
odds_ratio <- function(a, b) {
  df <- data.frame(var1 = a, var2 = b)
  fml <- stats::reformulate(termlabels = "var1", response = "var2") # TODO: POC
  test_res <- stats::glm(fml, data = df, family = "binomial")

  estimate <- test_res[["coefficients"]][["var1"]] # TODO: POC
  res <- list(result = exp(estimate), N = nrow(df))

  glm_summary <- as.data.frame(stats::summary.glm(test_res)[["coefficients"]])
  if (nrow(glm_summary) >= 2) {
    std_error <- glm_summary[["Std. Error"]][[2]]
    p_value <- glm_summary[["Pr(>|z|)"]][[2]]

    range_half_width <- stats::qnorm(1 - 0.05 / 2) * std_error
    res <- append(
      res,
      list(
        CI_lower_limit = exp(estimate - range_half_width),
        CI_upper_limit = exp(estimate + range_half_width),
        p_value = p_value
      )
    )
  }
  res
}
