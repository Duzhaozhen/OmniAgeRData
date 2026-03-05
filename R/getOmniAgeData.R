#' Get OmniAgeR Data Resources
#'
#' @param title The title or ResourceName of the dataset.
#' @param localTest Logical. For internal developer use only.
#' Set to TRUE for local package testing before Bioconductor publication.
#' Default is FALSE.
#' @param localDir Character. For internal developer use only.
#' The path to the local data folder if localTest is TRUE.
#' @param verbose Logical. Whether to print progress messages. Default is TRUE.
#' @return The loaded R object.
#' @importFrom AnnotationHub query
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom qs2 qs_read
#' @export
#' @examples
#' # 1. Mock a local environment for BiocCheck to run
#' # In a real scenario, you would have your data in a local folder
#' local_dir <- tempdir()
#' saveRDS(matrix(1:10), file.path(local_dir, "test_data.rds"))
#'
#' # 2. Run a local test (this is "runnable" and satisfies BiocCheck)
#' try({
#'     res <- getOmniAgeData("test_data",
#'         localTest = TRUE,
#'         localDir = local_dir
#'     )
#'     print(res)
#' })
#'
#' # 3. The official cloud usage
#' if (interactive()) {
#'     lung_data <- getOmniAgeData("omniager_lung_inv")
#' }
#'
getOmniAgeData <- function(
    title, localTest = FALSE, localDir = "local_test_data", verbose = TRUE) {
    # 1. Handling the local development and testing mode
    if (localTest) {
        return(.loadLocalData(title, localDir, verbose))
    }

    # 2. The official cloud download mode
    eh <- ExperimentHub::ExperimentHub()
    res <- AnnotationHub::query(eh, c("OmniAgeRData", title))

    if (length(res) == 0) {
        stop(sprintf("Resource '%s' not found in OmniAgeRData.", title))
    }

    if (verbose) {
        message("Retrieving resource: ", hubTitle)
    }
    dataObjOrPath <- res[[1]]
    hubTitle <- res$title

    if (is.character(dataObjOrPath) &&
        grepl("\\.qs2?$", hubTitle)) {
        if (!requireNamespace("qs2", quietly = TRUE)) {
            stop("Package 'qs2' is required to read this resource.")
        }
        return(qs2::qs_read(dataObjOrPath))
    }

    return(dataObjOrPath)
}
## Internal helper function to load data from a local directory.
## This avoids redundancy in the main getOmniAgeData function and
## helps keep the main function under the 50-line limit.
## @param title Character(1). Pattern to match the filename.
## @param localDir Character(1). Path to search.
## @return Loaded object or throws an error.

.loadLocalData <- function(title, localDir, verbose) {
    if (verbose) {
        message("--- Running in Local Development Mode ---")
    }

    exactPattern <- paste0("^", title, "\\.(rds|qs2?)$")
    possibleFiles <- list.files(
        localDir,
        pattern = exactPattern,
        ignore.case = TRUE,
        full.names = TRUE
    )

    if (length(possibleFiles) == 0) {
        stop(sprintf(
            "Local file exactly matching '%s' (.rds or .qs2) not found in %s",
            title,
            localDir
            )
        )
    }

    localFile <- possibleFiles[1]
    if (verbose) {
        message("Loading local file: ", localFile)
    }

    if (grepl("\\.qs2?$", localFile, ignore.case = TRUE)) {
        if (!requireNamespace("qs2", quietly = TRUE)) {
            stop("Package 'qs2' required.")
        }
        return(qs2::qs_read(localFile))
    } else if (grepl("\\.rds$", localFile, ignore.case = TRUE)) {
        return(readRDS(localFile))
    } else {
        stop("Unsupported format for local testing. Expected .qs2 or .rds")
    }
}
