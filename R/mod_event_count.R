EC <- poc(
  ID = poc(
    TABLE = "table",
    HIERARCHY = "hierarchy",
    GRP = "group",
    MIN_PERCENT = "min_percent"
  ),
  MSG = poc(
    VALIDATE = poc(
      NO_GRP = "No group selected",
      NO_HIERARCHY = "No hierarchy selected or more than two levels selected",
      NO_MIN_PERCENT = "No minimum percent selected",
      NO_TABLE_ROWS = "Table dataset has 0 rows",
      NO_POP_ROWS = "Population dataset has 0 rows"
    )    
  )
)

#' Computes an event table with subject counts and percentages
#'
#' @param event_df `data.frame`
#' A data frame containing the event data. It should have columns corresponding to subjects, hierarchy levels, and group variables.
#'
#' @param pop_df `data.frame`
#' A data frame containing the population data. It must have columns corresponding to subjects and group variables.
#'
#' @param hierarchy `character(0)`
#' A character vector of column names from `event_df` to use as the hierarchy. Can be one or two levels.
#'
#' @param group_var `character(0)`
#' A string representing the column name in `pop_df` used for grouping the population data.
#'
#' @param subjid_var `character(0)`
#' A string representing the subject identifier column name. This column must be present in both `event_df` and `pop_df`.
#'
#' @param .special_char `character(0)`
#' A special character used internally for naming and processing hierarchy levels. Default is `"\x1d"`.
#'
#' @return A list containing:
#' - `df`: A data frame with the processed event data, including counts and percentages.
#' - `meta`: A list containing metadata related to the hierarchy, group variable, and subject counts.
#'
compute_events_table <- function(event_df, pop_df, hierarchy = character(0), group_var = character(0), subjid_var, .special_char = "\x1d") {

  total_column_name <- "Total"
  hier_lvl_col <- paste0(.special_char, "lvl")
  checkmate::assert_disjunct(pop_df[[group_var]], total_column_name)
  checkmate::assert_subset(hierarchy, names(event_df))
  checkmate::assert_subset(group_var, names(event_df))
  checkmate::assert_character(hierarchy)
  checkmate::assert_character(group_var)
  checkmate::assert_string(subjid_var, min.chars = 1)

  n_denominator <- local({        
    nd <- pop_df |>
    dplyr::group_by(dplyr::across(dplyr::all_of(!!group_var))) |>
    dplyr::summarise(N = length(unique(.data[[subjid_var]])))
    total <- length(unique(pop_df[[subjid_var]]))
    stats::setNames(c(nd[["N"]], total), c(as.character(nd[[group_var]]), total_column_name))
  })
  
  reduced_group_event_df <- event_df[, c(subjid_var, hierarchy), drop = FALSE]
  reduced_group_event_df <- dplyr::left_join(
    reduced_group_event_df, pop_df[, c(subjid_var, group_var), drop = FALSE],
    by = subjid_var
  )
  # event_df may not contain all groups
  levels(reduced_group_event_df[[group_var]]) <- levels(pop_df[[group_var]])

  rev_hierarchy <- rev(hierarchy)
  hierarchy_df_list <- vector(mod = "list", length = length(rev_hierarchy))
  for (idx in c(seq_along(rev_hierarchy), length(rev_hierarchy) + 1)) {          
    curr_hierarchy <- local({
      if (idx > length(rev_hierarchy)) character(0) else rev_hierarchy[idx:length(rev_hierarchy)]            
    })
    empty_hierarchy <- setdiff(hierarchy, curr_hierarchy)

    curr_group_by_cols <- c(curr_hierarchy, group_var)
    curr_group_select_cols <- c(subjid_var, curr_hierarchy, group_var)

    curr_total_by_cols <- c(curr_hierarchy)
    curr_total_select_cols <- c(subjid_var, curr_hierarchy)

    # Explicit inclusion of group_var in complete even for totals          
    complete_by <- c(curr_hierarchy, group_var) 

    curr_grouped_count_df <- reduced_group_event_df |>  
      dplyr::select(dplyr::all_of(curr_group_select_cols)) |>
      dplyr::distinct() |>
      dplyr::group_by(dplyr::across(dplyr::all_of(curr_group_by_cols))) |>
      dplyr::summarise(
        "N" = dplyr::n(),
        subjid = list(.data[[subjid_var]]),
        perc = {
          current_group <- dplyr::cur_group()[[group_var]]
          100 * (.data[["N"]] / n_denominator[[current_group]])
          }
        ) |>
      dplyr::ungroup() |>        
    tidyr::complete(!!!rlang::syms(complete_by), fill = list(N=0, subjid = list(character(0)), perc = 0))
    
    curr_total_count_df <-  reduced_group_event_df  |>  
      dplyr::select(dplyr::all_of(curr_total_select_cols)) |>
      dplyr::distinct() |>
      dplyr::group_by(dplyr::across(dplyr::all_of(curr_total_by_cols))) |>
      dplyr::summarise(
      "N" = dplyr::n(),
      subjid = list(.data[[subjid_var]]),
      perc = {
        current_group <- total_column_name
        100 * (.data[["N"]] / n_denominator[[current_group]])
        }
      ) |>
      dplyr::ungroup() |>
      dplyr::mutate(
        !!group_var := factor(total_column_name)
      ) |>
      tidyr::complete(
        !!!rlang::syms(complete_by),
        fill = list(N = 0, subjid = list(character(0)), perc = 0)
      )

      curr_count_df <- dplyr::bind_rows(curr_grouped_count_df, curr_total_count_df)
      curr_count_df[, empty_hierarchy] <- factor(.special_char)
      curr_count_df[, hier_lvl_col] <- idx

      hierarchy_df_list[[idx]] <- curr_count_df
  }

  hierarchy_df <- dplyr::bind_rows(hierarchy_df_list)

  res <- list(
    df = hierarchy_df,
    meta = list(hierarchy = hierarchy, group_var = group_var, hier_lvl_col = hier_lvl_col, special_char = .special_char, n_denominator = n_denominator)
  )  
  
  res
}

