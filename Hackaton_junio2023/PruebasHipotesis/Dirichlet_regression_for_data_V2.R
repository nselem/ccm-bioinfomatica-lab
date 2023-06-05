library(DirichletReg)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Read data                                                               ####

data_v2= read.csv("regression_V2 - data.csv")

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Prepare data for Dirichlet regression: defines response variable        ####

data_v2$Y = DR_data(data_v2[, 1:4])

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit Dirichlet regression                                                ####

fit = DirichReg(
  Y ~
    tmin_june + tmax_june + prec_june +
    population + population.density +
    bio08 + bio09 + bio10 + bio11 + bio16 + bio17 + bio18 + bio19,
  data = data_v2,
  model = "common",
  subset = NULL,
  weights = NULL,
  control = list(iterlim=5000)
)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Display summary of results                                              ####

summary(fit)
