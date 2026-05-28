#' Mock boxplot app
#' @keywords mock
#' @param dry_run Return parameters used in the call
#' @param update_query_string automatically update query string with app state
#' @param ui_defaults,srv_defaults a list of values passed to the ui/server function
#' @param anlfl_flags indicates that the input data contain analysis flag variables or not
#' @export

mock_app_boxplot <- function(dry_run = FALSE, update_query_string = TRUE, srv_defaults = list(), ui_defaults = list(), anlfl_flags = FALSE) {
  data <- test_data(anlfl_flags = anlfl_flags)
  bm_dataset <- shiny::reactive({
    data[["bm"]]
  })

  group_dataset <- shiny::reactive({
    data[["sl"]]
  })

  ui_params <- c(
    list(
      id = "not_ebas"
    ),
    ui_defaults
  )

  if (anlfl_flags) {
    anlfl_vars <- c("ANLFL1", "ANLFL2")
  } else {
    anlfl_vars <- NULL
  }

  srv_params <- c(
    list(
      id = "not_ebas",
      bm_dataset = bm_dataset,
      group_dataset = group_dataset,
      subjid_var = "SUBJID",
      cat_var = "PARCAT",
      par_var = "PARAM",
      x_axis_vars = "VISIT",
      value_vars = c("VALUE1", "VALUE2", "VALUE3"),
      anlfl_vars = anlfl_vars,
      quantile_type = 2L
    ),
    srv_defaults
  )

  if (dry_run) {
    return(list(ui = ui_params, srv = srv_params))
  }

  mock_app_wrap(
    update_query_string = update_query_string,
    ui = function() do.call(boxplot_UI, ui_params),
    server = function() {
      do.call(boxplot_server, srv_params)
    }
  )
}


#' Mock mm boxplot app
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @export

mock_app_boxplot_mm <- function(update_query_string = TRUE, anlfl_flags = FALSE) {
  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }

  data <- test_data(anlfl_flags = anlfl_flags)


  if (anlfl_flags) {
    anlfl_vars <- c("ANLFL1", "ANLFL2")
  } else {
    anlfl_vars <- NULL
  }

  dv.manager::run_app(
    data = list(dummy = list(bm = data[["bm"]], adsl = data[["sl"]])),
    module_list = list(
      Boxplot = mod_boxplot(
        "boxplot",
        bm_dataset_name = "bm",
        group_dataset_name = "adsl",
        x_axis_vars = c("VISIT"),
        value_vars = c("VALUE1", "VALUE2"),
        subjid_var = "SUBJID",
        cat_var = "PARCAT",
        anlfl_vars = anlfl_vars,
        default_cat = "PARCAT1",
        default_par = "PARAM11"
      )
    ),
    filter_data = "adsl",
    filter_key = "SUBJID",
    enableBookmarking = "url"
  )
}


#' Mock mm boxplot app with deprecated visit_var and default_visit arguments
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @export



mock_app_boxplot_mm_depr <- function(update_query_string = TRUE, anlfl_flags = FALSE) {
  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }

  data <- test_data(anlfl_flags = anlfl_flags)


  if (anlfl_flags) {
    anlfl_vars <- c("ANLFL1", "ANLFL2")
  } else {
    anlfl_vars <- NULL
  }

  dv.manager::run_app(
    data = list(dummy = list(bm = data[["bm"]], adsl = data[["sl"]])),
    module_list = list(
      Boxplot = mod_boxplot(
        "boxplot",
        bm_dataset_name = "bm",
        group_dataset_name = "adsl",
        visit_var = "VISIT",
        value_vars = c("VALUE1", "VALUE2"),
        subjid_var = "SUBJID",
        cat_var = "PARCAT",
        anlfl_vars = anlfl_vars,
        default_visit = "VISIT1",
        default_main_group = "GENDER"
      )
    ),
    filter_data = "adsl",
    filter_key = "SUBJID",
    enableBookmarking = "url"
  )
}



#' Mock mm boxplot app with using crossover design data
#' @keywords mock
#' @inheritParams mock_app_boxplot
#' @export




set.seed(42)

subjects <- sprintf("SUBJ%03d", 1:24)
sequences <- c(
  rep("R-T1-T2-T3", 6),
  rep("T1-T2-T3-R", 6),
  rep("T2-T3-R-T1", 6),
  rep("T3-R-T1-T2", 6)
)

# assign COUNTRY and GENDER per subject
countries <- c("USA", "Germany", "UK")
genders <- c("Male", "Female")

subject_country <- sample(countries, length(subjects), replace = TRUE)
subject_gender  <- sample(genders, length(subjects), replace = TRUE)

trt_map <- list(
  "R-T1-T2-T3" = c("R", "T1", "T2", "T3"),
  "T1-T2-T3-R" = c("T1", "T2", "T3", "R"),
  "T2-T3-R-T1" = c("T2", "T3", "R", "T1"),
  "T3-R-T1-T2" = c("T3", "R", "T1", "T2")
)

rows <- vector("list", length(subjects) * 4)
k <- 1

for (i in seq_along(subjects)) {
  subj <- subjects[i]
  seqn <- sequences[i]
  trts <- trt_map[[seqn]]

  # subject-level attributes
  country <- subject_country[i]
  gender  <- subject_gender[i]

  for (visit in 1:4) {
    trt <- trts[visit]
    base <- c(R = 100, T1 = 92, T2 = 88, T3 = 84)[[trt]]
    aval <- round(base + rnorm(1, 0, 4), 2)

    rows[[k]] <- data.frame(
      USUBJID = subj,
      COUNTRY = country,
      GENDER  = gender,
      PARCAT = "EFFICACY",
      PARAM = "CHANGE_FROM_BASELINE",
      AVISIT = paste("Visit", visit),
      AVISITN = visit,
      TRT = trt,
      SEQUENCE = seqn,
      PERIOD = visit,
      AVAL = aval,
      stringsAsFactors = FALSE
    )
    k <- k + 1
  }
}
# create data frame with multiple records per subject
df <- do.call(rbind, rows)

# create subject level data frame
adsl <- unique(df[c("USUBJID", "COUNTRY", "GENDER")])


mock_app_boxplot_mm_crossover <- function(update_query_string = TRUE, anlfl_flags = FALSE) {
  if (!requireNamespace("dv.manager")) {
    stop("Install dv.manager")
  }

  if (anlfl_flags) {
    anlfl_vars <- c("ANLFL1", "ANLFL2")
  } else {
    anlfl_vars <- NULL
  }

  dv.manager::run_app(
    data = list(dummy = list(bm = df, adsl = adsl)),
    module_list = list(
      Boxplot = mod_boxplot(
        "boxplot",
        bm_dataset_name = "bm",
        group_dataset_name = "adsl",
        value_vars = c("AVAL"),
        subjid_var = "USUBJID",
        cat_var = "PARCAT",
        anlfl_vars = anlfl_vars,
        x_axis_vars = c("AVISIT", "TRT"),
        default_cat = "EFFICACY",
        default_par = "CHANGE_FROM_BASELINE"
      )
    ),
    filter_data = "adsl",
    filter_key = "USUBJID",
    enableBookmarking = "url"
  )
}





















