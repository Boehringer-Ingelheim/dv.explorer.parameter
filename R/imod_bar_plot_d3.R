BARD3 <- pack_of_constants( # nolint
  D3_CONTAINER = "d3_container",
  D3_BAR = "d3_bar"
)

#' D3 bar plot
#'
#' Plot the contents of a dataframe as a bar plot, with optional legend, palette and alignment margins.
#'
#'
#' @details This plot always include the value 0 as baseline.
#'
#' *msg func* contains a string containing JS code. When evaluated, this string will be evaluated in the client
#' and must return a function that receives a single parameter. That parameter will contain a JS object with the same
#' fields as columns in *data* for the point being hovered.
#'
#' @param id Shiny ID `[character(1)]`
#'
#' @param data `[data.frame() | shiny::reactive(data.frame) | shinymeta::metaReactive(data.frame)]`
#'
#' dataframe to plot. It expects the following format:
#'
#'  - columns names are "x", "y", "z" and, optionally, "label" and "color"
#'
#'  - There is one entry for each "x" present in the dataset.
#'     In other words, the values for each bar are defined explicitly, even if they are NA
#'
#'  - Axis labels and legend title are stored as the attribute "label" of the "x", "y" and "z" columns. (Legend title
#' is not implemented yet)
#'
#'  - "x" is a factor. The order of the levels dictates the ordering of the x axis.
#'
#'  - "z" is be a factor
#'
#'  - "label" values are printed on top of each of the bars
#'
#'  - If the column is included, "color" values override the color defined according to the palette paremeter. For
#' the entries that we do not want to override the `NA` value must be passed in the color column.
#'
#'  - It can contain additional columns that are not used for plotting but can be used in the tooltip.
#'
#' @param x_axis,y_axis,z_axis `[character(1) | NULL | shiny::reactive(character(1) | NULL) |
#'  shinymeta::metaReactive(character(1) | NULL)]`
#'
#'  Indicate the absence/presence and location of the axis descriptors
#' (the descriptor for the x and y axes are the plot ticks; for the z axis it's the legend)
#'
#'  - x_desc can take the following values: "N" (north), "S" (south), NULL
#'
#'  - y_desc can take the following values: "W" (west), "E" (east), NULL
#'
#'  - z_desc can take the following values: "N", "E", "S", "W", NULL
#'
#' @param palette `[character(1+) | shiny::reactive(character(1+)) | shinymeta::metaReactive(character(1+))]`
#'
#'  Vector that maps values to "z" colors. The names of the vector are hexadecimal colors
#'  encoded as #rrggbb or #rrggbbaa (red, green, blue, alpha) and the values are the "z" values that
#'  should be mapped to that color.
#'
#'  - the palette is complete (i.e. it should offer one color per value)
#'
#'  - z values that are `NA` or `NULL` are colored in grey.
#'
#' @param margin `[numeric(4) | shiny::reactive(numeric(4)) | shinymeta::metaReactive(numeric(4))]`
#'
#'  margin to be used on each of the sides. It must contain four entries named `top`, `bottom`, `left` and `right`
#'
#' @param msg_func `[character(1) | shiny::reactive(numeric(1)) | shinymeta::metaReactive(numeric(1))]`
#'
#' A JS string that is evaluated in the client. The string must return
#' a function that receives a single parameter and returns HTML code that is placed in the tooltip. If NULL a
#' default tooltip is shown.
#'
#' @param quiet `[logical(1) | shiny::reactive(logical(1)) | shinymeta::metaReactive(logical(1))]`
#'
#'  A boolean indicating if javascript code should include debug output.
#'
#' @param ... Extra parameters that are passed to [r2d3::d3Output], [r2d3::renderD3] and [r2d3::r2d3]
#'
#' @return
#'
#' ## UI
#' A bar plot
#'
#' ## Server
#' A list with one entry:
#'   margin: similar to the margin parameter with the minimum margins for the current plot
#'
# @inheritDotParams r2d3::r2d3 -data -script -options -elementId -dependencies -d3_version
# @inheritDotParams r2d3::d3Output -outputId
# @inheritDotParams r2d3::renderD3 -expr
#'
#' @name bar_D3
#' @keywords internal
NULL

