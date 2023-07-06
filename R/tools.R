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
  # Code based on msm:::normboot.msm()
  sim <- mvtnorm::rmvnorm(B, x$opt$par, x$covmat[x$paramdata$optpars, x$paramdata$optpars])
  params <- matrix(nrow = B, ncol = x$paramdata$npars)
  params[, x$paramdata$optpars] <- sim
  params[, x$paramdata$fixedpars] <- rep(x$paramdata$params[x$paramdata$fixedpars], each = B)
  params[, x$paramdata$hmmpars] <- rep(msm:::msm.mninvlogit.transform(x$paramdata$params[x$paramdata$hmmpars], x$hmodel), each = B)
  params <- params[, !duplicated(abs(x$paramdata$constr)), drop = FALSE][, abs(x$paramdata$constr), drop = FALSE] * rep(sign(x$paramdata$constr), each = B)
  sim.stat <- vector(B, mode = "list")
  for (i in 1:B) {
    x.rep <- updatepars.msm(x, params[i, ])
    sim.stat[[i]] <- stat(x.rep)
  }
  return(sim.stat)
}
