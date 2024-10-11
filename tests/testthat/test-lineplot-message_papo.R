# YT#VH33e387131d296de57ba6b9be8368c156#VH00000000000000000000000000000000#
# This is a test template for modules that select a subject ID and send it to dv.papo.

# In order to fit it to your module, it needs three pieces of information:
# 1) An instance of the module you want to test, parameterized to produce valid output and not trigger a `shiny::req`.
mod <- mod_lineplot(
  module_id = "mod",
  bm_dataset_name = "bm",
  group_dataset_name = "sl",
  subjid_var = "SUBJID",
  cat_var = "PARCAT",
  par_var = "PARAM",
  visit_vars = c("VISIT"),
  value_vars = c("VALUE1"),
  default_cat = "PARCAT1",
  default_par = "PARAM11",
  receiver_id = "papo"
)

# 2) Data matching the previous parameterization.
data <- test_data()

# 3) Fully namespaced input ID that, when set to a subject ID value, should make the module send dv.papo a message.
trigger_input_id <- "mod-selected_subject"

# This portion of the test template defines the expected protocol for sending a message to dv.papo and is shared across
# all modules that do so. The first line on this file is a hash of the contents of this `local` section. Its purpose
# is to maintain all copies of this portion of the file synchronized.
# See https://github.com/dull-systems/yours_truelib for more details.
test_harness <- local({
  datasets <- shiny::reactive(data)

  afmm <- list(
    unfiltered_dataset = datasets,
    filtered_dataset = datasets,
    module_output = function() list(),
    utils = list(switch2 = function(id) NULL),
    dataset_metadata = list(name = shiny::reactive("dummy_dataset_name"))
  )

  app_ui <- function() {
    shiny::fluidPage(mod[["ui"]](mod[["module_id"]]))
  }

  app_server <- function(input, output, session) {
    ret_value <- mod[["server"]](afmm)

    ret_value_update_count <- shiny::reactiveVal(0)
    shiny::observeEvent(ret_value[["subj_id"]](), ret_value_update_count(ret_value_update_count() + 1))

    shiny::exportTestValues(
      ret_value = try(ret_value[["subj_id"]]()), # try because of https://github.com/rstudio/shiny/issues/3768
      update_count = ret_value_update_count()
    )
    return(ret_value)
  }

  app <- shiny::shinyApp(
    ui = app_ui,
    server = function(input, output, session) {
      ret_value <- app_server(input, output, session)

      ret_value_update_count <- shiny::reactiveVal(0)
      shiny::observeEvent(ret_value[["subj_id"]](), ret_value_update_count(ret_value_update_count() + 1))

      shiny::exportTestValues(
        ret_value = try(ret_value[["subj_id"]]()), # try because of https://github.com/rstudio/shiny/issues/3768
        update_count = ret_value_update_count()
      )
    }
  )

  test_that("module adheres to send_subject_id_to_papo protocol", {
    app <- shinytest2::AppDriver$new(app, name = "test_send_subject_id_to_papo_protocol")

    app$wait_for_idle()

    # Module starts and sends no message
    exports <- app$get_values()[["export"]]
    testthat::expect_equal(exports[["update_count"]], 0)

    trigger_subject_selection <- function(subject_id) {
      set_input_params <- append(
        as.list(setNames(subject_id, trigger_input_id)),
        list(allow_no_input_binding_ = TRUE, priority_ = "event")
      )
      do.call(app$set_inputs, set_input_params)
    }

    # Module sends exactly one message per trigger event, even if subject does not change
    subject_ids <- c("A", "A", "B")
    for (i in seq_along(subject_ids)) {
      trigger_subject_selection(subject_ids[[i]])

      exports <- app$get_values()[["export"]]
      # Module outputs selection once
      testthat::expect_equal(exports[["ret_value"]], subject_ids[[i]])
      testthat::expect_equal(exports[["update_count"]], i)
    }

    app$stop()
  })
})
