# Connectivity Analysis Project Skeleton

This repository restructures the provided analysis script into a reproducible R project. The layout separates reusable functions, data storage, scripts, and tests so you can continue developing or share the work on GitHub.

## Project structure

- `R/` – reusable functions (`config.R`, `data_loading.R`, `feature_engineering.R`).
- `scripts/` – analysis entry points (`run_analysis.R`).
- `data-raw/` – store source data (expected `database_final.xlsx`).
- `data/` – optional processed data exports.
- `results/` – automatically created to hold RDS/metadata outputs.
- `tests/` – `testthat` unit tests for the data-processing helpers.

## Setup

1. Install the required R packages (one time):

   ```r
   source("R/config.R")
   load_required_packages()
   ```

2. Place your raw Excel dataset at `data-raw/database_final.xlsx` (or update the path in `scripts/run_analysis.R`).

## Running the analysis

Execute the main script from the repository root:

```bash
Rscript scripts/run_analysis.R
```

Outputs are written to `results/`:

- `database_final_cleaned.rds` – cleaned wide data.
- `database_long.rds` – long-format version ready for modeling.
- `metadata.txt` – human-readable summary of detected variables.

## Testing

Run the lightweight unit tests to confirm the helpers behave as expected:

```bash
Rscript -e 'testthat::test_dir("tests/testthat")'
```

## Preparing for GitHub

- The repository is already organized with a clear layout and `.gitignore` entries for common R artifacts.
- Add your data to `data-raw/` (it is git-ignored by default) and push the branch to GitHub.

