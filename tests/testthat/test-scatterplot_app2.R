# File is split in two on purpose shinytest2 fails to starts apps in specific files. Splitting the apps in different files
# seems to solve this problem. This seems to be system dependent, so not easy to reproduce. Probably has to do with
# the system resources

# nolint start
# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc(
  # nolint
  INPUT = poc(
    X = poc(
      CAT = tns(SP$ID$X$PAR, "cat_val"),
      PAR = tns(SP$ID$X$PAR, "par_val"),
      VAL = tns(SP$ID$X$PAR_VALUE, "val"),
      VIS = tns(SP$ID$X$PAR_VISIT, "val")
    ),
    Y = poc(
      CAT = tns(SP$ID$Y$PAR, "cat_val"),
      PAR = tns(SP$ID$Y$PAR, "par_val"),
      VAL = tns(SP$ID$Y$PAR_VALUE, "val"),
      VIS = tns(SP$ID$Y$PAR_VISIT, "val")
    ),
    GRP = tns(SP$ID$GRP, "val"),
    COLOR = tns(SP$ID$COLOR, "val"),
    ANLFL = tns(BP$ID$ANLFL_FILTER, "val")
  ),
  OUTPUT = poc(
    CHART = tns(SP$ID$CHART),
    TABPANEL = tns(SP$ID$TAB_TABLES),
    TABLES = poc(
      LISTING = tns(SP$ID$TABLE_LISTING) %>% structure(tab = SP$MSG$LABEL$TABLE_LISTING),
      CORRELATION = tns(SP$ID$TABLE_CORRELATION) %>% structure(tab = SP$MSG$LABEL$TABLE_REGRESSION),
      REGRESSION = tns(SP$ID$TABLE_REGRESSION) %>% structure(tab = SP$MSG$LABEL$TABLE_REGRESSION)
    )
  )
)

skip_if_not_running_shiny_tests()

test_that("default values are set", {
  srv_defaults <- list(
    default_x_cat = "PARCAT2",
    default_x_par = "PARAM22",
    default_x_visit = "VISIT2",
    default_x_value = "VALUE2",
    default_y_cat = "PARCAT3",
    default_y_par = "PARAM32",
    default_y_visit = "VISIT3",
    default_y_value = "VALUE3",
    default_group = "CAT2",
    default_color = "CAT3"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_scatterplot(
        srv_defaults = !!srv_defaults
      )
    )
  )

  if (is.null(app)) {
    rlang::abort("App could not be started")
  }

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$X$CAT]], srv_defaults[["default_x_cat"]])
  expect_equal(input_values[[ID$INPUT$X$PAR]], srv_defaults[["default_x_par"]])
  expect_equal(input_values[[ID$INPUT$X$VIS]], srv_defaults[["default_x_visit"]])
  expect_equal(input_values[[ID$INPUT$X$VAL]], srv_defaults[["default_x_value"]])
  expect_equal(input_values[[ID$INPUT$Y$CAT]], srv_defaults[["default_y_cat"]])
  expect_equal(input_values[[ID$INPUT$Y$PAR]], srv_defaults[["default_y_par"]])
  expect_equal(input_values[[ID$INPUT$Y$VIS]], srv_defaults[["default_y_visit"]])
  expect_equal(input_values[[ID$INPUT$Y$VAL]], srv_defaults[["default_y_value"]])
  expect_equal(input_values[[ID$INPUT$GRP]], srv_defaults[["default_group"]])
  expect_equal(input_values[[ID$INPUT$COLOR]], srv_defaults[["default_color"]])
})


test_that("default values are set including analysis flag variables", {
  srv_defaults <- list(
    default_x_cat = "PARCAT2",
    default_x_par = "PARAM22",
    default_x_visit = "VISIT2",
    default_x_value = "VALUE2",
    default_y_cat = "PARCAT3",
    default_y_par = "PARAM32",
    default_y_visit = "VISIT3",
    default_y_value = "VALUE3",
    default_group = "CAT2",
    default_color = "CAT3"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_scatterplot(
        srv_defaults = !!srv_defaults,
        anlfl_flags = TRUE
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$X$CAT]], srv_defaults[["default_x_cat"]])
  expect_equal(input_values[[ID$INPUT$X$PAR]], srv_defaults[["default_x_par"]])
  expect_equal(input_values[[ID$INPUT$X$VIS]], srv_defaults[["default_x_visit"]])
  expect_equal(input_values[[ID$INPUT$X$VAL]], srv_defaults[["default_x_value"]])
  expect_equal(input_values[[ID$INPUT$Y$CAT]], srv_defaults[["default_y_cat"]])
  expect_equal(input_values[[ID$INPUT$Y$PAR]], srv_defaults[["default_y_par"]])
  expect_equal(input_values[[ID$INPUT$Y$VIS]], srv_defaults[["default_y_visit"]])
  expect_equal(input_values[[ID$INPUT$Y$VAL]], srv_defaults[["default_y_value"]])
  expect_equal(input_values[[ID$INPUT$GRP]], srv_defaults[["default_group"]])
  expect_equal(input_values[[ID$INPUT$COLOR]], srv_defaults[["default_color"]])
  expect_equal(input_values[[ID$INPUT$ANLFL]], "ANLFL1")
})
# nolint end
