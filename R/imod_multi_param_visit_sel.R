MPVS <- poc(
  ID = poc(
    VISIBLE_ROW_COUNT = "visible_row_count",
    CAT_PREFIX = "cat_",
    PAR_PREFIX = "par_",
    VIS_PREFIX = "vis_"
  ),
  CONST = poc(
    MAX_ROW_COUNT = 8
  )
)

# Static collection of category, parameter and visit selectors
# with as many rows as dictated by the MAX_ROW_COUNT constant.
# They are made visible by updating the VISIBLE_ROW_COUNT input.
multi_param_visit_selector_UI <- function(id, default_cat, default_par, default_visit) {
  ns <- shiny::NS(id)

  cat_ids <- paste0(MPVS$ID$CAT_PREFIX, 1:MPVS$CONST$MAX_ROW_COUNT)
  par_ids <- paste0(MPVS$ID$PAR_PREFIX, 1:MPVS$CONST$MAX_ROW_COUNT)
  vis_ids <- paste0(MPVS$ID$VIS_PREFIX, 1:MPVS$CONST$MAX_ROW_COUNT)

  col_width <- 4

  row <- function(index) {
    visibility_condition <- paste0("input.", MPVS$ID$VISIBLE_ROW_COUNT, " >= ", index)
    opts <- list(`none-selected-text` = "Missing selection", `actions-box` = TRUE, `live-search` = TRUE)

    sel_cat <- cho_cat <- sel_par <- cho_par <- sel_vis <- cho_vis <- c()
    if (index == 1) {
      sel_cat <- cho_cat <- default_cat
      sel_par <- cho_par <- default_par
      sel_vis <- cho_vis <- default_visit
    }

    shiny::conditionalPanel(
      condition = visibility_condition, ns = ns,
      shiny::fluidRow(
        shiny::column(
          width = col_width,
          shinyWidgets::pickerInput(
            inputId = ns(cat_ids[[index]]), selected = sel_cat,
            choices = cho_cat, multiple = TRUE, options = opts
          )
        ),
        shiny::column(
          width = col_width,
          shinyWidgets::pickerInput(
            inputId = ns(par_ids[[index]]), selected = sel_par,
            choices = cho_par, multiple = TRUE, options = opts
          )
        ),
        shiny::column(
          width = col_width,
          shinyWidgets::pickerInput(
            inputId = ns(vis_ids[[index]]), selected = sel_vis,
            choices = cho_vis, multiple = TRUE, options = opts
          )
        )
      )
    )
  }

  hide <- function(e) shiny::tags[["div"]](e, style = "display: none")

  res <- shiny::tagList(
    hide(shiny::numericInput(inputId = ns(MPVS$ID$VISIBLE_ROW_COUNT), label = NULL, value = 1)),
    shiny::tags[["div"]](style = "width: fit-content;",
      shiny::fluidRow(
        shiny::column(width = col_width, shiny::HTML("<b>Category</b>")),
        shiny::column(width = col_width, shiny::HTML("<b>Parameter</b>")),
        shiny::column(width = col_width, shiny::HTML("<b>Visit</b>"))
      ),
      shiny::tagList(Map(row, 1:MPVS$CONST$MAX_ROW_COUNT))
    )
  )
  return(res)
}

