#!/usr/bin/env Rscript
# Main entry point for reproducing the analysis pipeline

source(file.path("R", "config.R"))
source(file.path("R", "data_loading.R"))
source(file.path("R", "feature_engineering.R"))

load_required_packages()
initialize_output_dir()

# User-configurable input
excel_file <- file.path(analysis_paths$data_dir, "database_final.xlsx")

message("\n=== Loading data ===")
data_list <- load_and_prepare_data(excel_file)
database_final <- data_list$data
metadata <- data_list$metadata

message("\n=== Creating long format ===")
database_long <- create_long_format(database_final, metadata)

# Save processed objects for downstream analyses
saveRDS(database_final, file.path(analysis_paths$output_dir, "database_final_cleaned.rds"))
saveRDS(database_long, file.path(analysis_paths$output_dir, "database_long.rds"))
writeLines(capture.output(str(metadata)), file.path(analysis_paths$output_dir, "metadata.txt"))

message("\nProcessing complete. Results saved to: ", normalizePath(analysis_paths$output_dir, mustWork = FALSE))
