# nolint start
component <- "heatmap_d3"

# Steps
# 1. Start an app with AppDriver. We will not navigate using this driver but connect to it with other drivers.
#   - We do this to avoid creating the app in the background manually, but just delegate it to AppDriver.
# 2. Get the app url from the AppDriver.
# 3. Start a driver with a new session per test.
# Reason: This allows starting test in clean sessions without restarting the app (restarting apps is really time
# consuming).
# Possible problems: If the app process in the background itself crashes in a given test, following tests will crash.
#
# TEST RUN IN INDEPENDENT SESSIONS BUT NOT INDEPENDENT APPS

root_app <- start_app_driver(rlang::quo({
  non_reactive_args <- c()
  both_args <- c()
  reactive_args <- c("data", "x_axis", "y_axis", "z_axis", "margin", "palette", "msg_func", "quiet")

  # STOP MODIFYING

  non_reactive_id <- stats::setNames(non_reactive_args, non_reactive_args)
  both_id <- stats::setNames(both_args, both_args)
  reactive_id <- stats::setNames(reactive_args, reactive_args)

  # HELPERS

  eval_inpt <- function(x, input) {
    val <- shiny::reactive({
      v <- tryCatch(
        {
          eval(parse(text = input[[x]]))
        },
        error = function(e) {
          NULL
        }
      )
    })

    list(
      val = val,
      as_reactive = shiny::reactive(input[[paste0(x, "_as_reactive")]])
    )
  }

  solver <- function(x, as_reactive) {
    if (is.null(as_reactive)) {
      as_reactive <- x[["as_reactive"]]()
    }

    if (isTRUE(as_reactive)) {
      x[["val"]]
    } else {
      x[["val"]]()
    }
  }

  create_inpt_tb <- function(x, include_check) {
    shiny::tags[["table"]](
      purrr::map(
        x,
        ~ {
          shiny::tags[["tr"]](
            shiny::tags[["td"]](.x),
            shiny::tags[["td"]](shiny::textAreaInput(.x, NULL)),
            shiny::tags[["td"]](if (include_check) shiny::checkboxInput(paste0(.x, "_as_reactive"), "As reactive?")),
          )
        }
      )
    )
  }

  ui <- function(request) {
    non_reactive_tb <- create_inpt_tb(non_reactive_id, FALSE)
    reactive_tb <- create_inpt_tb(reactive_id, FALSE)
    both_tb <- create_inpt_tb(both_id, TRUE)

    shiny::fluidPage(
      shiny::tagList(
        shiny::div(
          shiny::tags[["h3"]]("Bookmark"),
          shiny::bookmarkButton()
        ),
        shiny::div(
          shiny::tags[["h3"]]("Static"),
          non_reactive_tb,
          shiny::tags[["hr"]]()
        ),
        shiny::div(
          shiny::tags[["h3"]]("Reactive"),
          reactive_tb,
          shiny::tags[["hr"]]()
        ),
        shiny::div(
          shiny::tags[["h3"]]("Both"),
          both_tb,
          shiny::tags[["hr"]]()
        ),
        shiny::div(
          shiny::tags[["h3"]]("Module"),
          shiny::uiOutput("cont")
        )
      )
    )
  }

  server <- function(input, output, session) {
    n_ipt <- purrr::map(non_reactive_id, ~ eval_inpt(.x, input))
    r_ipt <- purrr::map(reactive_id, ~ eval_inpt(.x, input))
    b_ipt <- purrr::map(both_id, ~ eval_inpt(.x, input))

    returned_values <- NULL

    output[["cont"]] <- shiny::renderUI({
      message("Rendering")
      # MODIFY THIS BODY

      # Non reactive input should usually be first checked with shiny::req as there are no internal controls in the
      # module for "strange" values in them

      returned_values <<- dv.explorer.parameter:::heatmap_d3_server(
        "mod",
        data = solver(r_ipt[["data"]], as_reactive = TRUE),
        x_axis = solver(r_ipt[["x_axis"]], as_reactive = TRUE),
        y_axis = solver(r_ipt[["y_axis"]], as_reactive = TRUE),
        z_axis = solver(r_ipt[["z_axis"]], as_reactive = TRUE),
        margin = solver(r_ipt[["margin"]], as_reactive = TRUE),
        palette = solver(r_ipt[["palette"]], as_reactive = TRUE),
        msg_func = solver(r_ipt[["msg_func"]], as_reactive = TRUE)
      )


      output[["out"]] <- shiny::renderPrint({
        returned_values[["margin"]]()
      })

      # UIs must be static

      shiny::tagList(
        dv.explorer.parameter:::heatmap_d3_UI("mod"),
        shiny::verbatimTextOutput("out")
      )
    })

    shiny::exportTestValues(
      # MODIFY PARAMETERS AS NEEDED
      returned = returned_values
    )
  }

  shiny::shinyApp(
    ui = ui,
    server = server,
    enableBookmarking = "url"
  )
}))
on.exit(if ("stop" %in% names(root_app)) root_app$stop())

