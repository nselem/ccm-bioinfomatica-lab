library(leaps)
library(corrplot)

#   ____________________________________________________________________________
#   Read data                                                               ####

data_v1 = read.csv("regression_V1 - data.csv")

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Simple check coordinates for which bioclim variables were extracted     ####

plot(data_v1$longitude, data_v1$latitude)
text(data_v1$longitude + 7, data_v1$latitude, data_v1$city)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Correlation analysis for alpha-biodiversity measures                    ####

covar = cor(data_v1[, c("Observed", "Chao1", "ACE", "Shannon",
                        "Simpson", "Fisher")])
corrplot.mixed(covar,
               lower = "ellipse",
               upper = "number",
               order = "AOE")

#   ____________________________________________________________________________
#   Multiple linear regression Chao1                                              ####

full.model = lm(
  Chao1 ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1
)
summary(full.model)

##  ............................................................................
##  Backward variable selection                                             ####

models.backward = regsubsets(
  Chao1 ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "backward"
)
summary(models.backward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.backward = lm(Chao1 ~
                    bio01 + bio03 + bio04 + bio05 + bio07 +
                    bio08,
                  data = data_v1)
summary(fit.backward)

##  ............................................................................
##  Forward variable selection                                              ####

models.forward = regsubsets(
  Chao1 ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "forward"
)
summary(models.forward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.forward = lm(Chao1 ~
                   bio03 + bio06 + bio07 + bio08 + bio11 +
                   year,
                 data = data_v1)
summary(fit.forward)

###############################################################################################

#   Multiple linear regression Shannon                                              ####

full.model = lm(
  Shannon ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1
)
summary(full.model)

##  ............................................................................
##  Backward variable selection                                             ####

models.backward = regsubsets(
  Shannon ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "backward"
)
summary(models.backward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.backward = lm(Shannon ~
                    bio05 + bio07 + bio11 + bio12 + bio14 +
                    bio15,
                  data = data_v1)
summary(fit.backward)

##  ............................................................................
##  Forward variable selection                                              ####

models.forward = regsubsets(
  Shannon ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "forward"
)
summary(models.forward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.forward = lm(Shannon ~
                   bio02 + bio03 + bio07 + bio08 + bio10 + bio19 +
                   year,
                 data = data_v1)
summary(fit.forward)

###############################################################################################

#   Multiple linear regression Simpson                                             ####

full.model = lm(
  Simpson ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1
)
summary(full.model)

##  ............................................................................
##  Backward variable selection                                             ####

models.backward = regsubsets(
  Simpson ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "backward"
)
summary(models.backward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.backward = lm(Simpson ~
                    bio05 + bio06 + bio07 + bio08 + bio13 +
                    bio15,
                  data = data_v1)
summary(fit.backward)

##  ............................................................................
##  Forward variable selection                                              ####

models.forward = regsubsets(
  Simpson ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "forward"
)
summary(models.forward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.forward = lm(Simpson ~
                   bio02 + bio03 + bio04 + bio18 + bio19 + 
                   year,
                 data = data_v1)
summary(fit.forward)

###############################################################################################

#   Multiple linear regression Fisher                                            ####

full.model = lm(
  Fisher ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1
)
summary(full.model)

##  ............................................................................
##  Backward variable selection                                             ####

models.backward = regsubsets(
  Fisher ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "backward"
)
summary(models.backward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.backward = lm(Fisher ~
                    bio05 + bio07 + bio11 + bio12 + bio14 +
                    bio15,
                  data = data_v1)
summary(fit.backward)

##  ............................................................................
##  Forward variable selection                                              ####

models.forward = regsubsets(
  Fisher ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "forward"
)
summary(models.forward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.forward = lm(Fisher ~
                   bio03 + bio06 + bio08 + bio11 + bio19 + 
                   year,
                 data = data_v1)
summary(fit.forward)
###############################################################################################

#   Multiple linear regression Observed                                            ####

full.model = lm(
  Observed ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1
)
summary(full.model)

##  ............................................................................
##  Backward variable selection                                             ####

models.backward = regsubsets(
  Observed ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "backward"
)
summary(models.backward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.backward = lm(Observed ~
                    bio03 + bio05 + bio07 + bio08 + bio11 +
                    bio15,
                  data = data_v1)
summary(fit.backward)

##  ............................................................................
##  Forward variable selection                                              ####

models.forward = regsubsets(
  Observed ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "forward"
)
summary(models.forward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.forward = lm(Observed ~
                   bio03 + bio06 + bio08 + bio10 + bio11 + 
                   year,
                 data = data_v1)
summary(fit.forward)

###############################################################################################

#   Multiple linear regression ACE                                            ####

full.model = lm(
  ACE ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1
)
summary(full.model)

##  ............................................................................
##  Backward variable selection                                             ####

models.backward = regsubsets(
  ACE ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "backward"
)
summary(models.backward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.backward = lm(ACE ~
                    bio01 + bio03 + bio04 + bio05 + bio07 +
                    bio08,
                  data = data_v1)
summary(fit.backward)

##  ............................................................................
##  Forward variable selection                                              ####

models.forward = regsubsets(
  ACE ~
    bio01 + bio02 + bio03 + bio04 + bio05 + bio06 + bio07 +
    bio08 + bio09 + bio10 + bio11 + bio12 + bio13 + bio14 +
    bio15 + bio16 + bio17 + bio18 + bio19 + year,
  data = data_v1,
  nvmax = 5,
  method = "forward"
)
summary(models.forward)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Fit best resulting model                                                ####

fit.forward = lm(ACE ~
                   bio03 + bio06 + bio07 + bio08 + bio11 + 
                   year,
                 data = data_v1)
summary(fit.forward)
