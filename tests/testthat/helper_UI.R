advance_until <- function(arr, i, target_char) {
  n <- length(arr)
  repeat {
    i <- i + 1
    if (i > n || arr[[i]] == "\\") { # ignore escape sequence
      i <- i + 1
      next
    }
    if (i > n || arr[[i]] == target_char) break
  }
  i
}
# nolint start
get_js_global_symbols <- function(s) {
  arr <- sapply(utf8ToInt(s), intToUtf8)

  no_strings_nor_comments <- local({
    res <- c()
    n <- length(arr)
    i <- 0
    while (i < n) {
      i <- i + 1
      c <- arr[[i]]
      if (c == "'" || c == '"') { # skips over string literals
        i <- advance_until(arr, i, c)
        next
      } else if (c == "/") {
        i <- i + 1
        c <- arr[[i]]
        if (c == "/") { # skips over single-line comments
          i <- advance_until(arr, i, "\n")
          next
        } else if (c == "*") { # skips over multi-line comments
          repeat {
            i <- i + 1
            if (i + 1 > n || (arr[[i]] == "*" && arr[[i + 1]] == "/")) break
          }
          i <- i + 1
          next
        }
      }

      res <- c(res, c)
    }
    res
  })

  arr <- no_strings_nor_comments

  no_nested_content <- local({
    res <- c()
    n <- length(arr)

    scope_depth <- 0

    i <- 0
    while (i < n) {
      i <- i + 1
      c <- arr[[i]]
      if (c == "{") {
        scope_depth <- scope_depth + 1
      } else if (c == "}") {
        stopifnot(scope_depth > 0)
        scope_depth <- scope_depth - 1
      } else if (scope_depth == 0) {
        res <- c(res, c)
      }
    }

    res
  })

  ids <- local({
    res <- c()
    assignment_locations <- which(no_nested_content == "=")

    is_whitespace <- function(c) c <= " "

    for (loc in assignment_locations) {
      i <- loc
      while (i > 1 && is_whitespace(no_nested_content[[i - 1]])) i <- i - 1
      end <- i - 1
      while (i > 1 && !is_whitespace(no_nested_content[[i - 1]])) i <- i - 1
      beg <- i

      if (!is_whitespace(no_nested_content[[beg]])) {
        id <- paste(no_nested_content[beg:end], collapse = "")
        if (make.names(id) == id) {
          res <- c(res, id)
        }
      }
    }
    res
  })

  ids
}

# nolint end

# These helper locates unprefixed UIs
unprefixed_UI_ids <- function(prefix, l, path = "", ignored_uiOutputs = c()) { # nolint
  res <- list()

  if (inherits(l, "shiny.tag.list")) {
    new_path <- paste0(path, "/tag_list")
    for (child in l) {
      sub_res <- unprefixed_UI_ids(prefix, child, new_path, ignored_uiOutputs)
      res <- c(res, sub_res)
    }
  } else if (inherits(l, "shiny.tag")) {
    class(l) <- "list"
    html_element <- l[["name"]]
    id <- l[["attribs"]][["id"]]
    l_class <- l[["attribs"]][["class"]]

    new_path <- paste0(path, "/<", html_element, ' id="', id, '">')
    if (!is.null(id) && !startsWith(id, paste0(prefix, "-"))) {
      res <- append(res, new_path)
    }

    for (child in l[["children"]]) {
      sub_res <- unprefixed_UI_ids(prefix, child, new_path, ignored_uiOutputs)
      res <- append(res, sub_res)
    }

    if (!is.null(l_class)) {
      if (is.null(id) || !(id %in% paste0(prefix, "-", ignored_uiOutputs))) {
        classes <- strsplit(l_class, " ")[[1]]
        if ("shiny-html-output" %in% classes) {
          res <- append(res, paste0(new_path, ": uiOutput can hide unprefixed ids"))
        }
        if ("html-widget-output" %in% classes) {
          res <- append(res, paste0(new_path, ": widget output can hide unprefixed ids"))
        }
      }
    }

    if (identical(html_element, "script")) {
      stopifnot(length(l[["children"]]) == 1)
      script <- l[["children"]][[1]]
      js_symbols <- get_js_global_symbols(script)

      for (id in js_symbols) {
        if (!is.null(id) && !startsWith(id, paste0(prefix, "_"))) {
          res <- append(res, paste0(new_path, "/", id))
        }
      }
    }
  } else {
  }
  res
}
