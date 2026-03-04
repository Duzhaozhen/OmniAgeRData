.onLoad <- function(libname, pkgname) {
    fl <- system.file("extdata", "metadata.csv", package = pkgname)
    if (file.exists(fl)) {
        if (requireNamespace("ExperimentHub", quietly = TRUE)) {}
    }
}
