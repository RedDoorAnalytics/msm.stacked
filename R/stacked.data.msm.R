#' @title Calculate State Occupancy Probabilities Over Time from and to Every State
#'
#' @description The [stacked.data.msm()] function can be used to calculate
#'   state occupancy probabilities over time for multi-state models fitted
#'   using the {msm} package.
#'
#' @param model A multi-state model fitted using [msm::msm()].
#' @param tstart Numeric value denoting the starting time for calculating predictions.
#'   It can be time zero (e.g., the beginning of the study) or it can be a given follow-up
#'   time (e.g., one year after baseline) in which case predictions will be conditional on
#'   being in a given state at time `tstart`.
#' @param tforward Numeric value denoting how many units of time forward predictions are
#'   to be calculated for. For instance, if `tstart = t0` and `tforward = t1`, predictions
#'   will be computed up to time `t0 + t1`.
#' @param tseqn Numeric value denoting how many sub-intervals to use between `tstart` and
#'   `tstart + tforward`, defaulting to 5. This must be greater than one.
#' @param exclude Denotes a state (or more than one) for which transitions from such state are
#'   to be excluded. This is useful, for example, to avoid returning transitions from an absorbing
#'   state; the [states.msm()] function can be helpful to identify the names of the states for a
#'   given model. The `exclude` parameter defaults to `NULL`, where all transitions are returned.
#' @param conf.int Boolean value denoting whether confidence intervals for transition probabilities
#'   over time should be returned. This uses a parametric bootstrap approach and the percentile method,
#'   similar to that of `ci = "normal"` in [msm::pmatrix.msm()], but modified to ensure that a single
#'   model resample is used throughout all time points.
#'   Defaults to `FALSE`.
#' @param B Number of replication for the parametric boostrap procedure used to calculate
#'   confidence intervals if `conf.int = TRUE`.
#'   Defaults to 1,000.
#' @param alpha Desired significance level (1 - confidence level) for the confidence intervals if
#'   `conf.int = TRUE`.
#'   Defaults to 0.05
#' @param progress Boolean denoting whether a progress bar should be printed to show the status of
#'   the parametric bootstrap.
#'   Defaults to `TRUE` if `conf.int = TRUE`, `FALSE` otherwise.
#' @param ... Additional arguments to be passed to [msm::pmatrix.msm()]. This is useful,
#'   for example, if calculating predictions for a certain covariates pattern - otherwise,
#'   as in [msm::pmatrix.msm()], predictions will be assuming means of the covariates in
#'   the data.
#'
#' @return
#' A data frame with the following columns:
#' - `from`, denoting the starting state;
#' - `to`, denoting the destination state;
#' - `p`, denoting the probability of being in state `to` starting from state `from` at
#'   time `t`;
#' - `tstart`, denoting the starting point for the predictions;
#' - `t`, denoting the times for the predicted probabilities `p`.
#'
#' If `conf.int = TRUE`, then two columns with the lower and upper confidence interval
#' bounds will be included as well: `conf.low`, `conf.high`.
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
#'   deathexact = 4
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
#'
#' ### Example 3:
#' # Excluding transitions from a certain state, e.g., from State 4:
#' stacked.data.msm(model = cav.msm.cov, tstart = 0, tforward = 5, exclude = "State 4")
#'
#' # Returning transitions from State 1 only:
#' stacked.data.msm(
#'   model = cav.msm.cov,
#'   tstart = 0,
#'   tforward = 5,
#'   exclude = c("State 2", "State 3", "State 4")
#' )
#'
#' ### Example 4:
#' # Confidence intervals for transition probabilities,
#' # using B = 10 replicates to keep it fast:
#' p1.ci <- stacked.data.msm(
#'   model = cav.msm,
#'   tstart = 0,
#'   tforward = 1,
#'   tseqn = 3,
#'   conf.int = TRUE,
#'   B = 10,
#'   progress = FALSE
#' )
#' head(p1.ci)
#' # Compare with:
#' head(p1)
stacked.data.msm <- function(model, tstart, tforward, tseqn = 5, exclude = NULL, conf.int = FALSE, B = 1000, alpha = 0.05, progress = conf.int, ...) {
  # Check arguments
  arg_checks <- checkmate::makeAssertCollection()
  # 'model' must be of class 'msm'
  checkmate::assert_class(x = model, classes = "msm", add = arg_checks, .var.name = "model")
  # 'tstart', 'tforward', 'tseq', 'ref' must be a single number
  checkmate::assert_number(x = tstart, add = arg_checks, .var.name = "tstart")
  checkmate::assert_number(x = tforward, add = arg_checks, .var.name = "tforward")
  checkmate::assert_number(x = tseqn, add = arg_checks, .var.name = "tseqn")
  # 'exclude' must be a string (or vector of strings), but can be NULL
  checkmate::assert_character(x = exclude, add = arg_checks, null.ok = TRUE, .var.name = "exclude")
  # 'tseqn' must be greater than one
  checkmate::assert_true(x = (tseqn > 1), add = arg_checks, .var.name = "tseqn > 1")
  # 'tstart', 'tforward' must be greater than zero
  checkmate::assert_true(x = (tstart >= 0), add = arg_checks, .var.name = "tstart >= 0")
  checkmate::assert_true(x = (tforward > 0), add = arg_checks, .var.name = "tforward > 0")
  # 'ci' must be a single boolean
  checkmate::assert_logical(x = conf.int, len = 1, add = arg_checks, .var.name = "ci")
  # 'B' must be a single integer, greater than zero
  checkmate::assert_number(x = B, add = arg_checks, .var.name = "B")
  checkmate::assert_true(x = (B > 0), add = arg_checks, .var.name = "B > 0")
  # 'alpha' must be a single number between 0 and 1
  checkmate::assert_number(x = alpha, add = arg_checks, .var.name = "alpha")
  checkmate::assert_true(x = (alpha > 0 & alpha < 1), add = arg_checks, .var.name = "alpha in [0, 1]")
  # 'progress' must be a single boolean
  checkmate::assert_logical(x = progress, len = 1, add = arg_checks, .var.name = "progress")

  # Report
  if (!arg_checks$isEmpty()) checkmate::reportAssertions(arg_checks)

  # Sequence of `tseqn` equally-spaced points for forward predictions
  tseq <- seq(0, tforward, length.out = tseqn)

  # If model did not have asymptotic SEs we cannot do conf.int
  # So, we fail gracefully
  if (!model$foundse) {
    message("Asymptotic standard errors not available in fitted model. Continuing with conf.int = FALSE...")
    conf.int <- FALSE
  }

  # If confidence intervals are required, we need to resample models once per value of tseq
  if (conf.int) {
    resamp_models <- .resample_models(x = model, B = B)
  }

  # Setup progress bar if required
  if (conf.int & progress) {
    pb <- utils::txtProgressBar(min = 0, max = B * length(tseq), style = 3)
  }

  # Calculate pmatrix at each time point forward
  preds <- lapply(X = tseq, FUN = function(.t) {
    # Point estimates
    point_estimate <- .wrap_pmatrix.msm(t = .t, model = model, t1 = tstart, ...)
    if (conf.int) {
      # Confidence intervals
      # Setup progress bar, if required
      repl_point_estimate <- sapply(X = resamp_models, FUN = function(x) {
        # Calculate values for this model replicate
        out <- .wrap_pmatrix.msm(t = .t, model = x, t1 = tstart, ...)
        # Increment progress bar
        if (progress) utils::setTxtProgressBar(pb = pb, value = pb$getVal() + 1)
        # Return
        return(out$p)
      }, simplify = "matrix")
      # Calculate confidence intervals using the quantile method
      ci <- matrixStats::rowQuantiles(x = repl_point_estimate, probs = c(alpha / 2, 1 - alpha / 2))
      colnames(ci) <- c("conf.low", "conf.high")
      # Combine
      out <- cbind(point_estimate, ci)
      # Return
      return(out)
    }
    # Else, return point estimates only
    return(point_estimate)
  })

  # Close progress bar
  if (conf.int & progress) close(pb)

  # Bind rows
  preds <- do.call(rbind.data.frame, preds)

  # Exclude states if 'exclude' was defined
  if (!is.null(exclude)) {
    preds <- subset(preds, !(preds$from %in% exclude))
  }

  # Remove row names
  rownames(preds) <- NULL

  # Return data
  return(preds)
}
