make_clean_dataset <- function() {
  data.frame(
    cat = c("A", "A"  , "B", "B"),
    par = c("p1", "p2", "p1", "p2"),
    sub = c("s1", "s2", "s1", "s2"),
    vis = c("v1", "v1", "v2", "v2")
  )
}

make_dup_par_dataset <- function() {
  # par "p1" appears under two different cats — dup in par column
  data.frame(
    cat = c("A", "B"),
    par = c("p1", "p1"),
    sub = c("s1", "s2"),
    vis = c("v1", "v2")
  )
}

make_dup_row_dataset <- function() {
  # fully duplicate rows
  data.frame(
    cat = c("A", "A"),
    par = c("p1", "p1"),
    sub = c("s1", "s1"),
    vis = c("v1", "v1")
  )
}

# check_unique_cat_par_combinations <- function(dataset, cat_var, par_var) {
#   unique_cat_par_combinations <- vctrs::vec_unique(dataset[c(cat, par)])
#   any_dup <- vctrs::vec_duplicate_any(unique_cat_par_combinations[par])

#   if (any_dup) {
#     dup_mask <- vctrs::vec_duplicate_id(unique_cat_par_combinations[par]) != seq_len(nrow(unique_cat_par_combinations))
#   } else {
#     dup_mask <- FALSE
#   }

#   list(
#     unique = unique_cat_par_combinations,
#     any_dup = any_dup,
#     dup_mask = dup_mask
#   )
# }

# check_unique_sub_cat_par_vis_combinations <- function(dataset, sub_var, cat_var, par_var, vis_var) {
#   supposedly_unique <- dataset[c(sub_var, cat_var, par_var, vis_var)]
#   any_dup <- vctrs::vec_duplicate_any(supposedly_unique)

#   if (any_dup) {
#     dup_mask <- dup_mask <- vctrs::vec_duplicate_id(supposedly_unique) != seq_len(nrow(supposedly_unique))
#   } else {
#     dup_mask <- false
#   }

#   list(
#     any_dup = any_dup,
#     dup_mask = dup_mask
#   )
# }

test_that("check_unique_cat_par_combinations with no repetitions", {
  br

  df <- data.frame(
    cat = c("cA", "cA", "cB", "cA", "cA", "cB"),
    par = c("pA", "pB", "pC", "pA", "pB", "pC")
  )

  expect_identical(
    check_unique_cat_par_combinations(df, "cat", "par"),
    list(
      unique = vctrs::vec_unique(df),
      any_dup = FALSE,
      dup_mask = FALSE
    )
  )

})

test_that("check_unique_cat_par_combinations with repeated combinations", {
  df <- data.frame(
    cat = c("cA", "cA", "cB", "cA", "cA", "cB"),
    par = c("pA", "pB", "pB", "pA", "pB", "pC")
  )

  expect_identical(
    check_unique_cat_par_combinations(df, "cat", "par"),
    list(
      unique = vctrs::vec_unique(df),
      any_dup = TRUE,
      dup_mask = c(FALSE, FALSE, TRUE, FALSE)
    )
  )
})

test_that("check_unique_sub_cat_par_vis_combinations with no repetitions", {
  br

  df <- data.frame(
    sub = c("sA", "sA"),
    cat = c("cA", "cA"),
    par = c("pA", "pA"),
    vis = c("vA", "vB")
  )

  expect_identical(
    check_unique_sub_cat_par_vis_combinations(df, "sub", "cat", "par", "vis"),
    list(      
      any_dup = FALSE,
      dup_mask = FALSE
    )
  )
})

test_that("check_unique_sub_cat_par_vis_combinations with repeated combinations", {
  
  df <- data.frame(
    sub = c("sA", "sA", "sB"),
    cat = c("cA", "cA", "cB"),
    par = c("pA", "pA", "pB"),
    vis = c("vA", "vA", "vB")
  )

  expect_identical(
    check_unique_sub_cat_par_vis_combinations(df, "sub", "cat", "par", "vis"),
    list(      
      any_dup = TRUE,
      dup_mask = c(FALSE, TRUE, FALSE)
    )
  )
})