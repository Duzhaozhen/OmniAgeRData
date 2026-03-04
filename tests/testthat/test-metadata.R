library(testthat)
test_that("ExperimentHub metadata is valid", {
    metadata_file <- system.file("extdata",
        "metadata.csv",
        package = "OmniAgeRData"
    )
    df <- read.csv(metadata_file)
    metaColname <- c(
        "Title", "Description", "BiocVersion", "Genome", "SourceType",
        "SourceUrl", "SourceVersion", "Species", "TaxonomyId",
        "Coordinate_1_based", "DataProvider", "Maintainer",
        "RDataClass", "DispatchClass", "Location_Prefix",
        "RDataPath", "Tags"
    )
    expect_true(all(metaColname %in% colnames(df)))
})
