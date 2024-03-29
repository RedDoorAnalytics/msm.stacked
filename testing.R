library(msm)
devtools::load_all()

twoway4.q <- rbind(
  c(-0.5, 0.25, 0, 0.25),
  c(0.166, -0.498, 0.166, 0.166),
  c(0, 0.25, -0.5, 0.25),
  c(0, 0, 0, 0)
)
cav.msm.pw <- msm(
  formula = state ~ years,
  subject = PTNUM,
  data = cav,
  qmatrix = twoway4.q,
  deathexact = 4,
  pci = median(cav$years),
  control = list(trace = 1, REPORT = 1, maxit = 10000)
)

# Predictions from time 0 to time 1, with 3 mid-points:
p0 <- stacked.data.msm(model = cav.msm.pw, tstart = 0, tforward = 3, tseqn = 30, conf.int = TRUE, B = 100)
p1 <- stacked.data.msm(model = cav.msm.pw, tstart = 3, tforward = 3, tseqn = 30, conf.int = TRUE, B = 100)

ggplot(p0, aes(x = tstart + t, y = p, ymin = conf.low, ymax = conf.high)) +
  geom_ribbon(aes(fill = to), alpha = 0.2) +
  geom_line(aes(color = to)) +
  facet_wrap(~from)

ggplot(p1, aes(x = tstart + t, y = p, ymin = conf.low, ymax = conf.high)) +
  geom_ribbon(aes(fill = to), alpha = 0.2) +
  geom_line(aes(color = to)) +
  facet_wrap(~from)

# Without hessian:
cav.msm.pw.noh <- msm(
  formula = state ~ years,
  subject = PTNUM,
  data = cav,
  qmatrix = twoway4.q,
  deathexact = 4,
  pci = median(cav$years),
  control = list(trace = 1, REPORT = 1, maxit = 10000),
  hessian = FALSE
)
p0 <- stacked.data.msm(model = cav.msm.pw.noh, tstart = 0, tforward = 3, tseqn = 30, conf.int = TRUE, B = 100)
p0
