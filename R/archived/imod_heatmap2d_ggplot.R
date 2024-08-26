# Takes dataframe with x, y, z.

HM2GG <- pack_of_constants(WRAPPER = "wrapper", PLOT = "plot", CLICK = "click") # nolint

HM2GG_UI <- function(id) { # nolint
  ns <- shiny::NS(id)
  shiny::uiOutput(ns(HM2GG$WRAPPER))
}

#' ggplot heatmap wrapper
#'
#' Plot the contents of a dataframe as a heatmap, with optional legends, palette and alignment margins. None of
#' the parameters are reactive
#'
#' @param data data to plot. It expects the following format:
#'             - columns names are "x", "y", "z" and, optionally, "label"
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
#' @param palette Vector that maps values to "z" colors. The names of the vector are hexadecimal colors encoded as
#'                #rrggbb or #rrggbbaa (red, green, blue, alpha) and the values are the "z" values that should be
#'                mapped to that color.
#'                If "z" is categorical, the palette should be complete (i.e. it should offer one color per value).
#'                If "z" is continuous, the palette should contain at least two values covering the min-max range
#'                of possible values. If it contains more, the color of each grid rectangle will be linearly
#'                interpolated according to where its value falls between the two surrounding provided colors.
#'                Defaults to ggplot viridis palette.
HM2GG_plot <- function(data, x_desc, y_desc, z_desc, palette = NULL) { # nolint
  # Theme defaults
  theme_args <- list(
    axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust = 1, size = STYLE$AXIS_TEXT_SIZE),
    axis.text.y = ggplot2::element_text(size = STYLE$AXIS_TEXT_SIZE),
    legend.key.height = grid::unit(1, "inch") # nolint TODO: Should match size of panel, but it's tricky (https://stackoverflow.com/questions/19214914/how-can-i-make-the-legend-color-bar-the-same-height-as-my-plot-panel)
  )

  # Axes customization
  scale_x_position <- "bottom"
  if (is.null(x_desc)) {
    theme_args[["axis.text.x"]] <- ggplot2::element_blank()
    theme_args[["axis.title.x"]] <- ggplot2::element_blank()
    theme_args[["axis.ticks.x"]] <- ggplot2::element_blank()
  } else if (x_desc == "N") {
    scale_x_position <- "top"
  }

  scale_y_position <- "left"
  if (is.null(y_desc)) {
    theme_args[["axis.text.y"]] <- ggplot2::element_blank()
    theme_args[["axis.title.y"]] <- ggplot2::element_blank()
    theme_args[["axis.ticks.y"]] <- ggplot2::element_blank()
  } else if (y_desc == "E") {
    scale_y_position <- "right"
  }

  guide_fill <- ggplot2::guide_colorbar()

  if (is.null(z_desc)) {
    theme_args[["legend.position"]] <- "none"
  } else {
    guide_fill <- ggplot2::guide_colourbar(
      direction = "vertical", title.position = "top", title.hjust = 0.5
    )
  }

  theme <- do.call(ggplot2::theme, theme_args)

  common_aes <- ggplot2::aes(x = .data[["x"]], y = .data[["y"]])

  fill_column <- ifelse("color" %in% names(data), "color", "z")
  raster_aes <- ggplot2::aes(fill = .data[[fill_column]])

  labels <- get_lbls(data)
  z_label <- local({
    unique_labels <- unique(labels[["z"]])
    unique_labels <- unique_labels[!is.na(unique_labels)]
    res <- paste(unique_labels, collapse = ", ")
    res
  })
  labs <- ggplot2::labs(x = labels[["x"]], y = labels[["y"]], fill = z_label)

  # label contrast #iehohb, hardcoded to current BlRe palette. Otherwise should depend on luminance of background
  text_aes <- ggplot2::aes(label = .data[["label"]], color = abs(.data[["z"]]) > 0.7)

  # ggplot will respect the order of levels provided on the x axis (https://stackoverflow.com/a/5719691)
  data[["x"]] <- factor(data[["x"]], levels = unique(data[["x"]]))

  plot <- ggplot2::ggplot(data, mapping = common_aes) +
    theme +
    labs +
    ggplot2::scale_x_discrete(expand = c(0, 0), position = scale_x_position) +
    ggplot2::scale_y_discrete(
      expand = c(0, 0), position = scale_y_position,
      limits = rev(levels(data[["y"]])) # top-down ordering as specified in the dataset
    ) +
    ggplot2::guides(fill = guide_fill)

  if (length(unique(data[["y"]])) == 1) {
    # Nice borders for single-row heatmaps
    plot <- plot + ggplot2::geom_tile(mapping = raster_aes, colour = "black")
  } else {
    # Faster drawing for multi-row heatmaps
    plot <- plot + ggplot2::geom_raster(mapping = raster_aes)
  }

  # TODO: Treat possible color for NA
  na_color <- names(which(is.na(palette)))
  if (length(na_color) == 0) na_color <- "grey50"

  discrete_z <- is.factor(data[["z"]])
  if ("color" %in% names(data)) {
    plot <- plot + ggplot2::scale_fill_identity(na.value = na_color)
  } else if (is.null(palette)) {
    # TODO: It would be simpler to just get the only viridis palette we need and move it into the package:
    #       https://github.com/sjmgarnier/viridisLite/blob/master/data-raw/optionD.csv
    plot <- plot + viridis::scale_fill_viridis(discrete = discrete_z, option = "viridis", na.value = na_color)
  } else {
    if (discrete_z) {
      reverse_names_values <- function(a) {
        stats::setNames(names(a), a)
      }
      plot <- plot + ggplot2::scale_fill_manual(
        values = reverse_names_values(palette),
        limits = force,
        na.value = na_color
      )
    } else {
      # Avoid palette singularity so that ggplot does not complain
      unique_palette_values <- unique(palette[!is.na(palette)])
      if (length(unique_palette_values) == 1) {
        offset_range <- unique_palette_values / 10
        offsets <- seq(from = -offset_range, to = offset_range, length.out = length(palette))
        palette <- palette + offsets
      }

      values <- scales::rescale(palette)
      plot <- plot + ggplot2::scale_fill_gradientn(
        limits = c(min(palette, na.rm = TRUE), max(palette, na.rm = TRUE)),
        colors = names(palette),
        values = scales::rescale(palette),
        #  nolint na.value = na_color
      )
      values
    }
  }

  # This thing is responsible for most of the rendering time
  if ("label" %in% colnames(data)) {
    x_count <- length(unique(data[["x"]]))
    text_size <- 8.5 - x_count / 5 # FIXME: Ad-hoc text resizing should depend on dev.size instead
    plot <- plot + ggtext::geom_richtext(mapping = text_aes, label.colour = NA, fill = NA, size = text_size) +
      ggplot2::scale_color_manual(guide = "none", values = c("black", "white")) # label contrast #iehohb
  }

  # This would be the usual way of getting a square geom_tile, but I haven't figured out
  # how to interpret click_info if I use it
  # nolint plot <- plot + ggplot2::coord_fixed()

  plot
}

