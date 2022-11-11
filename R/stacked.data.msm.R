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
