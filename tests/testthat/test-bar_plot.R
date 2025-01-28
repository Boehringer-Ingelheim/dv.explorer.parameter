# nolint start
component <- "bar_D3"
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


# Create an app in the background

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

      returned_values <<- bar_d3_server(
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
        bar_d3_UI("mod"),
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


C <- pack_of_constants(
  EXPORTED_MARGIN = "mod-margin",
  D3_CONTAINER_SELECTOR = "#mod-d3_container",
  D3_BAR_GROUP = "#mod-bar",
  D3_LABEL_GROUP = "#mod-lable",
  X_TITLE_SELECTOR = "#mod-x_title",
  Y_TITLE_SELECTOR = "#mod-y_title",
  Z_TITLE_SELECTOR = "#mod-z_title",
  X_AXIS_SELECTOR = "#mod-x_axis",
  Y_AXIS_SELECTOR = "#mod-y_axis",
  Z_AXIS_SELECTOR = "#mod-z_axis",
  TOOLTIP_SELECTOR = "#mod-tooltip",
  SVG_JS_QUERY = "document.querySelector('#mod-d3_bar').innerHTML;"
)

state_one <- rlang::exprs(
  data = {
    data <- tibble::tibble(
      x = factor(c("x_A", "x_B")),
      y = c(1, 2),
      z = factor(c("z_A", "z_B")),
      label = c("l_A", "l_B")
    )
    data <- set_lbl(data, "x", lbl = "x_title")
    data <- set_lbl(data, "y", lbl = "y_title")
  },
  x_axis = "S",
  y_axis = "W",
  z_axis = "E",
  margin = c(top = 10, bottom = 55, left = 45, right = 50),
  palette = c("red" = "z_A", "blue" = "z_B"),
  msg_func = "(d)=>`X: ${d.x}<br>Y: ${d.y}<br>Z:${d.z}`",
  quiet = TRUE
)

state_two <- rlang::exprs(
  data = {
    data <- tibble::tibble(
      x = factor(c("x_AAAAA", "x_BBBBB")),
      y = c(1, 30),
      z = factor(c("z_AAAAA", "z_BBBBB")),
      label = c("l_AAAAA", "l_BBBBB")
    )
    data <- set_lbl(data, "x", lbl = "xxxxx_title")
    data <- set_lbl(data, "y", lbl = "yyyyy_title")
  },
  x_axis = "S",
  y_axis = "W",
  z_axis = "E",
  margin = c(top = 50, bottom = 60, left = 70, right = 80),
  palette = c("green" = "z_AAAAA", "maroon" = "z_BBBBB"),
  msg_func = "(d)=>`X: ${d.x}<br>Y: ${d.y}<br>Z:${d.z}`"
)

# ---- helper

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

shiny_test <- {
  test_that(
    paste(component, "should show a heatmap with all the components when correct input is passed (snapshot)") |>
      vdoc[["add_spec"]](c(
        specs$wfphm$wf$custom_palette
      )
      ),
    {
      testthat::skip_if_not(run_shiny_tests)
      fail_if_app_not_started()
      skip_if_suspect_check()
      app <- shinytest2::AppDriver$new(root_app$get_url())
      do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
      app$wait_for_idle()
      expect_snapshot(cran = TRUE, app$get_js(C$SVG_JS_QUERY))
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
      svg_st_one_1pass <- app$get_js(C$SVG_JS_QUERY)
      do.call(app$set_inputs, purrr::map(state_two, ~ deparse1(.x, collapse = "\n")))
      app$wait_for_idle()
      svg_st_two_1pass <- app$get_js(C$SVG_JS_QUERY)
      do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
      app$wait_for_idle()
      svg_st_one_2pass <- app$get_js(C$SVG_JS_QUERY)
      do.call(app$set_inputs, purrr::map(state_two, ~ deparse1(.x, collapse = "\n")))
      app$wait_for_idle()
      svg_st_two_2pass <- app$get_js(C$SVG_JS_QUERY)

      expect_equal(svg_st_one_1pass, svg_st_one_2pass)
      expect_equal(svg_st_two_1pass, svg_st_two_2pass)
    }
  )

  test_that(
    paste(component, "should include titles depending on data label") |>
      vdoc[["add_spec"]](c(
        specs$wfphm$wf$plot_y_axis_label
      )),
    {
      testthat::skip_if_not(run_shiny_tests)
      fail_if_app_not_started()
      skip_if_suspect_check()
      app <- shinytest2::AppDriver$new(root_app$get_url())
      do.call(app$set_inputs, purrr::map(state_one, ~ deparse1(.x, collapse = "\n")))
      app$wait_for_idle()
      # Present in state_one
      rvest::read_html(app$get_js(C$SVG_JS_QUERY)) %>%
        rvest::html_elements(C$X_TITLE_SELECTOR) %>%
        expect_length(1)
      rvest::read_html(app$get_js(C$SVG_JS_QUERY)) %>%
        rvest::html_elements(C$Y_TITLE_SELECTOR) %>%
        expect_length(1)

      # Not Present with NULL label
      state <- rlang::exprs(
        data = {
          data <- tibble::tibble(
            x = factor(c("x_A", "x_B")),
            y = c(1, 2),
            z = factor(c("z_A", "z_B")),
            label = c("l_A", "l_B")
          )
          data <- set_lbl(data, "x", lbl = NULL)
          data <- set_lbl(data, "y", lbl = NULL)
        }
      )

      do.call(app$set_inputs, purrr::map(state, ~ deparse1(.x, collapse = "\n")))
      app$wait_for_idle()
      rvest::read_html(app$get_js(C$SVG_JS_QUERY)) %>%
        rvest::html_elements(C$X_TITLE_SELECTOR) %>%
        expect_length(0)
      rvest::read_html(app$get_js(C$SVG_JS_QUERY)) %>%
        rvest::html_elements(C$Y_TITLE_SELECTOR) %>%
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

      rvest::read_html(app$get_js(C$SVG_JS_QUERY)) %>%
        rvest::html_elements(C$X_AXIS_SELECTOR) %>%
        rvest::html_children() %>%
        length() %>%
        `>`(0) %>%
        expect_true()

      rvest::read_html(app$get_js(C$SVG_JS_QUERY)) %>%
        rvest::html_elements(C$Y_AXIS_SELECTOR) %>%
        rvest::html_children() %>%
        length() %>%
        `>`(0) %>%
        expect_true()

      rvest::read_html(app$get_js(C$SVG_JS_QUERY)) %>%
        rvest::html_elements(C$Z_AXIS_SELECTOR) %>%
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

      rvest::read_html(app$get_js(C$SVG_JS_QUERY)) %>%
        rvest::html_elements(C$X_AXIS_SELECTOR) %>%
        rvest::html_children() %>%
        expect_length(0)

      rvest::read_html(app$get_js(C$SVG_JS_QUERY)) %>%
        rvest::html_elements(C$Y_AXIS_SELECTOR) %>%
        rvest::html_children() %>%
        expect_length(0)

      rvest::read_html(app$get_js(C$SVG_JS_QUERY)) %>%
        rvest::html_elements(C$Z_AXIS_SELECTOR) %>%
        rvest::html_children() %>%
        expect_length(0)
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
      req_margins_st_one <- app$get_values()[["export"]][[C$EXPORTED_MARGIN]]
      exp_margins_st_one <- list(top = 0, bottom = 40, left = 46, right = 36) %>%
        purrr::map(as.integer)
      expect_identical(req_margins_st_one, exp_margins_st_one)

      do.call(app$set_inputs, purrr::map(state_two, ~ deparse1(.x, collapse = "\n")))
      app$wait_for_idle()
      req_margins_st_two <- app$get_values()[["export"]][[C$EXPORTED_MARGIN]]
      exp_margins_st_two <- list(top = 0, bottom = 67, left = 43, right = 63) %>%
        purrr::map(as.integer)
      expect_identical(req_margins_st_two, exp_margins_st_two)
    }
  )

  test_that(
    paste(
      component,
      "should",
      "1. start with a hidden tooltip",
      "2. present a tooltip when the mouse move in rectangles",
      "3. hide it when it moves out"
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
          test <- app$get_html(C$TOOLTIP_SELECTOR) %>%
            rvest::read_html() %>%
            rvest::html_element(css = C$TOOLTIP_SELECTOR) %>%
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


      # In the test, I want to move the mouse over an element.
      # For the mouse to move over an element, the element must be in the viewport.
      # To ensure this, I set the viewport to be as large as the page. (Advantage of using an emulated browser)
      # Now, I can move the mouse anywhere on the page.

      metrics <- ch$Page$getLayoutMetrics()
      ch$Emulation$setDeviceMetricsOverride(width = metrics$contentSize$width, height = metrics$contentSize$height, deviceScaleFactor = 1, mobile = FALSE)

      # Move in      
      ch$Input$dispatchMouseEvent(type = "mouseMoved", x = rect_1[1], y = rect_1[2], button = "left")

      tt_msg <- app$get_html(C$TOOLTIP_SELECTOR) %>%
          rvest::read_html() %>%
          rvest::html_element(css = C$TOOLTIP_SELECTOR) %>%
          rvest::html_text()

      expect_identical(tt_msg, "x_A, 1, z_A")
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
            x = factor(c("x_A", "x_B")),
            y = c(1, 2),
            z = factor(c("z_A", "z_B")),
            label = c("l_A", "l_B"),
            color = c("orange", NA)
          )
          data <- set_lbl(data, "x", lbl = "x_title")
          data <- set_lbl(data, "y", lbl = "y_title")
        }
      )
      do.call(app$set_inputs, purrr::map(state, ~ deparse1(.x, collapse = "\n")))
      app$wait_for_idle()
      expect_snapshot(cran = TRUE, app$get_js(C$SVG_JS_QUERY))
    }
  )

  test_that(
    paste(
      component,
      "test_y_baseline NOT DONE"
    ),
    {
      skip("Base line != 0 not implemented")

      testthat::skip_if_not(run_shiny_tests)
      fail_if_app_not_started()
      skip_if_suspect_check()
    }
  )
}

# argument_testing <- {

#   # argument testing:

#   correct_args <- list(
#     data = tibble::tibble(
#       x = factor(c("x_A", "x_B")),
#       y = c(1, 2),
#       z = factor(c("z_A", "z_B"))
#     ),
#     x_axis = NULL,
#     y_axis = NULL,
#     z_axis = NULL,
#     margin = c(top = 0, bottom = 0, left = 0, right = 0),
#     palette = c("A" = "A"),
#     msg_func = "A",
#     quiet = TRUE
#   )

#   test_that(
#     paste(
#       component,
#       "data types must comply with doc",
#       collapse = "; "
#     ), {

#       # is dataframe

#       shiny::testServer(
#         app = bar_d3_server,
#         args = ,
#         expr = {
#         }
#       ) %>%
#         testthat::expect_snapshot_error(class = "simpleError")

#       # contains at least x,y,z columns

#       shiny::testServer(
#         app = bar_d3_server,
#         args = purrr::list_modify(correct_args, list(data = tibble::tibble())),
#         expr = {
#         }
#       ) %>%
#         testthat::expect_snapshot_error(class = "simpleError")
#     }
#   )

# }
# nolint end

