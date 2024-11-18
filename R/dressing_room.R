# Ad-hoc "T_"ype system ----

# basic types
T_logical <- function() list(kind = "logical")
T_factor <- function() list(kind = "factor")
T_character <- function() list(kind = "character")
T_date <- function() list(kind = "date")
T_datetime <- function() list(kind = "datetime")
T_integer <- function(min = NA, max = NA) list(kind = "integer", min = min, max = max) # allows numeric if all values are integer
T_numeric <- function(min = NA, max = NA) list(kind = "numeric", min = min, max = max)

# permissive types
T_anything <- function() list(kind = "anything")

# sum types
T_or <- function(...) list(kind = "or", options = list(...))

# known- and variable-length collections
T_group <- function(...) list(kind = "group", elements = list(...))

# domain-specific types
T_mod_ID <- function() list(kind = "mod")
T_dataset_name <- function() list(kind = "dataset_name")
T_col <- function(dataset_name, sub_kind = T_anything()) {
  list(kind = "col", dataset_name = dataset_name, sub_kind = sub_kind)
}
T_color <- function() list(kind = "color")
T_CDISC_study_day <- function() list(kind = "cdisc_study_day", min = NA, max = NA)
T_YN <- function() list(kind = "YN")
T_choice_from_col_contents <- function(param) list(kind = "choice_from_col_contents", param = param)
T_choice <- function(param) list(kind = "choice", param = param)

T_is_of_kind <- function(var, type) {
  res <- FALSE
  if (length(type) == 1 && is.na(type)) browser()

  if (type[["kind"]] == "or") {
    for (option in type[["options"]]) res <- res || T_is_of_kind(var, option)
  } else if (type[["kind"]] == "anything") {
    res <- TRUE
  } else if (type[["kind"]] == "factor") {
    res <- is.factor(var)
  } else if (type[["kind"]] == "character") {
    res <- is.character(var)
  } else if (type[["kind"]] == "date") {
    res <- inherits(var, "Date")
  } else if (type[["kind"]] == "datetime") {
    res <- inherits(var, "POSIXt")
  } else if (type[["kind"]] == "numeric") {
    res <- is.numeric(var)
  } else if (type[["kind"]] == "integer") {
    res <- is.integer(var) || (is.numeric(var) && all(var[is.finite(var)] %% 1 == 0))
  } else if (type[["kind"]] == "logical") {
    res <- is.logical(var)
  } else if (type[["kind"]] == "cdisc_study_day") {
    res <- (is.integer(var) || (is.numeric(var) && all(var[is.finite(var)] %% 1 == 0))) && all(var[is.finite(var)] != 0)
  } else if (type[["kind"]] == "YN") {
    res <- ((is.character(var) && setequal(unique(var), c("Y", "N"))) ||
      is.factor(var) && setequal(levels(var), c("Y", "N")))
  } else {
    browser()
  }
  return(res)
}

# flags
T_flag <- function(x, ...) {
  flag_names <- list(...)

  unknown_flags <- setdiff(
    flag_names,
    c( # common flags
      "optional", "zero_or_more", "one_or_more", "as_array", "named", "ignore",
      # domain-specific flags
      "subject_level_dataset_name", "subjid_var"
    )
  )
  if (length(unknown_flags)) browser()

  flag_values <- as.list(rep(TRUE, length(flag_names)))
  flags <- stats::setNames(flag_values, flag_names)
  return(do.call(structure, append(list(x), flags)))
}

T_map_to <- function(orig, dest) structure(orig, map_to = dest) # maps dataset col to a type the module understands

# Pair documentation with module API ----

T_get_type_as_text <- function(elem) {
  res <- ""

  types <- list(
    group = "list",
    logical = "logical",
    factor = "factor",
    integer = "integer",
    cdisc_study_day = "integer",
    numeric = "numeric",
    mod = "character",
    dataset_name = "character",
    col = "character",
    color = "character",
    character = "character",
    date = "Date",
    datetime = "POSIXt",
    YN = '"Y"/"N"'
  )

  if (elem$kind == "or") {
    res <- paste(Map(T_get_type_as_text, elem$options), collapse = "|")
  } else if (elem$kind == "choice") {
    res <- "character" # FIXME: Refer to the type of the column
  } else if (elem$kind == "choice_from_col_contents") {
    res <- "character" # FIXME: Refer to the type of the column
  } else if (!(elem$kind %in% names(types))) {
    message(paste("Missing kind", elem$kind))
  } else {
    res <- types[[elem$kind]]
  }

  return(res)
}

T_get_use_as_text_lines <- function(elem) {
  res <- character(0)

  if (elem$kind == "mod") {
    res <- "Unique Shiny module identifier"
  } else if (elem$kind == "dataset_name") {
    if (isTRUE(attr(elem, "subject_level_dataset_name"))) {
      res <- "Subject-level dataset name"
    } else {
      res <- "Dataset name"
    }
  } else if (elem$kind == "col") {
    if (isTRUE(attr(elem, "subjid_var"))) {
      res <- "Unique subject identifier column"
    } else {
      res <- sprintf("Indexes into dataset `%s`", elem$dataset_name)
      if (!identical(elem$sub_kind, T_anything())) {
        res <- c(res, sprintf("Expects `[%s]` values", T_get_type_as_text(elem$sub_kind)))
      }
    }
  } else if (elem$kind == "cdisc_study_day") {
    res <- "Represents a CDISC (non-zero) Study Day"
  } else if (elem$kind == "color") {
    res <- "Contains either an HTML (#xxxxxx) or an R color"
  } else if (elem$kind == "choice") {
    res <- "<placeholder>" # TODO: Refer to the actual column
  } else if (elem$kind == "choice_from_col_contents") {
    res <- "<placeholder>" # TODO: Refer to the actual column
  } else if (elem$kind %in% c("integer", "numeric", "character", "group")) {
    # nothing
  } else {
    message(paste("Missing use for kind", elem$kind))
  }

  return(res)
}

T_attach_docs <- function(api, docs) {
  stopifnot(is.character(docs[[1]]))

  attr(api, "docs") <- list(
    type = T_get_type_as_text(api),
    auto_desc = T_get_use_as_text_lines(api),
    manual_desc = docs[[1]]
  )

  if (api$kind == "group") {
    docs[[1]] <- NULL

    if (length(api$elements) != length(docs)) {
      stop(sprintf("api and docs are of different lengths (%d and %d)", length(api), length(docs)))
    } else if (!identical(names(api$elements), names(docs))) {
      stop(sprintf(
        "api and docs have different names (%s and %s)",
        paste(names(api$elements), collapse = ","), paste(names(docs), collapse = ",")
      ))
    }

    for (name in names(api$elements)) {
      api$elements[[name]] <- T_attach_docs(api$elements[[name]], docs[[name]])
    }
  }

  return(api)
}

T_eval_args <- function(args, eval_env) {
  # evaluate arguments before handing them down to arg-rewriting routines
  arg_names <- names(args)
  for (i_arg in seq_along(args)) {
    name <- arg_names[[i_arg]]
    eval_res <- eval(args[[i_arg]], envir = eval_env)
    args[i_arg] <- stats::setNames(list(eval_res), name) # R inferno 8.1.55
  }
  return(args)
}

# Permit caller to provide lists when arrays are desired by the module ----

T_honor_as_array_flag_inner <- function(api_field, elem) {
  if (isTRUE(attr(api_field, "zero_or_more")) || isTRUE(attr(api_field, "zero_or_more"))) {
    attr(api_field, "zero_or_more") <- FALSE
    attr(api_field, "one_or_more") <- FALSE
    for (i in seq_along(elem)) {
      elem[[i]] <- T_honor_as_array_flag_inner(api_field, elem[[i]])
    }
  } else if (api_field$kind == "group") {
    elem_names <- names(elem)
    for (i in seq_along(elem)) {
      name <- elem_names[[i]]
      if (!is.null(name) && name %in% names(api_field[["elements"]]) && !is.null(elem[[i]])) {
        elem[i] <- stats::setNames(
          list(T_honor_as_array_flag_inner(api_field[["elements"]][[name]], elem[[i]])), name
        ) # R inferno 8.1.55
      }
    }
  }

  if (isTRUE(attr(api_field, "as_array")) && is.list(elem)) {
    elem <- unlist(elem)
  }

  return(elem)
}

T_honor_as_array_flag <- function(mod_API, args) {
  env_that_called_the_module_function <- parent.frame(2)
  args <- T_eval_args(args, eval_env = env_that_called_the_module_function)
  args <- T_honor_as_array_flag_inner(mod_API, args)
  return(args)
}