#' Orders event table by subject counts
#'
#' @param d `list`
#' A list returned from `compute_events_table()` containing the event data and metadata.
#'
#' @return A data frame with the event data sorted by subject counts within each hierarchy level.
#'
compute_order_events_table <- function(d) {

  checkmate::assert_data_frame(d[["df"]]) # DP 
  checkmate::assert_list(d[["meta"]]) # DP  

  special_char <- d[["meta"]][["special_char"]]
  hierarchy <- d[["meta"]][["hierarchy"]]
  hier_lvl_col <- d[["meta"]][["hier_lvl_col"]]
  df <- d[["df"]]

  sort_col <- "N"

  events_order <- df |>
    dplyr::group_by(
      dplyr::across(
        dplyr::all_of(c(!!hierarchy))
      )
    ) |>
    dplyr::summarise(
      max_N = max(.data[[sort_col]]),
      !!hier_lvl_col := unique(.data[[hier_lvl_col]])
    ) |>
    dplyr::arrange(dplyr::desc(.data[["max_N"]]))

  max_hierarchy_lvl <- length(hierarchy)

  for (lvl in rev(seq_len(max_hierarchy_lvl))) {
    rank_col <- paste0(special_char, "_rank_", lvl)
    curr_df <- events_order[events_order[[hier_lvl_col]] == lvl, , drop = FALSE]
    curr_df[[rank_col]] <- dplyr::row_number(curr_df[["max_N"]])
    curr_hierarchy <- rev(hierarchy)[max_hierarchy_lvl:lvl]
    events_order <- dplyr::left_join(events_order, curr_df[, c(curr_hierarchy, rank_col)], by = curr_hierarchy)
  }

  events_order <- dplyr::mutate(
    events_order,
    dplyr::across(
      dplyr::starts_with(paste0(special_char, "_rank")),
      ~ dplyr::if_else(is.na(.x), Inf, .x)
    )
  )

  events_order <- dplyr::arrange(events_order, dplyr::desc(dplyr::across(dplyr::starts_with(paste0(special_char, "_rank")))))
  events_order[[paste0(special_char, "_rank_overall")]] <- rev(seq_len(nrow(events_order)))

  res <- events_order
  res
}

