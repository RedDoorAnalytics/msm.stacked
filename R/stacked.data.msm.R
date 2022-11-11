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
#'   `tstart + tforward`, defaulting to 5.
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
#'   deathexact = 4,
#'   fixedpars = TRUE # only to speed up examples!
#' )
#'
#' # Predictions from time 0 to time 1, with 3 mid-points:
#' p1 <- stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 3)
#' head(p1)
#'
#' # Predictions from time 1 to time 5, with 5 mid-points:
#' p2 <- stacked.data.msm(model = cav.msm, tstart = 1, tforward = 4, tseqn = 5)
#' head(p2)
#'
#' ### Example 2:
#' # Model with covariates
#' cav.msm.cov <- msm(
#'   formula = state ~ years,
#'   subject = PTNUM,
#'   data = cav,
#'   covariates = ~sex,
#'   qmatrix = twoway4.q,
#'   deathexact = 4,
#'   fixedpars = TRUE # only to speed up examples!
#' )
#'
#' # Predictions from time 0 to time 5, mean covariates values:
#' p3 <- stacked.data.msm(model = cav.msm.cov, tstart = 0, tforward = 5)
#'
#' # Predictions from time 0 to time 5, for `sex = 0`:
#' p4 <- stacked.data.msm(model = cav.msm.cov, tstart = 0, tforward = 5, covariates = list(sex = 0))
#'
#' # Predictions from time 0 to time 5, for `sex = 1`:
#' p5 <- stacked.data.msm(model = cav.msm.cov, tstart = 0, tforward = 5, covariates = list(sex = 1))
#'
#' # p3, p4, and p5 should all be different:
#' all.equal(p3, p4)
#' all.equal(p3, p5)
#' all.equal(p4, p5)
stacked.data.msm <- function(model, tstart, tforward, tseqn = 10, ...) {
  # Check arguments
  arg_checks <- checkmate::makeAssertCollection()
  # 'model' must be of class 'msm'
  checkmate::assert_class(x = model, classes = "msm", add = arg_checks, .var.name = "model")
  # 'tstart', 'tforward', 'tseq', 'ref' must be a single number
  checkmate::assert_number(x = tstart, add = arg_checks, .var.name = "tstart")
  checkmate::assert_number(x = tforward, add = arg_checks, .var.name = "tforward")
  checkmate::assert_number(x = tseqn, add = arg_checks, .var.name = "tseqn")
  # Report
  if (!arg_checks$isEmpty()) checkmate::reportAssertions(arg_checks)

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
