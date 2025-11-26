
test_that("roc_server prints message for 0 rows group_dataset", {

  pred_dataset <- data.frame(
    PARCAT = "Category A",
    PARAM  = "Param A",
    USUBJID = factor("SUBJ"),
    AVISIT = "Visit 1",
    AVAL = rnorm(1)
  )

  resp_dataset <- data.frame(
    PARCAT = "Category B",
    PARAM  = "Param B",
    USUBJID = factor("SUBJ"),
    AVISIT = "Visit 1",
    CHG1 = rnorm(1),
    CHG2 = rnorm(1)
  )

  group_dataset <- data.frame(
    USUBJID = factor("SUBJ"),
    GROUP = factor("Group 1")
  )

  # reduce number of rows in the group data to 0
  group_dataset <- group_dataset[0, ]


  shiny::testServer(
    app = roc_server,
    args = list(
      resp_dataset  = reactive(resp_dataset),
      pred_dataset  = reactive(pred_dataset),
      group_dataset = reactive(group_dataset)
    ),
    {
      # check that the error message produced is as expected
      err <- expect_error(isolate(v_group_dataset()), regexp = "Group dataset has 0 rows")
    }
  )
})

test_that("roc_server prints message for 0 rows resp_dataset", {

  pred_dataset <- data.frame(
    PARCAT = "Category A",
    PARAM  = "Param A",
    USUBJID = factor("SUBJ"),
    AVISIT = "Visit 1",
    AVAL = rnorm(1)
  )

  resp_dataset <- data.frame(
    PARCAT = "Category B",
    PARAM  = "Param B",
    USUBJID = factor("SUBJ"),
    AVISIT = "Visit 1",
    CHG1 = rnorm(1),
    CHG2 = rnorm(1)
  )

  group_dataset <- data.frame(
    USUBJID = factor("SUBJ"),
    GROUP = factor("Group 1")
  )

  # reduce number of rows in the resp data to 0
  resp_dataset <- resp_dataset[0, ]

  shiny::testServer(
    app = roc_server,
    args = list(
      resp_dataset  = reactive(resp_dataset),
      pred_dataset  = reactive(pred_dataset),
      group_dataset = reactive(group_dataset)
    ),
    {
      # check that the error message produced is as expected
      err <- expect_error(isolate(v_resp_dataset()), regexp = "Resp dataset has 0 rows")
    }
  )
})

test_that("roc_server prints message for 0 rows pred_dataset", {

  pred_dataset <- data.frame(
    PARCAT = "Category A",
    PARAM  = "Param A",
    USUBJID = factor("SUBJ"),
    AVISIT = "Visit 1",
    AVAL = rnorm(1)
  )

  resp_dataset <- data.frame(
    PARCAT = "Category B",
    PARAM  = "Param B",
    USUBJID = factor("SUBJ"),
    AVISIT = "Visit 1",
    CHG1 = rnorm(1),
    CHG2 = rnorm(1)
  )

  group_dataset <- data.frame(
    USUBJID = factor("SUBJ"),
    GROUP = factor("Group 1")
  )

  # reduce number of rows in the pred data to 0
  pred_dataset <- pred_dataset[0, ]

  shiny::testServer(
    app = roc_server,
    args = list(
      resp_dataset  = reactive(resp_dataset),
      pred_dataset  = reactive(pred_dataset),
      group_dataset = reactive(group_dataset)
    ),
    {
      # check that the error message produced is as expected
      err <- expect_error(isolate(v_pred_dataset()), regexp = "Pred dataset has 0 rows")
    }
  )
})













