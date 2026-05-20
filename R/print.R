#' Print a Synergy Result
#'
#' @param x A \code{synergy_result} object from \code{analyse_synergy()}.
#' @param ... Additional arguments passed to \code{print()}.
#'
#' @return \code{x} invisibly.
#' @exportS3Method
print.synergy_result <- function(x, ...) {
  cat("\nSynergy Analysis Result\n")
  cat("-----------------------\n")
  cat("Observations:", nrow(x$data), "\n")
  cat("Combination points:", nrow(x$ci_data), "\n")
  invisible(x)
}