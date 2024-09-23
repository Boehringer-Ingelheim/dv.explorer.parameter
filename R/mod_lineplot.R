# LINEPLOT
LP_ID <- poc(
  PAR_BUTTON = "par_button",
  GRP_BUTTON = "grp_button",
  VIS_BUTTON = "vis_button",
  PAR = "par",
  PAR_VALUE_TRANSFORM = "par_value",
  PAR_VISIT_COL = "par_visit_col",
  PAR_VISIT = "par_visit",
  VISIT_VAR_SELECTOR_RENDERUI = "visit_var_selector_renderui",
  TWEAKS_BUTTON = "tweaks_button",
  PLOT_BUTTON = "plot_button",
  PLOT_CENTRALITY_AND_DISPERSION = "plot_centrality_and_dispersion",
  TITLE_RENDERUI = "title_renderui",
  CHART_RENDERUI = "chart_renderui",
  CHART = "chart",
  TAB_TABLES = "tab_tables",
  SUBJECT_LISTING = "table_listing",
  COUNT_LISTING = "table_count",
  SUMMARY_LISTING = "table_summary",
  CHART_CLICK = "click",
  CHART_BRUSH = "brush",
  MAIN_GRP = "main_group",
  SUB_GRP = "sub_group",
  MISC = poc(
    WHISKER_BOTTOM = "whisker_bottom",
    WHISKER_TOP = "whisker_top",
    DODGE_WIDTH = 0.5, # TODO? Dehardcode
    ERROR_BAR_WIDTH = 0.5
  ),
  TWEAK_TRANSPARENCY = "transparency",
  TWEAK_Y_AXIS_PROJECTION = "y_axis_projection",
  SELECTED_SUBJECT = "selected_subject",
  LINE_HIGHLIGHT_MASK = "line_highlight_mask"
)

