library(dplyr)
library(testthat)

source("R/data_loading.R")
source("R/feature_engineering.R")

sample_data <- tibble::tibble(
  patient = c(1, 2),
  Pathology = c("FCD2+", "HS"),
  Sex = c("M", "F"),
  intra_out_ratio__theta = c(0.5, 0.7),
  intra_out_ratio__beta = c(0.6, 0.4)
)

metadata_list <- prepare_data_frame(sample_data)
long_df <- create_long_format(metadata_list$data, metadata_list$metadata)

test_that("pathology labels are cleaned", {
  expect_false(any(levels(metadata_list$data$Pathology) == "FCD2+"))
  expect_true("FCD2plus" %in% levels(metadata_list$data$Pathology))
})

test_that("metadata captures connectivity features", {
  expect_equal(length(metadata_list$metadata$connectivity_features), 2)
  expect_equal(sort(metadata_list$metadata$frequencies), c("beta", "theta"))
})

test_that("long format contains required columns", {
  expect_true(all(c("measure_type", "frequency", "value") %in% names(long_df)))
  expect_equal(nrow(long_df), 4)
})