# Map allowed types to those expected by the module ----

T_honor_map_to_flag_inner <- function(datasets, api_field, elem, field_to_dataset_map, current_field_name) {
  res <- list(map = field_to_dataset_map, actions = list())

  if (isTRUE(attr(api_field, "zero_or_more")) || isTRUE(attr(api_field, "zero_or_more"))) {
    attr(api_field, "zero_or_more") <- FALSE
    attr(api_field, "one_or_more") <- FALSE
    for (i in seq_along(elem)) {
      res <- T_honor_map_to_flag_inner(datasets, api_field, elem[[i]], field_to_dataset_map, current_field_name)
    }
  } else if (api_field$kind == "group") {
    group_field_to_dataset_map <- field_to_dataset_map # push new mapping used only inside group

    elem_names <- names(elem)
    for (i in seq_along(elem)) {
      name <- elem_names[[i]]
      if (!is.null(name) && name %in% names(api_field[["elements"]]) && !is.null(elem[[i]])) {
        subres <- T_honor_map_to_flag_inner(
          datasets, api_field[["elements"]][[name]], elem[[i]], group_field_to_dataset_map, name
        )
        res[["actions"]] <- append(res[["actions"]], subres[["actions"]])
        group_field_to_dataset_map <- subres[["map"]] # carry mappings defined inside this group
      }
    }

    res[["map"]] <- field_to_dataset_map # pop old mapping
  } else if (api_field$kind == "dataset_name") {
    res[["map"]][[current_field_name]] <- elem
  } else if (api_field$kind == "col") {
    map_to <- attr(api_field$sub_kind, "map_to")
    if (!is.null(map_to)) {
      dataset <- field_to_dataset_map[[api_field$dataset_name]]
      if (is.null(dataset)) stop("Column refers to unknown dataset") # TODO: Check this upstream, warn earlier
      res[["actions"]][[length(res[["actions"]]) + 1]] <- list(dataset = dataset, col = elem, kind = map_to)
    }
  }

  return(res)
}

T_do_map <- function(datasets, action) {
  dataset <- action[["dataset"]]
  col <- action[["col"]]
  kind <- action[["kind"]]

  col_data <- datasets[[dataset]][[col]]
  if (!T_is_of_kind(col_data, kind)) {
    mapped_from <- attr(col_data, "mapped_from")
    if (!is.null(mapped_from)) {
      stop(sprintf(
        "Dataset %s column %s has already been mapped from %s to %s",
        dataset, col, mapped_from, T_get_type_as_text(kind)
      ))
    }

    mapped_from <- class(col_data)

    attrs <- attributes(col_data)
    if (kind == "logical" && T_is_of_kind(col_data, T_YN())) {
      col_data <- (col_data == "Y")
    } else {
      kind_s <- T_get_type_as_text(kind)
      stop(sprintf("Can't map data from type %s to %s", paste(mapped_from, collapse = ", "), kind_s))
    }

    attributes(col_data) <- attrs
    attr(col_data, "mapped_from") <- mapped_from
  }

  return(col_data)
}

T_honor_map_to_flag <- function(datasets, mod_API, args) {
  # NOTE: Here we overwrite affected dataset columns with the desired type for the purpose of
  #       a particular argument. A 'Y/N' field will be cast to `logical` an thus will become
  #       unavailable as a character variable.
  #       Ideally we would like to cast dataset columns to separate columns with a different
  #       name and overwrite args to point to those new columns, which would sidestep that
  #       restriction. This, however, would entail modifying the argument list in reactive
  #       time depending on the contents of the dataset, which would force mod_*_server to
  #       treat column name arguments as reactives. That seems too much of a hassle for little
  #       benefit.
  env_that_called_the_module_function <- parent.frame(2)
  args <- T_eval_args(args, eval_env = env_that_called_the_module_function)

  mapping_actions <- T_honor_map_to_flag_inner(datasets, mod_API, args,
    field_to_dataset_map = list(),
    current_field_name = "<module_API>"
  )[["actions"]]

  for (action in mapping_actions) {
    dataset <- action[["dataset"]]
    col <- action[["col"]]
    datasets[[dataset]][[col]] <- T_do_map(datasets, action)
  }

  return(datasets)
}

inline_shiny_input <- function(elem, label = NULL, name_selector = NULL, label_elem = NULL) {
  if (is.character(label) && length(label) == 1 && nchar(label) > 0) {
    label_elem <- shiny::tags$label(`for` = NULL, label)
  }

  res <- shiny::tags[["div"]](
    style = "display: flex; align-items: baseline; place-content: space-between; column-gap:1rem",
    label_elem, name_selector, elem
  )
  return(res)
}

enable_nicer_unnamed_multicolumn_selection <- TRUE
enable_nicer_multichoice_selection <- TRUE

color_picker_input <- function(inputId, value = NULL) {
  # https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color +
  # https://shiny.posit.co/r/articles/build/building-inputs/ +
  # https://forum.posit.co/t/bookmarking-custom-inputs/162483

  restored_value <- shiny::restoreInput(id = inputId, default = NULL)
  if (!is.null(restored_value)) value <- restored_value

  list(
    shiny::singleton(shiny::tags$head(
      shiny::tags$script(r"--(
        var color_picker_binding = new Shiny.InputBinding();
        $.extend(color_picker_binding, {
          find: function(scope) { return scope.querySelectorAll('.color-picker'); },
          getValue: function(el) { return el.value; },
          subscribe: function(el, callback) {
            $(el).on('change.color_picker_binding', function(e) { callback(); });
          },
          unsubscribe: function(el) { $(el).off('.color_picker_binding'); }
        });
        Shiny.inputBindings.register(color_picker_binding);
      )--")
    )),
    shiny::tags$input(
      id = inputId, class = "color-picker", type = "color", style = "border:none", value = value
    )
  )
}

# NOTE: selectInput does not preserve the order of columns on bookmark restoration
# (see https://github.com/rstudio/shiny/issues/1490, which predates trump's presidency)
#       Bonus: returns character(0) on empty selection to allow to distinguish it from NULL, which is
#              the value returned when the input is not present.
T_select_input <- function(inputId, label, choices, selected = NULL, multiple = FALSE) {
  res <- NULL
  if (multiple) {
    caller_respects_limitations <- (
      (is.null(choices) ||
        (is.character(choices) && all(nchar(choices)) > 0)) &&
        (is.character(selected) || is.null(selected))
    )
    if (!caller_respects_limitations) browser()
    stopifnot(caller_respects_limitations)

    shiny::registerInputHandler(
      type = "dressing_room.select_input", fun = function(msg, session, input_name) as.character(msg), force = TRUE
    )

    internal_id <- paste0(inputId, "_internal")
    selected <- shiny::restoreInput(id = internal_id, default = selected)

    initial_value <- paste("[", paste(sprintf("'%s'", selected), collapse = ", "), "]")

    res <- shiny::selectizeInput(
      inputId = internal_id, label = label, choices = choices, multiple = TRUE, selected = selected,
      options = list( # https://selectize.dev/docs/events
        onInitialize =
          I(sprintf(
            "function() { this.setValue(%s); Shiny.setInputValue('%s:dressing_room.select_input', %s); }",
            initial_value, inputId, initial_value
          )),
        onChange = I(sprintf("v => Shiny.setInputValue('%s:dressing_room.select_input', v)", inputId)),
        plugins = list("drag_drop", "remove_button")
      )
    )
  } else {
    res <- shiny::selectInput(inputId, label, choices, selected, selectize = FALSE)
  }
  return(res)
}

