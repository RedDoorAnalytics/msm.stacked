# File for testing
library(msm)

# Builds upon the example in ?msm
twoway4.q <- rbind(
  c(-0.5, 0.25, 0, 0.25), c(0.166, -0.498, 0.166, 0.166),
  c(0, 0.25, -0.5, 0.25), c(0, 0, 0, 0)
)

statetable.msm(state, PTNUM, data = cav)

cav.msm <- msm(
  formula = state ~ years,
  subject = PTNUM,
  data = cav,
  qmatrix = twoway4.q,
  deathexact = 4
)

# Load
devtools::load_all()

# States
states.msm(cav.msm)

# Create a dataset with the predictions
stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 5, exclude = c("State 2", "State 3", "State 4"))
stacked.data.msm(model = cav.msm, tstart = 0, tforward = 10)

# Automatic stacked plot
stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 2)
stacked.plot.msm(model = cav.msm, tstart = 0, tforward = 2, exclude = "State 4")
stacked.plot.msm(model = cav.msm, tstart = 1, tforward = 2, tseqn = 10)

#
cav.msm <- msm(
  formula = state ~ years,
  subject = PTNUM,
  data = cav,
  covariates = ~sex,
  qmatrix = twoway4.q,
  deathexact = 4
)
