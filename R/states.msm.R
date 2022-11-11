#' @title List States of a Multi-State Model
#'
#' @description The [states.msm()] function lists the possible states of a
#'   multi-state model fitted with the {msm} package.
#'
#' @param model An object of class `msm`.
#'
#' @return A string vector of state names.
#'
#' @export
#'
#' @examples
#'
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
#' # Possible states:
#' states.msm(cav.msm)
states.msm <- function(model) {
  # Check arguments
  arg_checks <- checkmate::makeAssertCollection()
  # 'model' must be an 'msm' object
  checkmate::assert_class(x = model, classes = "msm", add = arg_checks, .var.name = "model")
  # Report
  if (!arg_checks$isEmpty()) checkmate::reportAssertions(arg_checks)

  # Extract states
  rownames(model$Qmatrices$baseline)
}
