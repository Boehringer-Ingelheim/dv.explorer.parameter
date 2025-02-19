# Changes from the original (should ask users about them):
# - Group filtering through global filter
# - Synchronized cat/par/transform/visit for the x and y axis
# - Transform/val provided by columns on the input dataset
# - No dendrogram or other visual grouping

# CORRELATION HEATMAP
CH_ID <- poc( # nolint
  PAR_BUTTON = "par_button",
  PAR_VALUE_TRANSFORM = "par_value",
  MULTI_PAR_VIS = "multi_par_vis",
  CORR_BUTTON = "corr_button",
  CORR_METHOD = "corr_method",
  CORR_METHOD_PEARSON = "pearson",
  CORR_METHOD_SPEARMAN = "spearman",
  CHART = "chart",
  SCATTER = "scatter",
  TAB_TABLES = "tab_tables",
  TABLE_CORRELATION_LISTING = "table_correlation_listing",
  TABLE_LISTING = "table_listing",
  CHART_CLICK = "click"
)
CH_MSG <- poc( # nolint
  LABEL = poc(
    PAR_BUTTON = "Parameter",
    PAR = "Parameter",
    CAT = "Category",
    PAR_VALUE_TRANSFORM = "Value and transform",
    PAR_VISIT = "Visit",
    GRP_BUTTON = "Grouping",
    MAIN_GRP = "Group",
    SUB_GRP = "Subgroup",
    PAGE_GRP = "Page Group",
    CORR_BUTTON = "Correlation",
    CORR_METHOD = "Method",
    CORR_METHOD_PEARSON = "Pearson",
    CORR_METHOD_SPEARMAN = "Spearman",
    P_VALUE = "p-value (2-sided)",
    CI_MIN = "95% CI (min)",
    CI_MAX = "95% CI (max)",
    COUNT = "N",
    TABLE_CORRELATION_LISTING = "Correlation Listing"
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
    LESS_THAN_2_PARAMETER = "Please select at least 2 parameters",
    TOO_MANY_ROWS = paste(
      "The dataset provided contains repeated rows with identical subject, category, parameter and",
      "visit values. This module expects those to be unique. Here are the first few duplicates:"
    )
  )
)
# UI and server functions

#' Correlation Heatmap module
#'
#' @param id Shiny ID `[character(1)]`
#'
#' @param default_cat Default selected categories
#'
#' @param default_par Default selected parameters
#'
#' @param default_visit Default selected visits
#'
#' @param default_corr_method Name of default correlation method
#'
#' @name mod_corr_hm
#'
#' @keywords main
#'
NULL

#' @describeIn mod_corr_hm UI
#'
#' @param id `[character(1)]`
#'
#' Shiny ID
#'
#' @export
corr_hm_UI <- function(id, default_cat = NULL, default_par = NULL, default_visit = NULL, default_corr_method = NULL) {
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

  parameter_menu <- drop_menu_helper(
    ns(CH_ID$PAR_BUTTON), CH_MSG$LABEL$PAR_BUTTON,
    multi_param_visit_selector_UI(
      id = ns(CH_ID$MULTI_PAR_VIS), default_cat = default_cat,
      default_par = default_par, default_visit = default_visit
    ),
    col_menu_UI(ns(CH_ID$PAR_VALUE_TRANSFORM))
  )

  correlation_menu <- drop_menu_helper(
    ns(CH_ID$CORR_BUTTON), CH_MSG$LABEL$CORR_BUTTON,
    shiny::radioButtons(
      inputId = ns(CH_ID$CORR_METHOD),
      label = CH_MSG$LABEL$CORR_METHOD,
      selected = default_corr_method %||% CH_ID$CORR_METHOD_PEARSON,
      inline = TRUE,
      choiceNames = c(
        CH_MSG$LABEL$CORR_METHOD_PEARSON, CH_MSG$LABEL$CORR_METHOD_SPEARMAN
      ),
      choiceValues = c(
        CH_ID$CORR_METHOD_PEARSON, CH_ID$CORR_METHOD_SPEARMAN
      )
    ),
  )

  ch_menu <- shiny::tagList(
    parameter_menu,
    correlation_menu
  )

  # Charts and tables ----

  chart <- HM2SVG_UI(id = ns(CH_ID$CHART))
  scatter <- shiny::uiOutput(ns(CH_ID$SCATTER))

  tables <- shiny::tabsetPanel(
    id = ns(CH_ID$TAB_TABLES),
    shiny::tabPanel(
      CH_MSG$LABEL$TABLE_CORRELATION_LISTING,
      DT::DTOutput(ns(CH_ID$TABLE_CORRELATION_LISTING))
    )
  )

  # main_ui ----

  chart_scatter <- shiny::div(
    style = "display:flex;flex-direction:row;justify-content:center;align-items:center",
    shiny::div(chart, style = "width: 50%"), shiny::div(scatter, style = "width: 38%"),
  )

  main_ui <- shiny::tagList(add_warning_mark_dependency(), ch_menu, chart_scatter, tables)

  if (..__is_db()) {
    ..__db_UI(ns("debug"), main_ui, stacked = TRUE) # Debugging
  } else {
    main_ui
  }
}