#' @describeIn bar_D3 UI
bar_d3_UI <- function(id, ...) { # nolint

  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  # paste ctxt ----
  paste_ctxt <- paste_ctxt_factory(id) # nolint

  # argument asserts ----

  # UI ----
  ns <- shiny::NS(id)

  shiny::tagList(
    shiny::div(
      id = ns(BARD3$D3_CONTAINER),
      style = "position:relative",
      r2d3::d3Output(ns(BARD3$D3_BAR), ...)
    )
  )
}

#' @describeIn bar_D3 Server
#' @return  A reactive list similar to that in the margin param, but indicating which margin is needed to safely plot
#' the figure. This value is only returned inside a Shiny application.
bar_d3_server <- function(id, data,
                          x_axis,
                          y_axis,
                          z_axis,
                          margin,
                          palette,
                          msg_func,
                          quiet = TRUE,
                          ...) {
  # id assert ---- It goes on its own as id is used to provide context to the other assertions
  checkmate::assert_string(id, min.chars = 1)

  module <- function(input, output, session) {
    # sessions ----
    ns <- session[["ns"]]

    # paste ctxt ----
    paste_ctxt <- paste_ctxt_factory(ns(""))

    # argument asserts ----

    assert_data <- function(data, add) {
      if (test_not_reactive(data)) {
        if (
          checkmate::assert(
            checkmate::check_data_frame(data),
            checkmate::check_names(names(data), type = "unique", must.include = c("x", "y", "z")),
            .var.name = paste_ctxt(data),
            combine = "and"
          ) || TRUE
        ) {
          is_single_row_per_participant <- nrow(
            dplyr::distinct(data, .data[["x"]], .data[["y"]])
          ) == length(unique(data[["x"]]))

          checkmate::assert_true(
            is_single_row_per_participant,
            .var.name = paste_ctxt(is_single_row_per_participant), add = add
          )
          checkmate::assert_factor(data[["x"]],
            empty.levels.ok = FALSE, any.missing = FALSE,
            .var.name = paste_ctxt(data[["x"]]), add = add
          )
          checkmate::assert_numeric(data[["y"]],
            .var.name = paste_ctxt(data[["y"]]), add = add
          )
          checkmate::assert_factor(data[["z"]],
            .var.name = paste_ctxt(data[["z"]]), add = add
          )
          if (isTRUE("color" %in% names(data))) {
            checkmate::assert_character(data[["color"]],
              any.missing = TRUE,
              .var.name = paste_ctxt(data[["color"]]), add = add
            )
          }
          if (isTRUE("label" %in% names(data))) {
            checkmate::assert_character(data[["label"]],
              any.missing = TRUE,
              .var.name = paste_ctxt(data[["label"]]), add = add
            )
          }
        }
      }
    }

    assert_x_axis <- function(x_axis, add) {
      if (test_not_reactive(x_axis)) {
        checkmate::assert_subset(x_axis, c("S"),
          empty.ok = TRUE,
          add = add, .var.name = paste_ctxt(x_axis)
        )
      }
    }

    assert_y_axis <- function(y_axis, add) {
      if (test_not_reactive(y_axis)) {
        checkmate::assert_subset(y_axis, c("W"),
          empty.ok = TRUE,
          add = add, .var.name = paste_ctxt(y_axis)
        )
      }
    }

    assert_z_axis <- function(z_axis, add) {
      if (test_not_reactive(z_axis)) {
        checkmate::assert_subset(z_axis, c("E"),
          empty.ok = TRUE,
          add = add, .var.name = paste_ctxt(z_axis)
        )
      }
    }

    assert_margin <- function(margin, add) {
      if (test_not_reactive(margin)) {
        checkmate::assert_numeric(
          margin,
          any.missing = FALSE, len = 4, names = "named", add = add
        )
        checkmate::assert_names(
          names(margin),
          type = "unique",
          permutation.of = c("top", "bottom", "left", "right"), add = add
        )
      }
    }



    assert_msg_func <- function(msg_func, add) {
      if (test_not_reactive(msg_func)) {
        checkmate::assert_string(msg_func,
          na.ok = FALSE, min.chars = 1,
          add = ac, .var.name = paste_ctxt(msg_func)
        )
      }
    }

    assert_quiet <- function(quiet, add) {
      if (test_not_reactive(quiet)) {
        checkmate::assert_logical(quiet,
          any.missing = FALSE, len = 1,
          add = add, .var.name = paste_ctxt(quiet)
        )
      }
    }



    ac <- checkmate::makeAssertCollection()
    assert_data(data, add = ac)
    assert_x_axis(x_axis, add = ac)
    assert_y_axis(y_axis, add = ac)
    assert_z_axis(z_axis, add = ac)
    assert_margin(margin, add = ac)
    assert_palette(palette, add = ac)
    assert_msg_func(msg_func, add = ac)
    assert_quiet(quiet, add = ac)
    assert_margin(margin, add = ac)
    checkmate::reportAssertions(ac)

    # input validation ----

    v_data <- validate_input(data, assert_data, ns(""))
    v_x_axis <- validate_input(x_axis, assert_x_axis, ns(""))
    v_y_axis <- validate_input(y_axis, assert_y_axis, ns(""))
    v_z_axis <- validate_input(z_axis, assert_z_axis, ns(""))
    v_margin <- validate_input(margin, assert_margin, ns(""))
    v_palette <- validate_input(palette, assert_palette, ns(""))
    v_msg_func <- validate_input(msg_func, assert_msg_func, ns(""))
    v_quiet <- validate_input(quiet, assert_quiet, ns(""))

    # server ----

    output[[BARD3$D3_BAR]] <- r2d3::renderD3({
      bar_D3(
        data = v_data(),
        parent = BARD3$D3_CONTAINER,
        x_axis = v_x_axis(), y_axis = v_y_axis(), z_axis = v_z_axis(),
        # Pass the namespace without "-", i.e. if ns("") = "app-mod-" then ns_str = "app-mod"
        ns_str = substr(ns(""), 1, nchar(ns("")) - 1),
        margin = v_margin(),
        palette = v_palette(),
        quiet = v_quiet(),
        msg_func = v_msg_func(),
        d3_version = "6",
        ...
      )
    })

    shiny::exportTestValues(
      margin = input[["margin"]]
    )

    shiny::setBookmarkExclude("margin")

    return(
      list(
        margin = shiny::reactive(input[["margin"]], label = ns("margin"))
      )
    )
  }
  shiny::moduleServer(id, module)
}

