test_that(
  "Generates proper SVG",
  {
    type <- dv.biomarker.general:::type
    output_size <- c(w = 100, h = 200) |> type("size")
    df <- data.frame(
      result = c(1, 2, 3),
      CI_lower_limit = c(0, 1, 2),
      CI_upper_limit = c(2, 3, 4)
    ) |> type("result_table")
    table_row_order <- seq_len(nrow(df)) |> type("sequence_permutation")
    axis_config <- c(x_min = -1, x_max = 1, ref_line_x = 0, tick_count = 5) |> type("axis_config")

    svg <- dv.biomarker.general:::gen_svg(output_size, df, table_row_order, axis_config)
    expect_snapshot(svg)
  }
)

test_that(
  "Generates proper result table",
  {
    pearson_correlation <- function(a, b) {
      test <- cor.test(a, b)
      res <- list(
        result = test[["estimate"]][["cor"]],
        CI_lower_limit = test[["conf.int"]][[1]],
        CI_upper_limit = test[["conf.int"]][[2]],
        p_value = test[["p.value"]]
      )
      res
    }

    ds <- data.frame(
      subject_id = as.factor(c("id_0", "id_1", "id_2", "id_3")),
      category = as.factor(c("cat_A", "cat_A", "cat_A", "cat_A")),
      parameter = as.factor(c("param_A", "param_A", "param_A", "param_A")),
      value = c(0, 0, 0, 3)
    ) |> type("data_subset")
    sl <- data.frame(
      subject_id = as.factor(c("id_0", "id_1", "id_2", "id_3")),
      var2 = c(0, 0, 0, 2)
    ) |> type("sl_df")
    fun <- pearson_correlation |> type("fun")
    label <- "label" |> type("S")

    table <- gen_result_table_fun(ds, sl, fun, label) # no warning
    expect_snapshot(table)

    ds <- ds[-c(4), ]
    sl <- sl[-c(4), ]
    table <- gen_result_table_fun(ds, sl, fun, label) # standard deviation is zero warning
    expect_snapshot(table)
  }
)

# TODO: test bookmarking (once inputs are fixed #etoozi)