# TODO: Document signature
apply_correlation_function <- function(df, fun, z_label) {
  need_one_cat_per_var(
    ds = df, cat_col = CNT$CAT, par_col = CNT$PAR,
    msg = "parameter name repeats across categories"
  )
  df <- df[c(CNT$SBJ, CNT$PAR, CNT$VAL)]

  parameters <- levels(df[["parameter"]])
  wider <- tidyr::pivot_wider(df, names_from = CNT$PAR, values_from = CNT$VAL)[parameters]

  res <- expand.grid(y = names(wider), x = names(wider))[c(2, 1)] # column 'y' to vary faster
  res[["z"]] <- 1
  res[[CH_MSG$LABEL$P_VALUE]] <- NA
  res[[CH_MSG$LABEL$CI_MIN]] <- NA
  res[[CH_MSG$LABEL$CI_MAX]] <- NA
  res[[CH_MSG$LABEL$COUNT]] <- NA_integer_
  res[["error"]] <- NA # TODO: POC

  n <- length(parameters)

  for (i in seq_len(n - 1)) {
    for (j in (i + 1):n) { # Skips upper triangle and diagonal
      # Compute dataframe row corresponding to this particular combination
      i_row <- (i - 1) * n + (j - 1) + 1
      reflected_i_row <- (j - 1) * n + (i - 1) + 1

      test_res <- tryCatch(
        expr = fun(wider[[i]], wider[[j]]),
        error = function(e) e[["message"]],
        warning = function(w) w[["message"]]
      )

      if (is.character(test_res)) {
        res[i_row, ][["error"]] <- res[reflected_i_row, ][["error"]] <- test_res
      } else {
        fields <- c("z", CH_MSG$LABEL$P_VALUE, CH_MSG$LABEL$CI_MIN, CH_MSG$LABEL$CI_MAX, CH_MSG$LABEL$COUNT)
        valid_pairs_count <- length(wider[[i]]) - sum(is.na(wider[[i]]) | is.na(wider[[j]]))

        res[i_row, ][fields] <- res[reflected_i_row, ][fields] <-
          c(
            test_res[["result"]] %||% NA_real_, test_res[["p_value"]] %||% NA_real_,
            test_res[["CI_lower_limit"]] %||% NA_real_, test_res[["CI_upper_limit"]] %||% NA_real_,
            valid_pairs_count
          )
      }
    }
  }

  data <- res

  data[["label"]] <- sprintf("%.2f", data[["z"]]) # embedded legend
  significant_indices <- (data[[CH_MSG$LABEL$P_VALUE]] < 0.05)
  significant_indices[is.na(significant_indices)] <- FALSE
  if (sum(significant_indices)) {
    data[significant_indices, ][["label"]] <- paste0(data[significant_indices, ][["label"]], "<br>(*)")
  }
  data[as.numeric(data[["x"]]) >= as.numeric(data[["y"]]), ][["label"]] <- "" # remove upper triangle
  attr(data[["z"]], "label") <- z_label

  if (all(is.na(data[["error"]]))) { # remove error column if empty
    data <- data[, !(names(data) %in% "error")]
  }

  data
}