#' Converts the event table to wide format
#'
#' @param d `list`
#' A list returned from `compute_events_table()` containing the event data and metadata.
#'
#' @param min_percent `numeric`
#' The minimum percentage threshold for filtering events. Rows where the percentage of subjects is below this threshold will be removed from the output.
#'
#' @return A list containing:
#' - `df`: A wide-format data frame with the event counts and percentages for each group and hierarchy level.
#' - `meta`: A list of metadata related to the event table.
#'
pivot_wide_format_events_table <- function(d, min_percent) {

  checkmate::assert_data_frame(d[["df"]]) # DP 
  checkmate::assert_list(d[["meta"]]) # DP  

  special_char <- d[["meta"]][["special_char"]]
  hierarchy <- d[["meta"]][["hierarchy"]]
  hier_lvl_col <- d[["meta"]][["hier_lvl_col"]]
  group_var <- d[["meta"]][["group_var"]]
  df <- d[["df"]]  

  cell_col <- paste0(special_char, "_", "cell")   
  events_table_format <- df[df[["perc"]] > min_percent, , drop = FALSE]
  count <- sprintf("%d ( %.2f %%)", events_table_format[["N"]], events_table_format[["perc"]])  
  subjid <- purrr::map(events_table_format[["subjid"]], as.character)
  events_table_format[[cell_col]] <- purrr::map2(count, subjid, ~list(count = .x, subjid = .y))  
  events_table_format <- events_table_format[, c(hierarchy, group_var, cell_col), drop = FALSE]  
  rep <- list(count = "—", subjid = character(0))  

  data_cols <- levels(events_table_format[[group_var]])
  wide_event <- tidyr::pivot_wider(events_table_format, names_from = !!group_var, names_expand = TRUE, values_from = c(cell_col), values_fill = list(special_char))
  wide_event[data_cols] <- purrr::map(
    wide_event[data_cols],
    ~purrr::map(
      .x,
      function(.x){        
        if(identical(.x, special_char)) rep else .x
      }
    )
  )
  
  res <- list(df = wide_event, meta = d[["meta"]])
  res

}

#' Sorts the wide-format event table by the overall subject count ranking
#'
#' @param event_d `list`
#' A list returned from `pivot_wide_format_events_table()` containing the wide-format event data and metadata.
#'
#' @param sort_df `data.frame`
#' A data frame returned from `compute_order_events_table()` containing the sorted event data by subject counts.
#'
#' @return A list containing:
#' - `df`: A sorted wide-format data frame of event counts and percentages.
#' - `meta`: Metadata updated with the ranking information.
#'
sort_wider_formatter_events_table <- function(event_d, sort_df) {

  checkmate::assert_data_frame(event_d[["df"]]) # DP   
  checkmate::assert_list(event_d[["meta"]]) # DP  
  checkmate::assert_data_frame(sort_df) # DP 

  special_char <- event_d[["meta"]][["special_char"]]
  hierarchy <- event_d[["meta"]][["hierarchy"]]
  hier_lvl_col <- event_d[["meta"]][["hier_lvl_col"]]
  event_df <- event_d[["df"]]  

  sort_names <- names(sort_df)
  rank_col <- paste0(special_char, "_rank_overall")
  join_cols <- c(
    hierarchy,
    hier_lvl_col,
    rank_col
  )

  sort_event_df <- event_df |>        
    dplyr::left_join(sort_df[, join_cols], by = c(hierarchy)) |>
    dplyr::arrange(dplyr::desc(.data[[rank_col]]))

  res <- list(
    df = sort_event_df,
    meta = c(event_d[["meta"]], list(rank_col = rank_col))
  )

  res
}