LP_MSG <- poc(
  LABEL = poc(
    PAR_BUTTON = "Parameter",
    VIS_BUTTON = "Visit",
    PAR = "Parameter",
    CAT = "Category",
    PAR_VALUE_TRANSFORM = "Value and transform",
    PAR_VISIT_COL = "Visit variable",
    PAR_VISIT = "Visits",
    GRP_BUTTON = "Grouping",
    PLOT_BUTTON = "Plot type",
    MAIN_GRP = "Group",
    SUB_GRP = "Subgroup",
    PAGE_GRP = "Page Group",
    OTHER_BUTTON = "Other",
    TABLE_CORRELATION_LISTING = "Correlation Listing",
    SUBJECT_LISTING = "Subject-level listing",
    COUNT_LISTING = "Data Count",
    SUMMARY_LISTING = "Summary listing",
    TABLE_SIGNIFICANCE = "Data Significance",
    TWEAK_TRANSPARENCY = "Transparency"
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

LP_CNT <- poc(
  PLOT_TYPE_SUBJECT_LEVEL = "Subject-level",
  CENTRALITY = "centrality",
  DISPERSION = "dispersion",
  SINGLE_PLOT_HEIGHT_PX = 600,
  MULTI_PLOT_HEIGHT_PX = 400,
  UNSELECTED_LINE_ALPHA = 0.3
)

# Changes from the original:
# - Transform/val now specified through columns on the dataset
# - Group filtering should be done through global filter
# TODO:
# - More pleasant facet strips?

# UI and server functions

#' @describeIn mod_lineplot UI
# NOTE: id documented in lineplot_server
#' @export
lineplot_UI <- function(id) {
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  # argument asserts ----

  # UI ----
  ns <- shiny::NS(id)

  table_heading <- shiny::uiOutput(outputId = ns(LP_ID$TITLE_RENDERUI))

  # Charts and tables ----

  chart <- shiny::uiOutput(outputId = ns(LP_ID$CHART_RENDERUI))

  tables <- shiny::tabsetPanel(
    id = ns(LP_ID$TAB_TABLES),
    shiny::tabPanel(
      LP_MSG$LABEL$SUBJECT_LISTING,
      shiny::br(),
      DT::DTOutput(ns(LP_ID$SUBJECT_LISTING))
    ),
    shiny::tabPanel(
      LP_MSG$LABEL$SUMMARY_LISTING,
      shiny::br(),
      DT::DTOutput(ns(LP_ID$SUMMARY_LISTING))
    ),
    shiny::tabPanel(
      LP_MSG$LABEL$COUNT_LISTING,
      shiny::br(),
      DT::DTOutput(ns(LP_ID$COUNT_LISTING))
    )
  )

  # main_ui ----

  main_ui <- shiny::tagList(fontawesome::fa_html_dependency(), table_heading, chart, tables)

  if (..__is_db()) {
    ..__db_UI(ns("debug"), main_ui, stacked = TRUE) # Debugging
  } else {
    main_ui
  }
}

# This function is a companion to lineplot chart
# It helps populate the LP_ID$LINE_HIGHLIGHT_MASK column with TRUE/FALSE depending on
# the grouping variables present in selected points
lp_selected_line_mask <- function(data, selected_points) {
  res <- FALSE
  grouping_vars <- intersect(c(CNT$SBJ, CNT$MAIN_GROUP, CNT$SUB_GROUP), names(selected_points))
  if (length(grouping_vars) > 0) {
    res <- !is.na(match(data.frame(t(data[grouping_vars])), data.frame(t(selected_points[grouping_vars]))))
  }
  res
}

# Pseudolog projection. Alternative to log projection that handles non-positive values.
# (see https://win-vector.com/2012/03/01/modeling-trick-the-signed-pseudo-logarithm/amp/)
#
# We could use `scales::pseudo_log_trans(base = 10)`, but its default breaks are bad and won't get fixed:
#  https://github.com/r-lib/scales/issues/219
# We could also take the object returned by that function and modify its `breaks` field, but the structure of ggtplot2
# transform objects is not documented and we can't assume it will remain stable.
# The ggplot2 manual (`?ggplot2::scale_y_continuous`) says transformations must be created through calls to
# `scales::trans_new` (ggplot2 >= 3.5.0) or `scales::new_transform` (ggplot2 >= 3.5.0).
lp_pseudo_log <- function(x, base = 10) asinh(x / 2) / log(base)
lp_inverse_pseudo_log <- function(x, base = 10) 2 * sinh(x * log(base))

lp_pseudo_log_projection <- function(base = 10) {
  breaks <- function(x) {
    res <- NULL
    if (all(x >= 0)) {
      res <- scales::log_breaks(base)(x)
    } else if (all(x <= 0)) {
      res <- -scales::log_breaks(base)(abs(x))
    } else {
      max_limit <- max(c(2, abs(x)))
      breaks <- scales::log_breaks(base)(c(1, max_limit))
      res <- unique(c(-breaks, 0, breaks))
    }
    return(res)
  }

  scales::trans_new(
    name = paste0("pseudolog-", format(base)),
    transform = lp_pseudo_log, inverse = lp_inverse_pseudo_log,
    breaks = breaks, domain = c(-Inf, Inf)
  )
}

lineplot_chart <- function(data, title = NULL, ref_line_data = NULL, log_projection = FALSE, alpha = 1) {
  trace_grp1 <- CNT$PAR
  if (CNT$MAIN_GROUP %in% names(data)) trace_grp1 <- CNT$MAIN_GROUP
  if (CNT$SBJ %in% names(data)) trace_grp1 <- CNT$SBJ

  trace_grp2 <- NULL
  if (CNT$SUB_GROUP %in% names(data)) trace_grp2 <- CNT$SUB_GROUP

  x_label <- get_lbl_robust(data, CNT$VIS)
  y_label <- get_lbl_robust(data, CNT$VAL)

  plot_aesthetic <- ggplot2::aes(
    x = .data[[CNT$VIS]], y = .data[[CNT$VAL]],
    group = .data[[trace_grp1]]
  )

  # Highlight whole lines containing any point tagged as "to highlight"
  # If no highlight column is provided, add one set to FALSE
  matching_rows <- data.frame()
  if (LP_ID$LINE_HIGHLIGHT_MASK %in% names(data)) {
    matching_rows <- data[data[[LP_ID$LINE_HIGHLIGHT_MASK]], ]
  }
  data[[LP_ID$LINE_HIGHLIGHT_MASK]] <- lp_selected_line_mask(data, matching_rows)

  if (CNT$MAIN_GROUP %in% names(data)) {
    plot_aesthetic <- utils::modifyList(
      plot_aesthetic,
      ggplot2::aes(
        color = .data[[CNT$MAIN_GROUP]]
      )
    )
  }

  if (CNT$SUB_GROUP %in% names(data)) {
    plot_aesthetic <- utils::modifyList(
      plot_aesthetic,
      ggplot2::aes(
        linetype = .data[[CNT$SUB_GROUP]]
      )
    )
  }

  if (!is.null(trace_grp2)) {
    plot_aesthetic <- utils::modifyList(
      plot_aesthetic,
      ggplot2::aes(
        group = interaction(.data[[trace_grp1]], .data[[trace_grp2]])
      )
    )
  }

  draw_whiskers <- LP_ID$MISC$WHISKER_BOTTOM %in% names(data)

  dodge_width <- 0
  if (draw_whiskers) {
    dodge_width <- LP_ID$MISC$DODGE_WIDTH
  }

  # in order to highlight selected lines, we _decrease_ the alpha of the rest
  alpha_selected <- alpha
  alpha_unselected <- LP_CNT$UNSELECTED_LINE_ALPHA * alpha
  if (!any(data[[LP_ID$LINE_HIGHLIGHT_MASK]])) alpha_unselected <- alpha

  fig <- ggplot2::ggplot(data = data, mapping = plot_aesthetic) +
    ggplot2::geom_line(
      size = 1.1, # more readable for stippled lines
      position = ggplot2::position_dodge(width = dodge_width)
    ) +
    ggplot2::geom_point(
      size = 3,
      position = ggplot2::position_dodge(width = dodge_width)
    ) +
    ggplot2::aes(alpha = .data[[LP_ID$LINE_HIGHLIGHT_MASK]]) +
    ggplot2::scale_alpha_manual(values = c(`TRUE` = alpha_selected, `FALSE` = alpha_unselected)) +
    ggplot2::xlab(x_label) +
    ggplot2::ylab(y_label) +
    ggplot2::labs(color = NULL, linetype = NULL) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, size = STYLE$PLOT_TITLE_SIZE),
      axis.title = ggplot2::element_text(size = STYLE$AXIS_TITLE_SIZE),
      axis.text.x = ggplot2::element_text(angle = 15, size = STYLE$AXIS_TEXT_SIZE, hjust = 1),
      axis.text.y = ggplot2::element_text(size = STYLE$AXIS_TEXT_SIZE),
      strip.text.x = ggplot2::element_text(size = STYLE$STRIP_TEXT_SIZE),
      strip.text.y = ggplot2::element_text(size = STYLE$STRIP_TEXT_SIZE)
    ) +
    ggplot2::guides(
      color = ggplot2::guide_legend(override.aes = list(alpha = 1)),
      alpha = "none" # Excludes LINE_HIGHLIGHT_MASK column from the legend, because posit grammars are very intuitive
    )

  # Ticks for continuous time variable
  if (is.numeric(data[[CNT$VIS]])) {
    fig <- fig + ggplot2::scale_x_continuous(
      breaks = unique(data[[CNT$VIS]]),
      minor_breaks = NULL,
      labels = unique(data[[CNT$VIS]])
    )
  } else {
    fig <- fig + ggplot2::scale_x_discrete(drop = FALSE)
  }

  # Error bars
  if (draw_whiskers) {
    errorbar_aesthetic <- ggplot2::aes(
      ymin = .data[[LP_ID$MISC$WHISKER_BOTTOM]],
      ymax = .data[[LP_ID$MISC$WHISKER_TOP]]
    )
    fig <- fig + ggplot2::geom_errorbar(
      mapping = errorbar_aesthetic,
      width = LP_ID$MISC$ERROR_BAR_WIDTH,
      position = ggplot2::position_dodge(width = dodge_width)
    )
  }

  # Reference lines
  if (!is.null(ref_line_data)) {
    ref_line_col_names <- names(ref_line_data)[names(ref_line_data) != CNT$PAR]
    ref_line_count <- length(ref_line_col_names)

    for (i in seq_len(ref_line_count)) {
      name <- ref_line_col_names[[i]]
      ref_line_data[[paste0(name, "_label")]] <- get_lbl_robust(ref_line_data, name)
    }

    # NOTE: Otherwise ggplot complains about missing groups for the aesthetic
    if (CNT$MAIN_GROUP %in% names(data)) ref_line_data[[CNT$MAIN_GROUP]] <- ""
    if (CNT$SUB_GROUP %in% names(data)) ref_line_data[[CNT$SUB_GROUP]] <- ""

    ref_line_data[[CNT$SBJ]] <- ""

    for (i in seq_len(ref_line_count)) {
      data_col <- ref_line_col_names[[i]]
      name_col <- paste0(data_col, "_label")
      # by making linetype depend on the column name and including it into the aesthetic,
      # we get the legend for free
      fig <- fig + ggplot2::geom_hline(
        data = ref_line_data,
        ggplot2::aes(
          yintercept = .data[[data_col]],
          linetype = .data[[name_col]]
        )
      )
    }
  }

  fig <- fig + ggplot2::ggtitle(title)

  # Facetting
  fig <- fig + ggplot2::facet_grid(
    rows = ggplot2::vars(.data[[CNT$PAR]]),
    scales = "free_y"
  )

  # Optional log projection
  if (isTRUE(log_projection)) {
    # we use the deprecated `trans` argument instead of `transform`
    # because the latter is only supported in ggplot2 >= 3.5.0
    fig <- fig + ggplot2::scale_y_continuous(trans = lp_pseudo_log_projection(base = 10))
  }

  fig
}