# TODO: Document signature
ch_listings_table <- function(corr_df, ds, z_label) {
  meaningful_unique_indices <- as.numeric(corr_df[["x"]]) > as.numeric(corr_df[["y"]])
  res <- corr_df[meaningful_unique_indices, ]

  # Round to four decimals # NOTE: mentioned in vignettes/correlation_heatmap.Rmd
  fields <- c("z", CH_MSG$LABEL$P_VALUE, CH_MSG$LABEL$CI_MIN, CH_MSG$LABEL$CI_MAX)
  for (field in fields) {
    res[[field]] <- sprintf("%.4f", res[[field]])
  }
  names(res)[names(res) == "z"] <- z_label

  res[["label"]] <- NULL # embedded text is redundant; it's just a lower precision 'z'

  res
}

scatter_plot <- function(df, x_var, y_var) {
  need_one_cat_per_var(
    ds = df, cat_col = CNT$CAT, par_col = CNT$PAR,
    msg = "parameter name repeats across categories"
  )
  df <- df[c(CNT$SBJ, CNT$PAR, CNT$VAL)]
  checkmate::assert_numeric(df[[CNT$VAL]], finite = TRUE, any.missing = FALSE)
  x_y_df <- tidyr::pivot_wider(df, names_from = CNT$PAR, values_from = CNT$VAL)[union(x_var, y_var)]
  x <- x_y_df[[x_var]]
  y <- x_y_df[[y_var]]

  # NOTE: This is scatterplot needs a thorough tightening of screws, but let's see how users like it first

  svg_elem_list <- list()
  svg_elem_stack <- list()

  # TODO: Repeats #irewah
  SVG_append_raw <- function(s) svg_elem_list[[length(svg_elem_list) + 1]] <<- s # nolint

  SVG_push <- function(elem, desc, ...) { # nolint
    s <- paste0("<", elem, " ", ssub(desc, ...), ">")
    index <- length(svg_elem_list) + 1
    elem_index <- list(elem = elem, index = index)
    svg_elem_list[[index]] <<- s
    svg_elem_stack[[length(svg_elem_stack) + 1]] <<- elem_index
    return(elem_index)
  }

  SVG_pop <- function(elem_index) { # nolint
    top <- svg_elem_stack[[length(svg_elem_stack)]]
    if (!identical(top, elem_index)) stop("pop does not match push")
    s <- paste0("</", elem_index[["elem"]], ">")
    svg_elem_list[[length(svg_elem_list) + 1]] <<- s
    svg_elem_stack[length(svg_elem_stack)] <<- NULL
  }

  # Square plot
  scatter_size <- 680
  apron_size <- 10
  axis_size <- 100

  # nolint start
  #           SIZE DIAGRAM       [delta]      [cumulative]
  #                              _0           (0)
  #                              _apron       (apron)
  #    | +                  +    .
  #  y |             *           .
  #    |          *              .
  #  l |                         .
  #  a |    *            *       .
  #  b |                         .
  #  e |            *            .
  #  l |      *                  .
  #    |         *  *            .
  #    | +               *  +    _scatter     (apron + scatter)
  #      ____________________    _apron       (2*apron + scatter)
  #            x label           _axis        (2*apron + scatter + axis)
  # nolint end

  viewbox_size <- 2 * apron_size + scatter_size + axis_size

  r_x <- range(x, na.rm = TRUE)
  r_x[is.na(r_x)] <- 1
  x_min <- floor(r_x[[1]])
  x_max <- ceiling(r_x[[2]])
  if (x_min == x_max) x_max <- x_min + 1
  x_width <- x_max - x_min

  r_y <- range(y, na.rm = TRUE)
  r_y[is.na(r_y)] <- 1
  y_min <- floor(r_y[[1]])
  y_max <- ceiling(r_y[[2]])
  if (y_min == y_max) y_max <- y_min + 1
  y_width <- y_max - y_min

  nx <- (x - x_min) / x_width * scatter_size
  ny <- (1 - (y - y_min) / y_width) * scatter_size

  dot_r <- 5

  dots <- local({
    paste0(
      "<circle r='", dot_r, "' cx='", nx, "' cy='", ny, "' fill='", "black", "' /> ",
      collapse = "\n"
    )
  })

  svg <- SVG_push(
    "svg", "xmlns='http://www.w3.org/2000/svg' version='2.1' width=100% viewBox='0 0 W H'",
    W = viewbox_size, H = viewbox_size
  )

  local({
    # nolint start
    DEBUG_LAYOUT <- FALSE
    if (DEBUG_LAYOUT) {
      rect <- function(x1, y1, w, h, color) {
        ssub("<rect x='X' y='Y' width='W' height='H' fill='COLOR' />",
          X = x1, Y = y1, W = w, H = h, COLOR = color
        )
      }

      viewbox <- SVG_append_raw(rect(0, 0, viewbox_size, viewbox_size, "GhostWhite"))
      x_label <- SVG_append_raw(rect(0, apron_size, axis_size, scatter_size, "LightSteelBlue"))
      y_label <- SVG_append_raw(rect(axis_size + apron_size, viewbox_size - axis_size, scatter_size, axis_size, "LightSteelBlue"))
      scatter <- SVG_append_raw(rect(axis_size + apron_size, apron_size, scatter_size, scatter_size, "PaleGoldenRod"))
    }
    # nolint end
  })

  XY <- function(xy) paste0(xy[[1]], ",", xy[[2]]) # nolint

  # horizontal axis line
  x_label_NW <- c(axis_size + apron_size, viewbox_size - axis_size) # nolint
  x_label_NE <- c(axis_size + apron_size + scatter_size, viewbox_size - axis_size) # nolint
  SVG_append_raw(
    paste(
      "<polyline points='",
      XY(x_label_NW + c(0, apron_size)),
      XY(x_label_NW),
      XY(x_label_NE),
      XY(x_label_NE + c(0, apron_size)),
      "' fill='none' stroke='black' stroke-linejoin='round'/>"
    )
  )
  # vertical axis line
  y_label_NE <- c(axis_size, apron_size) # nolint
  y_label_SE <- c(axis_size, apron_size + scatter_size) # nolint
  SVG_append_raw(
    paste(
      "<polyline points='",
      XY(y_label_NE - c(apron_size, 0)),
      XY(y_label_NE),
      XY(y_label_SE),
      XY(y_label_SE - c(apron_size, 0)),
      "' fill='none' stroke='black' stroke-linejoin='round'/>"
    )
  )

  scatter_NE <- c(axis_size + apron_size, apron_size) # nolint
  into_scatter_area <- SVG_push("g", "transform='translate(X, Y)'", X = scatter_NE[[1]], Y = scatter_NE[[2]])
  SVG_append_raw(dots)
  SVG_pop(into_scatter_area)

  tick_size <- 20

  # Axes ticks
  SVG_append_raw("<text x='X' y='Y' font-size=FS px alignment-baseline='hanging' text-anchor='end'>TEXT</text>" |>
    ssub(
      X = y_label_NE[[1]] - apron_size, Y = y_label_NE[[2]] + apron_size,
      FS = tick_size, TEXT = y_max
    ))
  SVG_append_raw("<text x='X' y='Y' font-size=FS px alignment-baseline='bottom' text-anchor='end'>TEXT</text>" |>
    ssub(
      X = y_label_SE[[1]] - apron_size, Y = y_label_SE[[2]] - apron_size,
      FS = tick_size, TEXT = y_min
    ))
  SVG_append_raw("<text x='X' y='Y' font-size=FS px alignment-baseline='hanging' text-anchor='start'>TEXT</text>" |>
    ssub(
      X = x_label_NW[[1]] + apron_size, Y = x_label_NW[[2]] + apron_size,
      FS = tick_size, TEXT = x_min
    ))
  SVG_append_raw("<text x='X' y='Y' font-size=FS px alignment-baseline='hanging' text-anchor='end'>TEXT</text>" |>
    ssub(
      X = x_label_NE[[1]] - apron_size, Y = x_label_NE[[2]] + apron_size,
      FS = tick_size, TEXT = x_max
    ))


  axis_legend_size <- tick_size * 1.5
  y_label <- (y_label_NE + y_label_SE) / 2

  y_label_max_width <- scatter_size * 0.8
  # nolint start
  SVG_append_raw("
  <foreignObject x='X' y='Y' width=1 height=1 style='overflow: visible'>
  <div xmlns='http://www.w3.org/1999/xhtml' style='width:W;height:H;display:flex;align-items:center;justify-content:center;-webkit-transform:rotate(-90deg);transform-origin: center;'>
    <p style='margin:0;font-size:FS;text-align:center;white-space:pre-line'>TEXT</p>
  </div>
  </foreignObject>
  " |> ssub(
    X = y_label[[1]] - 4 * apron_size - y_label_max_width / 2, Y = y_label[[2]] - axis_size / 2,
    W = paste0(y_label_max_width, "px"), H = paste0(axis_size, "px"),
    FS = paste0(axis_legend_size, "px"), TEXT = y_var
  ))
  # nolint end

  x_label <- (x_label_NE + x_label_NW) / 2
  x_label_max_width <- scatter_size * 0.8
  SVG_append_raw("
    <foreignObject x='X' y='Y' width='W' height='H'>
    <div xmlns='http://www.w3.org/1999/xhtml' style='display:flex;align-items:center;justify-content:center;'>
      <p style='margin:0;font-size:FS;text-align:center'>TEXT</p>
    </div>
    </foreignObject>
   " |> ssub(
    X = x_label[[1]] - x_label_max_width / 2, Y = x_label[[2]] + 2 * apron_size,
    W = x_label_max_width, H = axis_size,
    FS = paste0(axis_legend_size, "px"), TEXT = x_var
  ))

  SVG_pop(svg)

  svg_string <- paste(svg_elem_list, collapse = "\n")
  return(svg_string)
}