multi_param_visit_selector_server <- function(id, data, cat_var, par_var, visit_var) {
  cat_ids <- paste0(MPVS$ID$CAT_PREFIX, 1:MPVS$CONST$MAX_ROW_COUNT)
  par_ids <- paste0(MPVS$ID$PAR_PREFIX, 1:MPVS$CONST$MAX_ROW_COUNT)
  vis_ids <- paste0(MPVS$ID$VIS_PREFIX, 1:MPVS$CONST$MAX_ROW_COUNT)

  # Behavior of selectors; isolated from reactivity
  empty_state <- function(row_count) {
    triplet <- list(cat = c(), par = c(), vis = c())
    triplets <- rep(list(triplet), row_count)
    res <- list(
      selected = triplets, choices = triplets,
      visible_row_count = 1, row_count = row_count
    )
    return(list2env(res, parent = emptyenv()))
  }

  compute_row_update <- function(state, cat, par, vis, choices, index) {
    res <- list()

    updated <- function(state, slot, sel, cho, index) {
      res <- !identical(state[["choices"]][[index]][[slot]], cho)
      state[["selected"]][[index]][[slot]] <- sel
      state[["choices"]][[index]][[slot]] <- cho
      return(res)
    }

    if (updated(state, "cat", sel = cat, cho = choices$cat, index)) {
      res[[length(res) + 1]] <- list(
        kind = "update_picker", id = cat_ids[[index]],
        selected = cat, choices = choices$cat
      )
    }

    choices_par <- unlist(choices$par_per_cat[cat], use.names = FALSE, recursive = TRUE)

    if (updated(state, "par", sel = par, cho = choices_par, index)) {
      res[[length(res) + 1]] <- list(
        kind = "update_picker", id = par_ids[[index]],
        selected = par, choices = choices_par
      )
    }

    if (updated(state, "vis", sel = vis, cho = choices$vis, index)) {
      res[[length(res) + 1]] <- list(
        kind = "update_picker", id = vis_ids[[index]],
        selected = vis, choices = choices$vis
      )
    }

    return(res)
  }

  compute_updates <- function(state, selected, choices) {
    res <- list()

    last_nonempty_row_index <- 0
    for (i in seq_along(selected)) {
      sel <- selected[[i]]
      sub_res <- compute_row_update(state, sel[["cat"]], sel[["par"]], sel[["vis"]], choices, i)
      res <- append(res, sub_res)
      if (length(sel[["cat"]]) > 0 && length(sel[["par"]]) > 0 && length(sel[["vis"]]) > 0) last_nonempty_row_index <- i
    }

    visible_row_count <- last_nonempty_row_index + 1
    if (visible_row_count != state$visible_row_count) {
      res[[length(res) + 1]] <- list(kind = "update_numeric", id = MPVS$ID$VISIBLE_ROW_COUNT, value = visible_row_count)
      state$visible_row_count <- visible_row_count
    }

    return(res)
  }

  apply_updates <- function(session, updates) {
    for (update in updates) {
      if (update[["kind"]] == "update_picker") {
        if (is.null(update[["choices"]])) update[["choices"]] <- character(0)

        null_as_char0 <- function(v) if (is.null(v)) character(0) else v # pickerInput quirk

        shinyWidgets::updatePickerInput(
          session,
          inputId = update[["id"]],
          selected = null_as_char0(update[["selected"]]),
          choices = null_as_char0(update[["choices"]])
        )
      } else if (update[["kind"]] == "update_numeric") {
        shiny::updateNumericInput(session, update[["id"]], value = update[["value"]])
      } else {
        # Ignore unknown update kind
      }
    }
  }

  server_function <- function(input, output, session) {
    # `data` is the only reactive input to this module and we only care about three of its columns,
    # which we use to populate the 'choices' of the selector matrix.
    # This transformation could be done by the caller and this module would be more general, but until
    # there's a second user for it, who cares
    choices <- shiny::reactive({
      data <- data()

      # the category and visit columns can be taken as they come
      categories <- levels(data[[cat_var]])
      visits <- levels(data[[visit_var]])

      # which parameters fall under which categories
      par_per_cat <- list()
      for (cat in categories) {
        mask <- (data[[cat_var]] == cat)
        par_per_cat[[cat]] <- as.character(sort(unique(data[[par_var]][mask])))
      }

      list(cat = categories, par_per_cat = par_per_cat, vis = visits)
    }) |> trigger_only_on_change()

    # The state of the module is not encoded in its selectors.
    # Instead, selectors reflect the state of the module.
    state <- empty_state(row_count = MPVS$CONST$MAX_ROW_COUNT)

    # custom bookmarking:
    # - store selected input state into a single value
    # - avoid running update logic during bookmark restoration
    # - after bookmark restoration, run update logic and overwrite input state
    shiny::observe(shiny::setBookmarkExclude(names(shiny::reactiveValuesToList(input, all.names = TRUE))))
    shiny::onBookmark(function(bookmark_state) {
      visible_selected <- state$selected[1:state$visible_row_count]
      bookmark_state$values[["visible_selected"]] <- to_shiny_bookmark_value(visible_selected)
    })
    restoring_bookmark <- shiny::reactiveVal(FALSE)
    shiny::onRestore(function(bookmark_state) restoring_bookmark(TRUE))
    shiny::onRestored(function(bookmark_state) {
      restoring_bookmark(FALSE)

      try({
        visible_selected_unsafe <- from_shiny_bookmark_value(bookmark_state$values[["visible_selected"]])[["unsafe"]]

        # Makes sure returned deserialized value is plain list of named lists of character arrays
        # and no extra attributes have been added
        # TODO: Could be simplified by _not_ using `serialize` and just encoding the nested list ourselves.
        to_safe <- function(x) {
          res <- empty_state(row_count = MPVS$CONST$MAX_ROW_COUNT)
          if (!is.list(x)) {
            return(res)
          }
          attributes(x) <- NULL

          for (i in seq_along(x)) {
            if (!is.list(x[[i]])) {
              return(res)
            }
            attributes(x[[i]]) <- attributes(x[[i]])["names"]
            for (j in seq_along(x[[i]])) {
              if (!is.character(x[[i]][[j]])) {
                return(res)
              }
              attributes(x[[i]][[j]]) <- NULL
            }
          }
          return(x)
        }

        visible_selected <- to_safe(visible_selected_unsafe)
        updates <- compute_updates(state, selected = visible_selected, choices = choices())
        apply_updates(session, updates)
      })
    })

    empty_return_val <- data.frame(cat = character(0), par = character(0), vis = character(0))

    selection <- shiny::reactiveVal(empty_return_val)

    shiny::observe({
      # ?? Shiny server appears to trigger onBookmarked events at inconvenient times which may prevent
      #    an actually useful invalidation of this observe. We just make a note of coming back later
      if (shiny::isolate(restoring_bookmark())) {
        shiny::invalidateLater(500)
        shiny::req(FALSE)
      }

      selected <- list()
      for (i in seq_len(MPVS$CONST$MAX_ROW_COUNT)) {
        selected[[i]] <- list(cat = input[[cat_ids[[i]]]], par = input[[par_ids[[i]]]], vis = input[[vis_ids[[i]]]])
      }
      choices <- choices()

      local({ # early out if inputs not available
        available_inputs <- names(shiny::isolate(shiny::reactiveValuesToList(input)))
        expected_inputs <- c(cat_ids, par_ids, vis_ids)
        found_inputs <- intersect(expected_inputs, available_inputs)
        shiny::req(length(found_inputs) == length(expected_inputs))
      })

      updates <- compute_updates(state, selected = selected, choices = choices)
      apply_updates(session, updates)

      # Update returned selection (union of Cartesian product of row selections)
      res <- data.frame()
      for (i in seq_len(MPVS$CONST$MAX_ROW_COUNT)) {
        df <- expand.grid(selected[[i]], stringsAsFactors = FALSE)
        res <- rbind(res, df)
      }
      res <- res[!duplicated(res), ]

      if (nrow(res) == 0) res <- empty_return_val

      colnames(res) <- c(CNT$CAT, CNT$PAR, CNT$VIS)

      selection(res)
    })

    input_ids <- c()
    input_ids[[CNT$CAT]] <- paste0(id, "-", cat_ids)
    input_ids[[CNT$PAR]] <- paste0(id, "-", par_ids)
    input_ids[[CNT$VIS]] <- paste0(id, "-", vis_ids)

    structure(selection, id = input_ids)
  }
  shiny::moduleServer(id, server_function)
}