lp_listings_table <- function(df, selection, target_subject_input_id = NULL) {
  checkmate::assert_data_frame(selection, min.rows = 1)
  checkmate::check_subset(c(CNT$PAR, CNT$VIS), names(selection))

  columns_to_remove <- c(CNT$VAL, setdiff(names(selection), names(df)))
  selection <- selection[setdiff(names(selection), columns_to_remove)]

  result <- dplyr::left_join(selection, df, by = names(selection))

  visit_order <- order(result[[CNT$VIS]])
  result <- result[visit_order, ]

  labels <- get_lbls_robust(df)
  labels <- stats::setNames(make.unique(unlist(labels)), names(labels))
  labels[labels == ""] <- ".0" # make.unique will miss empty labels, so we special-case them
  result <- rename_with_list(result, labels)

  if (!is.null(target_subject_input_id) && CNT$SBJ %in% names(selection)) {
    subject_ids <- selection[[CNT$SBJ]]

    col <- "Details"
    result[[col]] <- ""
    for (i in seq_len(nrow(result))) {
      subject_id <- subject_ids[[i]]
      result[col][i, ] <- as.character(shiny::tags[["button"]](
        class = "",
        shiny::icon("address-card"),
        onclick = sprintf(
          "Shiny.setInputValue('%s', '%s', {priority:'event'});",
          target_subject_input_id, subject_id
        )
      ))
    }
  }

  result
}

lp_summary_listing <- function(selection) {
  target_cols <- c(
    CNT$VIS, CNT$MAIN_GROUP, CNT$SUB_GROUP, CNT$CAT, CNT$PAR, CNT$VAL,
    LP_ID$MISC$WHISKER_BOTTOM, LP_ID$MISC$WHISKER_TOP
  )

  present_cols <- names(selection)
  table_cols <- intersect(target_cols, present_cols)

  result <- selection[table_cols]

  result
}

lp_count_table <- function(df) {
  group_cols <- setdiff(names(df), c(CNT$SBJ, CNT$VAL))
  df <- dplyr::group_by(df, dplyr::across(dplyr::all_of(group_cols))) |> dplyr::count(name = "n")
  df <- tidyr::pivot_wider(df, names_from = CNT$VIS, values_from = "n", values_fill = 0)
  df <- dplyr::ungroup(df)

  labels <- get_lbls_robust(df)
  labels <- stats::setNames(make.unique(unlist(labels)), names(labels))
  labels[labels == ""] <- ".0"
  df <- rename_with_list(df, labels)
  df
}

# Light wrapper around bp_subset_data that allows for visit to be a numerical variable
lp_subset_data <- function(cat, cat_col, par, par_col, val_col,
                           vis, vis_col, group_vect, bm_ds, group_ds, subj_col) {
  numerical_visit <- is.numeric(bm_ds[[vis_col]])
  if (numerical_visit) {
    attrs <- attributes(bm_ds[[vis_col]])
    bm_ds[[vis_col]] <- as.factor(bm_ds[[vis_col]])
  }
  res <- bp_subset_data(
    cat, cat_col, par, par_col, val_col,
    vis, vis_col, group_vect, bm_ds, group_ds, subj_col
  )
  if (numerical_visit) {
    res[[CNT$VIS]] <- as.numeric(as.character(res[[CNT$VIS]]))
    attributes(res[[CNT$VIS]]) <- attrs
  }
  return(res)
}

lp_ci <- function(x) {
  result <- NA
  ci_level <- 0.95
  if (dplyr::n() > 1) {
    se <- stats::sd(x, na.rm = TRUE) / sqrt(dplyr::n())
    multiplier <- stats::qt(ci_level / 2 + .5, dplyr::n() - 1)
    result <- se * multiplier
  }
  result
}

#' Default lineplot summary functions
#'
#' @name default_lineplot_functions
#'
NULL

#' @describeIn default_lineplot_functions Default mean functions
#' @export
lp_mean_summary_functions <- list(
  `function` = function(x) base::mean(x, na.rm = TRUE),
  `dispersion` = list(
    # `No error bar` implicit
    `Standard deviation` = list(
      top = function(x) base::mean(x, na.rm = TRUE) + stats::sd(x, na.rm = TRUE),
      bottom = function(x) base::mean(x, na.rm = TRUE) - stats::sd(x, na.rm = TRUE)
    ),
    `Standard error` = list(
      top = function(x) base::mean(x, na.rm = TRUE) + stats::sd(x, na.rm = TRUE) / sqrt(dplyr::n()),
      bottom = function(x) base::mean(x, na.rm = TRUE) - stats::sd(x, na.rm = TRUE) / sqrt(dplyr::n())
    ),
    `CI 0.95` = list(
      top = function(x) base::mean(x, na.rm = TRUE) + lp_ci(x),
      bottom = function(x) base::mean(x, na.rm = TRUE) - lp_ci(x)
    )
  ),
  `y_prefix` = "Mean "
)

lp_quantile_type <- 2 # From original EBAS # TODO: Figure out if this is a user requirement
#' @describeIn default_lineplot_functions Default median functions
#' @export
lp_median_summary_functions <- list(
  `function` = function(x) stats::median(x, na.rm = TRUE),
  `dispersion` = list(
    # `No error bar` implicit
    `Quartile` = list(
      top = function(x) stats::quantile(x, 0.75, type = lp_quantile_type, na.rm = TRUE),
      bottom = function(x) stats::quantile(x, 0.25, type = lp_quantile_type, na.rm = TRUE)
    ),
    `Median absolute deviation` = list(
      top = function(x) stats::median(x, na.rm = TRUE) + stats::mad(x, na.rm = TRUE),
      bottom = function(x) stats::median(x, na.rm = TRUE) - stats::mad(x, na.rm = TRUE)
    )
  ),
  `y_prefix` = "Median "
)


