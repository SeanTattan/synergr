#' Plot a CI Heatmap
#'
#' @param x A \code{synergy_result} object from \code{analyse_synergy()}.
#' @param ... Additional arguments (unused).
#'
#' @return A \code{ggplot2} object.
#' @export
plot_heatmap <- function(x, ...) {
  UseMethod("plot_heatmap")
}

#' @exportS3Method
#' @rdname plot_heatmap
plot_heatmap.synergy_result <- function(x, ...) {
  ggplot2::ggplot(
    x$ci_data,
    ggplot2::aes(
      x = factor(DrugA),
      y = factor(DrugB),
      fill = CI
    )
  ) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_gradient2(
      midpoint = 1
    ) +
    ggplot2::theme_minimal()
}