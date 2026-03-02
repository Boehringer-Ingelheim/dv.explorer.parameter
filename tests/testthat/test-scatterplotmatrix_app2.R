# nolint start
# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc(
  # nolint
  INPUT = poc(
    CAT = tns(SPM$ID$PAR, "cat_val"),
    PAR = tns(SPM$ID$PAR, "par_val"),
    VAL = tns(SPM$ID$PAR_VALUE, "val"),
    VIS = tns(SPM$ID$PAR_VISIT, "val"),
    GRP = tns(SPM$ID$MAIN_GRP, "val"),
    ANLFL = tns(BP$ID$ANLFL_FILTER, "val")
  ),
  OUTPUT = poc(
    CHART = tns(SPM$ID$CHART)
  )
)

test_that("default values are set", {
  srv_defaults <- list(
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_visit = "VISIT2",
    default_value = "VALUE2",
    default_main_group = "CAT3"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_scatterplotmatrix(
        srv_defaults = !!srv_defaults
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$CAT]], srv_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], srv_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$VIS]], srv_defaults[["default_visit"]])
  expect_equal(input_values[[ID$INPUT$VAL]], srv_defaults[["default_value"]])
  expect_equal(input_values[[ID$INPUT$GRP]], srv_defaults[["default_main_group"]])
})


test_that("default values are set including analysis flag variables", {
  srv_defaults <- list(
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_visit = "VISIT2",
    default_value = "VALUE2",
    default_main_group = "CAT3"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_scatterplotmatrix(
        srv_defaults = !!srv_defaults,
        anlfl_flags = TRUE
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$CAT]], srv_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], srv_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$VIS]], srv_defaults[["default_visit"]])
  expect_equal(input_values[[ID$INPUT$VAL]], srv_defaults[["default_value"]])
  expect_equal(input_values[[ID$INPUT$GRP]], srv_defaults[["default_main_group"]])
  expect_equal(input_values[[ID$INPUT$ANLFL]], "ANLFL1")
})
# nolint end
