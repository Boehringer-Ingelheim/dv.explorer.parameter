# Takes dataframe with x, y, z.

HM2SVG <- pack_of_constants(CHART = "chart", PLOT = "plot", CLICK = "click") # nolint

HM2SVG_UI <- function(id) { # nolint
  ns <- shiny::NS(id)
  shiny::uiOutput(ns(HM2SVG$CHART))
}

#' svg heatmap plot
#'
#' Plot the contents of a dataframe as a heatmap, with optional legends, palette and alignment margins. None of
#' the parameters are reactive
#'
#' @param data data to plot. It expects the following format:
#'             - columns names are `x`, `y`, `z` and, optionally, `label`
#'             - both `x` and `y` columns are factors
#'             - There is one entry for each combination of "x" and "y" present in the dataset.
#'               In other words, the values for each heatmap rectangle are defined explicitly, even if they are NA
#'             - Axis labels and legend title are stored as the attribute "label" of the "x", "y" and "z" columns
#'             - The order of records in the data frame dictates the ordering of the x/y axes in the final plot
#'
#' @param x_desc,y_desc,z_desc Indicate the absence/presence and location of the axis descriptors
#'               (the descriptor for the x and y axes are the plot ticks; for the z axis it's the legend)
#'               - x_desc can take the following values: "N" (north), "S" (south), NULL (absent)
#'               - y_desc can take the following values: "W" (west), "E" (east), NULL (absent)
#'               - z_desc can take the following values: "N", "E", "S", "W", NULL
#' @param pal_fun Function that maps values on column `z` of `data` to a color in #rrggbb or #rrggbbaa format
#' @param palette Vector that maps values to "z" colors. The names of the vector are hexadecimal colors encoded as
#'                #rrggbb or #rrggbbaa (red, green, blue, alpha) and the values are the "z" values that should be
#'                mapped to that color.
#'                If "z" is categorical, the palette should be complete (i.e. it should offer one color per value).
#'                If "z" is continuous, the palette should contain at least two values covering the min-max range
#'                of possible values. If it contains more, the color of each grid rectangle will be linearly
#'                interpolated according to where its value falls between the two surrounding provided colors.
#'
#' @param ns namespace to apply to the click events
#'
#' @keywords internal
HM2SVG_plot <- function(data, x_desc, y_desc, z_desc, pal_fun, palette, ns) { # nolint
  # TODO: default palette?
  lev <- levels(data[["x"]])
  n <- length(lev)
  shiny::req(n > 0)

  if (!("color" %in% names(data))) {
    data[["color"]] <- pal_fun(data[["z"]])
  }

  # Font color for labels. They need to stand out in front of the cell background color, so we compute
  # the color luminance, threshold it and choose 'white' or 'black' so that it contrasts properly:
  data[["font_color"]] <- ifelse(
    colSums(
      grDevices::col2rgb(data[["color"]]) * c(0.3, 0.59, 0.11)
    ) < 128,
    "white",
    "black"
  )

  # TODO: Assert x and y levels of data are contiguous ?

  # NOTE: This function appends SVG string fragments to `svg_elem_list` and finally collapses that list into
  #       a string which then returns. There are a few local `SVG_*` helper functions that superassign to that
  #       list. Be aware of them.
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

  SVG_append <- function(elem, desc, ...) { # nolint
    id <- SVG_push(elem, desc, ...)
    SVG_pop(id)
  }

  cell_width <- 100
  legend_width <- 200
  legend_height <- 80
  z_legend_width <- 0 # NOTE: Added afterwards
  spacer_width <- 10
  grid_width <- n * cell_width

  # this is a map of the layout from left to right
  viewbox_width <- (
    spacer_width + legend_width +
      spacer_width + grid_width +
      spacer_width + spacer_width + z_legend_width +
      spacer_width
  )
  viewbox_height <- viewbox_width - spacer_width - z_legend_width

  z_legend_bar_width <- viewbox_width / 35
  z_legend_font_size <- viewbox_width / 35
  z_legend_separation <- viewbox_width / 25

  viewbox_width <- viewbox_width + 4 * z_legend_bar_width

  svg <- SVG_push(
    "svg", "xmlns='http://www.w3.org/2000/svg' version='2.1' width=100% viewBox='0 0 W H'",
    W = viewbox_width, H = viewbox_height
  )
  outer_margin <- SVG_push("g", "transform='translate(X, Y)'", X = spacer_width, Y = spacer_width)

  grid <- SVG_push("g", "transform='translate(W)'", W = legend_width + spacer_width)

  # The bulk of the SVG contents are the grid cells. Instead of iterating through them, we interpolate a template string
  # with the contents of the data frame, because it's much faster
  cells <- local({
    i <- as.numeric(data[["x"]])
    j <- as.numeric(data[["y"]])

    # de-emphasize diagonal autocorrelations
    diagonal_mask <- (i == j)
    size <- ifelse(diagonal_mask, cell_width / 3, cell_width)
    x <- cell_width * (i - 1) + ifelse(diagonal_mask, cell_width / 3, 0)
    y <- cell_width * (j - 1) + ifelse(diagonal_mask, cell_width / 3, 0)

    # nolint start
    paste0(
      "<g onclick=\"Shiny.setInputValue('", ns(HM2SVG$CLICK), "', {x: ", i, ", y: ", j, "})\">
       <rect width='", size, "' height='", size, "' x='", x, "' y='", y, "' fill='", data[["color"]],
      "' stroke-width='2' stroke='white' />
       <foreignObject x='", x, "' y='", y, "' width='100' height='100'>
       <div xmlns='http://www.w3.org/1999/xhtml' style='display:flex;align-items:center;height:100%;justify-content:center;'>
         <p style='margin:0;font-size:32px;text-align:center;color:", data[["font_color"]], "'>", data[["label"]], "</p>
       </div>
       </foreignObject>
     </g>
     ",
      collapse = "\n"
    )
    # nolint end
  })
  SVG_append_raw(cells)

  SVG_pop(grid)

  # y labels
  for (i in seq_along(lev)) {
    l <- lev[[i]]

    # nolint start
    label <- ssub("
    <foreignObject x='0' y='Y' width='W' height='H'>
    <div xmlns='http://www.w3.org/1999/xhtml' style='display:flex;align-items:center;height:100%;justify-content:end;-webkit-transform:rotate(0deg);'>
      <p style='margin:0;font-size:20px;'>LABEL</p>
    </div>
    </foreignObject>
    ", Y = (i - 1) * 100 + 10, W = legend_width, H = legend_height, LABEL = l)
    # nolint end
    SVG_append_raw(label)
  }

  # x labels
  for (i in seq_along(lev)) {
    l <- lev[[i]]

    # nolint start
    label <- ssub("
    <foreignObject x='X' y='Y' width=1 height=1 style='overflow: visible'>
    <div xmlns='http://www.w3.org/1999/xhtml' style='display:flex;align-items:center;width:W;height:H;justify-content:end;-webkit-transform:rotate(-90deg);transform-origin: right;'>
      <p style='margin:0;font-size:20px;'>LABEL</p>
    </div>
    </foreignObject>
    ",
      X = (i - 1) * cell_width + legend_width + spacer_width - legend_width + cell_width / 2,
      Y = cell_width * length(lev) - legend_height / 2 + 10,
      W = paste0(legend_width, "px"), H = paste0(legend_height, "px"), LABEL = l
    )
    # nolint end
    SVG_append_raw(label)
  }

  # legend
  gradient <- SVG_push("linearGradient", "id='legend_gradient' x1='0' x2='0' y1='1' y2='0'")
  rescaled_palette <- scales::rescale(palette)
  for (i_step in seq_along(rescaled_palette)) {
    SVG_append("stop", "offset='PERCENT%' stop-color='COLOR'",
      PERCENT = rescaled_palette[[i_step]] * 100, COLOR = names(rescaled_palette)[[i_step]]
    )
  }
  SVG_pop(gradient)

  z_legend <- SVG_push(
    "g", "transform='translate(X)'",
    X = legend_width + spacer_width + grid_width + spacer_width + spacer_width
  )

  SVG_append("rect",
    "width='WIDTH' height='HEIGHT' x='X' y='Y' fill='url(#legend_gradient)' stroke-width='2' stroke='white'",
    WIDTH = z_legend_bar_width, HEIGHT = cell_width * n, X = 0, Y = 0
  )

  ticks <- SVG_push("g", "transform='translate(X)'", X = z_legend_separation)
  SVG_append_raw(
    "<text y='Y' font-size=FS px alignment-baseline='hanging'>1</text>" |>
      ssub(FS = z_legend_font_size, Y = 100 * 0 * n / 4)
  )
  SVG_append_raw(
    "<text y='Y' font-size=FS px alignment-baseline='middle'>0.5</text>" |>
      ssub(FS = z_legend_font_size, Y = 100 * 1 * n / 4)
  )
  SVG_append_raw(
    "<text y='Y' font-size=FS px alignment-baseline='middle'>0</text>" |>
      ssub(FS = z_legend_font_size, Y = 100 * 2 * n / 4)
  )
  SVG_append_raw(
    "<text y='Y' font-size=FS px alignment-baseline='middle'>-0.5</text>" |>
      ssub(FS = z_legend_font_size, Y = 100 * 3 * n / 4)
  )
  SVG_append_raw(
    "<text y='Y' font-size=FS px alignment-baseline='bottom'>-1</text>" |>
      ssub(FS = z_legend_font_size, Y = 100 * n)
  )
  SVG_pop(ticks)

  z_label <- attr(data[["z"]], "label")
  if (is.character(z_label) && length(z_label) == 1 && nchar(z_label) > 0) {
    SVG_append_raw(
      "<g transform='rotate(-90) translate(-Y, X)' transform-origin='center,center'>" |>
        ssub(Y = 100 * n / 2, X = 2.5 * z_legend_separation)
    )
    SVG_append_raw(
      "<text x='0' y='Y' font-size=FS px alignment-baseline='middle' text-anchor='middle' >LABEL</text>" |>
        ssub(FS = z_legend_font_size, Y = 0, LABEL = z_label)
    )
    SVG_append_raw("</g>")
  }

  SVG_pop(z_legend)

  SVG_pop(outer_margin)
  SVG_pop(svg)

  svg_string <- paste(svg_elem_list, collapse = "\n")
  return(svg_string)
}

#' Server side of ggplot-only heatmap
#'
#' Plot the contents of a dataframe as a heatmap, with optional legends, palette and alignment margins. All
#' parameters can be reactive
#'
#' @param id shiny ID
#' @inheritParams HM2SVG_plot
#' @param margins Offset in pixels from the edges of the drawable area to the outer perimeter of the heatmap
#'                (excluding legends and axis descriptions). It's a non-reactive list of possibly reactive "top",
#'                "bottom", "left" and "right" numerical values.
#' @param debug_gtable Activate debug mode
#' @return List of margins (Margin in pixels this plot would have if drawn in isolation encoded as
#'         a reactiveValues object with
#'         elements "top", "bottom", "left" and "right") and click (reactive that returns user click info)
#' @keywords internal

HM2SVG_server <- function(id, data, x_desc = "S", y_desc = "W", z_desc = "E", palette = NULL, # nolint
                          margins = list(top = 0, bottom = 0, left = 0, right = 0),
                          debug_gtable = FALSE) { # nolint
  shiny::moduleServer(id = id, module = function(input, output, session) {
    ns <- session[["ns"]]

    pal_fun <- shiny::reactive({
      palette <- resolve_or_return(palette)

      na_color <- names(which(is.na(palette)))
      if (length(na_color) > 0) stop("Explicit NA on palette still not supported") # TODO

      colors <- names(palette)
      values <- unname(palette)
      pal_fun <- scales::gradient_n_pal(colors, values)
      return(pal_fun)
    })

    output[[HM2SVG$CHART]] <- shiny::renderUI({
      data <- data()

      x_desc <- resolve_or_return(x_desc)
      y_desc <- resolve_or_return(y_desc)
      z_desc <- resolve_or_return(z_desc)
      palette <- resolve_or_return(palette)
      data <- resolve_or_return(data)

      shiny::validate(
        shiny::need(nrow(data) > 0, "Need at least one parameter"),
        shiny::need(is.null(x_desc) || x_desc %in% c("N", "S"), paste0("x_desc==", x_desc, " not implemented")),
        shiny::need(is.null(y_desc) || y_desc == "W", paste0("y_desc==", y_desc, " not implemented")),
        shiny::need(is.null(z_desc) || z_desc == "E", paste0("z_desc==", z_desc, " not implemented"))
      )

      svg_string <- HM2SVG_plot(data, x_desc, y_desc, z_desc, pal_fun = pal_fun(), palette = palette, ns = ns)

      shiny::HTML(svg_string)
    })

    click <- shiny::reactive({
      coordinfo <- input[[HM2SVG$CLICK]]

      shiny::req(coordinfo)
      x_levels <- levels(data()[["x"]])
      y_levels <- levels(data()[["y"]])
      shiny::req(coordinfo$x <= length(x_levels))
      shiny::req(coordinfo$y <= length(y_levels))

      res <- list(x = x_levels[[coordinfo$x]], y = y_levels[[coordinfo$y]])
      return(res)
    })

    return(click)
  })
}
