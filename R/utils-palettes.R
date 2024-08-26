#' Returns a divergent palette to use with heatmap
#'
#'
#' @param max,neut,min the values to be associated with the extreme and central colors
#' @param colors the palette colors
#'
#' max, neut, min the values to be associated with the extreme and central colors. If the palette contains more colors,
#' the values are interpolated.
#'
#' @return Vector The names of the vector are hexadecimal colors
#'                encoded as #rrggbb or #rrggbbaa (red, green, blue, alpha) and the values are the "z" values that
#'                should be mapped to that color.
#' @keywords internal

pal_div_palette <- function(max, neut, min, colors) {
  n_colors <- length(colors)
  colors_per_side <- (n_colors - 1) / 2

  values <- c(
    seq(from = max, to = neut, length.out = colors_per_side + 1),
    seq(from = neut, to = min, length.out = colors_per_side + 1)[2:(colors_per_side + 1)]
  )

  stats::setNames(
    values,
    colors
  )
}

# Helper functions to work with palettes

#' Returns a continous palette to use with heatmap
#'
#' @param d a vector containing the values to be colored
#' @param seq_pos_colors,seq_neg_colors,div_colors,zero_color a palette for sequential positive, sequential
#' negative, divergent or all zeroes datasets. The zero_color expects a single color, all other expect an odd number of
#' colors. The divergent palette central color is considered the neutral and is always associated to 0.
#'
#' @return Vector The names of the vector are hexadecimal colors
#'                encoded as #rrggbb or #rrggbbaa (red, green, blue, alpha) and the values are the "z" values that
#'                should be mapped to that color.
#' @keywords internal

pal_get_cont_palette <- function(d,
                                 seq_pos_colors = RColorBrewer::brewer.pal(9, name = "Reds"),
                                 seq_neg_colors = rev(RColorBrewer::brewer.pal(9, name = "Blues")),
                                 div_colors = rev(RColorBrewer::brewer.pal(11, name = "RdBu")),
                                 zero_color = "rgb(242, 239, 238)") {
  type_lim <- pal_get_scale_type_lim(d)
  type <- type_lim[["type"]]
  lim <- type_lim[["lim"]]

  p <- switch(type,
    "seq_positive" = pal_seq_palette(lim[1], lim[2], seq_pos_colors),
    "seq_negative" = pal_seq_palette(lim[1], lim[2], seq_neg_colors),
    "divergent" = pal_div_palette(lim[1], lim[2], lim[3], div_colors),
    "all_zero" = pal_zero_palette(zero_color),
    rlang::abort("scale_type not found")
  )

  # remove duplicated entries in the case all are NA values
  p <- p[!duplicated(names(p))]
  p
}

# Helper functions to work with palettes

#' Returns a categorical palette to use with heatmap
#'
#' @param d a vector containing the values to be colored
#' @param colors the colors to be used. They will be recycled as needed.
#'
#' @return Vector The names of the vector are hexadecimal colors
#'                encoded as #rrggbb or #rrggbbaa (red, green, blue, alpha) and the values are the "z" values that
#'                should be mapped to that color.
#' @keywords internal

pal_get_cat_palette <- function(d, colors) {
  d <- unique(as.character(d))
  n_values <- length(d)
  n_colors <- length(colors)
  stats::setNames(
    d,
    rep(colors, ceiling(n_values / n_colors))[1:n_values]
  )
}

pal_colorize_custom_cat_df <- function(
    df, custom) {
  df |>
    dplyr::group_by(.data[["y"]]) |>
    dplyr::mutate(color = {
      if (dplyr::cur_group()[["y"]] %in% names(custom)) {
        custom[[dplyr::cur_group()[["y"]]]](.data[["z"]])
      } else {
        NA_character_
      }
    }) |>
    dplyr::ungroup()
}

# TODO: This nested for approach can very likely be improved by some vectorizing/purring
pal_colorize <- function(d, p, default = "#CDCDCD") {
  d <- as.character(d)
  color <- rep_len(default, length.out = length(d))
  n_p <- names(p)
  for (p_idx in seq_along(p)) {
    for (d_idx in seq_along(d)) {
      if (identical(d[[d_idx]], p[[p_idx]])) {
        color[[d_idx]] <- n_p[[p_idx]]
      }
    }
  }
  color
}

#' Returns a palette with a single color
#'
#' @param color the color
#'
#' The palette always return two repeated entries
#'
#' @return Vector The names of the vector are hexadecimal colors
#'                encoded as #rrggbb or #rrggbbaa (red, green, blue, alpha) and the values are the "z" values that
#'                should be mapped to that color.
#' @keywords internal

pal_zero_palette <- function(color) {
  stats::setNames(
    c(0, 0),
    c(color, color)
  )
}

#' A sequential palette to use with heatmap
#'
#'
#' @param max,min the values to be associated with the extreme and colors
#' @param colors the palette colors
#'
#' max, min the values are associated with the extreme colors. If the palette contains more colors,
#' the values are interpolated.
#'
#' @return Vector The names of the vector are hexadecimal colors
#'                encoded as #rrggbb or #rrggbbaa (red, green, blue, alpha) and the values are the "z" values that
#'                should be mapped to that color.
#' @keywords internal

pal_seq_palette <- function(max, min, colors) {
  n_colors <- length(colors)

  values <- c(
    seq(from = max, to = min, length.out = n_colors)
  )

  stats::setNames(
    values,
    colors
  )
}