#' Renders the wide-format event table as an HTML table
#'
#' @param d `list`
#' A list returned from `sort_wider_formatter_events_table()` containing the sorted wide-format event data and metadata.
#'
#' @param on_cell_click `character(0)`
#' A JavaScript callback function to be executed when a table cell is clicked. Default is `NULL`.
#'
#' @return An HTML table generated using `shiny::tags` and formatted for interactive display.
#'
sort_wide_format_event_table_to_HTML <- function(d, on_cell_click = NULL) {
  checkmate::assert_data_frame(d[["df"]]) # DP 
  checkmate::assert_list(d[["meta"]]) # DP 
  
  special_char <- d[["meta"]][["special_char"]]
  hierarchy <- d[["meta"]][["hierarchy"]]
  hier_lvl_col <- d[["meta"]][["hier_lvl_col"]]
  group_var <- d[["meta"]][["group_var"]]
  row_id_col <- d[["meta"]][["row_id_col"]]
  n_denominator <- d[["meta"]][["n_denominator"]]
  df <- d[["df"]]

  entry_name_col <- paste0(special_char, "entry_name")

  table <- shiny::tags[["table"]]
  th <- shiny::tags[["th"]]
  thc <- function(...) th(class = "text-center", ...)
  tr <- shiny::tags[["tr"]]
  td <- shiny::tags[["td"]]
  tdc <- function(...) td(class = "text-center", ...)

  df_names <- names(df)
  internal_columns <- df_names[startsWith(df_names, special_char)]
  data_columns <- df_names[!df_names %in% c(hierarchy, internal_columns)]
  column_headers <- local({
    N_column_headers <- c("", paste0("(N = ", n_denominator[data_columns], ")"))
    purrr::map2(c("", data_columns), N_column_headers, ~shiny::span(.x, shiny::br(), .y))
  })
  
  hierarchy_length <- length(hierarchy)

  df[[entry_name_col]] <- local({    
    purrr::pmap_chr(
      df[c(hierarchy, hier_lvl_col)], function(...){
        args <- list(...)
        if (args[[hier_lvl_col]] > hierarchy_length) return("Overall")
        curr_lvl <- rev(hierarchy)[args[[hier_lvl_col]]]
        curr_label <- as.character(args[[curr_lvl]])
        curr_label
      }
    )    
  })

  title <- sprintf("Event count by %s", paste(hierarchy, collapse = ", "))  

  header_row <- tr(
    class = "no-border",
    purrr::map(column_headers, thc)
  )

  max_hierarchy_lvl <- hierarchy_length + 1

  body <- vector(mode = "list", length = nrow(df))  
  for (r in seq_len(nrow(df))) {
    curr_row <- df[r, , drop = FALSE]
    curr_hier_lvl <- curr_row[[hier_lvl_col]]        
        
    if (curr_hier_lvl > 1) {
      collapse_control <- shiny::icon("table", onclick = "ec_collapse(this)")     
    } else {
      collapse_control <- NULL
    }

    indent <- max_hierarchy_lvl - curr_hier_lvl
    indent_class <- sprintf("indent-%d", indent)    
    entry_cell <- td(shiny::span(collapse_control, curr_row[[entry_name_col]]))
    data_cells <- purrr::imap(curr_row[data_columns], ~tdc(.x[[1]][["count"]], column = .y,onclick = on_cell_click))
    body[[r]] <- tr(
      "row-id" = r,
      class = c(indent_class),
      indent = indent,
      entry_cell,
      data_cells
    )
  }

  shiny::div(
    shiny::p(
      title
    ),
  
  table(
    class = "table event-count",
    event_count_dep(),
    header_row,
    !!!body
  )  
  )
}

#' UI for the event count module
#'
#' @param id `character(0)`
#' The ID for the event count module instance.
#'
#' @return A `shiny::tagList` containing the user interface for selecting hierarchy, group, and minimum percentage for event counting.
#'
event_count_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::div(      
      col_menu_UI(id = ns(EC$ID$HIERARCHY)),
      col_menu_UI(id = ns(EC$ID$GRP)),
      shiny::numericInput(ns(EC$ID$MIN_PERCENT), label = "Minimum %", value = 0, min = 0, max = 100)
    ),    
    shiny::uiOutput(ns(EC$ID$TABLE))
  )
}

