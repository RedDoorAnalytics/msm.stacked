#' @title Produce Stacked Probabilities Plots
#'
#' @description The [stacked.plot.msm()] function can be used to produce stacked
#'   probabilities plots for multistate models fitted using the {msm} package.
#'
#' @param ... Arguments passed onto [stacked.data.msm()].
#' @param plab A string denoting the label of each facet. Defaults to "From".
#' @param ylab A string denoting the label of the vertical axis. Defaults to "Probability".
#' @param xlab A string denoting the label of the horizontal axis. Defaults to "Time".
#' @param start0 A boolean value denoting whether plots should start the horizontal axis
#'   at time zero, irrespectively of `tstart`.
#'
#' @return A [ggplot2::ggplot()] object.
#'
#' @seealso [stacked.data.msm()], [msm::msm()], [msm::pmatrix.msm()]
#'
#' @export
stacked.plot.msm <- function(..., plab = "From", ylab = "Time", xlab = "Probability", start0 = TRUE) {
  preds <- stacked.data.msm(...)
  # Process labels for facets
  names(preds)[names(preds) == "from"] <- plab
  plab <- rlang::sym(plab)
  # Create a stacked area plot
  plot <- ggplot2::ggplot(data = preds, mapping = ggplot2::aes(x = tstart + t, y = p, fill = to)) +
    ggplot2::geom_area() +
    ggplot2::facet_wrap(facets = ggplot2::vars(!!{{ plab }}), labeller = ggplot2::label_both) +
    ggplot2::labs(y = ylab, x = xlab)
  if (start0) {
    plot <- plot +
      ggplot2::coord_cartesian(xlim = c(0, max(ggplot2::layer_scales(plot)$x$range$range)))
  }
  return(plot)
}
