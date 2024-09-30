# it_ stands for "interactive title"

it_custom_styles <- shiny::tags[["head"]](
  # nolint start
  shiny::tags[["style"]](
    "
    .nopad { display: inline-block; }                                 /* horizontal layout */
    .selector_as_link .selectize-input { border:0px; padding:0}             /* horizontally aligned with rest of text */
    .selector_as_link .shiny-input-container { width:auto; margin: 0 }
    .selector_as_link.shiny-input-container { width:auto; }
    .selector_as_link .selectize-control.single .selectize-input:after { display: none }
    .selector_as_link .control-label {display: none}
    .nopad .selectize-control { display: inline-block; vertical-align: top; margin: 0}

    .selector_as_link .item { color:#069; }                                    /* link-ish color */
    .selector_as_link .item:hover { text-decoration: underline; }              /* link-ish behavior */

    .selector_as_link .selectize-dropdown.single { width:auto !important }     /* wider drop-down options */

    .button_as_link.drop-menu-input button { /* horizontally aligned with rest of text */
      vertical-align:top; border:0px; padding: 0; color:#069
    }

    .centered_flex_row { display:flex;flex-direction:row;justify-content:center;align-items:baseline;gap:0.5rem; }
    "
  )
  # nolint end
)

it_as_link <- function(tag) {
  res <- NULL
  checkmate::assert_class(tag, "shiny.tag")

  if (length(grep("\\<drop-menu-input\\>", tag$attribs[["class"]])) > 0) {
    res <- shiny::tagAppendAttributes(tag, class = "button_as_link")
  } else { # FIXME: Assumes (probably mistakenly, that anything that is not a drop menu is a selector)
    res <- shiny::tagAppendAttributes(tag, class = "selector_as_link nopad")
  }
  res
}

# FIXME: Smells like too much magic
it_interactive_title <- function(...) {
  l <- list(...)
  for (i in seq_along(l)) {
    e <- l[[i]]
    if (is.character(e)) {
      e <- shiny::p(e)
    } else {
      e <- it_as_link(e)
    }
    l[[i]] <- e
  }

  div <- do.call(shiny::div, l) |> shiny::tagAppendAttributes(class = "centered_flex_row")

  return(shiny::tagList(it_custom_styles, div))
}

it_selection_to_label <- function(sel, max_char) {
  label <- NULL
  sel_count <- length(sel)
  if (sel_count > 0) {
    label <- paste0(sel[1], ", ...")
    potential_label <- ""
    for (i in seq(sel_count)) {
      potential_label <- paste(sel[1:i], collapse = ", ")
      if (i < sel_count) label <- paste0(potential_label, ", ...")
      if (nchar(label) <= 32) {
        label <- potential_label
      } else {
        break
      }
    }
  }
  label
}

it_error_highlight <- function(s) paste0('<span style="color:#a94442;font-style: italic;" >', s, "</span>")

it_relabel_button <- function(id,
                              is_valid = shiny::reactive(TRUE),
                              label_if_valid,
                              label_if_not_valid = shiny::reactive("_"),
                              session = shiny::getDefaultReactiveDomain()) {
  shiny::observe({
    is_valid <- is_valid()
    shiny::req(is.logical(is_valid))

    label <- NULL
    if (is_valid) {
      label <- try(label_if_valid())
      if (inherits(label, "try-error")) label <- NULL
    } else {
      label <- it_error_highlight(label_if_not_valid())
    }
    if (is.null(label)) label <- it_error_highlight("unable to get button label")

    shiny::updateActionButton(session = session, inputId = id, label = label)
  })
}
