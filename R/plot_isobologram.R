#' Plot a Normalised Isobologram
#'
#' Generates a normalised isobologram from a \code{synergy_result} object,
#' colouring each combination point by its Loewe Combination Index (CI).
#' Points below the line of additivity (dashed) indicate synergy (CI < 1),
#' points above indicate antagonism (CI > 1).
#'
#' @param result A \code{synergy_result} object returned by \code{analyse_synergy()}.
#' @param save Logical. If \code{TRUE}, saves the plot to \code{figures/} as a PNG. Default \code{FALSE}.
#' @param width Plot width in inches. Default \code{7}.
#' @param height Plot height in inches. Default \code{6}.
#' @param dpi Plot resolution. Default \code{300}.
#'
#' @return A \code{ggplot2} object (invisibly if \code{save = TRUE}).
#' @export
#'
#' @examples
#' \dontrun{
#' result <- analyse_synergy(df, drug_a = compound_conc,
#'                               drug_b = inhibitor_conc,
#'                               response = value)
#' plot_isobologram(result)
#' plot_isobologram(result, save = TRUE)
#' }
plot_isobologram <- function(result, save = FALSE, width = 7, height = 6, dpi = 300) {

  # --- input validation ---
  if (!inherits(result, "synergy_result")) {
    stop("`result` must be a `synergy_result` object from `analyse_synergy()`.")
  }

  ci_data <- result$ci_data

  required_cols <- c("DrugA", "DrugB", "Dx_A", "Dx_B", "CI")
  missing_cols  <- setdiff(required_cols, names(ci_data))
  if (length(missing_cols) > 0) {
    stop("ci_data is missing expected columns: ", paste(missing_cols, collapse = ", "))
  }

  # --- build plot ---
  iso_plot <- ci_data %>%
    dplyr::mutate(
      frac_A = DrugA / Dx_A,
      frac_B = DrugB / Dx_B
    ) %>%
    ggplot2::ggplot(ggplot2::aes(x = frac_A, y = frac_B, color = CI)) +
    ggplot2::geom_abline(slope = -1, intercept = 1, linetype = "dashed", colour = "grey40") +
    ggplot2::geom_point(size = 3) +
    ggplot2::scale_color_gradient2(
      low      = "#D7191C",   # synergy    - red
      mid      = "#FFFFFF",   # additive   - white
      high     = "#2B7CB6",   # antagonism - blue
      midpoint = 1
    ) +
    ggplot2::labs(
      title = "Normalised Isobologram",
      x     = "Fraction of single-agent dose (DrugA / Dx_A)",
      y     = "Fraction of single-agent dose (DrugB / Dx_B)",
      color = "CI"
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      panel.grid  = ggplot2::element_blank(),
      axis.text   = ggplot2::element_text(size = 12, colour = "black"),
      plot.title  = ggplot2::element_text(size = 14, colour = "black"),
      legend.text = ggplot2::element_text(size = 12, colour = "black"),
      axis.title  = ggplot2::element_text(size = 14, colour = "black")
    )

  # --- optionally save ---
  if (save) {
    dir.create("figures", showWarnings = FALSE)
    filename <- file.path("figures", "isobologram.png")
    ggplot2::ggsave(filename, plot = iso_plot, width = width, height = height, dpi = dpi)
    message("Saved: ", filename)
    return(invisible(iso_plot))
  }

  iso_plot
}