#' @describeIn mod_corr_hm Server
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
#' @param default_value `[character(1)|NULL]`
#'
#' Default values for the selectors
#'
#' @export
#'
corr_hm_server <- function(id,
                           bm_dataset,
                           subjid_var = "SUBJID",
                           cat_var = "PARCAT",
                           par_var = "PARAM",
                           visit_var = "AVISIT",
                           value_vars = "AVAL",
                           default_value = NULL) {
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

    # argument asserts ----

    # dataset validation ----
    v_ch_dataset <- shiny::reactive(
      {
        # TODO: Remove once dataset checks are in place
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_data_frame(bm_dataset(), min.rows = 1, .var.name = ns("bm_dataset"), add = ac)
        checkmate::assert_names(
          names(bm_dataset()),
          type = "unique",
          must.include = c(
            VAR$CAT, VAR$PAR, VAR$SBJ, VAR$VIS, VAR$VAL
          ),
          .var.name = ns("bm_dataset"),
          add = ac
        )
        shiny::req(ac$isEmpty())

        checkmate::reportAssertions(ac)

        bm_dataset()
      },
      label = ns("v_ch_dataset")
    )

    inputs <- list()
    inputs[[CH_ID$PAR_VALUE_TRANSFORM]] <- col_menu_server(
      id = CH_ID$PAR_VALUE_TRANSFORM,
      data = v_ch_dataset,
      label = CH_MSG$LABEL$PAR_VALUE_TRANSFORM,
      include_func = function(val, name) {
        name %in% VAR$VAL
      }, include_none = FALSE, default = default_value
    )

    mpvs <- multi_param_visit_selector_server(
      CH_ID$MULTI_PAR_VIS, v_ch_dataset,
      cat_var = VAR$CAT, par_var = VAR$PAR, visit_var = VAR$VIS
    )

    inputs[[CH_ID$CORR_METHOD]] <- shiny::reactive(input[[CH_ID$CORR_METHOD]])

    # Reactivity must be solved inside otherwise the function does not depend on the value
    sv_not_empty <- function(input, ..., msg) {
      function(x) {
        if (test_not_empty(input())) NULL else msg
      }
    }

    # We listen to button presses shiny::reactive(input[[BP$ID$PAR_BUTTON]]) because when the app starts the element
    # inside the dropdown menu are not present
    # Therefore on the first pass the styles are not applied because they are not present until the first click on the
    # menus happen
    # We also listen to dataset changes, as the par selector elements are drawn using shinyoutput it may be the case
    # that the following happens
    # A dataset loads, the invalidation rules are applied, dataset changes, the selector is redrawn but with no
    # invalidation decoration
    # but because there is no change in the output the rules are not reapplied and invalidation decoration is
    # not applied.

    param_iv <- shinyvalidate::InputValidator$new()

    mpvs_ids <- attr(mpvs, "id")
    param_iv$add_rule(
      mpvs_ids[[CNT$CAT]][[1]],
      shinyvalidate::sv_required(message = CH_MSG$VALIDATE$NO_CAT_SEL)
    )
    param_iv$add_rule(
      mpvs_ids[[CNT$PAR]][[1]],
      shinyvalidate::sv_required(message = CH_MSG$VALIDATE$NO_PAR_SEL)
    )
    param_iv$add_rule(
      mpvs_ids[[CNT$VIS]][[1]],
      shinyvalidate::sv_required(message = CH_MSG$VALIDATE$NO_VISIT_SEL)
    )

    param_iv$add_rule(
      get_id(inputs[[CH_ID$PAR_VALUE_TRANSFORM]]),
      sv_not_empty(inputs[[CH_ID$PAR_VALUE_TRANSFORM]],
        msg = CH_MSG$VALIDATE$NO_VALUE_SEL
      )
    )
    param_iv$enable()

    shiny::observeEvent(param_iv$is_valid(), {
      session$sendCustomMessage(
        "dv_bm_toggle_warning_mark",
        list(
          id = ns(CH_ID$PAR_BUTTON),
          add_mark = !param_iv$is_valid()
        )
      )
    })

    # input validation ----
    v_input_subset <- shiny::reactive(
      {
        shiny::validate(
          shiny::need(
            param_iv$is_valid(),
            "Current selection cannot produce an output, please review menu feedback"
          )
        )
        subset_inputs <- c(CH_ID$PAR_VALUE_TRANSFORM, CH_ID$CORR_METHOD)
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

    # data reactives ----

    data_subset <- shiny::reactive({
      res <- ch_subset_data(
        sel = mpvs(),
        cat_col = VAR$CAT,
        par_col = VAR$PAR,
        val_col = v_input_subset()[[CH_ID$PAR_VALUE_TRANSFORM]],
        vis_col = VAR$VIS,
        bm_ds = v_ch_dataset(),
        subj_col = VAR$SBJ
      )

      shiny::validate(
        shiny::need(
          length(unique(res[["subject_id"]])) > 1,
          "Need at least two data points to compute correlations"
        )
      )
      res
    })

    # List of output arguments
    # nolint output_arguments <- list()

    # correlation heatmap plot----

    label_for_method <- function(method) {
      if (method == CH_ID$CORR_METHOD_PEARSON) {
        res <- paste(CH_MSG$LABEL$CORR_METHOD_PEARSON, "c.c.")
      } else if (method == CH_ID$CORR_METHOD_SPEARMAN) {
        res <- paste(CH_MSG$LABEL$CORR_METHOD_SPEARMAN, "c.c.")
      }
      res
    }

    correlation_data <- shiny::reactive({
      df <- data_subset()
      method <- v_input_subset()[[CH_ID$CORR_METHOD]]
      z_label <- label_for_method(method)

      corr_fun <- NULL
      if (method == CH_ID$CORR_METHOD_PEARSON) {
        corr_fun <- dv.explorer.parameter::pearson_correlation
      } else {
        if (method == CH_ID$CORR_METHOD_SPEARMAN) corr_fun <- dv.explorer.parameter::spearman_correlation
      }
      shiny::req(corr_fun)
      corr_fun <- corr_fun

      # NOTE: This thing can be made to run faster (~5x) by getting rid of intermediate functions
      #       and operating on a tighter matrix representation.
      #       See https://stackoverflow.com/a/13112337 and https://stackoverflow.com/a/9917412
      #       if you're interested.
      #       A more dramatic improvement would be to generate the graphic using plain `cor()` and
      #       produce a partial or complete listing using our internal function.
      apply_correlation_function(df, corr_fun, z_label) |>
        set_lbl("y", get_lbl_robust(df, "value"))
    })

    palette <- pal_div_palette(-1, 0, 1, rev(RColorBrewer::brewer.pal(11, name = "RdBu")))

    v_click_xy <- HM2SVG_server(id = CH_ID$CHART, data = correlation_data, palette = palette)

    output[[CH_ID$SCATTER]] <- shiny::renderUI({
      click <- v_click_xy()
      x_var <- click[["x"]]
      y_var <- click[["y"]]

      df <- data_subset()
      df <- df[df[[CNT$PAR]] %in% c(x_var, y_var), ]
      na_inf_idx <- is.na(df[[CNT$VAL]]) | !is.finite(df[[CNT$VAL]])
      na_inf_subjects <- levels(droplevels(df[[CNT$SBJ]][na_inf_idx]))
      df <- df[!df[[CNT$SBJ]] %in% na_inf_subjects, ]

      if (length(na_inf_subjects) > 0) {
        shiny::showNotification(
          paste(length(na_inf_subjects), "have been dropped due to NA or Inf values"),
          type = "warning"
        )
      }


      shiny::validate(
        shiny::need(
          checkmate::test_data_frame(df, min.rows = 1),
          "No rows returned by selection"
        )
      )

      svg_string <- scatter_plot(df, x_var, y_var)

      shiny::HTML(svg_string)
    })

    # listings/count table ----
    listing_contents <- shiny::reactive({
      data <- correlation_data()
      shiny::validate(
        shiny::need(
          nrow(data) > 1,
          "Need at least two data points to compute correlations"
        )
      )

      ds <- data_subset()
      method <- v_input_subset()[[CH_ID$CORR_METHOD]]
      z_label <- label_for_method(method)

      res <- ch_listings_table(data, ds, z_label)
      res
    })

    output[[CH_ID$TABLE_CORRELATION_LISTING]] <- DT::renderDT(listing_contents())

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
      listing_contents = listing_contents()
    )

    # return ----
    NULL
  }

  shiny::moduleServer(id, module)
}


