# nolint start

component <- "wfphm-wf"
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
  mock_app_wfphm()
}))
on.exit(if ("stop" %in% names(root_app)) root_app$stop())

fail_if_app_not_started <- function() {
  if (is.null(root_app)) rlang::abort("App could not be started")
}

tns <- tns_factory("not_ebas")

C <- pack_of_constants(
  VISIT = tns("wf-visit-val"),
  CAT = tns("hmcat-cat-val"),
  CONT = tns("hmcont-cont-val"),
  PCAT = tns("hmpar-par-cat_val"),
  PPAR = tns("hmpar-par-par_val"),
  PVAL = tns("hmpar-value-val"),
  PVISIT = tns("hmpar-visit-val"),
  PTR = tns("hmpar-transform"),
  WF_QUERY = "document.querySelector('#not_ebas-wf-chart-d3_bar').innerHTML;",
  WF_CONTAINER = "#not_ebas-wf-chart-d3_container",
  HMCAT_QUERY = "document.querySelector('#not_ebas-hmcat-chart-d3_heatmap').innerHTML;",
  HMCAT_CONTAINER = "#not_ebas-hmcat-chart-d3_container",
  HMCONT_QUERY = "document.querySelector('#not_ebas-hmcont-chart-d3_heatmap').innerHTML;",
  HMCONT_CONTAINER = "#not_ebas-hmcont-chart-d3_container",
  HMPAR_QUERY = "document.querySelector('#not_ebas-hmpar-chart-d3_heatmap').innerHTML;",
  HMPAR_CONTAINER = "#not_ebas-hmpar-chart-d3_container",
  NON_GXP_TAG = "#not_ebas-non_gxp_tag",
  SAVE_PNG = tns("save_png"),
  SAVE_SVG = tns("save_svg"),
  FILENAME = tns("filename")
)

test_that(
  paste(
    component,
    "calls are done with the correct arguments"
  ) %>%
    vdoc[["add_spec"]](c(
      specs$wfphm$wfphm$composition,
      specs$wfphm$wfphm$x_sorted
    )
    ),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    app <- shinytest2::AppDriver$new(root_app$get_url())
    app$set_inputs(
      !!C$CAT := "CAT1",
      !!C$CONT := "CONT1",
      !!C$PCAT := "PARCAT1"
    )

    app$set_inputs(
      !!C$PPAR := "PARAM11"
    )

    app$wait_for_idle()
    exported_values <- app$get_values(export = TRUE)[["export"]]

    resolve_reactive <- function(x) {
      lapply(
        x,
        function(v) {
          if (is.function(v)) {
            shiny::isolate(v())
          } else {
            v
          }
        }
      )
    }


    expect_snapshot(cran = TRUE, exported_values[["not_ebas-wf_args"]] |> resolve_reactive())
    expect_snapshot(cran = TRUE, exported_values[["not_ebas-hmcat_args"]] |> resolve_reactive())
    expect_snapshot(cran = TRUE, exported_values[["not_ebas-hmcont_args"]] |> resolve_reactive())
    expect_snapshot(cran = TRUE, exported_values[["not_ebas-hmpar_args"]] |> resolve_reactive(), transform = function(x) {
      is_bytecode <- grepl("bytecode", x)
      ifelse(is_bytecode, "<bytecode: RANDOM VALUE - NO SNAPSHOT>", x)
    })
  }
)

test_that(
  paste(
    component,
    "plots are drawn and files are saved"
  ) %>%
    vdoc[["add_spec"]](c(
      specs$wfphm$wfphm$composition,
      specs$wfphm$wfphm$x_sorted,
      specs$wfphm$wfphm$chart_download
    )
    ),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    app <- shinytest2::AppDriver$new(root_app$get_url())
    app$set_inputs(
      !!C$CAT := "CAT1", # nolint
      !!C$CONT := "CONT1", # nolint
      !!C$PCAT := "PARCAT1" # nolint
    )

    app$set_inputs(
      !!C$PPAR := "PARAM11" # nolint
    )

    app$wait_for_idle()

    expect_r2d3_svg(app, list(
      list(svg = C$WF_QUERY, container = C$WF_CONTAINER, n = 1),
      list(svg = C$HMCAT_QUERY, container = C$HMCAT_CONTAINER, n = 1),
      list(svg = C$HMCONT_QUERY, container = C$HMCONT_CONTAINER, n = 1),
      list(svg = C$HMPAR_QUERY, container = C$HMPAR_CONTAINER, n = 2)
    ))

    down_dir <- tempdir()
    filename <- "filename"
    app$get_chromote_session()$Browser$setDownloadBehavior("allow", downloadPath = down_dir)

    do.call(app$set_inputs, setNames(list(filename), list(C$FILENAME)))
    app$wait_for_idle()
    app$click(C$SAVE_PNG)
    app$wait_for_idle()
    app$click(C$SAVE_SVG)
    app$wait_for_idle()

    png_file <- file.path(down_dir, sprintf("%s.png", filename))
    svg_file <- file.path(down_dir, sprintf("%s.svg", filename))

    retry <- 10
    file_found <- FALSE
    while (!file_found && retry > 0) {
      file_found <- file.exists(png_file)
      retry <- retry - 1
    }

    expect_true(file_found)
    expect_snapshot_file(path = png_file)
    expect_snapshot_file(path = svg_file)
  }
)

test_that(
  paste(
    component,
    "nonGxP notification is shown"
  ) %>%
    vdoc[["add_spec"]](c(
      specs$wfphm$wfphm$non_gxp_notification
    )
    ),
  {
    testthat::skip_if_not(run_shiny_tests)
    fail_if_app_not_started()
    skip_if_suspect_check()
    app <- shinytest2::AppDriver$new(root_app$get_url())
    expect_length(app$get_html(C$NON_GXP_TAG), 1)
  }
)

test_that(
  "wfphm validation error when bm_dataset or group_dataset have 0 rows",
  {
    shiny::testServer(
      wfphm_server,
      args = list(
        id = "A",
        bm_dataset = shiny::reactive(tibble::tibble()),
        group_dataset = shiny::reactive(tibble::tibble())
      ),
      {
        v_bm_dataset() %>%
          expect_snapshot_error(class = "validation", cran = TRUE)

        v_group_dataset() %>%
          expect_snapshot_error(class = "validation", cran = TRUE)
      }
    )
  }
)

# nolint end
