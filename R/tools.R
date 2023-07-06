#' @keywords internal
.wrap_pmatrix.msm <- function(t, model, t1, ...) {
  out <- msm::pmatrix.msm(x = model, t = t, t1 = t1, ...)
  class(out) <- "matrix"
  out <- as.data.frame.table(out)
  names(out)[names(out) == "Var1"] <- "from"
  names(out)[names(out) == "Var2"] <- "to"
  names(out)[names(out) == "Freq"] <- "p"
  out[["tstart"]] <- t1
  out[["t"]] <- t
  return(out)
}

#' @keywords internal
.resample_models <- function(x, B) {
  # See msm:::normboot.msm() for a more extensive implementation
  #
  # Check that x$paramdata$fixedpars, x$paramdata$hmmpars have length = 0
  # This way we don't have to support models with fixed parameters or hidden markov models
  if (length(x$paramdata$fixedpars) > 0) stop("Models with constraints (argument `fixedpars` of msm()) are not supported by this functionality.", call. = FALSE)
  if (length(x$paramdata$hmmpars) > 0) stop("Hidded Markov models are not supported by this functionality.", call. = FALSE)
  # Resample
  sim <- mvtnorm::rmvnorm(B, x$opt$par, x$covmat[x$paramdata$optpars, x$paramdata$optpars])
  params <- matrix(nrow = B, ncol = x$paramdata$npars)
  params[, x$paramdata$optpars] <- sim
  # Create a list
  out <- lapply(
    X = seq(B),
    FUN = function(i) {
      this <- msm::updatepars.msm(x, params[i, ])
      stat(this)
    }
  )
  return(out)
}
