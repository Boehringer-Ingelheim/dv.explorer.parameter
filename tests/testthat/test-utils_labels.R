component <- "utils_labels"

test_that(
  "get_lbls should return a named list where name is the name of the column and value is the attribute label of the
   column if no label is present it should return NULL
  ",
  {
    df <- data.frame(a = 1, b = 2, c = 3)
    attr(df[["a"]], "label") <- "lab_a"
    # No label in b
    attr(df[["c"]], "label") <- "lab_c"
    expected <- list(a = "lab_a", b = NULL, c = "lab_c")

    expect_identical(get_lbls(df), expected)
  }
)

test_that(
  "get_lbl should return the label of a single columns if no label is present it should return NULL
  ",
  {
    df <- data.frame(a = 1, b = 2)
    attr(df[["a"]], "label") <- "lab_a"
    # No label in b

    expect_identical(get_lbl(df, "a"), "lab_a")
    expect_identical(get_lbl(df, "b"), NULL)
  }
)

test_that(
  "rpl_nulls_name should replace NULL entries with the name of the entry",
  {
    l <- list(a = NULL, b = "lab_b")
    expect_identical(rpl_nulls_name(l), list(a = "a", b = "lab_b"))
  }
)

test_that(
  "swap_val_names should swap values and names in a named vector or list",
  {
    l <- list(a = "lab_a", b = "lab_b")
    expect_identical(swap_val_names(l), list("lab_a" = "a", "lab_b" = "b"))

    l <- c(a = "lab_a", b = "lab_b")
    expect_identical(swap_val_names(l), c("lab_a" = "a", "lab_b" = "b"))
  }
)

test_that(
  "swap_val_names should throw an error when there are null values in l",
  {
    l <- list(a = "lab_a", b = "lab_b", c = NULL)
    expect_error(
      swap_val_names(l),
      regexp = "NULL values are not allowed in l"
    )
  }
)

test_that(
  "set_lbl should set the label of a column in a data_frame",
  {
    df <- data.frame(a = 1)
    df <- set_lbl(df, "a", "lab_a")
    expect_identical(get_lbl(df, "a"), "lab_a")
  }
)

test_that(
  "set_lbl should set several labels in a data_frame",
  {
    df <- data.frame(a = 1, b = 2, c = 3)
    df <- set_lbls(df, list(a = "lab_a", b = "lab_b"))
    expect_identical(get_lbls(df), list(a = "lab_a", b = "lab_b", c = NULL))
  }
)

test_that(
  "set_lbl should set several labels in a data_frame",
  {
    df <- data.frame(a = 1, b = 2, c = 3)
    df <- set_lbls(df, list(a = "lab_a", b = "lab_b"))
    expect_identical(get_lbls(df), list(a = "lab_a", b = "lab_b", c = NULL))
  }
)

test_that(
  "get_lbl_robust returns the label attribute or the name of the column if the label is NULL",
  {
    df <- data.frame(a = 1, b = 2)
    df <- set_lbls(df, list(a = "lab_a"))
    expect_identical(get_lbl_robust(df, "a"), "lab_a")
    expect_identical(get_lbl_robust(df, "b"), "b")
  }
)
