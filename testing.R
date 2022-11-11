# File for testing
library(msm)

# Builds upon the example in ?msm
twoway4.q <- rbind(
  c(-0.5, 0.25, 0, 0.25), c(0.166, -0.498, 0.166, 0.166),
  c(0, 0.25, -0.5, 0.25), c(0, 0, 0, 0)
)
cav.msm <- msm(
  formula = state ~ years,
  subject = PTNUM,
  data = cav,
  qmatrix = twoway4.q,
  deathexact = 4
)

# Create a dataset with the predictions
df <- stacked.msm.data(model = cav.msm, tstart = 0, tforward = 1, tseqn = 5)
df

# Automatic plot
stacked.msm.plot(model = cav.msm, tstart = 0, tforward = 2, tseqn = 10)
stacked.msm.plot(model = cav.msm, tstart = 1, tforward = 2, tseqn = 10)
