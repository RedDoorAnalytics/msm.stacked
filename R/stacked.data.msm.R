#' @title Calculate State Occupancy Probabilities Over Time from and to Every State
#'
#' @description The [stacked.data.msm()] function can be used to calculate
#'   state occupancy probabilities over time for multistate models fitted
#'   using the {msm} package.
#'
#' @param model A multistate model fitted using [msm::msm()].
#' @param tstart Numeric value denoting the starting time for calculating predictions.
#'   It can be time zero (e.g., the beginning of the study) or it can be a given follow-up
#'   time (e.g., one year after baseline) in which case predictions will be conditional on
#'   being in a given state at time `tstart`.
#' @param tforward Numeric value denoting how many units of time forward predictions are
#'   to be calculated for. For instance, if `tstart = t0` and `tforward = t1`, predictions
#'   will be computed up to time `t0 + t1`.
#' @param tseqn Numeric value denoting how many sub-intervals to use between `tstart` and
#'   `tstart + tforward`, defaulting to 10. A larger number of `tnseq` will lead to smoother plots once using
#'   the [stacked.plot.msm()] function.
#' @param ... Additional arguments to be passed to [msm::pmatrix.msm()]. This is useful,
#'   for example, if calculating predictions for a certain covariates pattern - otherwise,
#'   as in [msm::pmatrix.msm()], predictions will be assuming means of the covariates in
#'   the data.
#'
#' @return A data frame with the following columns:
#' - `from`, denoting the starting state;
#' - `to`, denoting the destination state;
#' - `p`, denoting the probability of being in state `to` starting from state `from` at
#'   time `t`;
#' - `tstart`, denoting the starting point for the predictions;
#' - `t`, denoting the times for the predicted probabilities `p`.
#'
#' @seealso [msm::msm()], [msm::pmatrix.msm()]
#'
#' @export
stacked.data.msm <- function(model, tstart, tforward, tseqn = 10, ...) {
  # Sequence of `tseqn` equally-spaced points for forward predictions
  tseq <- seq(0, tforward, length.out = tseqn)
  # Calculate pmatrix at each time point forward
  preds <- lapply(X = tseq, FUN = function(.t) {
    out <- msm::pmatrix.msm(x = model, t = .t, t1 = tstart, ...)
    class(out) <- "matrix"
    out <- as.data.frame.table(out)
    names(out)[names(out) == "Var1"] <- "from"
    names(out)[names(out) == "Var2"] <- "to"
    names(out)[names(out) == "Freq"] <- "p"
    out[["tstart"]] <- tstart
    out[["t"]] <- .t
    return(out)
  })
  # Bind rows
  preds <- do.call(rbind.data.frame, preds)
  # Return data
  return(preds)
}