# Data manipulation

#' Subset datasets for correlation heatmap
#'
#' @description
#'
#' Prepares the main data frame  for the rest of the correlation heatmap functions by
#' subsetting `bm_dataset` according to the category, parameter and visit combinations
#' captured by the rows of the `sel` parameter.
#'
#' @param sel a data.frame with three columns CNT$CAT, CMT$PAR, CNT$VIS.
#'
#' @details
#'
#' - factors from `bm_ds` are releveled so all extra levels not present after subsetting are dropped and are sorted
#' according to `par` and `cat`. Unless parameters are renamed in [subset_bds_param()] then no releveling occurs.
#' - `label` attributes from `bm_ds` are retained when available.
#'
#' @param bm_ds `data.frame`
#'
#' data frames to be used as inputs in [subset_bds_param]
#'
#' @inheritParams subset_bds_param
#'
#' @inheritParams subset_adsl
#'
#' @returns
#'
#' `[data.frame()]`
#'
#' | ``r CNT$CAT`` | ``r CNT$PAR`` | ``r CNT$SBJ`` |``r CNT$VAL`` |``r CNT$VIS`` |
#' | -- | -- | -- | -- | -- |
#' |xx|xx|xx|xx|xx|
#'
#' @keywords internal
ch_subset_data <- function(sel, cat_col, par_col, val_col, vis_col, bm_ds, subj_col) {
  cat <- unique(sel[[CNT$CAT]])
  par <- unique(sel[[CNT$PAR]])
  vis <- unique(sel[[CNT$VIS]])

  paste_par_vis <- function(p, v) paste0(p, " - ", v)
  sel_par_vis <- paste_par_vis(sel[[CNT$PAR]], sel[[CNT$VIS]])

  res <- subset_bds_param(
    ds = bm_ds, par = par, par_col = par_col,
    cat = cat, cat_col = cat_col, val_col = val_col,
    vis = vis, vis_col = vis_col, subj_col = subj_col
  )

  shiny::validate(
    need_rows(res)
  )

  res[[CNT$PAR]] <- paste_par_vis(res[[CNT$PAR]], res[[CNT$VIS]])
  res <- res[res[[CNT$PAR]] %in% sel_par_vis, ]
  res[[CNT$PAR]] <- factor(res[[CNT$PAR]])

  shiny::validate(
    need_rows(res)
  )

  # Drop non-present factor levels and restore lost labels
  labels <- get_lbls(res)
  res <- droplevels(res)
  res <- set_lbls(res, labels)

  res
}