HM2GG_pad_table <- function(table_grob, anchor_grob_name, insert_direction, insert_index_offset, # nolint
                            current_margin, target_margin, pixels_per_inch) {
  grob_names <- table_grob$layout$name
  insertion_index <- which(grob_names == anchor_grob_name)
  insertion_pos <- table_grob$layout[insertion_index, ][[insert_direction]] + insert_index_offset
  if (!is.null(target_margin) && target_margin > current_margin) {
    offset <- target_margin - current_margin

    gtable_add_function <- NULL
    if (insert_direction %in% c("l", "r")) {
      gtable_add_function <- gtable::gtable_add_cols
    } else if (insert_direction %in% c("t", "b")) {
      gtable_add_function <- gtable::gtable_add_rows
    } else {
      stop('Insert direction must be either "l", "r", "t" or "b"')
    }

    gtable_add_args <- list(
      table_grob, grid::unit(offset / pixels_per_inch, "in"),
      insertion_pos
    )

    table_grob <- do.call(gtable_add_function, gtable_add_args)
  }
  return(table_grob)
}

# NOTE: ggplot2 is built on top of the grid package. Here are some useful resources
#       https://bookdown.org/rdpeng/RProgDA/the-grid-package.html
#       https://stat.ethz.ch/R-manual/R-devel/library/grid/doc/grid.pdf
#       https://www.stat.auckland.ac.nz/~paul/RGraphics/chapter5.pdf (R Graphics by Paul Murrell)
#       https://www.stat.auckland.ac.nz/~paul/grid/doc/R-1.8.0/nullunit.pdf
#       https://genviz.org/module-07-appendix/0007/01/01/advancedggplot2/

