component <- "utils_misc"

local({
  test_that("prefix_repeat_parameters prefixes repeat parameters", {
    input <- data.frame(
      PARCAT = c("A", "B", "C", "A", "B"),
      PARAM = c("x", "x", "y", "y", "z")
    )
    output <- prefix_repeat_parameters(input, "PARCAT", "PARAM")
    expected <- data.frame(
      PARCAT = c("A", "B", "C", "A", "B"),
      PARAM = c("A-x", "B-x", "C-y", "A-y", "z")
    )
    expect_equal(output, expected)
  })

  test_that("prefix_repeat_parameters preserves levels on data.frame factor columns", {
    input <- data.frame(
      PARCAT = c("A", "B", "C", "A", "B"),
      PARAM = as.factor(c("x", "x", "y", "y", "z"))
    )
    
    output <- prefix_repeat_parameters(input, "PARCAT", "PARAM")
    
    all_input_levels <- levels(input[["PARAM"]])
    levels_supposedly_common_to_both_input_and_output <- levels(output[["PARAM"]])[seq_along(all_input_levels)]
    expect_equal(all_input_levels, levels_supposedly_common_to_both_input_and_output)
    
    expected <- data.frame(
      PARCAT = c("A", "B", "C", "A", "B"),
      PARAM = factor(c("A-x", "B-x", "C-y", "A-y", "z"), levels = levels(output[["PARAM"]]))
    )
    expect_equal(output, expected)
  })

  test_that("prefix_repeat_parameters does not duplicate columns unnecessarily", {
    # Create a mock dataset
    input <- data.frame(
      PARCAT = c("A", "B", "C", "A", "B"),
      PARAM = c("x", "x", "y", "y", "z")
    )
    output <- prefix_repeat_parameters(input, "PARCAT", "PARAM")
    
    get_memory_address <- function(x) {
      # We should use .Internal(inspect(x)), but CRAN forbids it and we hope to be there one day.
      res <- base::tracemem(x)
      untracemem(x)
      return(res)
    }
    
    expect_equal(get_memory_address(input[["PARCAT"]]), get_memory_address(output[["PARCAT"]]))
  })
})
