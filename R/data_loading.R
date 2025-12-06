# Data loading and initial processing utilities

#' Prepare a data frame by cleaning labels and extracting metadata
#'
#' @param data A data frame containing clinical and connectivity features
#' @param pathology_col Column name containing pathology labels
#' @return List with cleaned data frame and metadata
prepare_data_frame <- function(data, pathology_col = "Pathology") {
  if (!pathology_col %in% names(data)) {
    stop("Column '" , pathology_col, "' not found in data.")
  }

  data[[pathology_col]] <- factor(data[[pathology_col]])
  if ("FCD2+" %in% levels(data[[pathology_col]])) {
    levels(data[[pathology_col]])[levels(data[[pathology_col]]) == "FCD2+"] <- "FCD2plus"
  }

  categorical_vars <- intersect(c("Sex", "Temporal", "MRI", "Outcome"), names(data))
  for (var in categorical_vars) {
    data[[var]] <- factor(data[[var]])
  }

  all_cols <- names(data)
  connectivity_pattern <- "^(intra_|out_).*__\\w+$"
  connectivity_features <- grep(connectivity_pattern, all_cols, value = TRUE)

  frequencies <- unique(gsub(".*__(\\w+)$", "\\1", connectivity_features))
  measure_types <- unique(gsub("__(\\w+)$", "", connectivity_features))
  clinical_vars <- setdiff(all_cols, connectivity_features)

  metadata <- list(
    n_patients = if ("patient" %in% names(data)) length(unique(data$patient)) else NA,
    n_samples = nrow(data),
    pathologies = levels(data[[pathology_col]]),
    n_pathologies = length(levels(data[[pathology_col]])),
    frequencies = frequencies,
    connectivity_features = connectivity_features,
    measure_types = measure_types,
    clinical_vars = clinical_vars
  )

  list(data = data, metadata = metadata)
}

#' Load data from disk and prepare it for analysis
#'
#' @param file_path Path to the Excel file containing the dataset
#' @return List with cleaned data frame and metadata
load_and_prepare_data <- function(file_path) {
  if (!file.exists(file_path)) {
    stop("Data file not found at ", normalizePath(file_path, mustWork = FALSE))
  }

  raw_data <- readxl::read_excel(file_path)
  prepare_data_frame(raw_data)
}
