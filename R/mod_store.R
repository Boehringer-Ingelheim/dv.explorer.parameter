store_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::uiOutput(ns("cont"))
  )
}

store_server <- function(id, value) {
  mod <- function(input, output, session) {
    ns <- session[["ns"]]

    states <- shiny::reactiveVal(list())

    shiny::onBookmark(function(state) {
      state$values$states <- states()
    })

    shiny::onRestore(function(state) {
      states(state$values$states %||% list())
    })

    shiny::setBookmarkExclude(names = c("load_state", "save_state", "delete_state", "state_name"))

    output[["cont"]] <- shiny::renderUI({
      stored_states_ui <- vector(mode = "list", length = length(states()))
      for (idx in seq_along(states())) {
        name <- names(states())[[idx]]
        li_class <- "list-group-item"
        stored_states_ui[[idx]] <- shiny::tagList(
          shiny::tags[["li"]](
            class = li_class,
            name,
            shiny::div(
              shiny::tags$button(shiny::icon("upload"),
                class = "btn btn-default",
                onClick = paste0("Shiny.setInputValue('", ns("load_state"), "','", name, "',{priority: \"event\"})")
              ),
              shiny::tags$button(shiny::icon("delete-left"),
                class = "btn btn-default",
                onClick = paste0(
                  "Shiny.setInputValue('",
                  ns("delete_state"), "','", name, "', {priority: \"event\"})"
                )
              ),
              shiny::tags$button(shiny::icon("magnifying-glass"),
                class = "btn btn-default",
                onClick = paste0(
                  "Shiny.setInputValue('",
                  ns("view_state"), "','", name, "', {priority: \"event\"})"
                )
              ),
              style = "display: flex; align-items: center;"
            ),
            style = "display: flex; align-items: center; column-gap: 10px; justify-content: space-between"
          )
        )
      }

      save_text_input <- shiny::textInput(ns("state_name"),
        label = NULL,
        placeholder = "Save current state",
        width = "100%"
      )
      save_text_input$attribs$style <- paste0(save_text_input$attribs$style, " margin-bottom: 0px;")
      save_ui <- shiny::tags[["li"]](
        class = "list-group-item",
        shiny::div(
          style = "display:flex; align-items: baseline;",
          save_text_input,
          shiny::actionButton(ns("save_state"), label = NULL, icon = shiny::icon("floppy-disk"))
        )
      )

      shiny::tags[["ul"]](
        stored_states_ui,
        save_ui,
        class = "list-group"
      )
    })

    shiny::observeEvent(input[["save_state"]], {
      shiny::req(checkmate::test_string(input[["state_name"]], min.chars = 1))
      s <- states()
      s[[input[["state_name"]]]] <- value()
      states(s)
    })

    shiny::observeEvent(input[["delete_state"]], {
      shiny::req(checkmate::test_string(input[["delete_state"]], min.chars = 1))
      s <- states()
      s[[input[["delete_state"]]]] <- NULL
      states(s)
    })

    shiny::observeEvent(input[["view_state"]], {
      shiny::showModal(
        shiny::modalDialog(
          shiny::renderPrint({
            states()[[input[["view_state"]]]]
          })
        )
      )
    })

    res <- shiny::reactive({
      shiny::req(checkmate::test_string(input[["load_state"]], min.chars = 1))
      message("EO2")
      shiny::isolate(states()[[input[["load_state"]]]])
    })

    return(res)

    shiny::outputOptions(output, "cont", suspendWhenHidden = FALSE)
  }
  shiny::moduleServer(id, mod)
}
