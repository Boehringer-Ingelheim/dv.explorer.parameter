mock_app_mpvs <- function(in_fluid = TRUE, defaults = list()) {
  container <- if (in_fluid) shiny::fluidPage else shiny::tagList

  data <- test_data()[["bm"]]

  shiny::shinyApp(
    ui = function(request) {
      container(
        multi_param_visit_selector_UI("sel", default_cat = NULL, default_par = NULL, default_visit = NULL),
        shiny::uiOutput("out"),
        shiny::bookmarkButton()
      )
    },
    server = function(input, output, session) {
      # TODO PACK THIS MAGIC
      shiny::observe({
        shiny::reactiveValuesToList(input) # Trigger this observer every time an input changes
        session$doBookmark()
      })
      shiny::onBookmarked(shiny::updateQueryString)

      sel <- multi_param_visit_selector_server(
        "sel", shiny::reactive(data),
        cat_var = "PARCAT", par_var = "PARAM", visit_var = "VISIT"
      )

      output[["out"]] <- shiny::renderUI({
        thing <- utils::capture.output(print(sel())) |> paste(collapse = "\n")
        shiny::pre(thing)
      })
    },
    enableBookmarking = "url"
  )
}
