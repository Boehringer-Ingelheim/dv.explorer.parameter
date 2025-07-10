test_that(
  "lp_subset_data subsets and merges a bm and group dataset",
  {
    skip("Routine is a copy of bm_subset_data, which already is extensively tested.")
  }
)

# chart
test_that("lineplot_chart produces a ggplot", {
  df <- data.frame(row.names = seq(1))

  df[[CNT$VIS]] <- c("vis_1")
  df[[CNT$MAIN_GROUP]] <- c("A")
  df[[CNT$PAR]] <- c("par_1")
  df[[CNT$VAL]] <- c(1)
  df[[LP_ID$MISC$WHISKER_BOTTOM]] <- c(0)
  df[[LP_ID$MISC$WHISKER_TOP]] <- c(2)

  p <- lineplot_chart(data = df, ref_line_data = NULL)
  expect_true("ggplot" %in% class(p))
})

test_that("lineplot_chart renders reference lines" |> vdoc[["add_spec"]](c(specs$lineplot_module$reference_values)), {
  df <- data.frame(row.names = seq(1))

  df[[CNT$VIS]] <- c("vis_1")
  df[[CNT$MAIN_GROUP]] <- c("A")
  df[[CNT$PAR]] <- c("par_1")
  df[[CNT$VAL]] <- c(1)
  df[[LP_ID$MISC$WHISKER_BOTTOM]] <- c(0)
  df[[LP_ID$MISC$WHISKER_TOP]] <- c(2)

  ref_line_df <- data.frame(
    as.factor(c("par_1", "par_1", "par_1")),
    as.factor(c("A", "A", "A")),
    c(0.50, 0.75, 0.87)
  ) |> setNames(c(CNT$PAR, CNT$MAIN_GROUP, CNT$VAL))

  ref_line_df1 <- ref_line_df[1,]
  ref_line_df2 <- ref_line_df[2,]
  ref_line_df3 <- ref_line_df[3,]

  ref_line_data <- list(
    foo = ref_line_df1, bar = ref_line_df2, baz = ref_line_df3
  )

  p <- lineplot_chart(data = df, ref_line_data = ref_line_data)

  refline_count <- 0
  for (layer in p[["layers"]]) {
    refline_count <- refline_count + "GeomHline" %in% class(layer[["geom"]])
  }
  expect_equal(refline_count, nrow(ref_line_df))
})

# listings table

test_that("lp_listings_table subsets a data frame based on the values of a one-rowed data frame", {
  df <- tibble::tibble(A = c(1, 2, 3), B = c(4, 5, 6), C = c(7, 8, 9))
  f_df <- tibble::tibble(A = 2, B = 5, C = 8)
  expected_output <- tibble::tibble(A = 2, B = 5, C = 8)

  df <- data.frame(row.names = seq(4))
  df[[CNT$VIS]] <- c("vis_1", "vis_2", "vis_1", "vis_2")
  df[[CNT$MAIN_GROUP]] <- c("A", "A", "B", "B")
  df[[CNT$PAR]] <- c("par_1", "par_1", "par_1", "par_1")
  df[[CNT$VAL]] <- c(1, 2, 3, 4)

  sel <- data.frame(row.names = seq(1))
  sel[[CNT$VIS]] <- c("vis_1")
  sel[[CNT$MAIN_GROUP]] <- c("A")
  sel[[CNT$PAR]] <- c("par_1")
  sel[[CNT$VAL]] <- c(1)

  expected_output <- sel

  actual_output <- lp_listings_table(df = df, selection = sel)
  expect_equal(actual_output, expected_output)
})

# count table

test_that("lp_count_table counts the number of rows grouped by everything except CNT$SBJ and CNT$VAL and pivotted on visit", {
  df <- data.frame(row.names = seq(5))
  df[[CNT$SBJ]] <- c("sbj_1", "sbj_1", "sbj_2", "sbj_2", "sbj_3")
  df[[CNT$VIS]] <- c("vis_1", "vis_2", "vis_1", "vis_2", "vis_1")
  df[[CNT$MAIN_GROUP]] <- c("A", "A", "B", "B", "B")
  df[[CNT$PAR]] <- c("par_1", "par_1", "par_1", "par_1", "par_1")
  df[[CNT$VAL]] <- c(1, 2, 3, 4, 5)

  actual_output <- lp_count_table(df = df)
  actual_output <- as.data.frame(actual_output) # don't care about its "tibbleness"

  expected_output <- data.frame(row.names = seq(2))
  expected_output[[CNT$MAIN_GROUP]] <- c("A", "B")
  expected_output[[CNT$PAR]] <- c("par_1", "par_1")
  expected_output[["vis_1"]] <- c(1, 2)
  expected_output[["vis_2"]] <- c(1, 1)

  expect_equal(actual_output, expected_output)
})


# patient selection

test_that("lineplot_chart maintains existing color in lines of selected patients, and changes color to light grey in lines of unselected patients", {
  df <- structure(list(
    subject_id = structure(c(
      1L, 2L, 3L, 4L, 5L, 6L,
      7L, 8L, 9L, 10L, 11L, 12L, 13L, 14L, 15L, 16L, 17L, 18L, 19L,
      20L, 1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L, 10L, 11L, 12L, 13L,
      14L, 15L, 16L, 17L, 18L, 19L, 20L, 1L, 2L, 3L, 4L, 5L, 6L, 7L,
      8L, 9L, 10L, 11L, 12L, 13L, 14L, 15L, 16L, 17L, 18L, 19L, 20L
    ), levels = c(
      "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
      "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"
    ), class = "factor", label = "Label of SUBJID"),
    category = structure(c(
      1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
      1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
      1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
      1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
      1L, 1L, 1L, 1L, 1L, 1L
    ), levels = "PARCAT1", class = "factor", label = "Label of PARCAT"),
    parameter = structure(c(
      1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
      1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
      1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
      1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
      1L, 1L, 1L, 1L, 1L, 1L
    ), levels = "PARAM11", class = "factor", label = "Label of PARAM"),
    visit = structure(c(
      1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
      1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 2L,
      2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L,
      3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L,
      3L, 3L, 3L, 3L, 3L
    ), levels = c("VISIT1", "VISIT2", "VISIT3"), class = "factor", label = "Label of VISIT"), value = structure(1:60, label = "Label of VALUE1"),
    line_highlight_mask = c(
      FALSE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,
      TRUE
    )
  ), row.names = c(NA, 60L), class = "data.frame")

  test_plot <- lineplot_chart(data = df)

  vdiffr::expect_doppelganger(title = "patient-selection", fig = test_plot)
})


















test_that(
  "centrality and dispersion calculations are correct",
  {
    skip("The module will eventually offload stats calculation to user-provided routines")
  }
)

test_that(
  "bookmarks are restored correctly",
  {
    skip("This is a self-imposed requirement and its testing is somewhat involved. Punting on it for the first release")
  }
)
