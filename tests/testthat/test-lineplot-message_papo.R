mod <- mod_lineplot(
  module_id = "mod",
  bm_dataset_name = "bm",
  group_dataset_name = "sl",
  subjid_var = "USUBJID",
  cat_var = "PARCAT",
  par_var = "PARAM",
  visit_vars = c("VISIT"),
  value_vars = c("VALUE1"),
  default_cat = "PARCAT1",
  default_par = "PARAM11",
  receiver_id = "papo"
)
data <- test_data()
trigger_input_id <- "mod-selected_subject"
test_communication_with_papo(mod, data, trigger_input_id)