#' Correlation Heatmap module
#'
#' Display a heatmap of correlation coefficients (Pearson, Spearman) along with confidence intervals
#' and p-values between dataset parameters over a single visit.
#'
#' @param module_id Shiny ID `[character(1)]`
#'
#' Module identifier
#'
#' @param bm_dataset_name `[character(1)]`
#'
#' Biomarker dataset name
#'
#' @name mod_corr_hm
#'
#' @keywords main
#'
#' @export
#'
mod_corr_hm <- function(module_id, bm_dataset_name,
                        subjid_var = "SUBJID",
                        cat_var = "PARCAT",
                        par_var = "PARAM",
                        visit_var = "AVISIT",
                        value_vars = "AVAL",
                        default_cat = NULL, default_par = NULL, default_visit = NULL,
                        default_value = NULL) {
  mod <- list(
    ui = function(mod_id) {
      corr_hm_UI(id = mod_id, default_cat = default_cat, default_par = default_par, default_visit = default_visit)
    },
    server = function(afmm) {
      corr_hm_server(
        id = module_id,
        bm_dataset = shiny::reactive(afmm[["filtered_dataset"]]()[[bm_dataset_name]]),
        default_value = default_value, subjid_var = subjid_var, cat_var = cat_var, par_var = par_var,
        visit_var = visit_var, value_vars = value_vars
      )
    },
    module_id = module_id
  )
  return(mod)
}

