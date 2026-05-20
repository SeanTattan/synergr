#' Plot a 3D Response Surface
#'
#' @param x A \code{synergy_result} object from \code{analyse_synergy()}.
#' @param ... Additional arguments (unused).
#'
#' @return A \code{plotly} object.
#' @export
plot_surface <- function(x, ...) {
  UseMethod("plot_surface")
}

#' @exportS3Method
#' @rdname plot_surface
plot_surface.synergy_result <- function(x, ...) {
  df <- x$ci_data
  response_grid <- df %>%
    dplyr::select(DrugA, DrugB, Response) %>%
    tidyr::pivot_wider(
      names_from = DrugB,
      values_from = Response
    )
  ci_grid <- df %>%
    dplyr::select(DrugA, DrugB, CI) %>%
    tidyr::pivot_wider(
      names_from = DrugB,
      values_from = CI
    )
  z_response <- as.matrix(response_grid[, -1])
  z_CI <- as.matrix(ci_grid[, -1])
  xvals <- response_grid$DrugA
  yvals <- as.numeric(colnames(z_response))
  plotly::plot_ly() %>%
    plotly::add_surface(
      x = ~xvals,
      y = ~yvals,
      z = ~z_response,
      surfacecolour = ~z_CI
    )
}