bar_D3 <- function(data, # nolintr
                   parent = NULL,
                   ns_str = NULL,
                   x_axis = "S", y_axis = "W", z_axis = "E",
                   margin = list(top = 0, bottom = 0, left = 0, right = 0),
                   palette = NULL,
                   msg_func = NULL,
                   quiet = TRUE,
                   ...) {
  prev_shadow_option <- getOption("r2d3.shadow")
  options <- options(r2d3.shadow = FALSE)
  on.exit(options(r2d3.shadow = prev_shadow_option), add = TRUE)

  # We assume we are in a shiny environment if no parent is passed. Otherwise, we assume it is running in a knitr,
  # Rstudio, etc. If it is not a Shiny environment we create a random ID to provide a specific ID for the r2d3 container
  # so we can attach the tooltip to it.

  is_shiny <- !is.null(parent)
  parent_id <- if (is_shiny) parent else paste0("bar-widget", sample(letters, 10, replace = TRUE))

  # Many things are forced to be lists because, lists are passed as an array of objects, but vectors are passed as
  # arrays. Check: jsonlite::toJSON(as.list(c(a="aaaa"))) and jsonlite::toJSON(c(a="aaaa")). This is particularly
  # dangerous with vectors of size one.

  r2d3::r2d3(
    data = data,
    script = system.file("www/dist/d3_barplot.js", package = "dv.biomarker.general", mustWork = TRUE),
    options = list(
      parent = parent_id,
      x_axis = x_axis, y_axis = y_axis, z_axis = z_axis,
      ns_str = ns_str,
      margin = as.list(margin),
      sorted_x = as.list(levels(data[["x"]])),
      palette = list(
        colors = as.list(names(palette)),
        values = as.list(unname(palette))
      ),
      x_title = get_lbl(data, "x"),
      y_title = get_lbl(data, "y"),
      quiet = quiet,
      msg_func = msg_func
    ),
    elementId = if (is_shiny) NULL else parent_id,
    dependencies = list(dvd3h_dep()),
    ...
  )
}