# Correlation heatmap module interface description ----
# TODO: Fill in
mod_corr_hm_API_docs <- list(
  "Correlation Heatmap",
  module_id = "",
  bm_dataset_name = "",
  subjid_var = "",
  cat_var = "",
  par_var = "",
  visit_var = "",
  value_vars = "",
  default_cat = "",
  default_par = "",
  default_visit = "",
  default_value = "" # FIXME(miguel): Should be called default_value_var
)

mod_corr_hm_API_spec <- TC$group(
  module_id = TC$mod_ID(),
  bm_dataset_name = TC$dataset_name(),
  subjid_var = TC$col("bm_dataset_name", TC$factor()) |> TC$flag("subjid_var"),
  cat_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor())),
  par_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor())),
  visit_var = TC$col("bm_dataset_name", TC$or(TC$character(), TC$factor(), TC$numeric())),
  value_vars = TC$col("bm_dataset_name", TC$numeric()) |> TC$flag("one_or_more"),
  default_cat = TC$choice_from_col_contents("cat_var") |> TC$flag("zero_or_more", "optional"),
  default_par = TC$choice_from_col_contents("par_var") |> TC$flag("zero_or_more", "optional"),
  default_visit = TC$choice_from_col_contents("visit_var") |> TC$flag("zero_or_more", "optional"),
  default_value = TC$choice("value_vars") |> TC$flag("optional") # FIXME(miguel): Should be called default_value_var
) |> TC$attach_docs(mod_corr_hm_API_docs)