# NOTE: If we were trying to align subplots manually, we would resort to gtable::{c,r}bind as discussed in the
#       "Aligning plot panels" section of:https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html

# TODO: Modify plot axes
# TODO: Adapt size of labels: GeomLabel$default_aes$size
# nolint                      update_geom_defaults("text", list(size = 6))
# TODO: Colormap
# TODO: ? Dictate aspect ratio of heatmap cells: coord_equal(ratio = 1); theme(aspect.ratio = 1)
# TODO: ? Make color bar legends fit

# TODO: Document
HM2GG_pad_plot <- function(plot, margins) { # nolint
  # Adding padding to a plot:
  # =========================
  # 0 ggplot draws plots in four stages: construct, build, render and draw.
  #   The first two stages can be completed by invoking ggplot_build on our ggplot2 object:
  built_plot <- ggplot2::ggplot_build(plot)
  # 1 Then we can build the "grobs" (primitive graphic objects of the "grid" base R package) by calling
  #   ggplot_gtable, which gives us a "table grob":
  table_grob <- ggplot2::ggplot_gtable(built_plot)
  # 2 This object is a good intermediate representation for manipulation. It's described here:
  #   https://cran.r-project.org/web/packages/gridExtra/vignettes/gtable.html

  # 3 This is the fun part:
  #   We look for the main heatmap panel (aptly named "panel"), compute the spacing to its left, right, top and
  #   bottom and add some extra rows and columns to align it to the target margins
  grob_names <- table_grob$layout$name

  pixels_per_inch <- grDevices::dev.size(units = "px") / grDevices::dev.size(units = "in")
  x_ppi <- pixels_per_inch[1]
  y_ppi <- pixels_per_inch[2]

  panel_index <- which(grob_names == "panel") # Main portion of a heatmap
  panel_layout <- table_grob$layout[panel_index, ]

  grob_widths <- sapply(table_grob$widths, grid::convertUnit, "in") * x_ppi
  grob_heights <- sapply(table_grob$heights, grid::convertUnit, "in") * y_ppi

  modified_table_grob <- table_grob

  computed_margins <- list()

  right_margin_index <- panel_layout[["r"]]
  computed_margins[["right"]] <- sum(utils::tail(grob_widths, length(grob_widths) - right_margin_index))
  left_margin_index <- panel_layout[["l"]]
  computed_margins[["left"]] <- sum(utils::head(grob_widths, left_margin_index - 1)) # Everything to the left of "panel"
  bottom_margin_index <- panel_layout[["b"]]
  computed_margins[["bottom"]] <- sum(utils::tail(grob_heights, length(grob_heights) - bottom_margin_index))
  top_margin_index <- panel_layout[["t"]]
  computed_margins[["top"]] <- sum(utils::head(grob_heights, top_margin_index - 1)) # Everything above "panel"

  # We do the right side first because it does not affect indices of left columns. Same for bottom/top
  modified_table_grob <- HM2GG_pad_table(
    table_grob = modified_table_grob,
    anchor_grob_name = "ylab-r",
    insert_direction = "l",
    insert_index_offset = -1,
    current_margin = computed_margins[["right"]],
    target_margin = resolve_or_return(margins[["right"]]),
    pixels_per_inch = x_ppi
  )

  modified_table_grob <- HM2GG_pad_table(
    table_grob = modified_table_grob,
    anchor_grob_name = "ylab-l",
    insert_direction = "l",
    insert_index_offset = 0,
    current_margin = computed_margins[["left"]],
    target_margin = resolve_or_return(margins[["left"]]),
    pixels_per_inch = x_ppi
  )

  if ("bottom" %in% names(margins)) {
    modified_table_grob <- HM2GG_pad_table(
      table_grob = modified_table_grob,
      anchor_grob_name = "xlab-b",
      insert_direction = "t",
      insert_index_offset = -1,
      current_margin = computed_margins[["bottom"]],
      target_margin = resolve_or_return(margins[["bottom"]]),
      pixels_per_inch = y_ppi
    )
  }

  if ("top" %in% names(margins)) {
    modified_table_grob <- HM2GG_pad_table(
      table_grob = modified_table_grob,
      anchor_grob_name = "xlab-t",
      insert_direction = "t",
      insert_index_offset = 0,
      current_margin = computed_margins[["top"]],
      target_margin = resolve_or_return(margins[["top"]]),
      pixels_per_inch = y_ppi
    )
  }

  # 4 If we wanted to hand the modified plot to plotly, we would need to turn it into a ggplot2 object again
  #   Unfortunately, all the methods that I've tried use some grid graphics feature that plotly does not support.
  #   For example, I can't do this:
  #   > modified_plot <- ggplotify::as.ggplot(modified_table_grob)
  #   > return(modified_table_grob)
  #   But ggplotify::as.ggplot uses ggplot2::annotation_custom to "generate" the plot. That function relies on
  #   geom_GeomCustomAnn, which is not supported by plotly (https://github.com/plotly/plotly.R/issues/348)
  #
  #   Luckily, we can go ahead and show the plot with grid::grid.draw(), or base::plot(). I have to admit,
  # I don't know how this works, since it looks to me like it sidesteps the regular shiny rendering pipeline.

  res <- list(grob = modified_table_grob, margins = computed_margins)
  return(res)
}

