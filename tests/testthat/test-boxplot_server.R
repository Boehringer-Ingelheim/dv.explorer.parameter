
test_that("boxplot_server prints message for 0 rows group_dataset", {
  data <- test_data(anlfl_flags = FALSE)

  # reduce number of rows in the input data to 1
  bm_dataset <- data$bm[1, ]
  # reduce number of rows in the input group data to 0
  group_dataset <- data$sl[0, ]

  shiny::testServer(
    app = boxplot_server,
    args = list(
      bm_dataset    = reactive(bm_dataset),
      group_dataset = reactive(group_dataset),
      value_vars = "VALUE1",
      x_axis_vars = "VISIT",
      subjid_var = "SUBJID"
    ),
    {
      # check that the error message produced is as expected
      err <- expect_error(isolate(v_group_dataset()), regexp = "Group dataset has 0 rows")
    }
  )
})


test_that("boxplot_server prints message for 0 rows bm_dataset", {
  data <- test_data(anlfl_flags = FALSE)

  # reduce number of rows in the input data to 0
  bm_dataset <- data$bm[0, ]
  # reduce number of rows in the input group data to 1
  group_dataset <- data$sl[1, ]

  shiny::testServer(
    app = boxplot_server,
    args = list(
      bm_dataset    = reactive(bm_dataset),
      group_dataset = reactive(group_dataset),
      value_vars = "VALUE1",
      x_axis_vars = "VISIT",
      subjid_var = "SUBJID"
    ),
    {
      # check that the error message produced is as expected
      err <- expect_error(isolate(v_bm_dataset()), regexp = "Parameter dataset has 0 rows")
    }
  )
})

test_that("boxplot_server does not build the significance table output when allow_pvalue = FALSE", {
  data <- test_data(anlfl_flags = FALSE)

  shiny::testServer(
    app = boxplot_server,
    args = list(
      bm_dataset    = reactive(data$bm),
      group_dataset = reactive(data$sl),
      value_vars = "VALUE1",
      x_axis_vars = "VISIT",
      subjid_var = "SUBJID",
      allow_pvalue = FALSE
    ),
    {
      expect_null(output_arguments[[BP$ID$TABLE_SIGNIFICANCE]])
    }
  )
})

test_that("boxplot_server builds the significance table output when allow_pvalue = TRUE (default)", {
  data <- test_data(anlfl_flags = FALSE)

  shiny::testServer(
    app = boxplot_server,
    args = list(
      bm_dataset    = reactive(data$bm),
      group_dataset = reactive(data$sl),
      value_vars = "VALUE1",
      x_axis_vars = "VISIT",
      subjid_var = "SUBJID"
    ),
    {
      expect_false(is.null(output_arguments[[BP$ID$TABLE_SIGNIFICANCE]]))
    }
  )
})

test_that("boxplot_server ignores the violin checkbox input when allow_violin = FALSE", {
  data <- test_data(anlfl_flags = FALSE)

  shiny::testServer(
    app = boxplot_server,
    args = list(
      bm_dataset    = reactive(data$bm),
      group_dataset = reactive(data$sl),
      value_vars = "VALUE1",
      x_axis_vars = "VISIT",
      subjid_var = "SUBJID",
      allow_violin = FALSE
    ),
    {
      session$setInputs(violin_check = TRUE)
      expect_false(inputs[[BP$ID$VIOLIN_CHECK]]())
    }
  )
})

test_that("boxplot_server honors the violin checkbox input when allow_violin = TRUE (default)", {
  data <- test_data(anlfl_flags = FALSE)

  shiny::testServer(
    app = boxplot_server,
    args = list(
      bm_dataset    = reactive(data$bm),
      group_dataset = reactive(data$sl),
      value_vars = "VALUE1",
      x_axis_vars = "VISIT",
      subjid_var = "SUBJID"
    ),
    {
      session$setInputs(violin_check = TRUE)
      expect_true(inputs[[BP$ID$VIOLIN_CHECK]]())
    }
  )
})