#' @describeIn mod_lineplot Server
#'
#' @param id Shiny ID `[character(1)]`
#'
#' @param bm_dataset `[data.frame()]`
#'
#' An ADBM-like dataset similar in structure to the one in
#' [this example](https://www.cdisc.org/kb/examples/adam-basic-data-structure-bds-using-paramcd-80288192),
#' with one record per subject per parameter per analysis visit.
#'
#' It should have, at least, the columns specified by the parameters `subjid_var`, `cat_var`,
#' `par_var`, `visit_vars` and `value_vars`.
#' The semantics of these columns are as described in the CDISC standard for variables
#' USUBJID, PARCAT, PARAM, AVISIT and AVAL, respectively.
#'
#' Optional columns specified by `ref_line_vars` should contain the same numeric value for all
#' records of the same parameter.
#'
#' @param group_dataset `[data.frame()]`
#'
#' An ADSL-like dataset similar in structure to the one in
#' [this example](https://www.cdisc.org/kb/examples/adam-subject-level-analysis-adsl-dataset-80283806),
#' with one record per subject.
#'
#' It should contain, at least, the column specified by the parameter `subjid_var`.
#'
#' @param summary_functions `[list()]`
#'
#' TODO:
#'
#' @param dataset_name `[shiny::reactive(*)]`
#'
#' A reactive that indicates a possible change in the column structure of any of the two datasets
#'
#' @param cat_var,par_var,visit_vars `[character(1)]`
#'
#' Columns from `bm_dataset` that correspond to the parameter category, parameter and visit
#'
#' @param value_vars `[character(n)]`
#'
#' Columns from `bm_dataset` that correspond to values of the parameters
#'
#' @param additional_listing_vars `[character(n)]`
#'
#' Columns from `bm_dataset` that will be appended to the single-subject listing
#'
#' @param subjid_var `[character(1)]`
#'
#' Column corresponding to the subject ID
#'
#' @param ref_line_vars `[character(n)]`
#'
#' Columns for `bm_dataset` specifying reference values for parameters
#'
#' @param on_sbj_click `[function()]`
#'
#' Function to invoke when a subject is clicked in the single-subject listing
#'
#' @param default_cat,default_par,default_visit_var,default_visit_val,default_main_group `[character(1)|NULL]`
#'
#' Default values for the selectors
#'
#' @param default_sub_group,default_val,default_centrality_function,default_dispersion_function `[character(1)|NULL]`
#'
#' Default values for the selectors
#'
#' @export
#'
lineplot_server <- function(id,
                            bm_dataset,
                            group_dataset,
                            dataset_name = shiny::reactive(character(0)),
                            summary_functions = list(
                              `Mean` = lp_mean_summary_functions,
                              `Median` = lp_median_summary_functions
                            ),
                            subjid_var = "SUBJID",
                            cat_var = "PARCAT",
                            par_var = "PARAM",
                            visit_vars = c("AVISIT"),
                            value_vars = c("AVAL", "PCHG"),
                            additional_listing_vars = character(0),
                            ref_line_vars = character(0),
                            on_sbj_click = NULL,
                            default_centrality_function = NULL,
                            default_dispersion_function = NULL,
                            default_cat = NULL,
                            default_par = NULL,
                            default_val = NULL,
                            default_visit_var = NULL,
                            default_visit_val = NULL,
                            default_main_group = NULL,
                            default_sub_group = NULL,
                            default_transparency = 1.,
                            default_y_axis_projection = 'Linear') {
  ac <- checkmate::makeAssertCollection()
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1, add = ac)
  # non reactive asserts
  checkmate::assert_string(cat_var, min.chars = 1, add = ac)
  checkmate::assert_string(par_var, min.chars = 1, add = ac)
  checkmate::assert_character(
    value_vars,
    min.chars = 1, any.missing = FALSE,
    all.missing = FALSE, unique = TRUE, min.len = 1, add = ac
  )
  checkmate::assert_character(visit_vars, min.chars = 1, min.len = 1, add = ac)
  checkmate::assert_character(additional_listing_vars, min.chars = 1, add = ac)
  checkmate::assert_string(default_centrality_function, min.chars = 1, add = ac, null.ok = TRUE)
  checkmate::assert_string(default_dispersion_function, min.chars = 1, add = ac, null.ok = TRUE)
  checkmate::assert_character(default_cat, min.chars = 1, add = ac, null.ok = TRUE)
  checkmate::assert_character(default_par, min.chars = 1, add = ac, null.ok = TRUE)
  checkmate::assert_string(default_visit_var, min.chars = 1, add = ac, null.ok = TRUE)
  checkmate::assert(
    checkmate::check_character(default_visit_val, min.chars = 1, null.ok = TRUE),
    checkmate::check_numeric(default_visit_val, null.ok = TRUE),
    add = ac
  )
  checkmate::assert_string(default_main_group, min.chars = 1, add = ac, null.ok = TRUE)
  checkmate::assert_string(default_sub_group, min.chars = 1, add = ac, null.ok = TRUE)
  checkmate::assert_string(subjid_var, min.chars = 1, add = ac)

  checkmate::reportAssertions(ac)

  # module constants ----
  VAR <- poc( # Parameters from the function that will be considered constant across the function
    CAT = cat_var,
    PAR = par_var,
    VAL = value_vars,
    VIS = visit_vars,
    SBJ = subjid_var
  )


  module <- function(input, output, session) {
    # sessions ----
    ns <- session[["ns"]]

    # argument asserts ----

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
        df <- bm_dataset()
        ac <- checkmate::makeAssertCollection()
        checkmate::assert_data_frame(df, min.rows = 1, .var.name = ns("bm_dataset"), add = ac)
        checkmate::assert_names(
          names(df),
          type = "unique",
          must.include = c(
            VAR$CAT, VAR$PAR, VAR$SBJ, VAR$VIS, VAR$VAL, ref_line_vars
          ),
          .var.name = ns("bm_dataset"),
          add = ac
        )
        unique_par_names <- df |>
          dplyr::distinct(dplyr::across(c(VAR$CAT, VAR$PAR))) |>
          dplyr::group_by(dplyr::across(c(VAR$PAR))) |>
          dplyr::tally() |>
          dplyr::pull(.data[["n"]]) |>
          max()

        unique_par_names <- unique_par_names == 1
        checkmate::assert_true(unique_par_names, .var.name = ns("bm_dataset"), add = ac)
        checkmate::assert_factor(df[[VAR$SBJ]], .var.name = ns("subject column"), add = ac)
        unique_ref_values <- local({
          res <- TRUE
          if (is.data.frame(df) && all(ref_line_vars %in% names(df))) {
            res <- nrow(unique(df[c(VAR$CAT, VAR$PAR, ref_line_vars)])) ==
              nrow(unique(df[c(VAR$CAT, VAR$PAR)]))
          }
          res
        })
        # TODO: descriptive error message
        checkmate::assert_true(unique_ref_values, .var.name = ns("bm_dataset"), add = ac)
        checkmate::reportAssertions(ac)
        df
      },
      label = ns("v_bm_dataset")
    )

    input_lp <- list()
    input_lp[[LP_ID$PAR]] <- parameter_server(
      id = LP_ID$PAR,
      data = v_bm_dataset,
      cat_var = VAR$CAT,
      par_var = VAR$PAR,
      default_cat = default_cat,
      default_par = default_par,
      multi_cat = TRUE,
      multi_par = TRUE
    )
    input_lp[[LP_ID$PAR_VALUE_TRANSFORM]] <- col_menu_server(
      id = LP_ID$PAR_VALUE_TRANSFORM,
      data = v_bm_dataset,
      label = LP_MSG$LABEL$PAR_VALUE_TRANSFORM,
      include_func = function(val, name) {
        name %in% VAR$VAL
      },
      include_none = FALSE,
      default = default_val
    )
    input_lp[[LP_ID$PAR_VISIT_COL]] <- col_menu_server(
      id = LP_ID$PAR_VISIT_COL,
      data = v_bm_dataset,
      label = LP_MSG$LABEL$PAR_VISIT_COL,
      include_func = function(val, name) {
        name %in% VAR$VIS
      },
      include_none = FALSE,
      default = default_visit_var
    )
    input_lp[[LP_ID$PAR_VISIT]] <- val_menu_server(
      id = LP_ID$PAR_VISIT,
      label = LP_MSG$LABEL$PAR_VISIT,
      data = v_bm_dataset,
      var = input_lp[[LP_ID$PAR_VISIT_COL]],
      default = default_visit_val,
      multiple = TRUE,
      all_on_change = FALSE
    )
    input_lp[[LP_ID$MAIN_GRP]] <- col_menu_server(
      id = LP_ID$MAIN_GRP,
      data = v_group_dataset,
      label = "Select a grouping variable",
      include_func = function(x) {
        is.factor(x) || is.character(x)
      },
      default = default_main_group
    )
    input_lp[[LP_ID$SUB_GRP]] <- col_menu_server(
      id = LP_ID$SUB_GRP,
      data = v_group_dataset,
      label = "Select a sub grouping variable",
      include_func = function(x) {
        is.factor(x) || is.character(x)
      },
      default = default_sub_group
    )

    # input validation ----
    v_input_subset <- shiny::reactive(
      {
        # Maybe TODO(miguel): this validate(need(...)) prints an "Error:" message on the console
        #                     when the selection is invalid. It's annoying and it would be nice
        #                     to get rid of it
        shiny::validate(
          shiny::need(
            param_iv$is_valid() && visit_iv$is_valid() && group_iv$is_valid(),
            "Selection cannot produce an output. Please, review menu feedback."
          )
        )
        input_lp
      },
      label = ns("input_lp")
    )

    # data reactives ----

    data_subset <- shiny::reactive({
      l_input_lp <- v_input_subset()

      group_vect <- c()
      group_vect[[CNT$MAIN_GROUP]] <- l_input_lp[[LP_ID$MAIN_GRP]]()
      group_vect[[CNT$SUB_GROUP]] <- l_input_lp[[LP_ID$SUB_GRP]]()

      group_vect <- drop_nones(unlist(group_vect))

      lp_subset_data(
        cat = l_input_lp[[LP_ID$PAR]][["cat"]](),
        par = l_input_lp[[LP_ID$PAR]][["par"]](),
        val_col = l_input_lp[[LP_ID$PAR_VALUE_TRANSFORM]](),
        vis = l_input_lp[[LP_ID$PAR_VISIT]](),
        group_vect = group_vect,
        bm_ds = v_bm_dataset(),
        group_ds = v_group_dataset(),
        subj_col = VAR$SBJ,
        cat_col = VAR$CAT,
        par_col = VAR$PAR,
        vis_col = shiny::reactive({
          col <- l_input_lp[[LP_ID$PAR_VISIT_COL]]()
          shiny::req(col)
          col
        })()
      )
    })

    plot_data <- shiny::reactive({
      ds <- data_subset()
      y_label <- get_lbl_robust(ds, CNT$VAL)

      y_label_prefix <- ""

      grp_1 <- CNT$MAIN_GROUP
      if (!(grp_1 %in% names(ds))) grp_1 <- NULL
      grp_2 <- CNT$SUB_GROUP
      if (!(grp_2 %in% names(ds))) grp_2 <- NULL

      r_centrality <- centrality()
      r_dispersion <- dispersion()
      shiny::req(r_centrality)
      shiny::req(r_dispersion)
      if (r_centrality == LP_CNT$PLOT_TYPE_SUBJECT_LEVEL) {
        NULL
      } else {
        functions <- list(center = summary_functions[[r_centrality]][["function"]])
        if (r_dispersion != "None") {
          disp_f <- summary_functions[[r_centrality]][["dispersion"]][[r_dispersion]]
          functions[[LP_ID$MISC$WHISKER_TOP]] <- disp_f[["top"]]
          functions[[LP_ID$MISC$WHISKER_BOTTOM]] <- disp_f[["bottom"]]
        }

        ds <- dplyr::group_by(ds, dplyr::across(c(CNT$VIS, grp_1, grp_2, CNT$PAR)))
        ds <- dplyr::summarize(ds, dplyr::across(CNT$VAL, functions, .names = "{.fn}"), na.rm = TRUE)
        if ("center" %in% names(ds)) {
          names(ds)[names(ds) == "center"] <- CNT$VAL
        }

        try(
          {
            attr(ds[[LP_ID$MISC$WHISKER_BOTTOM]], "label") <- paste(r_dispersion, "lower limit")
            attr(ds[[LP_ID$MISC$WHISKER_TOP]], "label") <- paste(r_dispersion, "upper limit")
          },
          silent = TRUE
        )

        y_label_prefix <- summary_functions[[r_centrality]][["y_prefix"]]
      }

      ds <- set_lbl(ds, CNT$VAL, paste0(y_label_prefix, y_label))

      ds
    })

    ref_line_data <- shiny::reactive({
      res <- NULL
      if (length(ref_line_vars)) {
        res <- unique(bm_dataset()[c(VAR$PAR, ref_line_vars)])
        params <- v_input_subset()[[LP_ID$PAR]][["par"]]()
        res <- res[res[[VAR$PAR]] %in% params, ]
        names(res)[names(res) == VAR$PAR] <- CNT$PAR
      }
      res
    })

    plot_height <- shiny::reactive({
      params <- v_input_subset()[[LP_ID$PAR]][["par"]]()
      param_count <- length(params)
      plot_height_ <- if (param_count == 1) LP_CNT$SINGLE_PLOT_HEIGHT_PX else LP_CNT$MULTI_PLOT_HEIGHT_PX
      res <- max(100, param_count * plot_height_)
    })

    output[[LP_ID$CHART_RENDERUI]] <- shiny::renderUI({
      plot <- shiny::plotOutput(
        outputId = ns(LP_ID$CHART),
        click = ns(LP_ID$CHART_CLICK),
        brush = ns(LP_ID$CHART_BRUSH),
        height = paste0(plot_height(), "px")
      )

      # TODO(miguel): Candidate for shared util? Give visibility to this recurrent problem
      fix_brush_position_under_mm <- function(elem) {
        shiny::div(style = "position:relative", shiny::div(elem))
      }

      fix_brush_position_under_mm(plot)
    })

    # Clear brush when switching Y-axis projection
    shiny::observe({
      shiny::req(input[[LP_ID$TWEAK_Y_AXIS_PROJECTION]])
      brush <- shiny::isolate(input[[LP_ID$CHART_BRUSH]])
      shiny::req(brush)
      session$resetBrush(brush[["brushId"]])
    })

    compute_group_text <- function(df, main_group, sub_group) {
      groups <- c(main_group, sub_group) |>
        setdiff("None") |>
        unique()
      group_names <- get_lbls_robust(df[groups])
      res <- NULL
      if (length(group_names)) res <- paste(group_names, collapse = " and ")
      res
    }

    output[[LP_ID$CHART]] <- shiny::renderPlot({
      ds <- plot_data()
      ref_line_data <- ref_line_data()
      alpha <- input[[LP_ID$TWEAK_TRANSPARENCY]]
      selected_points <- last_selection()[["points"]]
      if (
        !setequal(names(ds), names(selected_points)) ||
          !identical(last_selection()[["visit_col"]], input_lp[[LP_ID$PAR_VISIT_COL]]())
      ) {
        selected_points <- data.frame() # selection was made based on different, incompatible plot data
      }

      ds[[LP_ID$LINE_HIGHLIGHT_MASK]] <- lp_selected_line_mask(ds, selected_points)

      should_log_project <- identical(input[[LP_ID$TWEAK_Y_AXIS_PROJECTION]], "Logarithmic")

      plot <- shiny::maskReactiveContext(
        lineplot_chart(
          data = ds,
          title = NULL,
          ref_line_data = ref_line_data,
          log_projection = should_log_project,
          alpha = alpha
        )
      )
      plot
    })

    # reactiveVal instead of reactive because selection depends on plot and plot on selection
    # we break the reactive cycle here
    last_selection <- shiny::reactiveVal(list(points = data.frame(), visit_col = NULL))
    shiny::observe({
      click <- input[[LP_ID$CHART_CLICK]]
      brush <- input[[LP_ID$CHART_BRUSH]]

      should_log_project <- identical(shiny::isolate(input[[LP_ID$TWEAK_Y_AXIS_PROJECTION]]), "Logarithmic")

      # order matters because brush implies click
      points <- data.frame()
      df <- shiny::isolate(plot_data())
      if (!is.null(brush)) {
        points <- get_selected_points(df, "brush", brush, should_log_project)
      } else if (!is.null(click)) {
        points <- get_selected_points(df, "click", click, should_log_project)
      }

      visit_col <- input_lp[[LP_ID$PAR_VISIT_COL]]()

      if (nrow(points)) {
        last_selection(list(points = points, visit_col = visit_col))
      } else if (!is.null(click)) {
        # empty selection after a brush/click clears selection
        last_selection(list(points = data.frame(), visit_col = NULL))
      }
    })

    get_selected_points <- function(df, interaction_type, interaction_data, should_log_project) {
      checkmate::assert_subset(interaction_type, c("click", "brush"))

      xvar <- CNT$VIS
      parameter <- interaction_data[["panelvar1"]]

      df <- local({ # filter out unrelated records
        indices <- df[[CNT$PAR]] == parameter
        shiny::req(any(indices)) # User may have removed plot last_selection refers to
        df[indices, ]
      })

      should_dodge <- LP_ID$MISC$WHISKER_BOTTOM %in% names(df)
      if (should_dodge) {
        # To make the graph readable when whiskers are present, we dodge the position of points in the x axis.
        # But shiny::nearPoints doesn't know how to deal with dodged points when every visit has a potentially
        # different amount of categories in it, because the dodge distance stops being constant across visits.
        # Here we give nearPoints a hand by adding a "dodged_x" column to the data frame.

        interaction_data[["domain"]][["discrete_limits"]] <- NULL # interpret as numeric instead of factor
        # How to interpret DODGE_WIDTH:
        # https://stackoverflow.com/questions/34889766/what-is-the-width-argument-in-position-dodge

        df_has_main_group <- CNT$MAIN_GROUP %in% names(df)
        df_has_sub_group <- CNT$SUB_GROUP %in% names(df)

        if (!df_has_main_group) df[[CNT$MAIN_GROUP]] <- 1.
        if (!df_has_sub_group) df[[CNT$SUB_GROUP]] <- 1.

        # add extra column with dodged coordinates to use inside nearPoints -- hack territory
        df[["dodged_x"]] <- 0.

        # Unique instead of levels to avoid visit levels with no rows
        for (visit in unique(df[[CNT$VIS]])) {
          visit_indices <- df[[CNT$VIS]] == visit
          subset <- df[visit_indices, ]
          total_group_count <- max(nrow(subset), 1)
          # The `max(..., 1)` on the line above guards against the edge case of `subset` having zero rows.
          # Logic preciding this loop makes that possibility unlikely but it doesn't prevent it completely.
          # By enforcing a minimum `total_group_count` of at least one, we make sure `offsets` will take
          # finite values.
          first_offset <- -LP_ID$MISC$DODGE_WIDTH / 2 + (LP_ID$MISC$DODGE_WIDTH / total_group_count) / 2
          last_offset <- abs(first_offset)
          offsets <- seq(from = first_offset, to = last_offset, length.out = total_group_count)

          plot_order <- order(subset[[CNT$SUB_GROUP]])
          subset[plot_order, ][["dodged_x"]] <- as.numeric(subset[plot_order, ][[xvar]]) + offsets

          df[visit_indices, ][["dodged_x"]] <- subset[["dodged_x"]]
        }

        if (!df_has_main_group) df[CNT$MAIN_GROUP] <- list(NULL)
        if (!df_has_sub_group) df[CNT$SUB_GROUP] <- list(NULL)

        xvar <- "dodged_x"
      }

      y_var <- CNT$VAL
      log_projection_col_name <- character(0)
      if (should_log_project) {
        log_projection_col_name <- "_pseudolog_projection"
        df[[log_projection_col_name]] <- lp_pseudo_log(df[[y_var]])
        y_var <- log_projection_col_name
      }

      if (interaction_type == "click") {
        points <- shiny::nearPoints(df = df, coordinfo = interaction_data, xvar = xvar, yvar = y_var)
      } else {
        stopifnot(interaction_type == "brush")
        points <- shiny::brushedPoints(df = df, brush = interaction_data, xvar = xvar, yvar = y_var)
      }

      if (should_log_project) {
        points <- drop_columns_by_name(points, log_projection_col_name)
      }

      points
    }

    append_extra_vars_to_listing <- function(df, bm_dataset, visit_var) {
      common_vars_orig <- c(VAR$SBJ, VAR$CAT, VAR$PAR, visit_var)
      bm_dataset <- bm_dataset[, c(common_vars_orig, additional_listing_vars)]

      common_vars_internal_names <- c("subject_id", "category", "parameter", "visit")
      rename_list <- stats::setNames(common_vars_internal_names, common_vars_orig)
      bm_dataset <- rename_with_list(bm_dataset, rename_list)
      res <- dplyr::left_join(df, bm_dataset, by = common_vars_internal_names)
      # recover labels dropped by dplyr
      for (col in common_vars_internal_names) attr(res[[col]], "label") <- attr(bm_dataset[[col]], "label")
      return(res)
    }

    # Interactive title selector interface ----
    title_ui <- local({
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
        ns(LP_ID$PAR_BUTTON), LP_MSG$LABEL$PAR_BUTTON,
        parameter_UI(id = ns(LP_ID$PAR)),
        col_menu_UI(ns(LP_ID$PAR_VALUE_TRANSFORM))
      )

      visit_menu <- drop_menu_helper(
        ns(LP_ID$VIS_BUTTON), LP_MSG$LABEL$VIS_BUTTON,
        col_menu_UI(ns(LP_ID$PAR_VISIT_COL)),
        val_menu_UI(ns(LP_ID$PAR_VISIT))
      )

      group_menu <- drop_menu_helper(
        ns(LP_ID$GRP_BUTTON), LP_MSG$LABEL$GRP_BUTTON,
        col_menu_UI(id = ns(LP_ID$MAIN_GRP)),
        col_menu_UI(id = ns(LP_ID$SUB_GRP))
      )

      plot_kind_menu <- drop_menu_helper(
        ns(LP_ID$PLOT_BUTTON), LP_MSG$LABEL$PLOT_BUTTON,
        parameter_UI(
          id = ns(LP_ID$PLOT_CENTRALITY_AND_DISPERSION)
        )
      )

      tweaks_menu <- drop_menu_helper(
        ns(LP_ID$TWEAKS_BUTTON),
        shiny::icon("cog"),
        shiny::sliderInput(
          inputId = ns(LP_ID$TWEAK_TRANSPARENCY),
          label = LP_MSG$LABEL$TWEAK_TRANSPARENCY,
          min = 0,
          max = 1,
          value = default_transparency,
          step = 0.05,
          ticks = FALSE
        ),
        shiny::radioButtons(
          ns(LP_ID$TWEAK_Y_AXIS_PROJECTION),
          "Y-axis projection",
          choices = c("Linear", "Logarithmic"),
          selected = default_y_axis_projection,
          inline = TRUE
        )
      )

      title_ui <- it_interactive_title(
        "Line plot of ",
        plot_kind_menu,
        parameter_menu,
        "on visit",
        visit_menu,
        "grouped by",
        group_menu,
        shiny::HTML("&emsp;\u2014&emsp;"),
        tweaks_menu # TODO: Move outside of interactive title and under settings cog dropdown
      )
      title_ui
    })

    centrality_dispersion <- local({
      summary_function_df <- local({
        res <- data.frame(Centrality = LP_CNT$PLOT_TYPE_SUBJECT_LEVEL, Dispersion = "None")
        for (i_f in seq_along(summary_functions)) {
          sum_name <- names(summary_functions)[[i_f]]
          dispersion_functions <- summary_functions[[i_f]][["dispersion"]]
          res <- rbind(res, c(sum_name, "None")) # None
          for (j_f in seq_along(dispersion_functions)) {
            disp_name <- names(dispersion_functions)[[j_f]]
            res <- rbind(res, c(sum_name, disp_name))
          }
        }

        res[["Centrality"]] <- factor(res[["Centrality"]], levels = unique(res[["Centrality"]]))
        res[["Dispersion"]] <- factor(res[["Dispersion"]], levels = unique(res[["Dispersion"]]))
        res
      })

      parameter_server(
        id = LP_ID$PLOT_CENTRALITY_AND_DISPERSION,
        data = shiny::reactive(summary_function_df),
        cat_var = "Centrality",
        par_var = "Dispersion",
        cat_label = "Centrality",
        par_label = "Dispersion",
        multi_cat = FALSE,
        multi_par = FALSE,
        default_cat = default_centrality_function,
        default_par = default_dispersion_function
      )
    })
    centrality <- centrality_dispersion[["cat"]]
    dispersion <- centrality_dispersion[["par"]]

    output[[LP_ID$TITLE_RENDERUI]] <- shiny::renderUI({
      title_ui
    })
    shiny::outputOptions(output, LP_ID$TITLE_RENDERUI, suspendWhenHidden = FALSE)

    # Input validators and button renaming ----
    # Plot type
    it_relabel_button(
      id = LP_ID$PLOT_BUTTON,
      is_valid = shiny::reactive(test_not_empty(centrality())),
      label_if_valid = shiny::reactive(centrality())
    )

    # Reactivity must be solved inside otherwise the function does not depend on the value
    sv_not_empty <- function(input, ..., msg) {
      function(x) {
        if (test_not_empty(input())) NULL else msg
      }
    }

    # Parameters
    param_iv <- shinyvalidate::InputValidator$new()
    param_iv$add_rule(
      get_id(
        input_lp[[LP_ID$PAR]]
      )[["cat"]],
      sv_not_empty(input_lp[[LP_ID$PAR]][["cat"]],
        msg = "Select at least one category"
      )
    )
    param_iv$add_rule(
      get_id(
        input_lp[[LP_ID$PAR]]
      )[["par"]],
      sv_not_empty(input_lp[[LP_ID$PAR]][["par"]],
        msg = "Select at least one parameter"
      )
    )
    param_iv$add_rule(
      get_id(
        input_lp[[LP_ID$PAR_VALUE_TRANSFORM]]
      ),
      sv_not_empty(input_lp[[LP_ID$PAR_VALUE_TRANSFORM]],
        msg = "Select one value transform"
      )
    )
    param_iv$enable()

    it_relabel_button(
      id = LP_ID$PAR_BUTTON,
      is_valid = shiny::reactive({
        param_iv$is_valid()
      }),
      label_if_valid = shiny::reactive({
        val_col <- get_lbl_robust(v_bm_dataset(), input_lp[[LP_ID$PAR_VALUE_TRANSFORM]]())
        params <- it_selection_to_label(input_lp[[LP_ID$PAR]][["par"]]())
        paste(val_col, "of", params)
      }),
      label_if_not_valid = shiny::reactive({
        "[select parameters]"
      })
    )

    # Visits
    visit_iv <- shinyvalidate::InputValidator$new()
    visit_iv$add_rule(
      get_id(input_lp[[LP_ID$PAR_VISIT_COL]]),
      sv_not_empty(input_lp[[LP_ID$PAR_VISIT_COL]],
        msg = "Select a visit variable"
      )
    )
    visit_iv$add_rule(
      get_id(input_lp[[LP_ID$PAR_VISIT]]),
      sv_not_empty(input_lp[[LP_ID$PAR_VISIT]],
        msg = "Select at least one visit value"
      )
    )
    visit_iv$enable()

    it_relabel_button(
      id = LP_ID$VIS_BUTTON,
      is_valid = shiny::reactive({
        visit_iv$is_valid()
      }),
      label_if_valid = shiny::reactive({
        it_selection_to_label(input_lp[[LP_ID$PAR_VISIT]]())
      }),
      label_if_not_valid = shiny::reactive({
        "[select visits]"
      })
    )

    # Grouping
    group_iv <- shinyvalidate::InputValidator$new()
    group_iv$add_rule(
      get_id(input_lp[[LP_ID$MAIN_GRP]]),
      sv_not_empty(input_lp[[LP_ID$MAIN_GRP]],
        msg = "Select a group"
      )
    )
    group_iv$add_rule(
      get_id(input_lp[[LP_ID$SUB_GRP]]),
      sv_not_empty(input_lp[[LP_ID$SUB_GRP]],
        msg = "Select a sub group"
      )
    )
    group_iv$enable()

    it_relabel_button(
      id = LP_ID$GRP_BUTTON,
      is_valid = shiny::reactive({
        group_iv$is_valid()
      }),
      label_if_valid = shiny::reactive({
        res <- "None"
        group_text <- compute_group_text(
          group_dataset(), input_lp[[LP_ID$MAIN_GRP]](), input_lp[[LP_ID$SUB_GRP]]()
        )
        if (!is.null(group_text)) res <- group_text
        res
      }),
      label_if_not_valid = shiny::reactive({
        "[select grouping]"
      })
    )

    format_table_title <- function(title) {
      htmltools::tags$caption(
        style = sprintf("caption-side: top; text-align: center; font-size:%spx;", STYLE$PLOT_TITLE_SIZE),
        title
      )
    }

    placeholder_table <- function(title, message) {
      res <- DT::datatable(
        data.frame(a = message),
        caption = format_table_title(title),
        colnames = c(""), selection = "none", rownames = FALSE, escape = FALSE,
        options = list(
          dom = "t", ordering = FALSE, processing = FALSE,
          columnDefs = list(
            list(targets = c(0), class = "dt-center")
          )
        )
      )
      return(res)
    }

    # listings table ----
    subject_listing_contents <- shiny::reactive({
      if (!identical(last_selection()[["visit_col"]], input_lp[[LP_ID$PAR_VISIT_COL]]())) {
        return(NULL)
      }

      points <- last_selection()[["points"]]

      target_subject_input_id <- NULL
      if (!is.null(on_sbj_click)) target_subject_input_id <- ns(LP_ID$SELECTED_SUBJECT)

      result <- NULL
      if ((nrow(points) > 0)) {
        df <- data_subset()

        centrality <- centrality()
        shiny::req(centrality)
        if (centrality == LP_CNT$PLOT_TYPE_SUBJECT_LEVEL) {
          # NOTE(miguel): If we decide to generalize this feature to other modules, the natural
          # place for the appending of columns would be lp_subset_data when no grouping is active
          bm_df <- v_bm_dataset()
          visit_var <- input_lp[[LP_ID$PAR_VISIT_COL]]()
          df <- shiny::maskReactiveContext(
            append_extra_vars_to_listing(df, bm_df, visit_var)
          )
        }

        result <- shiny::maskReactiveContext(
          lp_listings_table(
            df = df, selection = points,
            target_subject_input_id = target_subject_input_id
          )
        )
      }
      result
    })

    output[[LP_ID$SUBJECT_LISTING]] <- DT::renderDT({
      DT::datatable(
        subject_listing_contents(),
        escape = FALSE,
        caption = format_table_title(
          "Listing of data records contributing to points selected on the chart"
        )
      )
    })

    output[[LP_ID$SUMMARY_LISTING]] <- DT::renderDT({
      res <- NULL

      centrality <- centrality()
      shiny::req(centrality)

      placeholder_caption <- LP_MSG$LABEL$SUMMARY_LISTING
      if (centrality == LP_CNT$PLOT_TYPE_SUBJECT_LEVEL) {
        res <- placeholder_table(
          title = placeholder_caption,
          message = paste0(
            "Select a centrality measure other than '",
            LP_CNT$PLOT_TYPE_SUBJECT_LEVEL, "' to populate this listing"
          )
        )
        return(res)
      }

      points <- last_selection()[["points"]]
      if (nrow(points) == 0) {
        res <- placeholder_table(
          title = placeholder_caption,
          message = paste0("Click or brush points in the plot to populate this listing")
        )
        return(res)
      }

      res <- lp_summary_listing(points)

      column_indices_to_round <- NULL
      column_names_to_round <- intersect(c(CNT$VAL, LP_ID$MISC$WHISKER_BOTTOM, LP_ID$MISC$WHISKER_TOP), names(res))
      if (length(column_names_to_round) > 0) column_indices_to_round <- match(column_names_to_round, names(res))

      res <- DT::datatable(
        res,
        caption = format_table_title(placeholder_caption), escape = FALSE,
        colnames = unname(unlist(get_lbls_robust(res)))
      )
      res <- DT::formatRound(res, column_indices_to_round, digits = 2)

      res
    })

    count_listing_contents <- shiny::reactive({
      df <- data_subset()
      res <- lp_count_table(df)
      res
    })
    output[[LP_ID$COUNT_LISTING]] <- DT::renderDT({
      group_text <- compute_group_text(
        group_dataset(), input_lp[[LP_ID$MAIN_GRP]](), input_lp[[LP_ID$SUB_GRP]]()
      )
      title_text <- paste("Subject count per visit", group_text)
      DT::datatable(count_listing_contents(), caption = format_table_title(title_text))
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

    encode_df_for_export <- function(df) {
      res <- df
      if (is.data.frame(res)) {
        res <- list(
          col_names = colnames(df),
          contents = df |> as.matrix() |> unname()
        )
      }
      res
    }

    shiny::exportTestValues(
      subject_listing_contents = subject_listing_contents() |> encode_df_for_export(),
      summary_listing_contents = lp_summary_listing(last_selection()[["points"]]) |> encode_df_for_export(),
      count_listing_contents = count_listing_contents() |> encode_df_for_export(),
      data_subset = data_subset()
    )

    mod_return_value <- NULL
    if (!is.null(on_sbj_click)) {
      shiny::observe({
        shiny::req(!is.null(input[[LP_ID$SELECTED_SUBJECT]]))
        on_sbj_click()
      })
      mod_return_value <- list(subj_id = shiny::reactive(input[[LP_ID$SELECTED_SUBJECT]])) # to papo
    }

    return(mod_return_value)
  }

  shiny::moduleServer(id, module)
}

