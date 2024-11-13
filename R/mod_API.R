# Lineplot module interface description ----
mod_corr_hm_API_docs <- list(
  "Correlation Heatmap",
  module_id = "",
  bm_dataset_name = "",
  subjid_var = "",
  cat_var = "",
  par_var = "",
  visit_var = "",
  value_vars = "",
  default_cat = "",
  default_par = "",
  default_visit = "",
  default_val = "" # FIXME(miguel): Should be called default_value_var
)

# TODO: Complete
mod_corr_hm_API <- T_group(
  module_id = T_mod_ID(),
  bm_dataset_name = T_dataset_name(),
  subjid_var = T_col("bm_dataset_name", T_factor()) |> T_flag("subjid_var"),
  cat_var = T_col("bm_dataset_name", T_or(T_character(), T_factor())),
  par_var = T_col("bm_dataset_name", T_or(T_character(), T_factor())),
  visit_var = T_col("bm_dataset_name", T_or(T_character(), T_factor(), T_numeric())),
  value_vars = T_col("bm_dataset_name", T_numeric()) |> T_flag("zero_or_more"), # FIXME: one_or_more?
  default_cat = T_choice_from_col_contents("cat_var") |> T_flag("zero_or_more", "optional"),
  default_par = T_choice_from_col_contents("par_var") |> T_flag("zero_or_more", "optional"),
  default_visit = T_choice_from_col_contents("visit_var") |> T_flag("zero_or_more", "optional"),
  default_val = T_choice("value_vars") |> T_flag("optional") # FIXME(miguel): Should be called default_value_var
) |> T_attach_docs(mod_corr_hm_API_docs)

# Lineplot module interface description ----
mod_lineplot_API_docs <- list(
  "Line Plot",
  module_id = "",
  bm_dataset_name = "",
  group_dataset_name = "",
  receiver_id = "",
  # summary_functions = T_list(??),
  subjid_var = "",
  cat_var = "",
  par_var = "",
  visit_vars = "",
  cdisc_visit_vars = "",
  value_vars = "",
  additional_listing_vars = "",
  ref_line_vars = "",
  # default_centrality_function = ??, FIXME: T_choice()
  # default_dispersion_function = ??,
  # default_cat = ??,                 FIXME: T_choice("cat_var") |> T_flag("zero_or_more")
  # default_par = ??,
  # default_val = ??,
  # default_visit_var = ??,
  # default_visit_val = ??,
  # default_main_group = ??,
  # default_sub_group = ??,
  default_transparency = ""
  # default_y_axis_projection = ?? # FIXME: T_enum(c())
)

# TODO: Complete
mod_lineplot_API <- T_group(
  module_id = T_mod_ID(),
  bm_dataset_name = T_dataset_name(),
  group_dataset_name = T_dataset_name() |> T_flag("subject_level_dataset_name"),
  receiver_id = T_character() |> T_flag("optional", "ignore"),
  # summary_functions = T_list(??),
  subjid_var = T_col("group_dataset_name", T_factor()) |> T_flag("subjid_var"),
  cat_var = T_col("bm_dataset_name", T_or(T_character(), T_factor())),
  par_var = T_col("bm_dataset_name", T_or(T_character(), T_factor())),
  visit_vars = T_col("bm_dataset_name", T_or(T_character(), T_factor(), T_numeric())) |> T_flag("zero_or_more"), # FIXME: one_or_more?
  cdisc_visit_vars = T_col("bm_dataset_name", T_or(T_numeric())) |> T_flag("zero_or_more"), # FIXME: one_or_more?
  # FIXME: ? Interaction between visit_vars and cdisc_visit_vars; one needs to be specified
  value_vars = T_col("bm_dataset_name", T_numeric()) |> T_flag("zero_or_more"), # FIXME: one_or_more?
  additional_listing_vars = T_col("bm_dataset_name", T_anything()) |> T_flag("zero_or_more", "optional"),
  ref_line_vars = T_col("bm_dataset_name", T_anything()) |> T_flag("zero_or_more", "optional"),
  # default_centrality_function = ??, FIXME: T_choice()
  # default_dispersion_function = ??,
  # default_cat = ??,                 FIXME: T_choice("cat_var") |> T_flag("zero_or_more")
  # default_par = ??,
  # default_val = ??,
  # default_visit_var = ??,
  # default_visit_val = ??,
  # default_main_group = ??,
  # default_sub_group = ??,
  default_transparency = T_numeric(min = 0.05, max = 1.) |> T_flag("optional")
  # default_y_axis_projection = ?? # FIXME: T_enum(c())
) |> T_attach_docs(mod_lineplot_API_docs) # TODO: Attach


# Available module specifications ----
module_specifications <- list(
  "dv.explorer.parameter::mod_corr_hm" = mod_corr_hm_API,
  "dv.explorer.parameter::mod_lineplot" = mod_lineplot_API
)