#' Server logic for the event count module
#'
#' @param id `character(0)`
#' The ID for the event count module instance.
#'
#' @param table_dataset `data.frame`
#' A reactive dataset containing the event data.
#'
#' @param pop_dataset `data.frame`
#' A reactive dataset containing the population data.
#'
#' @param subjid_var `character(1)`
#' A string representing the subject identifier column in both datasets.
#'
#' @param show_modal_on_click `logical(1)`
#' A flag to indicate whether clicking a table cell should display a modal dialog with the subject IDs.
#'
#' @param default_hierarchy `character(1|2)|NULL`
#' A default value for the hierarchy variables (optional).
#'
#' @param default_group `character(1)|NULL`
#' A default value for the group variable (optional).
#'
#' @return A reactive value containing the list of subjects in the clicked cell, if applicable.
#'
event_count_server <- function(id, table_dataset, pop_dataset, subjid_var, show_modal_on_click = FALSE, default_hierarchy = NULL, default_group = NULL) {
  mod <- function(input, output, session) {

    ns <- session[["ns"]]

    inputs <- list()
    inputs[[EC$ID$HIERARCHY]] <- col_menu_server(
      id = EC$ID$HIERARCHY, data = table_dataset,
      label = "Event count by",
      include_func = function(x) {
        is.factor(x) || is.character(x)
      },
      default = default_hierarchy,
      multiple = TRUE
    )

    inputs[[EC$ID$GRP]] <- col_menu_server(
      id = EC$ID$GRP, data = pop_dataset,
      label = "Group by",
      include_func = function(x) {
        is.factor(x) || is.character(x)
      },
      default = default_group
    )

    inputs[[EC$ID$MIN_PERCENT]] <- shiny::reactive({
      input[[EC$ID$MIN_PERCENT]]
    })

    et <- shiny::reactive({
      d <- table_dataset()
      pd <- pop_dataset()
      group_var <- inputs[[EC$ID$GRP]]()
      hierarchy <- inputs[[EC$ID$HIERARCHY]]()
      min_percent <- inputs[[EC$ID$MIN_PERCENT]]()

      shiny::validate(
        shiny::need(
          checkmate::test_data_frame(d, min.rows = 1),
          EC$MSG$VALIDATE$NO_TABLE_ROWS
        ),
        shiny::need(
          checkmate::test_data_frame(pd, min.rows = 1),
          EC$MSG$VALIDATE$NO_POP_ROWS
        ),
        shiny::need(
          checkmate::test_string(group_var, min.chars = 1) && group_var != "None",
          EC$MSG$VALIDATE$NO_GRP
        ),
        shiny::need(
          checkmate::test_character(hierarchy, min.chars = 1, min.len = 1, max.len = 2),
          EC$MSG$VALIDATE$NO_HIERARCHY
        ),
        shiny::need(
          checkmate::test_number(min_percent, na.ok = FALSE, lower = 0, upper = 100),
          EC$MSG$VALIDATE$NO_MIN_PERCENT
        )
      )

      events_table_raw <- compute_events_table(d, pd, hierarchy, group_var, subjid_var)      
      sorted_events_table <- compute_order_events_table(events_table_raw)  


      t <- pivot_wide_format_events_table(events_table_raw, min_percent) |>
        sort_wider_formatter_events_table(sorted_events_table)

      t
    })

    output[[EC$ID$TABLE]] <- shiny::renderUI({
      on_cell_click <- sprintf("Shiny.setInputValue('%s', {row_id: Number(this.closest('tr').getAttribute('row-id')), column : this.getAttribute('column')}, {priority: 'event'})", ns("cell_click"))
      et() |> sort_wide_format_event_table_to_HTML(on_cell_click)  
    })

    if (show_modal_on_click) {
      shiny::observeEvent(input[["cell_click"]],{
        row <- input[["cell_click"]][["row_id"]]
        col <- input[["cell_click"]][["column"]]
        d <- shiny::modalDialog(
          paste("Subjects:", paste(et()[["df"]][[col]][[row]][["subjid"]], collapse = " "))
        )

        shiny::showModal(d)
      })
    }

    res <- shiny::reactive({
      row <- input[["cell_click"]][["row_id"]]
      col <- input[["cell_click"]][["column"]]

      shiny::validate(
        shiny::need(
          checkmate::test_string(col) && checkmate::test_number(row),
          "click a cell"
        )
      )
      et()[["df"]][[col]][[row]][["subjid"]]
    })

    res
  }

  shiny::moduleServer(
    id = id,
    module = mod
  )
}

