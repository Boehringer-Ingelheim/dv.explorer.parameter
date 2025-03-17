mod <- mod_boxplot(
  module_id = "mod",
  bm_dataset_name = "bm",
  group_dataset_name = "sl",
  receiver_id = "papo",
  subjid_var = "SUBJID",
  cat_var = "PARCAT",
  par_var = "PARAM",
  visit_var = "VISIT",
  value_vars = c("VALUE1", "VALUE2", "VALUE3"),
  default_cat = "PARCAT1",
  default_par = "PARAM11"
)
data <- test_data()
trigger_input_id <- "mod-BOTON"
test_communication_with_papo(mod, data, trigger_input_id,
                             'specs$boxplot_module$jumping_feature',
                             specs$boxplot_module$jumping_feature)
