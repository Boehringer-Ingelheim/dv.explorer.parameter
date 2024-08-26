test_that(
  "ch_subset_data subsets a parameter dataset from a selection dataframe",
  {
    d <- test_data()[["bm"]]
    sel <- data.frame()[1:3, ]
    sel[[CNT$CAT]] <- c("PARCAT1", "PARCAT2", "PARCAT3")
    sel[[CNT$PAR]] <- c("PARAM11", "PARAM22", "PARAM32")
    sel[[CNT$VIS]] <- c("VISIT1", "VISIT2", "VISIT3")

    res <- ch_subset_data(
      sel = sel,
      cat_col = "PARCAT",
      par_col = "PARAM",
      val_col = "VALUE1",
      vis_col = "VISIT",
      bm_ds = d,
      subj_col = "SUBJID"
    )
    checkmate::expect_set_equal(levels(res[[CNT$PAR]]), paste0(sel[[CNT$PAR]], " - ", sel[[CNT$VIS]]))
    checkmate::expect_factor(res[[CNT$PAR]])
  }
)

# correlation heatmap chart
test_that("HM2SVG_plot produces an SVG", {
  df <- data.frame(row.names = seq(4))
  df[["x"]] <- c("a", "a", "b", "b") |> as.factor()
  df[["y"]] <- c("a", "b", "a", "b") |> as.factor()
  df[["z"]] <- c(1, 0.5, 0.5, 1)

  palette <- pal_div_palette(-1, 0, 1, rev(RColorBrewer::brewer.pal(11, name = "RdBu")))
  colors <- names(palette)
  values <- unname(palette)
  pal_fun <- scales::gradient_n_pal(colors, values)

  svg <- HM2SVG_plot(df, x_desc = "S", y_desc = "W", z_desc = "E", pal_fun = pal_fun, palette = NULL, ns = identity)
  expect_true(is.character(svg) && startsWith(svg, "<svg"))
})

# scatter plot chart
test_that("scatter_plot produces an SVG", {
  df <- local({
    df <- data.frame(row.names = seq(6))
    df[[CNT$SBJ]] <- c("sbj_1", "sbj_2", "sbj_3", "sbj_1", "sbj_2", "sbj_3") |> as.factor()
    df[[CNT$CAT]] <- c("cat_1", "cat_1", "cat_1", "cat_2", "cat_2", "cat_2") |> as.factor()
    df[[CNT$PAR]] <- c("par_1", "par_1", "par_1", "par_2", "par_2", "par_2") |> as.factor()
    df[[CNT$VAL]] <- c(1, 1, 3, 4, 5, 5.5)
    df
  }) |>
    type("data_subset")

  x_var <- "par_1" |> type("S")
  y_var <- "par_2" |> type("S")
  svg <- scatter_plot(df, x_var, y_var)

  expect_true(is.character(svg) && startsWith(svg, "<svg"))
})

test_that("apply_correlation_function generates data for a heatmap", {
  df <- local({
    df <- data.frame(row.names = seq(6))
    df[[CNT$SBJ]] <- c("sbj_1", "sbj_2", "sbj_3", "sbj_1", "sbj_2", "sbj_3") |> as.factor()
    df[[CNT$CAT]] <- c("cat_1", "cat_1", "cat_1", "cat_2", "cat_2", "cat_2") |> as.factor()
    df[[CNT$PAR]] <- c("par_1", "par_1", "par_1", "par_2", "par_2", "par_2") |> as.factor()
    df[[CNT$VAL]] <- c(1, 1, 3, 4, 5, 5.5)
    df
  })

  a <- df[[CNT$VAL]][1:3]
  b <- df[[CNT$VAL]][4:6]

  pearson <- dv.biomarker.general::pearson_correlation
  label <- "label"
  res <- apply_correlation_function(df, pearson, label)
  par_1_2_index <- res[["x"]] == "par_1" & res[["y"]] == "par_2"

  expected_v <- pearson(a, b)[["result"]]
  expect_equal(res[par_1_2_index, ][["z"]], expected_v)

  spearman <- dv.biomarker.general::spearman_correlation
  res <- apply_correlation_function(df, spearman, label)
  par_1_2_index <- res[["x"]] == "par_1" & res[["y"]] == "par_2"

  expected_v <- spearman(a, b)[["result"]]
  expect_equal(res[par_1_2_index, ][["z"]], expected_v)
})

# listings/count table
test_that("ch_listings_table returns unique combinations of heatmap data and sums totals", {
  ds <- local({
    df <- data.frame(row.names = seq(6))
    df[[CNT$SBJ]] <- c("sbj_1", "sbj_2", "sbj_3", "sbj_1", "sbj_2", "sbj_3") |> as.factor()
    df[[CNT$CAT]] <- c("cat_1", "cat_1", "cat_1", "cat_2", "cat_2", "cat_2") |> as.factor()
    df[[CNT$PAR]] <- c("par_1", "par_1", "par_1", "par_2", "par_2", "par_2") |> as.factor()
    df[[CNT$VAL]] <- c(1, 1, 3, 4, 5, 5.5)
    df
  }) |>
    type("data_subset")

  pearson <- dv.biomarker.general::pearson_correlation |> type("fun")
  label <- "label" |> type("S")
  corr_df <- apply_correlation_function(ds, pearson, label)

  res <- ch_listings_table(corr_df, ds, label)
  testthat::expect_true(checkmate::check_data_frame(res, nrows = 1))
  testthat::expect_equal(res[["N"]], 3)
})

test_that(
  "bookmarks are restored correctly",
  {
    skip("This is a self-imposed requirement and its testing is somewhat involved. Punting on it for the first release")
  }
)