#' Server side of ggplot-only heatmap
#'
#' Plot the contents of a dataframe as a heatmap, with optional legends, palette and alignment margins. All
#' parameters can be reactive
#'
#' @param id shiny ID
#' @inheritParams HM2GG_plot
#' @param margins Offset in pixels from the edges of the drawable area to the outer perimeter of the heatmap
#'                (excluding legends and axis descriptions). It's a non-reactive list of possibly reactive "top",
#'                "bottom", "left" and "right" numerical values.
#' @param debug_gtable Activate debug mode
#' @return List of margins (Margin in pixels this plot would have if drawn in isolation encoded as
#'         a reactiveValues object with
#'         elements "top", "bottom", "left" and "right") and click (reactive that returns user click info)

HM2GG_server <- function(id, data, x_desc = "S", y_desc = "W", z_desc = "E", palette = NULL, # nolint
                         margins = list(top = 0, bottom = 0, left = 0, right = 0),
                         debug_gtable = FALSE) {
  shiny::moduleServer(id = id, module = function(input, output, session) {
    ns <- session[["ns"]]

    computed_margins <- shiny::reactiveValues()
    plot <- shiny::reactive(
      {
        x_desc <- resolve_or_return(x_desc)
        y_desc <- resolve_or_return(y_desc)
        z_desc <- resolve_or_return(z_desc)
        palette <- resolve_or_return(palette)
        data <- resolve_or_return(data)

        shiny::validate(
          shiny::need(nrow(data) > 0, ""),
          shiny::need(is.null(x_desc) || x_desc %in% c("N", "S"), paste0("x_desc==", x_desc, " not implemented")),
          shiny::need(is.null(y_desc) || y_desc == "W", paste0("y_desc==", y_desc, " not implemented")),
          shiny::need(is.null(z_desc) || z_desc == "E", paste0("z_desc==", z_desc, " not implemented"))
        )

        HM2GG_plot(data, x_desc, y_desc, z_desc, palette)
      },
      label = ns("plot")
    )

    plot_height <- shiny::reactiveVal(value = 100)

    output[[HM2GG$PLOT]] <- shiny::renderPlot(
      {
        pad_result <- HM2GG_pad_plot(plot(), resolve_or_return(margins))
        modified_table_grob <- pad_result[["grob"]]
        computed_margins[["left"]] <- pad_result[["margins"]][["left"]]
        computed_margins[["right"]] <- pad_result[["margins"]][["right"]]
        computed_margins[["top"]] <- pad_result[["margins"]][["top"]]
        computed_margins[["bottom"]] <- pad_result[["margins"]][["bottom"]]
        if (debug_gtable) {
          gtable::gtable_show_layout(modified_table_grob)
        } else {
          grid::grid.draw(modified_table_grob)
        }

        # (End of "Adding padding to a plot")

        # nolint start
        # if (!is.null(x_desc)) {
        #  pixels_per_inch <- dev.size(units = "px") / dev.size(units = "in")
        #  y_ppi <- pixels_per_inch[2]
        #  extra_legend_height <- max(graphics::strwidth(data[["x"]], units = "in")) * y_ppi
        #  magic_hack_factor <- 1.0 # FIXME
        #  extra_legend_height <- extra_legend_height * magic_hack_factor
        #  new_plot_height <- new_plot_height + extra_legend_height
        # }
        # nolint end

        # square cells -- winging it, because plotOutput height won't equal dev.size()[[2] anyways
        new_plot_height <- grDevices::dev.size(units = "px")[[1]]
        new_plot_height <- new_plot_height - computed_margins[["right"]] - computed_margins[["top"]]

        plot_height(new_plot_height)

        return(NULL)
      },
      execOnResize = TRUE
    ) # Align on resize without forcing the caller to provide reactive width and height

    output[[HM2GG$WRAPPER]] <- shiny::renderUI({
      shiny::plotOutput(ns(HM2GG$PLOT), width = "100%", height = plot_height(), click = ns(HM2GG$CLICK))
    })

    click <- shiny::reactive({
      coordinfo <- input[[HM2GG$CLICK]]
      shiny::req(coordinfo)

      # manual computation of nearest
      x <- coordinfo[["coords_img"]][["x"]]
      y <- coordinfo[["coords_img"]][["y"]]

      l <- computed_margins[["left"]]
      w <- coordinfo[["range"]][["right"]] - coordinfo[["range"]][["left"]]
      r <- w - computed_margins[["right"]]

      b <- computed_margins[["top"]]
      h <- coordinfo[["range"]][["bottom"]] - coordinfo[["range"]][["top"]]
      t <- h - computed_margins[["bottom"]]

      norm_x <- (x - l) / (r - l)
      norm_y <- (y - b) / (t - b)

      x_levels <- levels(data()[["x"]])
      x_index <- ceiling(length(x_levels) * norm_x)
      shiny::req(x_index >= 1 && x_index <= length(x_levels))
      x_value <- levels(data()[["x"]])[[x_index]]

      y_levels <- levels(data()[["y"]])
      y_index <- ceiling(length(y_levels) * norm_y)
      shiny::req(y_index >= 1 && y_index <= length(y_levels))
      y_value <- levels(data()[["y"]])[[y_index]]

      res <- list(x = x_value, y = y_value)

      res
    })

    return(list(margins = computed_margins, click = click))
  })
}
