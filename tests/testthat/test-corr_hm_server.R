
test_that("corr_hm_server prints message for 0 rows bm_dataset", {
  data <- test_data(anlfl_flags = FALSE)

  # reduce number of rows in the input data to 0
  bm_dataset <- data$bm[0, ]

  shiny::testServer(
    app = corr_hm_server,
    args = list(
      bm_dataset    = reactive(bm_dataset),
      value_vars = "VALUE1",
      visit_var = "VISIT",
      subjid_var = "SUBJID"
    ),
    {
      # check that the error message produced is as expected
      err <- expect_error(isolate(v_ch_dataset()), regexp = "Parameter dataset has 0 rows")
    }
  )
})

