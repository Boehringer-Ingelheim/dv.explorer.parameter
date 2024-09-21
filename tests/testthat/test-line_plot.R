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

test_that("lineplot_chart renders reference lines", {
  df <- data.frame(row.names = seq(1))

  df[[CNT$VIS]] <- c("vis_1")
  df[[CNT$MAIN_GROUP]] <- c("A")
  df[[CNT$PAR]] <- c("par_1")
  df[[CNT$VAL]] <- c(1)
  df[[LP_ID$MISC$WHISKER_BOTTOM]] <- c(0)
  df[[LP_ID$MISC$WHISKER_TOP]] <- c(2)

  refline_df <- data.frame(row.names = seq(1))
  refline_df[["ref line foo"]] <- c(.5)
  refline_df[["ref line bar"]] <- c(.75)
  refline_df[["ref line baz"]] <- c(.87)

  p <- lineplot_chart(data = df, ref_line_data = refline_df)

  refline_count <- 0
  for (layer in p[["layers"]]) {
    refline_count <- refline_count + "GeomHline" %in% class(layer[["geom"]])
  }
  expect_equal(refline_count, ncol(refline_df))
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