# Module explorer app ----
explorer_ui <- function() {
  panel <- function(...) {
    shiny::div(
      class = "panel panel-default",
      style = "background-color:#eff7ff;",
      shiny::div(class = "panel-body", style = "padding-bottom:0.5rem;", ...)
    )
  }

  ui <- shiny::fluidPage(
    fontawesome::fa_html_dependency(),
    shiny::tags$head(shiny::HTML("<title>Davinci's Module Dressing Room</title>")),

    # shamelessly stolen from https://github.com/insightsengineering/teal.modules.bsafe/blob/main/inst/www/bsafe.css
    # and https://github.com/insightsengineering/teal.modules.bsafe/blob/main/R/mod_bsafe.R
    shiny::tags$head(shiny::tags$style(shiny::HTML(r"--(
    .toggle-label .chevron:before {
      font-size: 2rem;
      display: inline-block;
      margin-left: 1rem;
      content:"\203A";
    }

    .toggle-checkbox:checked + .toggle-label .chevron:before {
      font-size: 2rem;
      display: inline-block;
      content:"\203A";
      transform: rotate(90deg);
    }

    .margin_bottom_0px { margin-bottom:0px; } /* Gen-X CSS */

    .inc_dec_button {background-color:#ffffffaa; border-radius:4px; border: 1px solid #000000aa; margin-bottom:14px;}
    .inc_dec_button:hover {background-color:#eeeeeeaa; border: 1px solid #000000ff}
    )--"))),
    shiny::div(style = "height:1.5rem"),
    shiny::sidebarLayout(
      shiny::div(
        class = "col-sm-3",
        panel(
          shiny::h4("DaVinci's Module Dressing Room",
            align = "center",
            style = "margin-top:0; margin-bottom:2rem; font-weight:bold"
          ),
          inline_shiny_input(
            shiny::selectInput(
              inputId = "spec", label = NULL,
              choices = names(module_specifications), selected = NULL,
              selectize = FALSE
            ),
            label_elem = shiny::tags$label(`for` = "spec", "Module", title = "Module to configure")
          ),
          shiny::uiOutput("data_input")
        ),
        panel(
          shiny::uiOutput("selectors")
        ),
      ),
      shiny::mainPanel(
        width = 9, style = "padding-left:0.5rem;",
        panel(
          shiny::conditionalPanel(
            condition = "input.edit_code == false",
            shiny::uiOutput("code")
          ),
          shiny::conditionalPanel(
            condition = "input.edit_code == true",
            shiny::tags$textarea(
              id = "manual_code",
              style = "width:100%; resize:vertical; height: 300px; font-family: 'Courier New', Courier, monospace;",
              class = "form-control"
            )
          ),
          shiny::checkboxInput("edit_code", "Edit code", value = FALSE)
        ),
        shiny::uiOutput("module")
      )
    )
  )

  return(ui)
}

message_well <- function(title, contents, color = "f5f5f5") {
  style <- sprintf(r"---(
    padding: 0.5rem;
    padding-left: 1rem;
    margin-bottom: 20px;
    background-color: %s;
    border: 1px solid #e3e3e3;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
    box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
  )---", color)

  res <- list(shiny::h3(title))
  if (length(contents)) res <- append(res, list(shiny::tags[["div"]](contents, style = style)))
  return(res)
}

# Solves https://github.com/rstudio/shiny/issues/825#issuecomment-496679761
observer_dedup <- local({
  # Evaluates `expr` under a reactive domain identified by `id` while keeping track of all observers created by it.
  # On repeated calls to this function, the old tracked observers are destroyed prior to evaluating `expr`.

  states <- list() # One state per `id`. Each state is an environment for mutation purposes.

  observer_dedup_func <- function(id, expr, session = shiny::getDefaultReactiveDomain(), verbose = FALSE) {
    # New state if unknown `id`
    if (!(id %in% names(states))) {
      states[[id]] <<- list2env(
        list(
          subdomain = list(end = function() NULL),
          captured_callbacks = list()
        ),
        parent = emptyenv()
      )
    }

    state <- states[[id]] # The only state that concerns us

    # Glorified append
    capture_callbacks <- function(callback) {
      return(state[["captured_callbacks"]][[length(state[["captured_callbacks"]]) + 1]] <<- callback)
    }

    make_scope_that_captures_callbacks <- function(namespace) {
      parent <- get("parent", envir = state[["subdomain"]])
      ns <- shiny::NS(namespace)
      scope <- parent$makeScope(namespace)
      overrides <- get("overrides", scope)
      overrides[["onEnded"]] <- capture_callbacks
      overrides[["makeScope"]] <- function(namespace) make_scope_that_captures_callbacks(ns(namespace))
      scope[["overrides"]] <- overrides
      return(scope)
    }

    invoke_and_remove_callbacks <- function() {
      for (cb in state[["captured_callbacks"]]) {
        if (verbose) {
          owner <- environment(cb)
          if (inherits(owner, "Observer")) {
            message(sprintf("Destroying observer %s %s", owner$.reactId, owner$.label))
          } else {
            browser()
          }
        }
        cb()
      }
      state[["captured_callbacks"]] <<- list()
    }

    state[["subdomain"]]$end() # Destroy tracked observers from the previous observer_dedup invocation
    state[["subdomain"]] <- shiny:::createSessionProxy( # Session that tracks observers even inside nested shiny modules
      session,
      makeScope = make_scope_that_captures_callbacks,
      onEnded = capture_callbacks,
      end = invoke_and_remove_callbacks
    )

    expr <- substitute(expr)
    env <- parent.frame()
    result <- shiny::withReactiveDomain(state[["subdomain"]], eval(expr, env))
    return(result)
  }
  return(observer_dedup_func)
})

explorer_server_with_datasets <- function(caller_datasets = NULL) {
  explorer_server <- function(input, output, session) {
    shiny::observe({
      input <- shiny::reactiveValuesToList(input)
      if ("module_id" %in% names(input)) { # FIXME: Should not depend on specific input
        session$doBookmark()
      }
    })
    shiny::onBookmarked(shiny::updateQueryString)

    datasets <- shiny::reactive({
      res <- caller_datasets
      if (is.null(res)) {
        dataset_info <- input[["datasets"]]
        shiny::req(dataset_info)
        res <- list()
        for (i_row in seq_len(nrow(dataset_info))) {
          row <- dataset_info[i_row, ]
          res[[row[["name"]]]] <- readRDS(row[["datapath"]])
        }
      }
      return(res)
    })

    well <- function(title_ui, contents, expanded, checkbox_id = NULL) {
      style <- r"---(
        min-height: 20px;
        padding: 19px;
        padding-top: 14px;
        padding-bottom: 0px;
        padding-right: 10px;
        margin-bottom: 20px;
        background-color: #1155a00c;
        border: 1px solid #00000020;
        border-radius: 4px;
      )---"

      checked <- if (isFALSE(expanded)) NULL else NA # awkward mapping, but HTML is what it is

      res <- list(
        shiny::div(
          title_ui,
          shiny::tags$input(
            id = checkbox_id, type = "checkbox", class = "toggle-checkbox",
            checked = checked, style = "display: none;"
          ),
          shiny::tags$label(
            `for` = checkbox_id, class = "toggle-label",
            shiny::tags$span(class = "chevron")
          ),
          style = "display:flex; align-items:baseline;"
        )
      )

      if (length(contents)) {
        res <- append(
          res,
          list(shiny::div(
            shiny::conditionalPanel(
              condition = paste0("input['", checkbox_id, "']"),
              shiny::tags[["div"]](contents, style = style)
            )
          ))
        )
      }

      return(res)
    }

    choices_from_dataset_and_columns <- function(datasets, dataset_slot, columns) {
      res <- NULL
      if (!is.null(dataset_slot) && length(columns)) {
        # Derive choices from dataset and columns
        dataset <- datasets[[dataset_slot]]
        if (length(columns) == 1) {
          col_data <- dataset[[columns]]
          if (is.factor(col_data)) {
            res <- levels(col_data)
          } else if (is.character(col_data)) {
            browser()
          } else if (is.numeric(col_data)) {
            res <- sort(unique(col_data))
          } else {
            browser()
          }
        } else {
          stopifnot(length(columns) > 1)
          browser() # TODO: Implement this: only present on mod_lineplot default_visit_val at the moment
        }
      }
      return(res)
    }

    column_selector <- function(elem, datasets, visible_datasets, visible_col_selectors, inputs, id, multiple) {
      dataset_name <- elem[["dataset_name"]]
      dataset_slot <- mget(dataset_name, envir = visible_datasets, ifnotfound = list(NULL), inherits = TRUE)[[1]]

      choices <- c()
      if (!is.null(dataset_slot)) {
        dataset <- datasets[[dataset_slot]]
        for (col_name in names(dataset)) {
          if (T_is_of_kind(dataset[[col_name]], elem[["sub_kind"]])) {
            label <- attr(dataset[[col_name]], "label")
            if (is.null(label)) {
              choices <- c(choices, col_name)
            } else {
              choices[[paste0(col_name, " [", label, "]")]] <- col_name
            }
          }
        }
      }

      if (length(choices) == 0) choices <- inputs[[id]]

      selected <- as.character(inputs[[id]])
      ui <- T_select_input(
        inputId = id, label = NULL, choices = as.character(choices), selected = selected, multiple = multiple
      )

      visible_col_selectors[[id]] <- list(dataset_slot = dataset_slot, columns = selected)

      return(ui)
    }

    compute_ui_info_inner <- function(visible_datasets, visible_col_selectors, label, name, elem, inputs, datasets, counts) {
      if (isTRUE(attr(elem, "ignore"))) {
        # NOTE: This element should have been filtered out at this point
        return(list(
          ui = shiny::p(paste("**FIXME: should have been ignored**", name)),
          input_ids = NULL, dependencies = list()
        ))
      }

      ui <- list()
      input_ids <- NULL
      deps <- list()

      if (elem[["kind"]] == "mod") {
        ui <- shiny::textInput(
          inputId = name, label = NULL, value = inputs[[name]],
          placeholder = "<shiny module ID>"
        )
        input_ids <- name
      } else if (elem[["kind"]] == "dataset_name") {
        ui <- shiny::selectInput(
          inputId = name, label = NULL,
          choices = names(datasets), selected = inputs[[name]],
          selectize = FALSE
        )

        if (!is.null(inputs[[name]]) && !is.null(label)) {
          visible_datasets[[label]] <- inputs[[name]]
        }
        input_ids <- name
        deps[[length(deps) + 1]] <- name # columns depend on datasets, so we ask for another pass
      } else if (elem[["kind"]] == "col") {
        ui <- column_selector(elem, datasets, visible_datasets, visible_col_selectors, inputs, name, multiple = FALSE)
        input_ids <- name
      } else if (elem[["kind"]] == "integer" || elem[["kind"]] == "numeric" ||
        elem[["kind"]] == "cdisc_study_day") {
        possible_values <- c(inputs[[name]], elem[["min"]], elem[["max"]], 0)
        value <- possible_values[which(is.finite(possible_values))[1]]

        ui <- shiny::numericInput(
          inputId = name, label = NULL, value = value,
          min = elem[["min"]], max = elem[["max"]], width = "5em"
        )
        input_ids <- name
      } else if (elem[["kind"]] == "color") {
        ui <- color_picker_input(inputId = name, value = inputs[[name]])
        input_ids <- name
      } else if (elem[["kind"]] == "group") {
        child_visible_datasets <- new.env(parent = visible_datasets)
        child_visible_col_selectors <- new.env(parent = visible_col_selectors)

        input_ids <- list()
        for (child_param in seq_along(elem$elements)) {
          child_name <- names(elem$elements)[[child_param]]
          child_elem <- elem[["elements"]][[child_param]]

          child_info <- compute_ui_info_outer(
            child_visible_datasets,
            child_visible_col_selectors,
            label = child_name,
            name = paste(c(name, child_name), collapse = "-"),
            child_elem, inputs, datasets, counts
          )

          ui[[length(ui) + 1]] <- child_info[["ui"]]
          input_ids[[child_name]] <- child_info[["input_ids"]]
          deps <- append(deps, child_info[["dependencies"]])
        }
      } else if (elem[["kind"]] == "choice_from_col_contents") {
        param <- elem$param
        deps <- c(deps, param)
        browser() # TODO
      } else if (elem[["kind"]] == "choice") {
        param <- elem$param
        choices <- visible_col_selectors[[param]][["columns"]]
        ui <- T_select_input(
          inputId = name, label = NULL, choices = as.character(choices), selected = as.character(inputs[[name]]),
          multiple = FALSE
        )
        input_ids <- name
        deps <- c(deps, param)
      } else {
        ui <- shiny::p(paste("TODO: ", elem[["kind"]]))
        input_ids <- list()
      }

      attr(input_ids, "as_array") <- attr(elem, "as_array")

      return(list(ui = ui, input_ids = input_ids, dependencies = deps))
    }

    # We use -/+ buttons instead of a shiny::numericInput because that clicking that selector twice in
    # quick succession triggers a race condition in the context of renderUIs that redraw the selector itself
    # Thus, we avoid representing the absolute number of elements and instead only capture the purpose of
    # incrementing or decrementing whatever value is stored on the server
    button_delta_id <- "button_delta"
    inc_dec_buttons <- function(id) {
      list(
        shiny::tags[["button"]](
          shiny::icon("minus"), class = "inc_dec_button",
          onclick = sprintf(
            "Shiny.setInputValue('%s', {id:'%s', delta:-1}, {priority:'event'});", button_delta_id, id
          )
        ),
        shiny::tags[["button"]](
          shiny::icon("plus"), class = "inc_dec_button",
          onclick = sprintf(
            "Shiny.setInputValue('%s', {id:'%s', delta:+1}, {priority:'event'});", button_delta_id, id
          )
        )
      )
    }

    # Bookmark shenanigans ----
    counts_rv <- shiny::reactiveValues()
    candidate_state <- NULL

    shiny::onBookmark(function(state) {
      state$values$counts <- shiny::reactiveValuesToList(counts_rv)
    })

    shiny::onRestored(function(state) {
      candidate_state <<- state$input
      counts <- state$values$counts
      for (name in names(counts)) counts_rv[[name]] <- counts[[name]]

      if (isTRUE(state$input[["edit_code"]])) {
        shiny::updateTextAreaInput(
          session = session, "manual_code",
          value = state$input[["manual_code"]]
        )
      }
    })

    retrigger_rv <- shiny::reactiveVal(0)
    shiny::observe({
      msg <- input[[button_delta_id]]
      if (!is.null(msg)) {
        id <- msg[["id"]]
        v <- shiny::isolate(counts_rv[[id]])
        new_v <- max(0, v + msg[["delta"]])
        counts_rv[[id]] <- new_v
        if (!identical(v, new_v)) retrigger_rv(shiny::isolate(retrigger_rv() + 1))
      }
    })

    hacky_select_input_align <- function(optional_ui, label, hover_info, ui) {
      label_elem <- list(shiny::tags$span(optional_ui,
        shiny::tags$label(`for` = NULL, label, title = hover_info),
        style = "display:inline-flex; align-items:baseline; padding-top:0.7rem;"
      ))

      ui <- shiny::tags[["div"]](
        style = "display: flex; align-items: flex-start; place-content: space-between; column-gap:1rem",
        label_elem, ui
      )
      return(ui)
    }

    compute_ui_info_outer <- function(visible_datasets, visible_col_selectors, label, name, elem, inputs, datasets, counts) {
      if (isTRUE(attr(elem, "ignore"))) {
        return(list(ui = NULL, input_ids = NULL, dependencies = NULL))
      } # NOTE: early out

      res <- NULL

      docs <- attr(elem, "docs")
      doc_pieces <- paste0("[", docs[["type"]], "]")
      if (nchar(docs[["manual_desc"]]) > 0) doc_pieces <- c(doc_pieces, docs[["manual_desc"]])
      if (length(docs[["auto_desc"]])) doc_pieces <- c(doc_pieces, paste(docs[["auto_desc"]], collapse = "\n"))

      hover_info <- paste(doc_pieces, collapse = "\n")

      dependencies <- list()

      optional_ui <- NULL
      if (isTRUE(attr(elem, "optional"))) {
        checkbox_id <- paste(c(name, "enabled"), collapse = "-")
        expanded <- isTRUE(inputs[[checkbox_id]])
        checked <- if (isFALSE(expanded)) NULL else NA # awkward mapping, but HTML is what it is
        checkbox <- list(shiny::tags$input(
          id = checkbox_id, type = "checkbox", class = "optional-checkbox",
          checked = checked, style = "margin-right:0.5rem;"
        ))

        dependencies <- c(dependencies, checkbox_id)
        if (expanded) {
          optional_ui <- checkbox
        } else {
          ui <- list(shiny::div(checkbox,
            shiny::tags$label(
              `for` = checkbox_id, label,
              style = "font-weight:normal;font-style:italic;margin-bottom:0px",
              title = hover_info
            ),
            style = "display:flex;align-items:baseline;padding-bottom:1rem;"
          ))

          return(list(ui = ui, input_ids = NULL, dependencies = dependencies)) # NOTE: early out
        }
      }

      named <- isTRUE(attr(elem, "named"))
      zero_or_more <- isTRUE(attr(elem, "zero_or_more"))
      one_or_more <- isTRUE(attr(elem, "one_or_more"))
      zero_or_one_or_more <- zero_or_more || one_or_more

      if (enable_nicer_unnamed_multicolumn_selection && zero_or_one_or_more && !named && elem$kind == "col") {
        # NOTE: special-case with a multiselector for a more streamlined interface
        ui <- column_selector(elem, datasets, visible_datasets, visible_col_selectors, inputs, name, multiple = TRUE)
        input_ids <- name

        ui <- hacky_select_input_align(optional_ui, label, hover_info, ui)

        res <- list(ui = ui, input_ids = input_ids, dependencies = dependencies)
      } else if (enable_nicer_multichoice_selection && zero_or_one_or_more && elem$kind == "choice_from_col_contents") {
        param <- elem$param

        choices <- character(0)
        info <- visible_col_selectors[[param]]
        if (length(info[["columns"]])) {
          choices <- choices_from_dataset_and_columns(
            datasets, info[["dataset_slot"]], info[["columns"]] # TODO(miguel): Try datasets[[dataset_slot]] instead
          )
        }

        ui <- T_select_input(
          inputId = name, label = NULL, choices = as.character(choices), selected = as.character(inputs[[name]]),
          multiple = TRUE
        )
        input_ids <- name

        ui <- hacky_select_input_align(optional_ui, label, hover_info, ui)

        dependencies <- c(dependencies, param)

        res <- list(ui = ui, input_ids = input_ids, dependencies = dependencies)
      } else if (zero_or_one_or_more) {
        attr(elem, "zero_or_more") <- FALSE
        attr(elem, "one_or_more") <- FALSE

        input_ids <- list()

        possible_values <- c(counts[[name]], 0)
        count <- possible_values[which(is.finite(possible_values))[1]]

        counts_rv[[name]] <- ifelse(name %in% names(counts), counts[[name]], 0)

        sub_ui <- list()

        name_input_ids <- character(0)
        for (i_rep in seq_len(count)) {
          child_name <- paste0(name, "-", i_rep)

          name_selector <- NULL

          if (named) {
            name_sel_id <- paste0(child_name, "-name")
            name_input_ids <- c(name_input_ids, name_sel_id)
            name_selector <- shiny::textInput(
              inputId = name_sel_id, label = NULL,
              value = inputs[[name_sel_id]], placeholder = "<name>"
            )
          }

          child_info <- compute_ui_info_inner(
            visible_datasets, visible_col_selectors,
            label = NULL, child_name, elem,
            inputs, datasets, counts
          )
          child_ui <- child_info[["ui"]]

          if (elem$kind == "group") { # repeats #eenahw partially; not ready to compress it yet
            child_ui <- list(well(
              title_ui = name_selector, child_ui,
              expanded = inputs[[child_name]],
              checkbox_id = child_name
            ))
          } else {
            child_ui <- list(inline_shiny_input(child_ui, label = NULL, name_selector = name_selector))
          }

          sub_ui <- append(sub_ui, child_ui)
          input_ids <- append(input_ids, list(child_info[["input_ids"]]))
          dependencies <- append(dependencies, child_info[["dependencies"]])
        }
        sub_ui <- append(sub_ui, inc_dec_buttons(name))

        title_ui <- list(optional_ui, shiny::tags$label(`for` = name, class = "chevron", label, title = hover_info))
        ui <- list(well(title_ui, sub_ui, expanded = inputs[[name]], name))

        if (named) {
          attr(input_ids, "name_input_ids") <- name_input_ids
        }

        attr(input_ids, "as_array") <- attr(elem, "as_array")

        res <- list(ui = ui, input_ids = input_ids, dependencies = dependencies)
      } else {
        res <- compute_ui_info_inner(visible_datasets, visible_col_selectors, label, name, elem, inputs, datasets, counts)
        res[["dependencies"]] <- c(dependencies, res[["dependencies"]])

        if (elem$kind == "group") { # repeats #eenahw partially; not ready to compress it yet
          title_ui <- list(optional_ui, shiny::tags$label(`for` = name, class = "chevron", label, title = hover_info))
          res[["ui"]] <- list(well(title_ui, res[["ui"]],
            expanded = inputs[[name]],
            checkbox_id = name
          ))
        } else {
          if (!is.null(optional_ui)) {
            res[["ui"]] <- list(inline_shiny_input(
              res[["ui"]],
              label_elem = list(shiny::tags$span(optional_ui,
                shiny::tags$label(`for` = NULL, label, title = hover_info),
                style = "display:inline-flex; align-items:baseline;"
              ))
            ))
          } else {
            res[["ui"]] <- list(
              shiny::tags[["div"]](style = "display: flex; align-items: baseline; place-content: space-between; column-gap:1rem",
                shiny::div(shiny::tags$label(`for` = NULL, label), style = "display:inline-flex;", title = hover_info), res[["ui"]]
              )
            )
          }
        }
      }

      return(res)
    }

    ui_and_ids <- shiny::reactive({
      ui <- list()
      input_ids <- list()
      deps <- list()

      selected_spec <- input[["spec"]]
      shiny::req(selected_spec)
      datasets <- datasets()

      inputs <- shiny::isolate(shiny::reactiveValuesToList(input))
      if (!is.null(candidate_state)) {
        inputs <- candidate_state
        candidate_state <<- NULL
      }

      visible_datasets <- new.env(parent = emptyenv())
      visible_col_selectors <- new.env(parent = emptyenv())
      spec_elements <- module_specifications[[selected_spec]]

      counts <- shiny::isolate(shiny::reactiveValuesToList(counts_rv))
      info <- shiny::maskReactiveContext(
        compute_ui_info_inner(visible_datasets, visible_col_selectors, "placeholder_label", name = NULL, spec_elements, inputs, datasets, counts)
      )
      ui <- info[["ui"]]
      input_ids <- info[["input_ids"]]
      deps <- info[["dependencies"]]

      for (dep in deps) input[[dep]] # makes this reactive depend only on certain inputs
      retrigger_rv()

      return(list(ui = ui, input_ids = input_ids))
    })

    output[["selectors"]] <- shiny::renderUI(ui_and_ids()[["ui"]])

    output[["data_input"]] <- shiny::renderUI({
      ui <- NULL
      if (is.null(caller_datasets)) {
        # no caller datasets: ask the user for some
        ui <- shiny::tagList(
          # Hacky alignment of fileInput
          shiny::tags[["div"]](
            style = "display: flex; align-items: flex-start; place-content: space-between; column-gap:1rem",
            shiny::tags$label(
              `for` = "datasets", "Datasets", style = "padding-top: 0.7rem;",
              title = "Input datasets for selected module"
            ),
            shiny::fileInput(
              inputId = "datasets", label = NULL, multiple = TRUE, accept = ".rds",
              capture = NULL
            )
          )
        )
      } else {
        ui <- shiny::HTML(sprintf("<b>Preloaded datasets:</b> %s", paste(names(caller_datasets), collapse = ", ")))
      }

      return(ui)
    })

    indent <- function(code, level) {
      indent_string <- strrep("  ", max(0, level))
      return(paste0(indent_string, code))
    }

    resolve_rhs <- function(id, parent_indent_level) {
      res <- ""
      if (is.character(id) && length(id) == 1) {
        param_value <- input[[id]]
        res <- deparse1(param_value)
      } else if (is.list(id)) {
        subres <- c()

        elem_names <- local({
          res <- names(id)
          name_input_ids <- attr(id, "name_input_ids")
          if (length(name_input_ids) > 0) {
            res <- Map(function(id) {
              s <- input[[id]]
              if (identical(s, "")) {
                s <- NULL
              } else {
                s <- deparse(s)
              }
            }, name_input_ids)
          }
          return(res)
        })

        for (i_elem in seq_along(id)) {
          name <- NULL
          if (i_elem <= length(elem_names)) name <- elem_names[[i_elem]]
          if (identical(name, "")) name <- NULL
          subres <- c(
            subres,
            paste(c(name, resolve_rhs(id[[i_elem]], parent_indent_level + 1)), collapse = " = ")
          )
        }

        as_array <- isTRUE(attr(id, "as_array"))
        container <- ifelse(as_array, "c", "list")

        res <- ""
        if (length(subres)) {
          res <- paste0(
            container,
            "(\n",
            paste(subres |> indent(parent_indent_level + 1), collapse = ",\n"),
            "\n",
            ")" |> indent(parent_indent_level)
          )
        } else {
          res <- paste0(res, container, "()")
        }
      } else {
        res <- "TODO"
      }
      return(res)
    }

    code <- shiny::reactive({
      selected_spec <- input[["spec"]]
      t <- paste0(selected_spec, "(\n")

      params <- local({
        res <- c()
        ids <- ui_and_ids()[["input_ids"]]

        missing_ids <- setdiff(ids, shiny::isolate(names(input)))
        for(id in missing_ids) input[[id]] # depend on missing expected inputs
        shiny::req(length(missing_ids) == 0) # but block execution until all inputs exist

        for (i_val in seq_along(ids)) {
          param_name <- names(ids)[[i_val]]
          id <- ids[[i_val]]
          res <- c(
            res,
            paste(c(param_name, resolve_rhs(id, parent_indent_level = 1)), collapse = " = ") |> indent(1)
          )
        }
        return(res)
      })

      t <- paste0(t, paste(params, collapse = ",\n"))
      t <- paste0(t, "\n)")

      # NOTE(miguel): If you want to plug your own styler, here would be a good place to do so. Here's an (ugly) example:
      # t <- sapply(parse(text = t), function(s) deparse1(s, collapse = '\n', width.cutoff = 80L)) # nolint

      return(t)
    })

    code_highlight_differences <- function(a, b) {
      # FIXME(miguel): Not the correct place to do this operation. We could have the parse tree prior to rendering it as
      #                text, so a tree comparison would be less heuristic. That would involve building a nested list
      #                inside code()+resolve_rhs, which we would also use here. Producing the indented code from that
      #                nested list would also be cleaner than the ad-hoc formatting I do in the `code()` reactive, but...
      # NOTE(miguel):  we're in a hurry, so look ma, no hands:

      drop_trailing_comma <- function(strings) {
        return(substr(strings, 1, nchar(strings) - endsWith(strings, ",")))
      }

      as <- strsplit(a, "\n", fixed = TRUE)[[1]] |> drop_trailing_comma()
      bs <- strsplit(b, "\n", fixed = TRUE)[[1]]
      res <- character(0)
      for (e in bs) {
        indices <- which(drop_trailing_comma(e) == as)
        if (length(indices)) {
          as <- as[-indices[[1]]]
        } else {
          e <- paste0("<strong>", e, "</strong>")
        }
        res <- c(res, e)
      }
      return(paste(res, collapse = "\n"))
    }

    prev_code_update_delay_s <- 3 # TODO: constant
    prev_code <- prev_diffed_code <- ""
    prev_code_t <- Sys.time()

    output[["code"]] <- shiny::renderUI({ # TODO: Add 'copy' icon, like the ones on code snippets on vignettes
      code <- code()

      code <- gsub("&", "&amp;", code, fixed = TRUE, useBytes = TRUE)
      code <- gsub("<", "&lt;", code, fixed = TRUE, useBytes = TRUE)
      code <- gsub(">", "&gt;", code, fixed = TRUE, useBytes = TRUE)

      t_current <- Sys.time()
      t_diff <- as.numeric(difftime(t_current, prev_code_t, units = "secs"))
      if (prev_code_update_delay_s <= t_diff) prev_diffed_code <<- prev_code
      prev_code <<- code
      prev_code_t <<- t_current

      code_to_print <- code
      if (!identical(prev_diffed_code, code)) code_to_print <- code_highlight_differences(prev_diffed_code, code)

      res <- shiny::HTML(paste0(
        "<pre><code style='white-space: pre;'>",
        code_to_print,
        "</code></pre>"
      ))

      return(res)
    })

    shiny::observeEvent(input[["edit_code"]], {
      if (isTRUE(input[["edit_code"]])) {
        shiny::updateTextAreaInput(session = session, "manual_code", value = code())
      }
    })


    error_and_ui_rv <- shiny::reactiveValues(ui = list(), error = NULL)

    # To avoid having multiple instances of the underlying reactive server running, we use
    # this pattern. It relies on the createMockDomain internal shiny function, but it was
    # recommended by Winston Chang back in this 2015 still open thread:
    # https://github.com/rstudio/shiny/issues/825#issue-75758069
    # https://github.com/rstudio/shiny/issues/825
    # https://github.com/rstudio/shiny/blame/main/R/reactive-domains.R
    #
    # See also #eecohg further down
    #
    #  Using this code fails with a
    # "session must be a ShinySession or session_proxy object."
    #  around:
    # > callModule(module, id, session = session)
    #  so either I'm doing something wrong or createMockDomain is no longer enough to
    #  fake a shiny session
    #
    shiny::observe({
      code_to_eval <- NULL
      if (isTRUE(input[["edit_code"]])) {
        code_to_eval <- input[["manual_code"]]
        shiny::req(is.character(code_to_eval))
      } else {
        code_to_eval <- trimws(code())
      }

      get_package_maintainer_name <- function() {
        package_name <- strsplit(input[["spec"]], split = "::", fixed = TRUE)[[1]][[1]]
        desc <- utils::packageDescription(package_name)[["Maintainer"]]
        if (is.character(desc) && length(desc) == 1 && nchar(desc) > 0) {
          desc <- paste0("`", desc, "`")
        } else {
          # NOTE: Available after installing from source, but not under devtools
          desc <- "the package maintainer"
        }
        return(desc)
      }

      error_and_ui <- local({
        ui <- NULL

        spec <- input[["spec"]]

        build_error <- function(title, condition, preface, ui = NULL) {
          return(list(error = list(title = title, condition = condition, preface = preface), ui = ui))
        }

        if (!is.character(spec) || nchar(input[["spec"]]) == 0) {
          return(build_error(
            title = "Module selection error",
            condition = base::simpleError("No DaVINCI module selected on the `Module` drop-down."),
            preface = "Module selection error"
          )) # FIXME: repeats message
        }

        if (!startsWith(code_to_eval, spec)) {
          return(build_error(
            title = "Module configuration error",
            condition = base::simpleError(paste("Expected call to", spec)),
            preface = "Module configuration error"
          )) # FIXME: repeats message
        }

        # FIXME(miguel): We should parse and evaluate arguments separately outside of a reactive environment
        #                to see if any of them is badly constructed, but here I take a shortcut and evaluate
        #                them all inside a list()
        list_of_args <- paste0("list", substr(code_to_eval, nchar(input[["spec"]]) + 1, nchar(code_to_eval)))
        parsed_code <- try(parse(text = list_of_args), silent = TRUE)
        eval_result <- try(eval(parsed_code), silent = TRUE)
        if (inherits(eval_result, "try-error")) {
          attr(eval_result, "condition")[["call"]][[1]] <- parse(text = spec)[[1]] # undo the spec->`list` substitution
          return(build_error(
            title = "Syntax error",
            condition = attr(eval_result, "condition"),
            preface = "Cannot parse the code provided."
          ))
        }

        # NOTE(miguel): With that out of the way, this shouldn't fail but I keep it just in case
        parsed_code <- try(parse(text = code_to_eval), silent = TRUE)
        if (inherits(parsed_code, "try-error")) {
          return(build_error(
            title = "Syntax error",
            condition = attr(parsed_code, "condition"),
            preface = "Cannot parse the code provided."
          ))
        }

        ui_server_id <- try(eval(parsed_code), silent = TRUE)
        shiny::req(!is.null(ui_server_id))
        if (inherits(ui_server_id, "try-error")) {
          return(build_error(
            title = "Module Development Error",
            condition = attr(ui_server_id, "condition"),
            preface = paste0("Please report the following error to ", get_package_maintainer_name(), ".")
          ))
        }

        if (!setequal(c("ui", "server", "module_id"), names(ui_server_id))) {
          return(build_error(
            title = "Module Configuration Error",
            condition = base::simpleError("The provided code does not return a {ui, server, module_id} triplet."),
            preface = paste0("Are you actually calling ", input[["spec"]], "?")
          ))
        }

        id <- ui_server_id[["module_id"]]
        if (is.function(ui_server_id[["ui"]])) ui <- ui_server_id[["ui"]](id)

        afmm <- list(
          unfiltered_dataset = datasets,
          filtered_dataset = datasets,
          module_output = function() list()
        )

        # Executes server on a separate reactive domain and destroys its observers when reinvoked
        server_return_val <- observer_dedup(
          id = "unique_dedup_id",
          ui_server_id[["server"]](afmm),
          session = session
        )

        if (inherits(server_return_val, "try-error")) {
          return(build_error(
            title = "Module Development Error",
            condition = attr(server_return_val, "condition"),
            preface = paste0("Please report the following error to ", get_package_maintainer_name(), "."),
            ui = ui
          ))
        }

        return(list(ui = ui))
      })

      error_and_ui_rv[["ui"]] <- error_and_ui[["ui"]]
      error_and_ui_rv[["error"]] <- error_and_ui[["error"]]
    })

    output[["module"]] <- shiny::renderUI({
      ui <- error_and_ui_rv[["ui"]]
      error <- error_and_ui_rv[["error"]]

      if (!is.null(error)) {
        error_message <- error$condition[["message"]]
        error_context <- paste(deparse(error$condition[["call"]]), collapse = "\n")

        ui <- list(
          message_well(error$title, error$preface, color = "#f4d7d7"),
          shiny::p("Message is:"),
          shiny::pre(error_message),
          shiny::p("And happened in the vicinity of:"),
          shiny::pre(error_context),
          shiny::div(ui, style = "visibility:hidden;") # does not remove ui from layout
        )
      }

      return(ui)
    })

    NULL
  }

  return(explorer_server)
}

# TODO: Export when finished

# Interactive module demo/configuration tool
#
# Launch an interactive configuration app for [mod_patient_profile()]. This application guides the user through the
# configuration of the module, offering an experimental point-and-click interface to the module API. Help is accessible
# by hovering over any of the provided parameters. \cr
# To try it using demo data, run `dv.explorer.parameter::explorer_app(dv.explorer.parameter:::safety_data())` in your R prompt.

#
# @param datasets `[list(data.frame(n))]` (optional) Datasets available to the module. One of them should be a
# demographic subject-level dataset and the rest should be visit-dependent datasets. If not provided, the UI offers a
# file input selector that is functionally equivalent.
#
explorer_app <- function(datasets = NULL) {
  shiny::shinyApp(
    ui = explorer_ui,
    server = explorer_server_with_datasets(caller_datasets = datasets),
    enableBookmarking = "url"
  )
}

app_creator_feedback_ui <- function(id) {
  id <- paste(c(id, "validator"), collapse = "-")
  ns <- shiny::NS(id)
  return(shiny::uiOutput(ns("ui")))
}

app_creator_feedback_server <- function(id, warning_messages, error_messages, ui) {
  id <- paste(c(id, "validator"), collapse = "-")
  module <- shiny::moduleServer(
    id,
    function(input, output, session) {
      output[["ui"]] <- shiny::renderUI({
        res <- list()
        warn <- warning_messages()
        if (length(warn)) {
          res[[length(res) + 1]] <- message_well("Module configuration warnings", Map(shiny::p, warn), color = "#fff7ef")
        }

        err <- error_messages()
        if (length(err)) {
          res[[length(res) + 1]] <- message_well("Module configuration errors", Map(shiny::p, err), color = "#f4d7d7")
        }

        if (length(error_messages()) == 0) res <- append(res, list(ui()))
        return(res)
      })
      shiny::outputOptions(output, "ui", suspendWhenHidden = FALSE)
    }
  )

  return(module)
}

# Ad-hoc "C_"hecks system ----

# Wrap the UI and server of a module so that, once parameterized, they go through a check function prior to running.
# The check function resides in `C_check_call[[namespaced_mod_name]]`.
# That function could be generated on the fly from the module API specification, but we go to the trouble of storing it
# as text inside the package so that its easy to step through and read.
C_module <- function(module) {
  where <- function(name, env = parent.frame()) { # lifted from http://adv-r.had.co.nz/Environments.html
    res <- NULL
    if (identical(env, emptyenv())) {
      stop("Can't find ", name, call. = FALSE)
    } else if (exists(name, envir = env, inherits = FALSE)) {
      res <- env
    } else {
      res <- where(name, parent.env(env))
    }
    return(res)
  }

  mandatory_module_args <- local({
    args <- formals(module)
    names(args)[sapply(args, function(x) is.name(x) && nchar(x) == 0)]
  })

  wrapper <- function(...) {
    args <- as.list(match.call())

    missing_args <- setdiff(mandatory_module_args, names(args[-1]))

    module_ui <- function(...) list()
    module_server <- function(...) NULL
    module_id <- ""
    if (length(missing_args) == 0) {
      evaluated_module <- do.call(module, args[-1]) # First arg is the function call, rest are the args
      module_ui <- evaluated_module[["ui"]]
      module_server <- evaluated_module[["server"]]
      module_id <- evaluated_module[["module_id"]]
    }

    namespaced_mod_name <- deparse(args[[1]])
    if (!grepl("::", namespaced_mod_name, fixed = TRUE)) { # TODO: Too hacky?
      namespaced_mod_name <- paste0(where("mod_corr_hm")[[".packageName"]], "::", namespaced_mod_name)
    }

    # TODO: If at some point all `unfiltered_dataset`s become available in a non-reactive form, we could do all checks
    #       prior to reactive time to have fewer moving parts. All `shiny::reactive`s from here until the end of the
    #       function would evaporate.

    res <- list(
      ui = function(module_id) app_creator_feedback_ui(module_id), # `module` UI gated by app_creator_feedback_server
      server = function(afmm) {
        fb <- shiny::reactive({
          res <- NULL
          if (length(missing_args)) {
            res <- list(
              warnings = character(0),
              errors = sprintf("Missing mandatory argument `%s`.", missing_args)
            )
          } else {
            # NOTE: We check the call here and not inside the module server function because:
            #       - app creators interact with the davinci module and not with the ui-server combo, so
            #         errors reported with respect to the module signature will make sense to them.
            #         The module server function might use a different function signature.
            #       - Here we also have access to the unfiltered dataset, which allows us to ensure call
            #         correctness independent of filter state or operation.
            #         Also, as long as the unfiltered dataset does not change (and to date no davinci app
            #         changes it dynamically) this check only runs once at the beginning of the application
            #         and has no further impact on performance.
            #       - "catch errors early"

            # Overwrite first "argument" (the function call, in fact) with the datasets provided to module manager
            names(args)[[1]] <- "datasets"
            args[[1]] <- shiny::isolate(afmm[["unfiltered_dataset"]]())

            # Prepend afmm to args to allow checking receiver_ids
            args <- append(list(afmm = afmm), args)

            check_call_function <- C_check_call[[namespaced_mod_name]]
            if (!is.function(check_call_function)) sprintf("Missing C_check_call function: %s", namespaced_mod_name)

            # check functions do not have defaults, so we extract them from the formals of the module for consistency
            missing_args <- setdiff(names(formals(module)), names(args))
            args <- c(args, formals(module)[missing_args])
            res <- do.call(check_call_function, args)
          }
          return(res)
        })

        fb_warn <- shiny::reactive(fb()[["warnings"]])
        fb_err <- shiny::reactive(fb()[["errors"]])

        app_creator_feedback_server(
          id = module_id, warning_messages = fb_warn, error_messages = fb_err,
          ui = shiny::reactive(module_ui(module_id))
        )

        # TODO: Modify afmm to the `map_to` flags in the API. `dv.papo` relies on this
        if (FALSE) {
          filtered_mapped_datasets <- shiny::reactive(
            T_honor_map_to_flag(afmm$filtered_dataset(), mod_lineplot_API, args)
          )

          bm_dataset <- shiny::reactive({
            shiny::req(bm_dataset_name)
            ds <- filtered_mapped_datasets()[[bm_dataset_name]]
            shiny::validate(
              shiny::need(!is.null(ds), paste("Could not find dataset", bm_dataset_name))
            )
            return(ds)
          })

          # TODO:
          corr_hm_server(
            id = module_id,
            bm_dataset = bm_dataset,
            default_value = default_value, subjid_var = subjid_var, cat_var = cat_var, par_var = par_var,
            visit_var = visit_var, value_vars = value_vars
          )
        }

        res <- shiny::reactive({
          res <- NULL
          fb <- fb()
          if (length(fb[["errors"]]) == 0) {
            res <- try(module_server(afmm), silent = TRUE)
          }
        })
        return(res())
      },
      module_id = module_id
    )

    return(res)
  }

  return(wrapper)
}

C_container <- function() list2env(x = list(messages = character(0)), parent = emptyenv())
C_assert <- function(container, cond, msg) {
  ok <- isTRUE(cond)
  if (!ok) container[["messages"]] <- c(container[["messages"]], msg)
  return(ok)
}

C_is_valid_shiny_id <- function(s) grepl("^$|^[a-zA-Z][a-zA-Z0-9_-]*$", s)

C_generate_check_function <- function(spec) {
  stopifnot(spec$kind == "group")

  res <- character(0)
  push <- function(s) res <<- c(res, s)
  push("function(afmm, datasets,")
  param_names <- paste(names(spec$elements), collapse = ",")
  push(param_names)
  push(", warn, err){\n")

  push("OK <- logical(0)\n")
  push("used_dataset_names <- new.env(parent = emptyenv())\n")

  for (elem_name in names(spec$elements)) {
    elem <- spec$elements[[elem_name]]
    attrs <- setdiff(names(attributes(elem)), c("names", "docs"))

    if (elem$kind == "mod") {
      push(sprintf("OK[['%s']] <- C_check_module_id('%s', %s, warn, err)\n", elem_name, elem_name, elem_name))
    } else if (elem$kind == "dataset_name") {
      push(sprintf(
        "OK[['%s']] <- C_check_dataset_name('%s', %s, datasets, used_dataset_names, warn, err)\n",
        elem_name, elem_name, elem_name
      ))
    } else if (elem$kind == "col") {
      push(sprintf("subkind <- %s\n", deparse(elem$sub_kind) |> paste(collapse = "")))
      push(sprintf("flags <- %s\n", deparse(attributes(elem)[attrs]) |> paste(collapse = "")))
      push(sprintf(
        "OK[['%s']] <- OK[['%s']] && C_check_dataset_colum_name('%s', %s, subkind, flags, %s, datasets[[%s]], warn, err)\n",
        elem_name, elem$dataset_name, elem_name, elem_name, elem$dataset_name, elem$dataset_name
      ))
    } else if (elem$kind == "choice_from_col_contents") {
      dataset_param_name <- spec$elements[[elem$param]]$dataset_name
      push(sprintf("flags <- %s\n", deparse(attributes(elem)[attrs]) |> paste(collapse = "")))
      push(sprintf(
        "OK[['%s']] <- OK[['%s']] && C_check_choice_from_col_contents('%s', %s, flags, '%s', datasets[[%s]], %s, warn, err)\n", 
        elem_name, elem$param, elem_name, elem_name, dataset_param_name, dataset_param_name, elem$param)
      )
    } else if (elem$kind == "choice") {
      push(sprintf("flags <- %s\n", deparse(attributes(elem)[attrs]) |> paste(collapse = "")))
      push(sprintf(
        "OK[['%s']] <- OK[['%s']] && C_check_choice('%s', %s, flags, '%s', %s, warn, err)\n", 
        elem_name, elem$param, elem_name, elem_name, elem$param, elem$param)
      )
    } else {
      push(sprintf("'TODO: %s (%s)'\n", elem_name, elem$kind))
    }
  }


  push(sprintf("return(OK)\n"))

  push("}\n")

  return(res)
}

# NOTE: For the moment call by running: devtools::load_all(); C_generate_check_functions()
C_generate_check_functions <- function(specs = module_specifications, output_file = "R/check_call_auto.R") {
  styler_off <- "({\n# styler: off"
  styler_on <- "\n\n})\n# styler: on\n"

  res <- c("# Automatically generated module API check functions. Think twice before editing them manually.\n")
  res <- c(res, styler_off)

  style_code <- function(code) {
    s <- paste(code, collapse = "")
    s <- parse(text = s, keep.source = FALSE)[[1]] |>
      deparse(width.cutoff = 100) |>
      trimws("right") |>
      paste(collapse = "\n")
    return(s)
  }

  for (spec_name in names(specs)) {
    if (!grepl("::", spec_name, fixed = TRUE)) stop(paste("Expected API spec name to be namespaced (`::`):", spec_name))
    denamespaced_spec_name <- strsplit(spec_name, "::")[[1]][[2]]
    check_function_name <- paste0("check_", denamespaced_spec_name, "_auto")
    res <- c(res, sprintf("\n\n# %s\n", spec_name))
    res <- c(
      res,
      c(check_function_name, "<-", C_generate_check_function(specs[[spec_name]])) |> style_code()
    )
  }

  res <- c(res, styler_on)

  contents <- paste(res, collapse = "")
  writeChar(contents, output_file, eos = NULL)

  return(NULL)
}

C_test_string <- function(s) {
  is.character(s) && length(s) == 1
}

C_check_module_id <- function(name, value, warn, err) {
  C_assert(err, C_test_string(value), sprintf("`%s` should be a string", name)) &&
    C_assert(warn, nchar(value) > 0, sprintf("Consider providing a non-empty `%s`.", name)) &&
    C_assert(
      err,
      C_is_valid_shiny_id(value),
      paste(
        sprintf("`%s` should be a valid identifier, starting with a letter and followed by", name),
        "alphanumeric characters, hyphens and underscores"
      )
    )
}

C_check_dataset_name <- function(name, value, available_datasets, used_dataset_names, warn, err) {
  ok <- (
    C_assert(err, !missing(value), sprintf("`%s` missing", name)) && # TODO: ? Remove this one
      C_assert(
        err,
        C_test_string(value) &&
          value %in% names(available_datasets),
        paste(
          sprintf("`%s` should be a string referring to one of the available datasets: ", name),
          paste(sprintf('"%s"', names(available_datasets)), collapse = ", "), "."
        )
      )
  )
  if (ok) used_dataset_names[[name]] <- value
  return(ok)
}

C_list_columns_of_kind <- function(dataset, type) {
  res <- names(dataset)[sapply(seq_len(ncol(dataset)), function(x) T_is_of_kind(dataset[[x]], type))]
  return(res)
}

C_check_dataset_colum_name <- function(name, value, subkind, flags, dataset_name, dataset_value, warn, err) {
  ok <- FALSE

  valid_column_names <- C_list_columns_of_kind(dataset_value, subkind)

  zero_or_more <- isTRUE(flags[["zero_or_more"]])
  one_or_more <- isTRUE(flags[["one_or_more"]])
  zero_or_one_or_more <- zero_or_more || one_or_more
  if (zero_or_one_or_more) {
    min_len <- 0
    if (one_or_more) min_len <- 1
    ok <- C_assert(
      err,
      is.character(value) &&
        all(value %in% valid_column_names) &&
        length(value) >= min_len,
      paste(
        sprintf(
          "`%s` should be a character vector of length greater than %s referring to one of the following columns of dataset `%s`: ",
          name, c("zero", "one")[[min_len + 1]], dataset_name
        ),
        paste(sprintf('"%s"', valid_column_names), collapse = ", "), "."
      )
    )
  } else {
    ok <- C_assert(
      err,
      C_test_string(value) &&
        all(value %in% valid_column_names),
      paste(
        sprintf("`%s` should be a string referring to one of the following columns of dataset `%s`: ", name, dataset_name),
        paste(sprintf('"%s"', valid_column_names), collapse = ", "), "."
      )
    )
  }
  return(ok)
}

C_list_values <- function(v) {
  res <- ''
  if(is.factor(v)) res <- sprintf('"%s"', levels(v))
  else if(is.character(v)) res <- sprintf('"%s"', unique(v))
  else browser()
  
  res <- paste(res, collapse = ", ")
  
  return(res)
}

C_check_length <- function(name, value, flags, warn, err) {
  ok <- FALSE
  if(isTRUE(flags[["optional"]]) && is.null(value)) {
    ok <- TRUE
  } else {
    min_len <- max_len <- 1L
    if(isTRUE(flags[["zero_or_more"]])){
      min_len <- 0L
      max_len <- +Inf
    } else if(isTRUE(flags[["one_or_more"]])) { 
      min_len <- 1L
      max_len <- +Inf
    }

    ok <- C_assert(err, min_len <= length(value) && length(value) <= max_len,
                   ifelse(min_len < max_len,
                          sprintf("`%s` has length %s but should have length in the range [%s, %s].",
                                  name, length(value), min_len, max_len),
                          sprintf("`%s` has length %s but should have length %s.",
                                  name, length(value), min_len))
    )

  }
  return(ok)
}

C_check_choice_from_col_contents <- function(name, value, flags, dataset_name, dataset_value, column, warn, err) {
  ok <- C_check_length(name, value, flags, warn, err) &&
    C_assert(err, all(value %in% dataset_value[[column]]), 
             sprintf("`%s` should contain only values present in column `%s` of dataset `%s`: %s.", 
                     name, column, dataset_name, C_list_values(dataset_value[[column]])))
  
  return(ok)
}

C_check_choice <- function(name, value, flags, values_name, values, warn, err) {
  ok <- C_check_length(name, value, flags, warn, err) &&
    C_assert(err, all(value %in% values), 
             sprintf("`%s` should contain only the following values: %s.", 
                     name, C_list_values(values)))

  return(ok)
}
