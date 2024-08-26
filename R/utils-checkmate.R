#' @keywords internal
paste_ctxt_factory <- function(context) {
  function(var_name) paste0("(", context, "): ", checkmate::vname(var_name))
}

# Either throws an assert or returns true, it is a middle ground between checkmates checks and assert.
#' @keywords internal
assert_or_true <- function(check, .var.name, add = NULL) { # nolint
  checkmate::makeAssertion(TRUE, res = check, var.name = .var.name, collection = add)
}

#' @keywords internal
test_not_reactive <- function(x) {
  !checkmate::test_multi_class(x, c("reactive", "shinymeta_reactive"))
}

#' @keywords internal
validate_input <- function(x, vf, context) {
  shiny::reactive(
    {
      rx <- resolve_or_return(x)
      ac <- checkmate::makeAssertCollection()
      vf(rx, add = ac)
      checkmate::reportAssertions(ac)
      rx
    },
    label = paste(context, checkmate::vname(x))
  )
}

#' @keywords internal
assert_margin <- function(margin, add) {
  if (test_not_reactive(margin)) {
    checkmate::assert_list(
      margin,
      any.missing = FALSE, len = 4, names = "named", types = "numeric", add = add
    )
    checkmate::assert_names(
      names(margin),
      type = "unique",
      permutation.of = c("top", "bottom", "left", "right"), add = add
    )
  }
}