check_mod_corr_hm <- function(
    afmm, datasets, module_id, bm_dataset_name, subjid_var, cat_var, par_var, visit_var,
    value_vars, default_cat, default_par, default_visit, default_value) {
  warn <- CM$container()
  err <- CM$container()

  # TODO: Replace this function with a generic one that performs the checks based on mod_corr_hm_API_spec.
  # Something along the lines of OK <- CM$check_API(mod_corr_hm_API_spec, args = match.call(), warn, err)

  OK <- check_mod_corr_hm_auto(
    afmm, datasets, module_id, bm_dataset_name, subjid_var, cat_var, par_var, visit_var,
    value_vars, default_cat, default_par, default_visit, default_value,
    warn, err
  )

  # Checks that API spec does not (yet?) capture
  if (OK[["subjid_var"]]) {
    dataset <- datasets[[bm_dataset_name]]
    OK[["subjid_var"]] <- CM$assert(err, is.factor(dataset[[subjid_var]]), "Column referenced by `subjid_var` should be a factor.")
  }

  if (OK[["subjid_var"]] && OK[["cat_var"]] && OK[["par_var"]] && OK[["visit_var"]]) {
    CM$check_unique_sub_cat_par_vis(
      datasets, "bm_dataset_name", bm_dataset_name,
      subjid_var, cat_var, par_var, visit_var, warn, err
    )
  }

  res <- list(warnings = warn[["messages"]], errors = err[["messages"]])
  return(res)
}

dataset_info_corr_hm <- function(bm_dataset_name, ...) {
  # TODO: Replace this function with a generic one that builds the list based on mod_boxplot_API_spec.
  # Something along the lines of CM$dataset_info(mod_corr_hm_API_spec, args = match.call())
  return(list(all = bm_dataset_name, subject_level = character(0)))
}

mod_corr_hm <- CM$module(mod_corr_hm, check_mod_corr_hm, dataset_info_corr_hm)