fail_if_app_not_started <- function() {
  if (is.null(root_app)) rlang::abort("App could not be started")
}

EXPORTED_MARGIN <- "mod-margin"
D3_CONTAINER_SELECTOR <- "#mod-d3_container"
D3_TILE_GROUP <- "#mod-tile"
D3_LABEL_GROUP <- "#mod-lable"
X_TITLE_SELECTOR <- "#mod-x_title"
Y_TITLE_SELECTOR <- "#mod-y_title"
Z_TITLE_SELECTOR <- "#mod-z_title"
X_AXIS_SELECTOR <- "#mod-x_axis"
Y_AXIS_SELECTOR <- "#mod-y_axis"
Z_AXIS_SELECTOR <- "#mod-z_axis"
TOOLTIP_SELECTOR <- "#mod-tooltip"

SVG_JS_QUERY <- "document.querySelector('#mod-d3_heatmap').innerHTML;"

state_one <- rlang::exprs(
  data = {
    data <- tibble::tibble(
      x = factor(c("x_A", "x_B", "x_A", "x_B")),
      y = factor(c("y_A", "y_A", "y_B", "y_B")),
      z = c(1, 2, 3, 4),
      label = c("1", "2", "3", "4")
    )
    data <- set_lbl(data, "x", lbl = "x_title")
    data <- set_lbl(data, "y", lbl = "y_title")
  },
  x_axis = "S",
  y_axis = "W",
  z_axis = "E",
  margin = c(top = 10, bottom = 55, left = 45, right = 50),
  palette = c("red" = 1, "blue" = 4),
  msg_func = "(d)=>`X: ${d.x}<br>Y: ${d.y}<br>Z:${d.z}`"
)

state_two <- rlang::exprs(
  data = {
    data <- tibble::tibble(
      x = factor(c("x_AAA", "x_AAA")),
      y = factor(c("y_AAA", "y_BBB")),
      z = c(1000, 2000),
      label = c("1000", "2000")
    )
    data <- set_lbl(data, "x", lbl = "x_title")
    data <- set_lbl(data, "y", lbl = "y_title")
  },
  x_axis = "S",
  y_axis = "W",
  z_axis = "E",
  margin = c(top = 10, bottom = 55, left = 45, right = 50),
  palette = c("red" = 1000, "blue" = 2000),
  msg_func = "(d)=>`X: ${d.x}<br>Y: ${d.y}<br>Z:${d.z}`"
)

state_three <- rlang::exprs(
  data = {
    data <- tibble::tibble(
      x = factor(c("x_AAA", "x_AAA")),
      y = factor(c("y_AAA", "y_BBB")),
      z = factor(c("A", "B")),
      label = c("l_A", "l_B")
    )
    data <- set_lbl(data, "x", lbl = "x_title")
    data <- set_lbl(data, "y", lbl = "y_title")
  },
  x_axis = "S",
  y_axis = "W",
  z_axis = "E",
  margin = c(top = 10, bottom = 55, left = 45, right = 50),
  palette = c("red" = "A", "blue" = "B"),
  msg_func = "(d)=>`X: ${d.x}<br>Y: ${d.y}<br>Z:${d.z}`"
)

