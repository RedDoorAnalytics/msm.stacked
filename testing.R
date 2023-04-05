library(msm)
devtools::load_all()

twoway4.q <- rbind(
  c(-0.5, 0.25, 0, 0.25),
  c(0.166, -0.498, 0.166, 0.166),
  c(0, 0.25, -0.5, 0.25),
  c(0, 0, 0, 0)
)
cav.msm <- msm(
  formula = state ~ years,
  subject = PTNUM,
  covariates = ~sex,
  data = cav,
  qmatrix = twoway4.q,
  deathexact = 4
)

# Predictions from time 0 to time 1, with 3 mid-points:
p0 <- stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 10, ci = "normal", covariates = list(sex = 0))
p1 <- stacked.data.msm(model = cav.msm, tstart = 0, tforward = 1, tseqn = 10, ci = "normal", covariates = list(sex = 1))

# See for instance:
ggplot(p0, aes(x = t, y = p, ymin = conf.low, ymax = conf.high)) +
  geom_ribbon(aes(fill = to), alpha = 0.2) +
  geom_line(aes(color = to)) +
  facet_wrap(~from)

ggplot(p1, aes(x = t, y = p, ymin = conf.low, ymax = conf.high)) +
  geom_ribbon(aes(fill = to), alpha = 0.2) +
  geom_line(aes(color = to)) +
  facet_wrap(~from)
