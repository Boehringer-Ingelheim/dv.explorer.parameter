pkg_name <- "dv.biomarker.general"

library(testthat)
library(pkg_name, character.only = TRUE)

test_check(pkg_name)