#' Invoke boxplot module
#'
#' @param module_id `[character(1)]`
#'
#' Module Shiny id
#'
#' @param table_dataset_name,group_dataset_name `[character(1)]`
#'
#' Name of the dataset
#'
#' @keywords main
#'
#' @export 
mod_event_count <- function(module_id,
                        table_dataset_name,
                        pop_dataset_name,
                        subjid_var = "USUBJID",
                        show_modal_on_click = FALSE,
                        default_hierarchy = NULL,
                        default_group = NULL,
                        table_dataset_disp,
                        pop_dataset_disp,
                        receiver_id = NULL,
                        server_wrapper_func = identity) {
  if (!missing(table_dataset_name) && !missing(table_dataset_disp)) {
    rlang::abort("`table_dataset_name` and `table_dataset_disp` cannot be used at the same time, use one or the other")
  }

  if (!missing(pop_dataset_name) && !missing(pop_dataset_disp)) {
    rlang::abort("`pop_dataset_name` and `pop_dataset_disp` cannot be used at the same time, use one or the other")
  }

  if (!missing(table_dataset_name)) {
    table_dataset_disp <- dv.manager::mm_dispatch("filtered_dataset", table_dataset_name)
  }

  if (!missing(pop_dataset_name)) {
    pop_dataset_disp <- dv.manager::mm_dispatch("filtered_dataset", pop_dataset_name)
  }

  mod <- list(
    ui = event_count_ui,
    server = function(afmm) {
      if (is.null(receiver_id)) {
        on_sbj_click_fun <- function() NULL
      } else {
        on_sbj_click_fun <- function() {
          afmm[["utils"]][["switch2"]](receiver_id)
        }
      }

      server_wrapper_func(
        event_count_server(
          id = module_id,
          table_dataset = dv.manager::mm_resolve_dispatcher(table_dataset_disp, afmm, flatten = TRUE),
          pop_dataset = dv.manager::mm_resolve_dispatcher(pop_dataset_disp, afmm, flatten = TRUE),
          subjid_var = subjid_var,
          show_modal_on_click = show_modal_on_click,
          # on_sbj_click = on_sbj_click_fun,
          default_hierarchy = default_hierarchy, default_group = default_group
        )
      )
    },
    module_id = module_id
  )
  mod
}

#' Mock hierarchy table app
#' @keywords mock
#' @param dry_run Return parameters used in the call
#' @param update_query_string automatically update query string with app state
#' @param ui_defaults,srv_defaults a list of values passed to the ui/server function
#' @export

mock_app_event_count <- function(dry_run = FALSE, update_query_string = TRUE, srv_defaults = list(), ui_defaults = list()) {

  chr2factor <- function(df){
    lbls <- get_lbls_robust(df)
    df[] <- purrr::map(df, ~if(is.character(.x)) factor(.x) else .x)
    df <- set_lbls(df, lbls)
    df
  }

  table_dataset <- shiny::reactive({
    pharmaverseadam::adae |> chr2factor()
  })

  pop_dataset <- shiny::reactive({
    pharmaverseadam::adsl |> chr2factor()
  })

  ui_params <- c(
    list(
      id = "mod"
    ),
    ui_defaults
  )

  srv_params <- c(
    list(
      id = "mod",
      table_dataset = table_dataset,
      pop_dataset = pop_dataset,
      subjid_var = "SUBJID"
    ),
    srv_defaults
  )

  if (dry_run) {
    return(list(ui = ui_params, srv = srv_params))
  }

  mock_app_wrap(
    update_query_string = update_query_string,
    ui = function() do.call(event_count_ui, ui_params),
    server = function() {
      do.call(event_count_server, srv_params)
    }
  )
}

mock_app_event_count_mm <- function() {

  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }

  chr2factor <- function(df){
    lbls <- get_lbls_robust(df)
    df[] <- purrr::map(df, ~if(is.character(.x)) factor(.x) else .x)
    df <- set_lbls(df, lbls)
    df
  }

  table_dataset <- shiny::reactive({
    pharmaverseadam::adae |> chr2factor()
  })

  pop_dataset <- shiny::reactive({
    pharmaverseadam::adsl |> chr2factor()
  })

  dv.manager::run_app(
    data = list(dummy = list(adae = pharmaverseadam::adae |> chr2factor(), adsl = pharmaverseadam::adsl |> chr2factor())),
    module_list = list(
      "ADAE by term" = mod_event_count(
        "event_count",
        table_dataset_disp = dv.manager::mm_dispatch("filtered_dataset", "adae"),
        pop_dataset_disp = dv.manager::mm_dispatch("filtered_dataset", "adsl"),
        show_modal_on_click = TRUE,
        default_hierarchy = c("AEBODSYS", "AEDECOD"),
        default_group = "TRT01P"
      )
    ),
    filter_data = "adsl",
    filter_key = "SUBJID",
    enableBookmarking = "url"
  )

}