#' Return the type of scale and its limits
#'
#' Inferes the type of scale and its limits based on the the data
#'
#' @param d the data from which the scale will be inferred
#'
#' @return A list with the entries:
#' ## type:
#'   - divergent: It has both positive, negative and 0 values
#'   - seq_positive: It has positive or 0 values
#'   - seq_negative: It has negative or 0 values
#'   - seq_positive: It has positive or 0 values
#'   - all_zero: It has only 0 values
#' ## lim:
#'   - If **divergent**: c(-max_abs, 0, max_abs) when max_abs is the maximum absolute value of all data
#'   - If **seq_positive** or **seq_negative**: c(min(d), max(d)) when max_abs is the maximum absolute value of all data
#'   - if **all_zerp**: c(0,0)
#'
#' @keywords internal
pal_get_scale_type_lim <- function(d) {
  data_rng <- range(d, na.rm = TRUE)
  negative <- data_rng[1] < 0 # nolint
  positive <- data_rng[2] > 0 # nolint

  UNK_SCALE <- "unknown_scale" # nolint

  scale_type <- dplyr::case_when(
    positive && negative ~ "divergent",
    positive && !negative ~ "seq_positive",
    !positive && negative ~ "seq_negative",
    !positive && !negative ~ "all_zero",
    TRUE ~ UNK_SCALE
  )

  stopifnot(scale_type != UNK_SCALE)

  max_abs <- max(abs(data_rng))

  scale_lim <- switch(scale_type,
    "divergent" = c(-max_abs, 0, max_abs),
    "seq_positive" = data_rng,
    "seq_negative" = data_rng,
    all_zero = 0,
    rlang::abort("scale_lim_not_found")
  )

  list(type = scale_type, lim = scale_lim)
}

assert_palette <- function(palette, add) {
  if (test_not_reactive(palette)) {
    checkmate::assert_character(palette,
      add = add,
      names = "named"
    )
  }
}

#' Create an svg simple legend for a categorical palette
#'
#' Colors can be specified as palettes or as colors, therefore we need to cover both.
#'
#' TODO: Consider not passing palettes and only passing colors inside the data
#'
#' @param palette
#'
#' @param data
#'
#' @keywords internal
#'

apply_cat_palette_legend <- function(palette, data) {
  pc <- names(palette)
  pv <- unname(palette)

  d <- data |>
    dplyr::distinct(dplyr::across(dplyr::any_of(c("y", "z", "color", "label"))))

  if ("color" %in% names(d)) {
    d[["color"]] <- purrr::pmap_chr(
      .l = list(tc = d[["color"]], tv = d[["z"]]),
      function(tc, tv) {
        if (!is.na(tc)) {
          return(tc)
        }
        return(pc[pv == tv])
      }
    )
  } else {
    d[["color"]] <- stats::setNames(pc, pv)[as.character(d[["z"]])]
  }

  d
}

create_cat_legend <- function(data) {
  # nolint start
  SQUARE_WIDTH <- 10
  SQUARE_HEIGHT <- 10
  ROW_HEIGHT <- SQUARE_HEIGHT
  SMALL_PADDING <- 2
  BIG_PADDING <- 5
  # nolint end

  data[["idx"]] <- seq_len(nrow(data)) - 1

  translate_group <- function(x, y) {
    paste0("translate(", x, ",", y, ")")
  }

  create_single_entries <- function(data) {
    data[["item"]] <- purrr::pmap(
      data,
      function(y, z, color, label, idx) {
        shiny::tagList(
          shiny::tags[["rect"]](x = "0", y = "0", height = SQUARE_HEIGHT, width = SQUARE_WIDTH, fill = color),
          shiny::tags[["text"]](
            x = SQUARE_WIDTH,
            y = SQUARE_HEIGHT,
            "font-size" = SQUARE_HEIGHT,
            "text-anchor" = "start",
            label
          )
        )
      }
    )
    return(data)
  }

  group_entries_by_cat <- function(data) {
    cat_entries <- list()

    for (idx in seq_len(nrow(data))) {
      cat <- as.character(data[["y"]][[idx]])
      tags <- data[["item"]][[idx]]

      cat_entries[[cat]] <- c(
        cat_entries[[cat]],
        list(shiny::tags[["g"]](
          tags,
          transform = translate_group(0, {
            l <- length(cat_entries[[cat]])
            message(l)
            (ROW_HEIGHT + SMALL_PADDING) * (length(cat_entries[[cat]]))
          })
        ))
      )
    }

    return(cat_entries)
  }

  group_entries_with_title <- function(cat_entries) {
    accum_height <- 0

    for (idx in seq_along(cat_entries)) {
      entry <- cat_entries[[idx]]
      name <- names(cat_entries)[[idx]]

      cat_entries[[idx]] <- shiny::tags[["g"]](
        shiny::tags[["text"]](
          x = 0, y = SQUARE_HEIGHT + BIG_PADDING,
          "font-size" = SQUARE_HEIGHT, "text-anchor" = "start", name
        ),
        shiny::tags[["g"]](
          entry,
          transform = translate_group(0, SQUARE_HEIGHT + BIG_PADDING + SMALL_PADDING)
        ),
        transform = translate_group(0, accum_height)
      )

      accum_height <- accum_height + (SQUARE_HEIGHT * length(entry)) + SQUARE_HEIGHT + BIG_PADDING + SMALL_PADDING
    }

    return(
      list(
        legend_groups = cat_entries,
        height = accum_height
      )
    )
  }

  g <- data |>
    create_single_entries() |>
    group_entries_by_cat() |>
    group_entries_with_title()

  shiny::tags[["svg"]](g[["legend_groups"]], height = g[["height"]] + BIG_PADDING + 50, width = 300)
}
