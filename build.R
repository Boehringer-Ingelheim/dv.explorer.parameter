#! /usr/local/bin/Rscript

success <- c(
  test = FALSE,
  valdoc = FALSE
)

# Getting package information ----
pkg_name <- read.dcf("DESCRIPTION")[1, "Package"]
pkg_version <- read.dcf("DESCRIPTION")[1, "Version"]

# Building ----

message("############################")
message("###### INSTALLING (S) ######")
message("############################")

devtools::install(upgrade = FALSE, args = "--install-tests")

message("############################")
message("###### INSTALLING (F) ######")
message("############################")

# Testing ----

message("##########################")
message("###### TESTING  (S) ######")
message("##########################")

test_results <- tibble::as_tibble(
  withr::with_envvar(
    new = list(CI = TRUE, no_proxy = "127.0.0.1", NOT_CRAN = TRUE, TESTTHAT_CPUS = 1),
    code = {
        testthat::set_max_fails(Inf)
        testthat::test_package(pkg_name)
    }
  )
)

success[["test"]] <- sum(test_results[["failed"]]) == 0

message("##########################")
message("###### TESTING  (F) ######")
message("##########################")