# helpers ----
# Returns the center first rectangle
get_rect_center <- function(app) {
  ch <- app$get_chromote_session()

  node_id <- ch$DOM$querySelector(
    nodeId = ch$DOM$getDocument()$root$nodeId,
    selector = "rect"
  )$nodeId

  d3_box <- ch$DOM$getBoxModel(node_id)$model$content
  x <- round(d3_box[[1]] + d3_box[[3]]) / 2
  y <- round(d3_box[[2]] + d3_box[[6]]) / 2

  return(c(x, y))
}

test_that(
  paste(component, "should show a heatmap with all the components when correct input is passed (continuous Z) (snapshot)"),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    app <- shinytest2::AppDriver$new(root_app$get_url())
    do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()
    expect_snapshot(cran = TRUE, app$get_js(SVG_JS_QUERY))
  }
)

test_that(
  paste(
    component,
    "should show a heatmap with all the components when correct input is passed (categorical Z) (snapshot)"
  ),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    app <- shinytest2::AppDriver$new(root_app$get_url())
    do.call(app$set_inputs, purrr::map(state_three, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()
    expect_snapshot(cran = TRUE, app$get_js(SVG_JS_QUERY))
  }
)

test_that(
  paste(component, "should not have duplicated elements when we redraw the image"),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()

    # We check that the returned svgs are the same when switching between states, this implies no duplicated
    # elements appear when the svg is redrawn. If any duplicated element appear there would be differences between
    # first and second pass

    app <- shinytest2::AppDriver$new(root_app$get_url())
    do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()
    svg_st_one_1pass <- app$get_js(SVG_JS_QUERY)
    do.call(app$set_inputs, purrr::map(state_two, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()
    svg_st_two_1pass <- app$get_js(SVG_JS_QUERY)
    do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()
    svg_st_one_2pass <- app$get_js(SVG_JS_QUERY)
    do.call(app$set_inputs, purrr::map(state_two, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()
    svg_st_two_2pass <- app$get_js(SVG_JS_QUERY)

    expect_equal(svg_st_one_1pass, svg_st_one_2pass)
    expect_equal(svg_st_two_1pass, svg_st_two_2pass)
  }
)

test_that(
  paste(component, "should not include titles when there is no data label"),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    app <- shinytest2::AppDriver$new(root_app$get_url())
    do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()

    # Present in state_one
    rvest::read_html(app$get_js(SVG_JS_QUERY)) %>%
      rvest::html_elements(X_TITLE_SELECTOR) %>%
      expect_length(1)

    rvest::read_html(app$get_js(SVG_JS_QUERY)) %>%
      rvest::html_elements(Y_TITLE_SELECTOR) %>%
      expect_length(1)

    state <- rlang::exprs(
      data = {
        data <- tibble::tibble(
          x = factor(c("x_A", "x_B")),
          y = factor(c(1, 2)),
          z = factor(c("z_A", "z_B")),
          label = c("l_A", "l_B")
        )
        data <- set_lbl(data, "x", lbl = NULL)
        data <- set_lbl(data, "y", lbl = NULL)
      }
    )

    do.call(app$set_inputs, purrr::map(state, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()

    # Not Present with NULL label
    rvest::read_html(app$get_js(SVG_JS_QUERY)) %>%
      rvest::html_elements(X_TITLE_SELECTOR) %>%
      expect_length(0)
    rvest::read_html(app$get_js(SVG_JS_QUERY)) %>%
      rvest::html_elements(Y_TITLE_SELECTOR) %>%
      expect_length(0)
  }
)

test_that(
  paste(component, "should not include axis when the parameter is null"),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    app <- shinytest2::AppDriver$new(root_app$get_url())
    do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()

    # Present in state_one

    rvest::read_html(app$get_js(SVG_JS_QUERY)) %>%
      rvest::html_elements(X_AXIS_SELECTOR) %>%
      rvest::html_children() %>%
      length() %>%
      `>`(0) %>%
      expect_true()

    rvest::read_html(app$get_js(SVG_JS_QUERY)) %>%
      rvest::html_elements(Y_AXIS_SELECTOR) %>%
      rvest::html_children() %>%
      length() %>%
      `>`(0) %>%
      expect_true()

    rvest::read_html(app$get_js(SVG_JS_QUERY)) %>%
      rvest::html_elements(Z_AXIS_SELECTOR) %>%
      rvest::html_children() %>%
      length() %>%
      `>`(0) %>%
      expect_true()

    state <- rlang::exprs(
      x_axis = NULL,
      y_axis = NULL,
      z_axis = NULL,
    )

    do.call(app$set_inputs, purrr::map(state, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()

    # Set all axis to NULL

    rvest::read_html(app$get_js(SVG_JS_QUERY)) %>%
      rvest::html_elements(X_AXIS_SELECTOR) %>%
      rvest::html_children() %>%
      length() %>%
      `==`(0) %>%
      expect_true()

    rvest::read_html(app$get_js(SVG_JS_QUERY)) %>%
      rvest::html_elements(Y_AXIS_SELECTOR) %>%
      rvest::html_children() %>%
      length() %>%
      `==`(0) %>%
      expect_true()

    rvest::read_html(app$get_js(SVG_JS_QUERY)) %>%
      rvest::html_elements(Z_AXIS_SELECTOR) %>%
      rvest::html_children() %>%
      length() %>%
      `==`(0) %>%
      expect_true()
  }
)

test_that(
  paste(component, "should return the requested margins"),
  {
    # Expected margins were checked visually against a running app
    # Keep in mind that the app uses the margins passed as options and not the requested ones
    # This means that when viewing the app the titles and axis appear cut, but here we are testing
    # what the module request as minimum margins, not the actual margins.
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    app <- shinytest2::AppDriver$new(root_app$get_url())

    do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()
    req_margins_st_one <- app$get_values()[["export"]][[EXPORTED_MARGIN]]
    exp_margins_st_one <- list(top = 0, bottom = 45, left = 49, right = 24) %>%
      purrr::map(as.integer)
    expect_identical(req_margins_st_one, exp_margins_st_one)

    do.call(app$set_inputs, purrr::map(state_two, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()
    req_margins_st_two <- app$get_values()[["export"]][[EXPORTED_MARGIN]]
    exp_margins_st_two <- list(top = 0, bottom = 58, left = 63, right = 44) %>%
      purrr::map(as.integer)
    expect_identical(req_margins_st_two, exp_margins_st_two)
  }
)

test_that(
  paste(
    component,
    "should
     start with a hidden tooltip,
     present a tooltip when the mouse move in rectangles
     and hide it when it moves out"
  ),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()


    app <- shinytest2::AppDriver$new(root_app$get_url())
    ch <- app$get_chromote_session()
    do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()


    rect_1 <- get_rect_center(app)

    expect_opacity <- function(opacity_value, visibility_value) {
      test <- app$get_html(TOOLTIP_SELECTOR) %>%
        rvest::read_html() %>%
        rvest::html_element(css = TOOLTIP_SELECTOR) %>%
        rvest::html_attr(name = "style") %>%
        (function(x) {
          stringr::str_detect(x, sprintf("opacity: %s;", opacity_value)) && stringr::str_detect(x, sprintf("visibility: %s;", visibility_value))
        })
      expect_true(test)
    }


    # In the test, I want to move the mouse over an element.
    # For the mouse to move over an element, the element must be in the viewport.
    # To ensure this, I set the viewport to be as large as the page. (Advantage of using an emulated browser)
    # Now, I can move the mouse anywhere on the page.

    metrics <- ch$Page$getLayoutMetrics()
    ch$Emulation$setDeviceMetricsOverride(width = metrics$contentSize$width, height = metrics$contentSize$height, deviceScaleFactor = 1, mobile = FALSE)

    # Starts hidden
    expect_opacity(0, "hidden")
    # Move in
    ch$Input$dispatchMouseEvent(type = "mouseMoved", x = rect_1[1], y = rect_1[2], button = "left")
    expect_opacity(1, "visible")
    # Move out
    ch$Input$dispatchMouseEvent(type = "mouseMoved", x = 0, y = 0, button = "left")
    expect_opacity(0, "hidden")
  }
)

test_that(
  paste(
    component,
    "should allow customizing the tooltip message"
  ),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    app <- shinytest2::AppDriver$new(root_app$get_url())
    ch <- app$get_chromote_session()
    do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()

    state <- rlang::exprs(
      msg_func = "(d)=>`${d.x}, ${d.y}, ${d.z}`"
    )

    do.call(app$set_inputs, purrr::map(state, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()

    rect_1 <- get_rect_center(app)

    metrics <- ch$Page$getLayoutMetrics()
    ch$Emulation$setDeviceMetricsOverride(width = metrics$contentSize$width, height = metrics$contentSize$height, deviceScaleFactor = 1, mobile = FALSE)

    # Move in
    ch$Input$dispatchMouseEvent(type = "mouseMoved", x = rect_1[1], y = rect_1[2], button = "left")
    app$get_html(TOOLTIP_SELECTOR) %>%
      rvest::read_html() %>%
      rvest::html_element(css = TOOLTIP_SELECTOR) %>%
      rvest::html_text() %>%
      expect_identical("x_A, y_A, 1")
  }
)

test_that(
  paste(component, "should accept colors and NAs in the color column"),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    app <- shinytest2::AppDriver$new(root_app$get_url())
    do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()

    state <- rlang::exprs(
      data = {
        data <- tibble::tibble(
          x = factor(c("x_AAA", "x_AAA")),
          y = factor(c("y_AAA", "y_BBB")),
          z = c(1000, 2000),
          label = c("1000", "2000"),
          color = c("orange", NA)
        )
        data <- set_lbl(data, "x", lbl = "x_title")
        data <- set_lbl(data, "y", lbl = "y_title")
      },
    )

    do.call(app$set_inputs, purrr::map(state, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()
    expect_snapshot(cran = TRUE, app$get_js(SVG_JS_QUERY))
  }
)


# Tests from bugs ----

test_that(
  paste(
    component,
    "should show a heatmap with all the components when two values have the same color in the palette (categorical Z) (snapshot)"
  ),
  {
    # Origin: At some stage we required that names in the palette were unique. This threw errors when several values
    # had the same color assigned, this happened often with categories when the colors were exhausted.

    state <- rlang::exprs(
      data = {
        data <- tibble::tibble(
          x = factor(c("x_AAA", "x_AAA")),
          y = factor(c("y_AAA", "y_BBB")),
          z = factor(c("A", "B")),
          label = c("l_A", "l_B")
        )
        data <- set_lbl(data, "x", lbl = "x_title")
        data <- set_lbl(data, "y", lbl = "y_title")
      },
      x_axis = "S",
      y_axis = "W",
      z_axis = "E",
      margin = c(top = 10, bottom = 55, left = 45, right = 50),
      palette = c("red" = "A", "red" = "B"),
      msg_func = "(d)=>`X: ${d.x}<br>Y: ${d.y}<br>Z:${d.z}`"
    )

    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    app <- shinytest2::AppDriver$new(root_app$get_url())
    do.call(app$set_inputs, purrr::map(state, ~ deparse1(.x, collapse = "\n")))
    app$wait_for_idle()
    expect_snapshot(cran = TRUE, app$get_js(SVG_JS_QUERY))
  }
)
# nolint end
