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
#'
#' @examples
#'
#' ### Example 1:
#' # Based on example in ?msm
#' # We first fit a {msm} model without covariates
#' library(msm)
#' twoway4.q <- rbind(
#'   c(-0.5, 0.25, 0, 0.25),
#'   c(0.166, -0.498, 0.166, 0.166),
#'   c(0, 0.25, -0.5, 0.25),
#'   c(0, 0, 0, 0)
#' )
#' cav.msm <- msm(
#'   formula = state ~ years,
#'   subject = PTNUM,
#'   data = cav,
#'   qmatrix = twoway4.q,
#'   deathexact = 4
#' )
#'
#' # Stacked probablities plot from 0 to 5:
#' stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 5)
#' # ...or, with finer predictions:
#' stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 5, tseqn = 100)
#'
#' # Predictions starting from time 1 to time 5:
#' stacked.plot.msm(model = cav.msm, tstart = 1, tforward = (5 - 1))
#' # Note that by default the plot starts at zero.
#' # If we wanted to start from `tstart:`
#' stacked.plot.msm(model = cav.msm, tstart = 1, tforward = (5 - 1), start0 = FALSE)
#'
#' ### Example 2:
#' # Model with covariates
#' cav.msm.cov <- msm(
#'   formula = state ~ years,
#'   subject = PTNUM,
#'   data = cav,
#'   covariates = ~sex,
#'   qmatrix = twoway4.q,
#'   deathexact = 4
#' )
#'
#' # Stacked probabilities plot, from time 0 to time 5, mean covariates values:
#' stacked.plot.msm(model = cav.msm.cov, tstart = 0, tforward = 5)
#'
#' # Stacked probabilities plot, from time 0 to time 5, for `sex = 0`:
#' stacked.plot.msm(model = cav.msm.cov, tstart = 0, tforward = 5, covariates = list(sex = 0))
#'
#' # Stacked probabilities plot, from time 0 to time 5, for `sex = 1`:
#' stacked.plot.msm(model = cav.msm.cov, tstart = 0, tforward = 5, covariates = list(sex = 1))
#'
#' # The three plots should be different!
stacked.plot.msm <- function(..., plab = "From", ylab = "Time", xlab = "Probability", start0 = TRUE) {
  # Check arguments
  arg_checks <- checkmate::makeAssertCollection()
  # 'plab', 'ylab', 'xlab' must be a single string
  checkmate::assert_string(x = plab, add = arg_checks, .var.name = "plab")
  checkmate::assert_string(x = ylab, add = arg_checks, .var.name = "ylab")
  checkmate::assert_string(x = xlab, add = arg_checks, .var.name = "xlab")
  # 'start0' must be a single logical value
  checkmate::assert_logical(x = start0, len = 1, add = arg_checks, .var.name = "start0")
  # Report
  if (!arg_checks$isEmpty()) checkmate::reportAssertions(arg_checks)

  # Get predictions
  preds <- stacked.data.msm(...)

  # Process labels for facets
  names(preds)[names(preds) == "from"] <- plab
  plab <- rlang::sym(plab)

  # Create a stacked area plot
  plot <- ggplot2::ggplot(data = preds, mapping = ggplot2::aes(x = tstart + t, y = p, fill = to)) +
    ggplot2::geom_area() +
    ggplot2::facet_wrap(facets = ggplot2::vars(!!{{ plab }}), labeller = ggplot2::label_both) +
    ggplot2::labs(y = ylab, x = xlab)

  # Start from zero (if requested)
  if (start0) {
    plot <- plot +
      ggplot2::coord_cartesian(xlim = c(0, max(ggplot2::layer_scales(plot)$x$range$range)))
  }

  # Return plot
  return(plot)
}