#' Line plot module
#'
#' Display line plots of raw or summary data over time. Summaries include measures of central tendency
#' (mean, median) and optional deviation and confidence estimators.
#'
#' @param module_id Shiny ID `[character(1)]`
#'
#' Module identifier
#'
#' @param bm_dataset_name,group_dataset_name `[character(1)]`
#'
#' Dataset names
#'
#' @param bm_dataset_disp,group_dataset_disp `[mm_dispatcher(1)]`
#' module manager dispatchers that used as `bm_dataset` and `group_dataset` to `lineplot_server`
#'
#' @param receiver_id `[character(1)]`
#'
#' Name of the module receiving the selected subject ID in the single subject listing. The name must be present in
#' the module list or NULL.
#'
#'
#' @name mod_lineplot
#'
#' @keywords main
#'
#' @export
#'
mod_lineplot <- function(module_id,
                         bm_dataset_name,
                         group_dataset_name,
                         receiver_id = NULL,
                         summary_functions = list(
                           `Mean` = lp_mean_summary_functions,
                           `Median` = lp_median_summary_functions
                         ),
                         subjid_var = "SUBJID",
                         cat_var = "PARCAT",
                         par_var = "PARAM",
                         visit_vars = c("AVISIT"),
                         value_vars = c("AVAL", "PCHG"),
                         additional_listing_vars = character(0),
                         ref_line_vars = character(0),
                         default_centrality_function = NULL,
                         default_dispersion_function = NULL,
                         default_cat = NULL,
                         default_par = NULL,
                         default_val = NULL,
                         default_visit_var = NULL,
                         default_visit_val = NULL,
                         default_main_group = NULL,
                         default_sub_group = NULL,
                         default_transparency = 1.,
                         default_y_axis_projection = 'Linear',
                         bm_dataset_disp, group_dataset_disp) {
  if (!missing(bm_dataset_name) && !missing(bm_dataset_disp)) {
    stop("`bm_dataset_name` and `bm_dataset_disp` cannot be used at the same time, use one or the other")
  }

  if (!missing(group_dataset_name) && !missing(group_dataset_disp)) {
    stop("`group_dataset_name` and `group_dataset_disp` cannot be used at the same time, use one or the other")
  }

  if (!missing(bm_dataset_name)) {
    bm_dataset_disp <- dv.manager::mm_dispatch("filtered_dataset", bm_dataset_name)
  }

  if (!missing(group_dataset_name)) {
    group_dataset_disp <- dv.manager::mm_dispatch("filtered_dataset", group_dataset_name)
  }

  mod <- list(
    ui = function(mod_id) {
      lineplot_UI(id = mod_id)
    },
    server = function(afmm) {
      on_sbj_click_fun <- NULL
      if (!is.null(receiver_id)) {
        on_sbj_click_fun <- function() afmm[["utils"]][["switch2"]](receiver_id)
      }

      lineplot_server(
        id = module_id,
        bm_dataset = dv.manager::mm_resolve_dispatcher(bm_dataset_disp, afmm, flatten = TRUE),
        group_dataset = dv.manager::mm_resolve_dispatcher(group_dataset_disp, afmm, flatten = TRUE),
        on_sbj_click = on_sbj_click_fun,
        summary_functions = summary_functions,
        subjid_var = subjid_var,
        cat_var = cat_var,
        par_var = par_var,
        visit_vars = visit_vars,
        value_vars = value_vars,
        additional_listing_vars = additional_listing_vars,
        ref_line_vars = ref_line_vars,
        default_centrality_function = default_centrality_function,
        default_dispersion_function = default_dispersion_function,
        default_cat = default_cat,
        default_par = default_par,
        default_val = default_val,
        default_visit_var = default_visit_var,
        default_visit_val = default_visit_val,
        default_main_group = default_main_group,
        default_sub_group = default_sub_group,
        default_transparency = default_transparency,
        default_y_axis_projection = default_y_axis_projection
      )
    },
    module_id = module_id
  )
  return(mod)
}
