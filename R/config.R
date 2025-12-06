# Global configuration and package management utilities

#' Analysis parameters
analysis_parameters <- list(
  significance_level = 0.05,
  cv_method = "LOPO",
  random_seed = 123,
  plot_width = 12,
  plot_height = 8,
  plot_dpi = 300
)

#' Default directories
analysis_paths <- list(
  data_dir = "data-raw",
  output_dir = "results"
)

#' Required packages for the workflow
required_packages <- c(
  "readxl", "dplyr", "tidyr", "stringr", "ggplot2", "ggpubr",
  "caret", "pROC", "nnet", "randomForest", "e1071", "xgboost",
  "writexl", "MASS"
)

#' Ensure all packages are installed and loaded
#'
#' @param packages Character vector of package names
load_required_packages <- function(packages = required_packages) {
  missing_packages <- setdiff(packages, rownames(installed.packages()))
  if (length(missing_packages) > 0) {
    message("Installing missing packages: ", paste(missing_packages, collapse = ", "))
    install.packages(missing_packages)
  }

  invisible(lapply(packages, library, character.only = TRUE, quietly = TRUE))
}

#' Create output directory if it does not exist
initialize_output_dir <- function(path = analysis_paths$output_dir) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
  invisible(path)
}

set.seed(analysis_parameters$random_seed)
