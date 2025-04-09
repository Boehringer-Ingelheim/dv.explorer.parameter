test_that("generate_ref_line_data groups ref values" |> vdoc[["add_spec"]](specs$lineplot_module$reference_values), {
  common <- "Common reference value"
  
  df <- data.frame(
    parameter =  c("A", "A", "B", "B", "C", "C") |> factor(),
    main_group = c("F", "M", "F", "M", "F", "M") |> factor(),
    A1LO =       c( 1,   1,   1,   2,   1,   2 ),
    A1HI =       c( 2,   2,   3,   3,   2,   3 )
  ) |> set_lbls(c(A1LO = "Low reference value"))
  res <- generate_ref_line_data(df, show_all_ref_vals = FALSE)
  for(i in seq_along(res)) rownames(res[[i]]) <- NULL
  
  expected_res <- list(
    "Low reference value" = data.frame(
      parameter = c("A", "B", "B", "C", "C") |> factor(),
      main_group = c(common, "F", "M", "F", "M") |> factor(levels = c("F", "M", common)),
      value = c(1, 1, 2, 1, 2)
    ),
    "A1HI" = data.frame(
      parameter = c("A", "B", "C", "C") |> factor(),
      main_group = c(common, common, "F", "M") |> factor(levels = c("F", "M", common)),
      value = c(2, 3, 2, 3)
    )
  )
  expect_equal(res, expected_res)
  
  res <- generate_ref_line_data(df, show_all_ref_vals = TRUE)
  for(i in seq_along(res)) rownames(res[[i]]) <- NULL
  
  expected_res <- list(
    "Low reference value\n(all ref. values)" = data.frame(
      parameter = c("A", "B", "B", "C", "C") |> factor(),
      main_group = c(common, common, common, common, common) |> factor(levels = c("F", "M", common)),
      value = c(1, 1, 2, 1, 2)
    ),
    "A1HI\n(all ref. values)" = data.frame(
      parameter = c("A", "B", "C", "C") |> factor(),
      main_group = c(common, common, common, common) |> factor(levels = c("F", "M", common)),
      value = c(2, 3, 2, 3)
    )
  )
  expect_equal(res, expected_res)
  
  df[["main_group"]] <- NULL
  res <- generate_ref_line_data(df, show_all_ref_vals = FALSE)
  for(i in seq_along(res)) rownames(res[[i]]) <- NULL
  
  expected_res <- list(
    "Low reference value" = data.frame(
      parameter = c("A") |> factor(levels = c("A", "B", "C")),
      value = c(1)
    ),
    "A1HI" = data.frame(
      parameter = c("A", "B") |> factor(levels = c("A", "B", "C")),
      value = c(2, 3)
    )
  )
  expect_equal(res, expected_res)
  
  res <- generate_ref_line_data(df, show_all_ref_vals = TRUE)
  for(i in seq_along(res)) rownames(res[[i]]) <- NULL
  
  expected_res <- list(
    "Low reference value\n(all ref. values)" = data.frame(
      parameter = c("A", "B", "B", "C", "C") |> factor(levels = c("A", "B", "C")),
      value = c(1, 1, 2, 1, 2)
    ),
    "A1HI\n(all ref. values)" = data.frame(
      parameter = c("A", "B", "C", "C") |> factor(levels = c("A", "B", "C")),
      value = c(2, 3, 2, 3)
    )
  )
  expect_equal(res, expected_res)
  
  df <- data.frame(
    parameter =  c("pA", "pA", "pA", "pB", "pB", "pB") |> factor(),
    main_group = c("gA", "gB", "gC", "gA", "gB", "gC") |> factor(),
    ref_val =    c( 1,    1,    2,    1,    2,    1 )
  )
  ref_line_data <- generate_ref_line_data(df, show_all_ref_vals = FALSE)
  
  recursive_factor_to_char <- function(e){
    if(inherits(e, "list")) for(i in seq_along(e)) e[[i]] <- recursive_factor_to_char(e[[i]])
    else if(inherits(e, "factor")) e <- as.character(e)
    return(e)
  }
  
  res <- compute_overlap_of_ref_line_data(ref_line_data)
  expect_identical(
    recursive_factor_to_char(res), # drops levels to make comparison easier
    list(
      list(parameter = "pA", value = 1, groups = c("gA", "gB")),
      list(parameter = "pB", value = 1, groups = c("gA", "gC"))
    )
  )
})
