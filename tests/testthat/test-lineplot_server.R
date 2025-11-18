
test_that("lineplot_server prints message for 0-row bm_dataset", {
  data <- test_data(anlfl_flags = FALSE)

  # reduce number of rows in the input data to zero
  bm_dataset <- data$bm[0, ]
  # reduce number of rows in the input group data to 1
  group_dataset <- data$sl[1, ]

  shiny::testServer(
    app = lineplot_server,
    args = list(
      bm_dataset    = reactive(bm_dataset),
      group_dataset = reactive(group_dataset),
      value_vars = "VALUE1",
      visit_var = "VISIT",
      subjid_var = "SUBJID"
    ),
    {
      # check that the error message produced is as expected
      err <- expect_error(isolate(v_bm_dataset()), regexp = "Parameter dataset has 0 rows")
    }
  )
})
