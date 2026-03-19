#' -----------------------------------------------------------------------------
#' Metadata Generation Script for OmniAgeRData
#' -----------------------------------------------------------------------------
#' Purpose: This script generates the 'metadata.csv' file required for
#'          Bioconductor's ExperimentHub. It scans local data files (RDS/QS2),
#'          maps them to their original study DOIs, and assigns proper
#'          taxonomy IDs and taxonomy species.
#'
#' Input:  1. Local RDS and QS2 files in the backup directory.
#'         2. 'inst/scripts/temp_providers.csv' containing DOI
#'         and provider info.
#'
#' Output: 'inst/extdata/metadata.csv'
#'
#' Author:  Zhaozhen Du (duzhaozhen2022@sinh.ac.cn)
#' Date:    2026-03-02
#' -----------------------------------------------------------------------------

library(dplyr)

# -----------------------------------------------------------------------------
# 1. Path Configuration and Initial Data Scanning
# -----------------------------------------------------------------------------

rds_path <- "~/AgingBiomarker_work/GitHub/OmniAgeR_backup_data/data28Feb26_rds"
rds_files <- list.files(rds_path, pattern = "\\.rds$")

# Detect RDataClass automatically by reading each RDS file
detected_classes <- sapply(rds_files, function(f) {
  obj <- readRDS(file.path(rds_path, f))
  return(class(obj)[1])
})


# ------------------------------------------------------------------------------
# 2. Build Basic Metadata Framework for RDS Files
# ------------------------------------------------------------------------------
metadata <- data.frame(
  Title = gsub("\\.rds$", "", rds_files),
  Description = paste("Aging omic biomarker predictor coefficients for",
                      gsub("\\.rds$", "", rds_files)),
  BiocVersion = "3.23",
  Genome = NA_character_,
  SourceUrl = NA_character_,
  Coordinate_1_based = TRUE,
  Maintainer = "Zhaozhen Du <duzhaozhen2022@sinh.ac.cn>",
  RDataClass = as.character(detected_classes),
  DispatchClass = "Rds",
  ResourceName = rds_files,
  stringsAsFactors = FALSE
)

# -----------------------------------------------------------------------------
# 3. Incorporate Large-scale Files (QS2 Format)
# -----------------------------------------------------------------------------
# Note: Using 'FilePath' DispatchClass for files > 1GB to prevent memory issues
qs2_files <- c("PCClocks_data.qs2", "SystemsAge_data.qs2")
qs2_metadata <- data.frame(
  Title = gsub("\\.qs2$", "", qs2_files),
  Description = c(
    "PC Clocks data (qs2 format). Use qs2::qd_read() to load.",
    "SystemsAge Clock data (qs2 format). Use qs2::qd_read() to load."
  ),
  BiocVersion = "3.23",
  Genome = NA_character_,
  SourceUrl = NA_character_,
  Coordinate_1_based = TRUE,
  Maintainer = "Zhaozhen Du <duzhaozhen2022@sinh.ac.cn>",
  RDataClass = "list",
  DispatchClass = "FilePath", # Critical for large files
  ResourceName = qs2_files,
  stringsAsFactors = FALSE
)

# Combine RDS and QS2 metadata
final_metadata <- rbind(metadata, qs2_metadata)

# ------------------------------------------------------------------------------
# 4. Integrate Source Mapping (Providers, Taxonomy, and DOI)
# ------------------------------------------------------------------------------
temp_providers <- read.csv("inst/scripts/temp_providers.csv")

# Initialize required columns with default values
final_metadata <- final_metadata %>%
  mutate(
    DataProvider = "Original Authors",
    SourceVersion = NA_character_,
    Species = NA_character_,
    TaxonomyId = NA_character_,
    SourceType = NA_character_,
    Tags = NA_character_
  )

# Fuzzy match Patterns to Titles and update metadata fields
# Loop through mapping table and update metadata with fuzzy matching
for (i in seq_len(nrow(temp_providers))) {
  pattern <- temp_providers$Pattern[i]
  # Identify rows in final_metadata that match the current pattern
  matched <- grepl(pattern, final_metadata$Title, ignore.case = TRUE)

  if (any(matched)) {
    # Extract current provider info to avoid long lines in assignment
    prov_data <- temp_providers[i, ]

    final_metadata$DataProvider[matched]  <- prov_data$DataProvider
    final_metadata$SourceVersion[matched] <-
      as.character(prov_data$SourceVersion)
    final_metadata$Species[matched]       <- prov_data$Species
    final_metadata$SourceUrl[matched]     <- prov_data$SourceUrl
    final_metadata$SourceType[matched]    <- prov_data$SourceType
    final_metadata$Tags[matched]    <- as.character(prov_data$Tag)

    # Assign TaxonomyId based on Species with clear line breaks
    final_metadata$TaxonomyId[matched] <- case_when(
      prov_data$Species == "Mus musculus"        ~ "10090",
      prov_data$Species == "Tursiops truncatus" ~ "9739",
      prov_data$Species == "Homo sapiens"       ~ "9606"
    )
  }
}

# ------------------------------------------------------------------------------
# 5. Finalize Paths and Formatting
# ------------------------------------------------------------------------------
# Replace with actual Zenodo Record ID after publishing
zenodo_id <- "18832408"
final_metadata <- final_metadata %>%
  mutate(
    Location_Prefix = "https://zenodo.org/",
    RDataPath = paste0("api/records/", zenodo_id, "/files/", ResourceName, "/content"),
  )

official_columns <- c(
  "Title", "Description", "BiocVersion", "Genome", "SourceType", "SourceUrl",
  "SourceVersion", "Species", "TaxonomyId", "Coordinate_1_based",
  "DataProvider", "Maintainer", "RDataClass", "DispatchClass",
  "Location_Prefix", "RDataPath", "Tags")


# Ensure all columns are present and ordered
final_metadata_fixed <- final_metadata[, official_columns]


# ------------------------------------------------------------------------------
# 6. Export to Package Directory
# ------------------------------------------------------------------------------
final_metadata_fixed$SourceUrl <- gsub("\\)$", "", final_metadata_fixed$SourceUrl)
write.csv(final_metadata_fixed, "inst/extdata/metadata.csv", row.names = FALSE)

