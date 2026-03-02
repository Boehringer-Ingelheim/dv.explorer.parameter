# TODO: Refactor according to:
# https://rstudio.github.io/shinytest2/articles/robust.html#assert-as-little-unnecessary-information
# TODO: A failure to start the app will delete all snapshots as they are never declared

tns <- tns_factory("not_ebas")

ID <- poc(
  INPUT = poc(
    CAT = tns(LP_ID$PAR, "cat_val"),
    PAR = tns(LP_ID$PAR, "par_val"),
    CENT = tns(LP_ID$PLOT_CENTRALITY_AND_DISPERSION, "cat_val"),
    DISP = tns(LP_ID$PLOT_CENTRALITY_AND_DISPERSION, "par_val"),
    VAL = tns(LP_ID$PAR_VALUE_TRANSFORM, "val"),
    VIS_COL = tns(LP_ID$PAR_VISIT_COL, "val"),
    VIS = tns(LP_ID$PAR_VISIT, "val"),
    MGRP = tns(LP_ID$MAIN_GRP, "val"),
    SGRP = tns(LP_ID$SUB_GRP, "val"),
    TRANSPARENCY = tns(LP_ID$TWEAK_TRANSPARENCY),
    ANLFL = tns(LP_ID$ANLFL_FILTER, "val")
  ),
  OUTPUT = poc(
    CHART = tns(LP_ID$CHART),
    TABPANEL = tns(LP_ID$TAB_TABLES),
    TABLES = poc(
      SUBJECT_LISTING = tns(LP_ID$SUBJECT_LISTING) %>% structure(tab = LP_MSG$LABEL$SUBJECT_LISTING),
      SUMMARY_LISTING = tns(LP_ID$SUMMARY_LISTING) %>% structure(tab = LP_MSG$LABEL$SUMMARY_LISTING),
      COUNT_LISTING = tns(LP_ID$COUNT_LISTING) %>% structure(tab = LP_MSG$LABEL$COUNT_LISTING)
    )
  )
)

test_that("default values are set", {
  skip_if_not_running_shiny_tests()



  srv_defaults <- list(
    default_centrality_fn = "Mean",
    default_dispersion_fn = "Standard deviation",
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_val = "VALUE2",
    default_visit_var = "VISIT2",
    default_visit_val = list(VISIT2 = c(1, 9)),
    default_main_group = "CAT2",
    default_sub_group = "CAT2"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_lineplot(
        srv_defaults = !!srv_defaults
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$CAT]], srv_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], srv_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$CENT]], srv_defaults[["default_centrality_fn"]])
  expect_equal(input_values[[ID$INPUT$DISP]], srv_defaults[["default_dispersion_fn"]])
  expect_equal(input_values[[ID$INPUT$VIS_COL]], srv_defaults[["default_visit_var"]])
  expect_equal(input_values[[ID$INPUT$VIS]], as.character(srv_defaults[["default_visit_val"]][["VISIT2"]]))
  expect_equal(input_values[[ID$INPUT$VAL]], srv_defaults[["default_val"]])
  expect_equal(input_values[[ID$INPUT$MGRP]], srv_defaults[["default_main_group"]])
  expect_equal(input_values[[ID$INPUT$SGRP]], srv_defaults[["default_sub_group"]])
})



test_that("default values are set including analysis flag variables", {
  skip_if_not_running_shiny_tests()



  srv_defaults <- list(
    default_centrality_fn = "Mean",
    default_dispersion_fn = "Standard deviation",
    default_cat = "PARCAT2",
    default_par = c("PARAM22", "PARAM23"),
    default_val = "VALUE2",
    default_visit_var = "VISIT2",
    default_visit_val = list(VISIT2 = c(1, 9)),
    default_main_group = "CAT2",
    default_sub_group = "CAT2"
  )

  app <- start_app_driver(
    rlang::quo(
      dv.explorer.parameter::mock_app_lineplot(
        srv_defaults = !!srv_defaults,
        anlfl_flags = TRUE
      )
    )
  )

  app$wait_for_idle()

  input_values <- app$get_values()[["input"]]
  expect_equal(input_values[[ID$INPUT$CAT]], srv_defaults[["default_cat"]])
  expect_equal(input_values[[ID$INPUT$PAR]], srv_defaults[["default_par"]])
  expect_equal(input_values[[ID$INPUT$CENT]], srv_defaults[["default_centrality_fn"]])
  expect_equal(input_values[[ID$INPUT$DISP]], srv_defaults[["default_dispersion_fn"]])
  expect_equal(input_values[[ID$INPUT$VIS_COL]], srv_defaults[["default_visit_var"]])
  expect_equal(input_values[[ID$INPUT$VIS]], as.character(srv_defaults[["default_visit_val"]][["VISIT2"]]))
  expect_equal(input_values[[ID$INPUT$VAL]], srv_defaults[["default_val"]])
  expect_equal(input_values[[ID$INPUT$MGRP]], srv_defaults[["default_main_group"]])
  expect_equal(input_values[[ID$INPUT$SGRP]], srv_defaults[["default_sub_group"]])
  expect_equal(input_values[[ID$INPUT$ANLFL]], "ANLFL1")
})
