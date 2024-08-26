# COMMON ----

CNT <- poc( # nolint
  SBJ = "subject_id",
  CAT = "category",
  PAR = "parameter",
  VIS = "visit",
  VAL = "value",
  VAR = "variable",
  X_VAL = "x_value",
  Y_VAL = "y_value",
  MAIN_GROUP = "main_group",
  SUB_GROUP = "sub_group",
  PAGE_GROUP = "page_group",
  COLOR_GROUP = "color_group"
)

CMN <- poc( # nolint
  MSG = poc(
    VALIDATE = poc(
      BM_TOO_MANY_ROWS = "(Biomarker) The selection returns more than 1 row per subject and cannot be plotted",
      GROUP_TOO_MANY_ROWS = "(Group) The selection returns more than 1 row per subject and cannot be plotted",
      GROUP_COL_REPEATED = "(Group) Selected group is already a column in resp or pred datasets",
      NO_ROWS = "Current selection returns 0 rows"
    )
  )
)







# VOLCANO PLOT ----

VP <- poc( # nolint
  ID = poc( # nolint
    PAR_BUTTON = "par_button",
    PAR = "par",
    PAR_VALUE = "par_value",
    PAR_VISIT = "par_visit",
    GRP_BUTTON = "grp_button",
    CONT_VAR = "cont_var",
    CAT_VAR = "cat_var",
    CONT_CAT_RADIO = "cont_cat_radio",
    STAT_METHOD_CONT = "stat_method_cont",
    STAT_METHOD_CAT = "stat_method_cat",
    STAT_THRESHOLD = "stat_threshold",
    P_THRESHOLD = "p_threshold",
    MULTIPLE_CORR_METHOD = "multiple_corr_method",
    OTHER_BUTTON = "other_button",
    CHART = "chart",
    TAB_TABLES = "tab_tables",
    TABLE_LISTING = "table_listing",
    TABLE_COUNT = "table_count",
    TABLE_SUMMARY = "table_summary",
    TABLE_SIGNIFICANCE = "table_significance",
    CHART_BRUSH = "brush"
  ),
  VAL = poc(
    STAT_METHOD_CAT = list("Odds", "Log2Fold"),
    STAT_METHOD_CONT = list("Pearson", "Regression"),
    MULTIPLE_CORR_METHOD = list("FDR", "Holm"),
    STAT_DEFAULT = 0,
    P_DEFAULT = 0.05
  ),
  MSG = poc( # nolint
    LABEL = poc(
      PAR_BUTTON = "Parameter",
      PAR = "Parameter",
      CAT = "Category",
      PAR_VALUE = "Value",
      PAR_VISIT = "Visit",
      GRP_BUTTON = "Stats",
      CONT_VAR = "Variable (Cont)",
      CAT_VAR = "Variable (Cat)",
      CONT_CAT_RADIO = "Variable Type",
      STAT_METHOD_CONT = "Method (Cont)",
      STAT_METHOD_CAT = "Method (Cat)",
      STAT_THRESHOLD = "Stat Threshold",
      P_THRESHOLD = "P Value Threshold",
      MULTIPLE_CORR_METHOD = "Multiple Correction",
      OTHER_BUTTON = "Other",
      TABLE_LISTING = "Data Listing",
      TABLE_COUNT = "Data Count",
      TABLE_SUMMARY = "Data Summary",
      TABLE_SIGNIFICANCE = "Data Significance"
    ),
    VALIDATE = poc(
      NO_CAT_SEL = "Select a category",
      NO_PAR_SEL = "Select a parameter",
      NO_VALUE_SEL = "Value selection does not exist",
      UKNOWN_VALUE_SEL = "Select a value",
      NO_VISIT_SEL = "Select a visit",
      NO_CONT_VAR_SEL = "Select a variable (Cont)",
      NO_CAT_VAR_SEL = "Select a variable (Cat)",
      NO_CAT_VAL_SEL = "Select at least one value (Cat)",
      NO_STAT_METHOD_CONT_SEL = "Select a statistical method (Cont)",
      NO_STAT_METHOD_CAT_SEL = "Select a statistical method (Cat)",
      NO_STAT_THRESHOLD_VAL = "Introduce an stat threshold",
      NO_P_THRESHOLD_VAL = "Introduce a p val threshold",
      NO_MULTIPLE_CORR_SEL = "Select a multiple correction method",
      BM_TOO_MANY_ROWS = "(Biomarker) The selection returns more than 1 row per subject and cannot be plotted",
      GROUP_TOO_MANY_ROWS = "(Group) The selection returns more than 1 row per subject and cannot be plotted",
      GROUP_COL_REPEATED = "(Group) Selected group is already a column in resp or pred datasets",
      NOT_INVARIANT_N_SBJ = "The number of subjects differ between datasets",
      NO_ROWS = "Current selection returns 0 rows",
      NON_POS_SIZE = "Figure size must be positive",
      X_COL_METRICS_NOT_IN_DS = "The selected column for the metrics X axis does not exist in the metrics dataset",
      N_SUBJECT_EMPTY_RESPONSES = function(x) {
        paste(x, "subjects with empty responses!")
      },
      CLICK_LISTING = "Click on a boxplot to see listing"
    )
  )
)

STYLE <- poc( # nolint
  PLOT_TITLE_SIZE = 18,
  AXIS_TEXT_SIZE = 14,
  AXIS_TITLE_SIZE = 16,
  STRIP_TEXT_SIZE = 12
)
