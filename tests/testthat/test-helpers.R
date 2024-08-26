# strip_data_pronoun ----

test_that("strip_data_pronoun removes .data pronoun from a string with single quotes", {
  input_str <- ".data[['col']]"
  expected_output <- "col"
  actual_output <- strip_data_pronoun(input_str)
  expect_equal(actual_output, expected_output)
})

test_that("strip_data_pronoun removes .data pronoun from a string with double quotes", {
  input_str <- ".data[[\"col\"]]"
  expected_output <- "col"
  actual_output <- strip_data_pronoun(input_str)
  expect_equal(actual_output, expected_output)
})

test_that("strip_data_pronoun removes .data pronoun from a string with c() function", {
  input_str <- "c(.data[['col']])"
  expected_output <- "col"
  actual_output <- strip_data_pronoun(input_str)
  expect_equal(actual_output, expected_output)
})

test_that("strip_data_pronoun leaves the string untouched if the regexp does not match the string", {
  input_str <- "col"
  expected_output <- "col"
  actual_output <- strip_data_pronoun(input_str)
  expect_equal(actual_output, expected_output)
})

test_that("strip_data_pronoun returns NULL if input is NULL", {
  input_str <- NULL
  expected_output <- NULL
  actual_output <- strip_data_pronoun(input_str)
  expect_equal(actual_output, expected_output)
})

# rename_with_list ----

test_that("rename_with_list renames columns in a data frame using a named list", {
  df <- data.frame(A = 1, B = 2)
  rename_vec <- list(A = "New A", B = "New B")
  expected_output <- data.frame("New A" = 1, "New B" = 2, check.names = FALSE)
  actual_output <- rename_with_list(df, rename_vec)
  expect_equal(actual_output, expected_output)
})

test_that("rename_with_list renames columns in a data frame using a named character vector", {
  df <- data.frame(A = 1, B = 2)
  rename_vec <- c(A = "New A", B = "New B")
  expected_output <- data.frame("New A" = 1, "New B" = 2, check.names = FALSE)
  actual_output <- rename_with_list(df, rename_vec)
  expect_equal(actual_output, expected_output)
})

test_that("rename_with_list ignores names not present in the data frame", {
  df <- data.frame(A = 1, B = 2)
  rename_vec <- c(A = "New A", C = "New C")
  expected_output <- data.frame("New A" = 1, B = 2, check.names = FALSE)
  actual_output <- rename_with_list(df, rename_vec)
  expect_equal(actual_output, expected_output)
})

test_that("rename_with_list returns the original data frame if rename_vec is empty", {
  df <- data.frame(A = 1, B = 2)
  rename_vec <- list()
  expected_output <- data.frame(A = 1, B = 2, check.names = FALSE)
  actual_output <- rename_with_list(df, rename_vec)
  expect_equal(actual_output, expected_output)

  df <- data.frame(A = 1, B = 2)
  rename_vec <- character(0)
  expected_output <- data.frame(A = 1, B = 2, check.names = FALSE)
  actual_output <- rename_with_list(df, rename_vec)
  expect_equal(actual_output, expected_output)
})

# equal_and_mask_from_vec----

test_that("equal_and_mask_from_vec filters a data frame using a named list of values", {
  df <- data.frame(A = c(1, 2, 3), B = c(4, 5, 6), C = c(7, 8, 9))
  fl <- list(A = 1, B = 4)
  expected_output <- c(TRUE, FALSE, FALSE)
  actual_output <- equal_and_mask_from_vec(df, fl)
  expect_equal(actual_output, expected_output)
})

test_that("equal_and_mask_from_vecq filters a data frame using an atomic vector of values", {
  df <- data.frame(A = c(1, 2, 3), B = c(4, 5, 6), C = c(7, 8, 9))
  fl <- c(A = 1, B = 4)
  expected_output <- c(TRUE, FALSE, FALSE)
  actual_output <- equal_and_mask_from_vec(df, fl)
  expect_equal(actual_output, expected_output)
})

test_that("equal_and_mask_from_vec returns a mask of all TRUE values if fl is empty", {
  df <- data.frame(A = c(1, 2, 3), B = c(4, 5, 6), C = c(7, 8, 9))
  fl <- list()
  expected_output <- c(TRUE, TRUE, TRUE)
  actual_output <- equal_and_mask_from_vec(df, fl)
  expect_equal(actual_output, expected_output)
})

test_that("equal_and_mask_from_vec returns a mask of all FALSE values if fl contains names not present in the data frame", { # nolint
  df <- data.frame(A = c(1, 2, 3), B = c(4, 5, 6), C = c(7, 8, 9))
  fl <- list(A = 1, B = 4, D = 10)
  expected_output <- c(FALSE, FALSE, FALSE)
  actual_output <- equal_and_mask_from_vec(df, fl)
  expect_equal(actual_output, expected_output)
})
