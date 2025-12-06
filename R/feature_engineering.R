# Feature engineering helpers

#' Convert the wide connectivity table into long format
#'
#' @param data A cleaned data frame containing connectivity features
#' @param metadata Metadata list produced by `prepare_data_frame`
#' @return A tibble in long format with frequency and measure type columns
create_long_format <- function(data, metadata) {
  connectivity_cols <- metadata$connectivity_features
  if (length(connectivity_cols) == 0) {
    stop("No connectivity features detected. Check the input data.")
  }

  freq_order <- c("broadband", "delta", "theta", "alpha", "beta", "gammalow")

  long_data <- data %>%
    tidyr::pivot_longer(
      cols = tidyselect::all_of(connectivity_cols),
      names_to = "variable",
      values_to = "value"
    ) %>%
    dplyr::mutate(
      measure_type = stringr::str_replace(variable, "__[^_]+$", ""),
      frequency = stringr::str_extract(variable, "[^_]+$")
    ) %>%
    dplyr::select(-variable) %>%
    dplyr::select(dplyr::any_of(c("patient", "Pathology")), measure_type, frequency, value, dplyr::everything()) %>%
    dplyr::mutate(frequency = factor(frequency, levels = intersect(freq_order, unique(frequency))))

  long_data
}
