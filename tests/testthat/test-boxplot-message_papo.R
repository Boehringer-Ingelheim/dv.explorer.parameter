# This is a test template for modules that select a subject ID and send it to dv.papo.

# In order to fit it to your module, it needs three pieces of information:
# 1) An instance of the module you want to test, parameterized to produce valid output and not trigger a `shiny::req`.
mod <- mod_boxplot_papo(
  module_id = "mod",
  bm_dataset_name = "bm",
  group_dataset_name = "sl",
  subjid_var = "SUBJID",
  cat_var = "PARCAT",
  par_var = "PARAM",
  visit_var = "VISIT",
  value_vars = c("VALUE1", "VALUE2", "VALUE3"),
  default_cat = "PARCAT1",
  default_par = "PARAM11"
)

# 2) Data matching the previous parameterization.
data <- test_data()

# 3) Fully namespaced input ID that, when set to a subject ID value, should make the module send dv.papo a message.
trigger_input_id <- "mod-BOTON"

source("message_papo-common.R", local = TRUE)
